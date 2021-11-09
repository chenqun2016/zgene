// import 'dart:html';

import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart' as webView;
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/share_utils.dart'
    if (dart.library.html) 'package:zgene/util/share_utils_web.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/configure.dart'
    if (dart.library.html) 'package:zgene/configure_web.dart';

//基础webview
class BaseWebView extends StatefulWidget {
  String url;
  String showTitle;
  String title;
  bool isShare = true;

  BaseWebView({Key key, this.url, this.title, this.showTitle, this.isShare})
      : super(key: key);

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
    print(widget.showTitle);
    if (widget.isShare == null) {
      widget.isShare = true;
    }
    if (widget.showTitle == null) {
      widget.showTitle = widget.title;
    }
    // Web不需要设定cookie
    if (!PlatformUtils.isWeb) {
      setCookie();
    }
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        supportZoom: false,
        transparentBackground: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent: "Z-Gene",
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    print("ssssddd");
    weNavJump(navigateJump);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage("assets/images/mine/icon_commonQus_back.png"),
              fit: BoxFit.fill,
            ),
          ),
          // color: Colors.red,
          padding: EdgeInsets.all(0),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
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
                centerTitle: true,
                title: Text(
                  widget.showTitle ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.TextMainBlack,
                  ),
                ),
                actions: <Widget>[
                  Offstage(
                    offstage: PlatformUtils.isWeb,
                    child: Offstage(
                      offstage: !widget.isShare,
                      child: IconButton(
                          icon: Image(
                            image: AssetImage(
                                "assets/images/home/icon_article_detail.png"),
                          ),
                          onPressed: () {
                            print(CommonUtils.splicingUrl(SpUtils()
                                .getStorageDefault(SpConstant.appShareIcon, "")
                                .toString()));
                            ShareUtils.showSheet(
                                context: context,
                                shareTitle: widget.title,
                                shareContent: SpUtils()
                                    .getStorageDefault(
                                        SpConstant.appShareSubtitle, "")
                                    .toString(),
                                shareUrl: _uri.toString(),
                                shareType: 1,
                                shareImageUrl: CommonUtils.splicingUrl(SpUtils()
                                    .getStorageDefault(
                                        SpConstant.appShareIcon, "")
                                    .toString()));
                          }),
                    ),
                  ),
                ],
              ),
              body: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Column(
                  children: <Widget>[
                    this._flag
                        ? _getMoreWidget()
                        : Container(
                            height: 0,
                          ),
                    if (null != _url)
                      Expanded(
                        // 官方代码
                        child: PlatformUtils.isWeb
                            // ? webView.WebView(
                            //     initialUrl: _url,
                            //     javascriptMode:
                            //         webView.JavascriptMode.unrestricted,
                            //   )
                            // ? webviewx()

                            ? EasyWebView(
                                onLoaded: () {
                                  print('Loaded: $_url');
                                },
                                src: _url,
                                isHtml: false,
                                isMarkdown: false,
                                convertToWidgets: false,
                                widgetsTextSelectable: false,
                                key: key,
                                webNavigationDelegate: (_) => false
                                    ? WebNavigationDecision.prevent
                                    : WebNavigationDecision.navigate,

                                // webNavigationDelegate: (request) {
                                //   print(Url);
                                //   print('blocking navigation to $request}');

                                //   // if (request.url.startsWith('http://webview')) {
                                //   //   //拦截以js://webview 开始的链接 说明页面执行了这个链接的跳转操作，也就是页面按钮被点击了。那么执行相关的flutter操作。
                                //   //   print('blocking navigation to $request}');
                                //   // }

                                //   return WebNavigationDecision.prevent;
                                // },

                                // width: 100,
                                // height: 100,
                              )
                            : _uri == null
                                ? Text("")
                                : InAppWebView(
                                    initialOptions: options,
                                    initialUrlRequest: URLRequest(url: _uri),
                                    onWebViewCreated: (controller) {
                                      CommonUtils.addJavaScriptHandler(
                                          controller, context);
                                    },
                                    onLoadStart:
                                        (InAppWebViewController controller,
                                            Uri url) {
                                      print("url== == " + url.path.toString());
                                    },
                                    // 加载进度变化事件.
                                    onProgressChanged:
                                        (InAppWebViewController controller,
                                            int progress) {
                                      if ((progress / 100) > 0.999) {
                                        setState(() {
                                          this._flag = false;
                                        });
                                      }
                                    },
                                    onLoadError:
                                        (controller, url, code, message) {
                                      print("webview error == " + message);
                                    },
                                    androidOnPermissionRequest:
                                        (controller, origin, resources) async {
                                      return PermissionRequestResponse(
                                          resources: resources,
                                          action:
                                              PermissionRequestResponseAction
                                                  .GRANT);
                                    },
                                  ),
                      )
                  ],
                ),
              ))),
    );
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

  void setCookie() async {
    var uri1;
    try {
      String token = SpUtils().getStorageDefault(SpConstant.Token, "");
      uri1 = Uri.parse(_url);
      await CommonUtils.setCookie(uri1, token);
    } catch (e) {
      print("setCookie-error==" + e);
    }
    setState(() {
      _uri = uri1;
    });
  }

  void navigateJump(args) {
    print("js调用flutter跳转");
    print(args);
    try {
      print("navigate try");
      if (null != args && args.length >= 2) {
        CommonUtils.toUrl(context: context, url: args[1], type: args[0]);
        if (args[1] == CommonUtils.URL_BUY ||
            args[1] == CommonUtils.URL_MY ||
            (args[1].contains(CommonUtils.URL_REPORT) &&
                !args[1].contains("_"))) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print("navigate catch");
      print(e);
    }
  }
}
