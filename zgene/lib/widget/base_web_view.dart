import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/sp_utils.dart';

///封装的WebView
class BasePageWebView extends StatefulWidget {
  String url;

  BasePageWebView({Key key, this.url}) : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<BasePageWebView> {
  double myHeight = 0.1;

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
        supportZoom: false,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent: "Z-Gene",
      ),
      android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          cacheMode: AndroidCacheMode.LOAD_NO_CACHE),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        this._flag
            ? _getMoreWidget()
            : Container(
                height: 0,
              ),
        SizedBox(
          height: myHeight,
          child: InAppWebView(
            // initialUrl: widget.url,

            initialOptions: options,

            initialUrlRequest: URLRequest(
                url: Uri.parse(_url),),

            onLoadError: (controller, url, code, message) {
              print("url==$url // code==$code  // message==$message");
            },
            onLoadHttpError: (controller, url, code, message) {
              print("url==$url // code==$code  // message==$message");
            },
            onWebViewCreated: (controller) {
              try {
                controller.addJavaScriptHandler(
                    handlerName: "handlerGetCode",
                    callback: (args) {
                      print(args);
                      return {
                        'os': PlatformUtils.isAndroid ? 'Android' : 'iOS',
                        'token':
                            SpUtils().getStorageDefault(SpConstant.Token, "")
                      };
                    });
              } catch (e) {
                print(e);
              }

              controller.loadUrl(
                  urlRequest: URLRequest(
                      url: Uri.parse(_url),));
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
            onLoadStop: (controller, url) async {
              print("onLoadStop:$url");
              Future.delayed(new Duration(milliseconds: 500), () async {
                int height = await controller.getContentHeight();
                print(height);
                setState(() {
                  myHeight = height.toDouble();
                });
              });
            },
          ),
        ),
      ],
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
}
