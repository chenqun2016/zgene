import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/util/sp_utils.dart';

//基础webview
class BaseWebView extends StatefulWidget {
  String url;
  String title;

  BaseWebView({Key key,  this.url, this.title}) : super(key: key);

  @override
  _BaseWebViewState createState() => _BaseWebViewState();
}

class _BaseWebViewState extends State<BaseWebView> {
  // 是否显示加载动画
  bool _flag = true;
  // final Map arguments;

  String _url = "";
  @override
  void initState() {
    super.initState();
    _url = widget.url;
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent: "zgene",
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorConstant.WhiteColor,
              brightness: Brightness.light,
              leading: IconButton(
                icon: ImageIcon(
                  AssetImage("assets/images/icon_mine_backArrow.png"),
                  size: 16,
                  color: ColorConstant.MainBlack,
                ),
                onPressed: () {
                  Navigator.pop(context, 1);
                },
              ),
              elevation: 0,
              title: Text(
                widget.title??"",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.MainBlack),
              ),
            ),
            body: Column(
              children: <Widget>[
                this._flag?
                     _getMoreWidget()
                    : Container(
                        height: 0,
                      ),
                Expanded(
                  // 官方代码
                  child: InAppWebView(
                    // initialUrl: widget.url,

                    initialOptions: options,
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(_url),
                        headers: {"Referer ": CommonConstant.BASE_API}),

                    onWebViewCreated: (controller) {
                      controller.addJavaScriptHandler(
                          handlerName: "handlerGetCode",
                          callback: (args) {
                            print(args);
                            return {
                              'os': Platform.isAndroid ? 'Android' : 'iOS',
                              'token': SpUtils()
                                  .getStorageDefault(SpConstant.Token, "")
                            };
                          });
                      controller.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse(_url),
                              headers: {"Referer ": CommonConstant.BASE_API}));
                    },
                    onLoadStart: (controller, url) async {
                      if (!(url.toString().startsWith("http:") ||
                          url.toString().startsWith("https:"))) {
                        await launch(url.toString());
                      }
                    },

                    // 加载进度变化事件.
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      if ((progress / 100) > 0.999) {
                        setState(() {
                          this._flag = false;
                        });
                      }
                    },
                  ),
                )
              ],
            )));
  }

  // 加载状态
  Widget _getMoreWidget() {
    return Container(
      // height: 0,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '加载中  ',
                style: TextStyle(fontSize: 16.0),
              ),
              CircularProgressIndicator(
                strokeWidth: 1.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
