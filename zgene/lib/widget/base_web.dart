import 'package:base/util/sp_utils.dart';
import 'package:base/widget/base_web.dart';
import 'package:flutter/material.dart';
import 'package:zgene/configure.dart'
    if (dart.library.html) 'package:zgene/configure_web.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/share_utils.dart'
    if (dart.library.html) 'package:zgene/util/share_utils_web.dart';

//基础webview
class ZgeneWebView extends BaseWebView {
  @override
  getState() {
    return _ZgeneWebViewState();
  }

  ZgeneWebView(
      {Key key,
      String url,
      String title = "",
      String showTitle = "",
      bool isShare = true})
      : super(
            key: key,
            url: url,
            title: title,
            showTitle: showTitle,
            isShare: isShare);
}

class _ZgeneWebViewState extends BaseWebViewState<ZgeneWebView> {
  @override
  void onPreBuild(BuildContext context) {
    weNavJump(navigateJump);
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

  @override
  void onRightButtonPressed() {
    print(CommonUtils.splicingUrl(
        SpUtils().getStorageDefault(SpConstant.appShareIcon, "").toString()));
    ShareUtils.showSheet(
        context: context,
        shareTitle: widget.title,
        shareContent: SpUtils()
            .getStorageDefault(SpConstant.appShareSubtitle, "")
            .toString(),
        shareUrl: uri.toString(),
        shareType: 1,
        shareImageUrl: CommonUtils.splicingUrl(SpUtils()
            .getStorageDefault(SpConstant.appShareIcon, "")
            .toString()));
  }

  @override
  void doAddJavaScriptHandler(controller) {
    CommonUtils.addJavaScriptHandler(controller, context);
  }

  @override
  Widget getRightBottomWidget() {
    return Image(
      image: AssetImage("assets/images/home/icon_article_detail.png"),
    );
  }
}
