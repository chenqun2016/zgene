import 'dart:collection';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/util/common_utils.dart';

typedef _CallBack = void Function(dynamic result);

Future<void> HomeGetHttp(int type, _CallBack callback) async {
  bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
  if (!isNetWorkAvailable) {
    return;
  }

  Map<String, dynamic> map = new HashMap();
  map['cid'] =
      type; //栏目ID 9:金刚区 10:Banner 11:探索之旅 12:独一无二的你 3:常见问题 6:示例报告（男） 7:示例报告（女） 15：精选报告
  HttpUtils.requestHttp(
    ApiConstant.contentList,
    parameters: map,
    method: HttpUtils.GET,
    onSuccess: (result) async {
      if (callback != null) {
        callback(result);
      }
    },
    onError: (code, error) {},
  );
}

Future<void> CategoriesGetHttp(int type, _CallBack callback) async {
  bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
  if (!isNetWorkAvailable) {
    return;
  }

  Map<String, dynamic> map = new HashMap();
  map['parent_cid'] = type; //ID 6:示例报告（男） 7:示例报告（女）
  HttpUtils.requestHttp(
    ApiConstant.categories,
    parameters: map,
    method: HttpUtils.GET,
    onSuccess: (result) async {
      EasyLoading.dismiss();
      if (callback != null) {
        callback(result);
      }
    },
    onError: (code, error) {
      EasyLoading.showError(error);
    },
  );
}

Future<void> ArchiveGetHttp(int id, _CallBack callback) async {
  bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
  if (!isNetWorkAvailable) {
    return;
  }
  ;

  HttpUtils.requestHttp(
    ApiConstant.contentDetail + "/${id}",
    method: HttpUtils.GET,
    onSuccess: (result) async {
      EasyLoading.dismiss();
      if (callback != null) {
        callback(result);
      }
    },
    onError: (code, error) {
      EasyLoading.showError(error);
    },
  );
}
