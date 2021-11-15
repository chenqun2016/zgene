import 'package:base/constant/color_constant.dart';
import 'package:base/util/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///用于页面中的webview，解决高度太高报错的问题
class BasePageWebView extends StatefulWidget {
  final String url;

  BasePageWebView({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<BasePageWebView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

// 是否显示加载动画
  double _progress = 0;
  String _url = "";
  WebViewController? _webViewController;
  double _webViewHeight = 1;

  @override
  void initState() {
    super.initState();
    _url = widget.url;
    if (PlatformUtils.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_progress <= 0.9) _getMoreWidget(),
        SizedBox(
            height: _webViewHeight,
            child: WebView(
              initialUrl: _url,
              allowsInlineMediaPlayback: true,
              debuggingEnabled: false,
              onProgress: (progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              userAgent: "Z-Gene",
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) => _onPageFinished(context, url),
              onWebViewCreated: (controller) async {
                _webViewController = controller;
              },
              gestureNavigationEnabled: false,
            )),
      ],
    );
  }

  Future<void> _onPageFinished(BuildContext context, String url) async {
    try {
      if (null != _webViewController) {
        double newHeight = double.parse(
          await _webViewController!
              .evaluateJavascript("document.documentElement.scrollHeight;"),
        );
        setState(() {
          _webViewHeight = newHeight;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // 加载状态
  Widget _getMoreWidget() {
    return LinearProgressIndicator(
      minHeight: 3,
      backgroundColor: Color(0x66007AF7),
      valueColor: AlwaysStoppedAnimation<Color>(ColorConstant.TextMainColor),
      value: _progress,
    );
  }
}
