import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/share_utils.dart'
    if (dart.library.html) 'package:zgene/util/share_utils_web.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:easy_web_view/easy_web_view.dart';

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
        allowsInlineMediaPlayback: false,
      ));

  @override
  Widget build(BuildContext context) {
    print("ssssddd");
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
                  widget.title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.TextMainBlack,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
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
                                .getStorageDefault(SpConstant.appShareIcon, "")
                                .toString()));
                      }),
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
                                // width: 100,
                                // height: 100,
                              )
                            : _uri == null
                                ? Text("")
                                : InAppWebView(
                                    initialOptions: options,
                                    initialUrlRequest: URLRequest(url: _uri),

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
}
