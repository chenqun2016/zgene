import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
// import 'package:divms/constant/config_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluwx/fluwx.dart';
// import 'package:jshare_flutter_plugin/jshare_flutter_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/config_constant.dart';
import 'package:zgene/util/platform_utils.dart';

enum JSharePlatform {
  wechatSession,
  wechatTimeLine,
  wechatFavourite,
  qq,
  qZone,
  sinaWeibo,
  sinaWeiboContact,
  facebook,
  facebookMessenger,
  twitter
}

///分享
class ShareUtils {
  // static JShare jShare = new JShare();
  static String title, content, url, imageUrl;
  static int type = 1; //1.网络图片 2.assets图片
  static List<Map<String, dynamic>> platfromList = [];

  ///分享
  static Widget showSheet(
      {BuildContext context,
      String shareTitle,
      String shareContent,
      String shareUrl,
      int shareType,
      String shareImageUrl}) {
    title = shareTitle;
    content = shareContent;
    url = shareUrl;
    type = shareType;
    imageUrl = shareImageUrl;
    platfromList = [];
    for (var i = 0; i < 4; i++) {
      Map<String, dynamic> map = new HashMap();
      switch (i) {
        case 0:
          if (ConfigConstant.wxAppKey.isEmpty ||
              ConfigConstant.wxAppSecret.isEmpty) {
            break;
          }
          map['name'] = "微信";
          map['icon'] = "assets/images/home/icon_weixin_share.png";
          map['platform'] = JSharePlatform.wechatSession;
          platfromList.add(map);
          break;
        case 1:
          if (ConfigConstant.wxAppKey.isEmpty ||
              ConfigConstant.wxAppSecret.isEmpty) {
            break;
          }
          map['name'] = "朋友圈";
          map['icon'] = "assets/images/home/icon_penyouquan_share.png";
          map['platform'] = JSharePlatform.wechatTimeLine;
          platfromList.add(map);
          break;
      }
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return _shareWidget(context);
        });
  }

  ///分享界面
  static Widget _shareWidget(BuildContext context) {
    return Container(
      height: 252,
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        //设置四周边框
        // border: new Border.all(width: 1, color: Colors.red),
      ),
      // color: Colors.white,
      child: new Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 47),
            child: Text(
              "分享到",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorConstant.TextSecondColor,
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 10),
            child: new Container(
              height: 150,
              child: new GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: platfromList.length,
                    mainAxisSpacing: 1.0,
                    childAspectRatio: 1.0),
                itemBuilder: (BuildContext context, int index) {
                  return new Column(
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: new GestureDetector(
                            child: new Image.asset(
                              platfromList[index]["icon"],
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              didSelectPlatform(index: index);
                            },
                          )),
                      new Text(
                        platfromList[index]["name"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.TextSecondColor,
                        ),
                      ),
                    ],
                  );
                },
                itemCount: platfromList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ///分享平台
  // static List<Map<String, dynamic>> platfromList = [
  //   {
  //     "name": "微信",
  //     "icon": "jiguang_socialize_wechat.png",
  //     "platform": JSharePlatform.wechatSession
  //   },
  //   {
  //     "name": "朋友圈",
  //     "icon": "jiguang_socialize_wxtimeLine.png",
  //     "platform": JSharePlatform.wechatTimeLine
  //   },
  //   {
  //     "name": "QQ",
  //     "icon": "jiguang_socialize_qq.png",
  //     "platform": JSharePlatform.qq
  //   },
  //   {
  //     "name": "微博",
  //     "icon": "jiguang_socialize_sina.png",
  //     "platform": JSharePlatform.sinaWeibo
  //   },
  // ];
  static String tempImageUrl = "share.png";

  /// 选择摸个平台分享
  static void didSelectPlatform({int index}) async {
    // print("Action - didSelectPlatform:  " +
    //     "platfrom = " +
    //     platfromList[index].toString());

    // JShareMessage message = new JShareMessage();
    // message.mediaType = JShareType.link;
    // message.platform = platfromList[index]["platform"];

    // message.text = content;
    // message.title = title;
    // message.url = url;
    if (imageUrl.isEmpty) {
      type = 2;
      imageUrl = "assets/images/home/icon_main_logo.png";
    }

    // if (PlatformUtils.isAndroid) {
    //   message.imagePath = await _tempSaveTestImage();
    // } else {
    //   File compressedFile = await FlutterNativeImage.compressImage(
    //       await _tempSaveTestImage(),
    //       quality: 32);
    //   message.imagePath = compressedFi le.path;
    // }

    // if (PlatformUtils.isIOS) {
    //ios分享微信
    if (platfromList[index]["platform"] == JSharePlatform.wechatSession) {
      File compressedFile =
          await FlutterNativeImage.compressImage(await _tempSaveTestImage());

      var model = WeChatShareWebPageModel(
        url,
        title: title,
        thumbnail: WeChatImage.file(compressedFile),
        scene: WeChatScene.SESSION,
        description: content,
      );

      shareToWeChat(model);

      return;
    }

    if (platfromList[index]["platform"] == JSharePlatform.wechatTimeLine) {
      //ios分享微信圈
      File compressedFile =
          await FlutterNativeImage.compressImage(await _tempSaveTestImage());

      var model = WeChatShareWebPageModel(
        url,
        title: title,
        thumbnail: WeChatImage.file(compressedFile),
        scene: WeChatScene.TIMELINE,
        description: content,
      );

      shareToWeChat(model);

      return;
    }
    // }

    // jShare.shareMessage(message: message).then((JShareResponse response) {
    //   print("分享回调：" + response.toJsonMap().toString());
    //   // setState(() {
    //   //   _resultString = "分享成功："+ response.toJsonMap().toString();
    //   // });
    //   /// 删除测试图片
    //   _tempDeleteTestImage();
    // }).catchError((error) {
    //   print("分享回调 -- 出错：${error.toString()}");

    //   // setState(() {
    //   //   _resultString = "分享失败："+ error.toString();
    //   // });
    //   //
    //   /// 删除测试图片
    //   _tempDeleteTestImage();
    // });
  }

  static Future<void> initPlatformState() async {
    // JShareConfig shareConfig =
    //     new JShareConfig(appKey: ConfigConstant.jpushAppKey);

    // /// 填写自己应用的极光 AppKey

    // shareConfig.channel = "channel";
    // shareConfig.isDebug = true;
    // shareConfig.isAdvertisinId = true;
    // shareConfig.isProduction = true;
    // shareConfig.universalLink = ConfigConstant.universalLink;

    // shareConfig.weChatAppId = ConfigConstant.wxAppKey;
    // shareConfig.weChatAppSecret = ConfigConstant.wxAppSecret;

    // jShare.setup(config: shareConfig);
  }

  ///处理图片
  static Future<String> _tempSaveTestImage() async {
    print("Action - _tempSaveTestImage:");
    final Directory directory = await getTemporaryDirectory();
    Uint8List bytes;
    if (type == 1) {
      bytes = await getImageBytes(imageUrl);
    } else {
      bytes = await getAssetsImageBytes(imageUrl);
    }
    String path = await saveFile(directory, bytes);

    return path;
  }

  /// TEST : 获取 assets里的图片（测试暂时用 assets 里的）
  static Future<Uint8List> getAssetsImageBytes(String imagePath) async {
    print("Action - getAssetsImageBytes:" + imagePath);

    ByteData byteData = await rootBundle.load("assets/images/" + imagePath);
    Uint8List uint8list = byteData.buffer.asUint8List();
    return uint8list;
  }

  /// TEST : 获取 assets里的图片（测试暂时用 assets 里的）
  static Future<Uint8List> getImageBytes(String imagePath) async {
    print("Action - getAssetsImageBytes:" + imagePath);

    var response = await Dio()
        .get(imagePath, options: Options(responseType: ResponseType.bytes));
    Uint8List uint8list = Uint8List.fromList(response.data);
    return uint8list;
  }

  /// TEST : 存储文件
  static Future<String> saveFile(Directory directory, Uint8List bytes) async {
    print("Action - _saveFile:" +
        "directory:" +
        directory.toString() +
        ",name:" +
        tempImageUrl);
    final File file = File('${directory.path}/$tempImageUrl');

    if (file.existsSync()) {
      file.deleteSync();
    }

    File file1 = await file.writeAsBytes(bytes);

    if (file1.existsSync()) {
      print('====保存成功');
    } else {
      print('====保存失败');
    }
    return file1.path;
  }

  /// TEST : 删除图片
  static void _tempDeleteTestImage() async {
    print("Action - _tempDeleteTestImage:");
    final Directory directory = await getTemporaryDirectory();
    String imageName = tempImageUrl;
    _deleteFile(directory, imageName);
  }

  /// TEST : 删除文件
  static void _deleteFile(Directory directory, String name) {
    print("Action - _deleteFile:");
    final File file = File('${directory.path}/$name');

    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
