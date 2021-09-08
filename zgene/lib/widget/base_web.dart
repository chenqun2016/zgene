import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:zgene/util/platform_utils.dart';

//基础webview
class BaseWebView extends StatefulWidget {
  String url;
  String title;

  BaseWebView({Key key, this.url, this.title}) : super(key: key);

  @override
  _BaseWebViewState createState() => _BaseWebViewState();
}

class _BaseWebViewState extends State<BaseWebView> {
  // 是否显示加载动画
  bool _flag = PlatformUtils.isWeb ? false : true;

  // final Map arguments;

  String _url = "";
  static ValueKey key = ValueKey('key_0');

  @override
  void initState() {
    super.initState();
    _url = widget.url;

   setCookie();
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
                widget.title ?? "",
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
                this._flag
                    ? _getMoreWidget()
                    : Container(
                        height: 0,
                      ),
                Expanded(
                  // 官方代码
                  child: PlatformUtils.isWeb
                      ? EasyWebView(
                          onLoaded: () {
                            print('Loaded: $_url');
                          },
                          src: _uri,
                          isHtml: false,
                          isMarkdown: false,
                          convertToWidgets: false,
                          widgetsTextSelectable: false,
                          key: key,
                          webNavigationDelegate: (_) => false
                              ? WebNavigationDecision.prevent
                              : WebNavigationDecision.navigate,
                          // width: 100,
                          // height: 100,
                        )
                      : InAppWebView(
                          initialOptions: options,
                          initialUrlRequest:
                              URLRequest(url: _uri),

                          // 加载进度变化事件.
                          onProgressChanged: (InAppWebViewController controller,
                              int progress) {
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

  var _uri;
  void setCookie() async{
    _uri = Uri.parse(_url);
    CookieManager cookieManager = CookieManager.instance();
    await cookieManager.setCookie(
      url: _uri,
      name: "jwt",
      value: SpUtils().getStorageDefault(SpConstant.Token, ""),
      isSecure: false,
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:zgene/util/platform_utils.dart';

// class BaseWebView extends StatefulWidget {
//   String url;
//   String title;

//   BaseWebView({Key key, this.url, this.title}) : super(key: key);

//   @override
//   _BaseWebViewState createState() => _BaseWebViewState();
// }

// class _BaseWebViewState extends State<BaseWebView> {
//   // 是否显示加载动画
//   bool _flag = PlatformUtils.isWeb ? false : true;
//   // 是否显示加载动画

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Scaffold(
//             appBar: AppBar(
//               title: Text(widget.title),
//             ),
//             body: Column(
//               children: <Widget>[
//                 this._flag ? _getMoreWidget() : Text(""),
//                 Expanded(
//                   // 官方代码
//                   child: InAppWebView(
//                     initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
//                     // 加载进度变化事件
//                     onProgressChanged:
//                         (InAppWebViewController controller, int progress) {
//                       if ((progress / 100) > 0.999) {
//                         setState(() {
//                           this._flag = false;
//                         });
//                       }
//                     },
//                   ),
//                 )
//               ],
//             )));
//   }

//   // 加载状态
//   Widget _getMoreWidget() {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(10.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '加载中...',
//               style: TextStyle(fontSize: 16.0),
//             ),
//             CircularProgressIndicator(
//               strokeWidth: 1.0,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
