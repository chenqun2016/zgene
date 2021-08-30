import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/color_constant.dart';

///下拉和加载更多配置工具来
class RefreshConfigUtils{

  ///头部配置
  static ClassicalHeader classicalHeader(){
    return ClassicalHeader(
      enableInfiniteRefresh: false,
      bgColor: Colors.transparent,
      infoColor: ColorConstant.TextMainBlack,
      textColor: ColorConstant.TextMainBlack,
      float: false,
      showInfo: false,
      enableHapticFeedback: true,
      refreshText: "下拉刷新",
      refreshReadyText: "即将加载...",
      refreshingText: "数据加载中...",
      refreshedText: "数据加载完成",
      refreshFailedText: "加载失败",
      noMoreText: "数据加载完成",
      infoText: "",
    );
  }

  ///底部配置
  static ClassicalFooter classicalFooter(){
    return  ClassicalFooter(
      bgColor: Colors.white,
      //  更多信息文字颜色
      infoColor: ColorConstant.TextMainBlack,
      // 字体颜色
      textColor: ColorConstant.TextMainBlack,
      // 加载失败时显示的文字
      loadText: "数据加载中...",
      // 没有更多时显示的文字
      noMoreText: '暂无更多数据了',
      // 是否显示提示信息
      showInfo: false,
      // 正在加载时的文字
      loadingText: "数据加载中...",
      // 准备加载时显示的文字
      loadReadyText: "即将加载",
      // 加载完成显示的文字
      loadedText: "加载完成",
    );
  }

}