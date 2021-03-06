import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info/package_info.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/util/login_base.dart';
import 'package:zgene/util/sp_utils.dart';

import 'base_response.dart';


///网络请求工具类
class HttpUtils {
  static int CONNECTTIMEOUT = 8000;
  static int RECEIVETIMEOUT = 8000;
  //需要登录错误码
  static const int _needLoginCode = 20201;

  static  Dio _dio;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  /// 创建 dio 实例对象
  static Future<Dio> createInstance() async {
    if (_dio == null) {
      var spUtils = SpUtils();
      String model, vendor, udid, authorization, version;
      int os, uid;
      //不是是第一次打开
      if (!spUtils.getStorageDefault(SpConstant.SpIsFirst, true)) {
        //获取设备信息
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          model = androidInfo.model;
          vendor = androidInfo.manufacturer;
          os = 1;
          udid = androidInfo.androidId;
          spUtils.setStorage(SpConstant.AppUdid, androidInfo.androidId);
        } else {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          model = iosInfo.model;
          vendor = iosInfo.localizedModel;
          os = 2;
          udid = iosInfo.identifierForVendor;
          spUtils.setStorage(SpConstant.AppUdid, iosInfo.identifierForVendor);
        }
        //app版本信息
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        version = packageInfo.version; //版本号
        // String buildNumber = packageInfo.buildNumber;//版本构建号

        authorization = spUtils.getStorageDefault(SpConstant.Token, "");
        uid = spUtils.getStorageDefault(SpConstant.Uid, 0);
      }

      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      var options = BaseOptions(
          baseUrl: CommonConstant.BASE_API,
          //连接时间为5秒
          connectTimeout: CONNECTTIMEOUT,
          //响应时间为3秒
          receiveTimeout: RECEIVETIMEOUT,
          //设置请求头
          headers: {
            "os": os, //1: andriod, 2: apple, 3:windows
            "udid": udid, //设备唯一id
            "uid": uid, //用户ID	对于未登录的用户传0或者不传
            "platform": "app", //平台
            "appv": version, //app版本
            "vendor": vendor, //	厂商
            "model": model, //型号
            "Authorization": authorization, //token
          },

          //默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
          contentType: Headers.jsonContentType,
          //共有三种方式json,bytes(响应字节),stream（响应流）,plain
          responseType: ResponseType.json);

      _dio = new Dio(options);
    }
    return _dio;
  }

  /// 清空 dio 对象
  static clear() {
    _dio = null;
  }
  /// request Get、Post 请/求
  //url 请求链接
  //parameters 请求参数
  //method 请求方式
  //onSuccess 成功回调
  //onError 失败回调
  static void requestHttp(String url,
      {parameters,
        method,
        Function(dynamic t) onSuccess,
        Function(int code, String error) onError}) async {
    parameters = parameters ?? {"": ""};
    method = method ?? 'GET';
    if (method == HttpUtils.GET) {
      getHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          if(null != onSuccess){
            onSuccess(data);
          }
        },
        onError: (code, error) {
          if(null != onError){
            onError(code, error);
          }
        },
      );
    } else if (method == HttpUtils.POST) {
      postHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          if(null != onSuccess){
            onSuccess(data);
          }
        },
        onError: (code, error) {
          if(null != onError){
            onError(code, error);
          }
        },
      );
    }
  }

  ///Get请求
  static void getHttp(
    String url, {
    parameters,
        Function(dynamic) onSuccess,
        Function(int code, String error) onError,
  }) async {
    ///定义请求参数

    parameters = parameters ?? {};

    //参数处理
    try {
      parameters.forEach((key, value) {
        if (url.indexOf(key) != -1) {
          url = url.replaceAll(':$key', value.toString());
        }
      });
    } catch (e) {}

    try {
      Dio dio = await createInstance();

      Response response = await dio.get(url, queryParameters: parameters);
      var responseString = json.decode(response.toString());
      var responseResult = BaseResponse.fromJson(responseString);
      print(responseString);
      int code = responseResult.code;
      print(responseResult.code);
      switch (code) {
        case _needLoginCode:
          EasyLoading.dismiss();
          if (onError != null) {
            onError(code??0, "请登录");
          }
          BaseLogin.login();
          return;
        default:
          break;
      }
      String msg = responseResult.msg;
      dynamic result = responseResult.result;
      if (code == 0) {
        if (onSuccess != null) {
          onSuccess(result);
        }
      } else {
        if (onError != null) {
          onError(code??0, msg??"");
        }
      }
      print('响应数据：' + response.toString());
    } catch (e) {
      print('请求出错：' + e.toString());
      if (onError != null) {
        onError(0, e.toString());
      }
    }
  }

  ///Post请求
  static void postHttp<T>(
    String url, {
    parameters,
         Function(T) onSuccess,
         Function(int code, String error) onError,
  }) async {
    ///定义请求参数
    parameters = parameters ?? {};
    try {
      parameters.forEach((key, value) {
        if (url.indexOf(key) != -1) {
          url = url.replaceAll(':$key', value.toString());
        }
      });
    } catch (e) {}
    print(parameters);
    try {
      Dio dio = await createInstance();
      Response response = await dio.post(url, data: parameters);
      var responseString = json.decode(response.toString());
      var responseResult = BaseResponse.fromJson(responseString);
      int code = responseResult.code;
      String msg = responseResult.msg;
      dynamic result = responseResult.result;
      print(responseResult.code);
      switch (code) {
        case _needLoginCode:
          EasyLoading.dismiss();
          onError(code?? 0, "请登录");
          BaseLogin.login();
          return;
        default:
          break;
      }

      if (code == 0) {
        onSuccess(result);
      } else {
        onError(code??0, msg??"");
      }
      print('响应数据：' + response.toString());
    } catch (e) {
      print('请求出错：' + e.toString());
      onError(0, e.toString());
    }
  }
}
