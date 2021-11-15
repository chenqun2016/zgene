import 'package:base/constant/color_constant.dart';
import 'package:base/constant/sp_constant.dart';
import 'package:base/util/platform_utils.dart';
import 'package:base/util/sp_utils.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

//基础webview
abstract class BaseWebView extends StatefulWidget {
  String url;
  String showTitle;
  String title;
  bool isShare;

  BaseWebView(
      {Key? key,
      required this.url,
      this.title = "",
      this.showTitle = "",
      this.isShare = true})
      : super(key: key);

  @override
  BaseWebViewState createState() => getState();

  BaseWebViewState getState();
}

abstract class BaseWebViewState<T extends BaseWebView> extends State<T> {
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

  void onPreBuild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    print("ssssddd");

    onPreBuild(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage("assets/images/icon_commonQus_back.png"),
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
                  widget.showTitle,
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
                          icon: getRightBottomWidget(),
                          onPressed: onRightButtonPressed),
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
                            : uri == null
                                ? Text("")
                                : InAppWebView(
                                    initialOptions: options,
                                    initialUrlRequest: URLRequest(url: uri),
                                    onWebViewCreated: (controller) {
                                      doAddJavaScriptHandler(controller);
                                    },
                                    onLoadStart:
                                        (InAppWebViewController controller,
                                            Uri? url) {
                                      print("url== == ${url?.path.toString()}");
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

  var uri;

  void setCookie() async {
    var uri1;
    try {
      String token = SpUtils().getStorageDefault(SpConstant.Token, "");
      uri1 = Uri.parse(_url);
      await setUriCookie(uri1, token);
    } catch (e) {
      print("setCookie-error==" + e.toString());
    }
    setState(() {
      uri = uri1;
    });
  }

  static const String JWT = "jwt";
  Future setUriCookie(uri1, String token) async {
    if (null != token && token.isNotEmpty) {
      CookieManager cookieManager = CookieManager.instance();
      Cookie? cookie = await cookieManager.getCookie(url: uri1, name: JWT);
      if (null != cookie &&
          null != cookie.value &&
          cookie.value.toString().isNotEmpty &&
          cookie.value != token) {
        await cookieManager.deleteCookie(url: uri1, name: JWT);
      }
      await cookieManager.setCookie(
        url: uri1,
        name: JWT,
        value: token,
        isSecure: false,
        isHttpOnly: false,
      );
    }
    return Future.value(1);
  }

  void onRightButtonPressed();

  void doAddJavaScriptHandler(controller);

  Widget getRightBottomWidget();
}
