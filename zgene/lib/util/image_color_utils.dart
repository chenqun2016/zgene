import 'dart:ui' as ui;

import 'package:base/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageColorUtils {
//读取 assets 中的图片
  static Future<ui.Image> loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return decodeImageFromList(bytes);
  }

  static String getAssetIcon(String color) {
    if ("green" == color) {
      return "assets/images/report/img_zhong.png";
    }
    if ("blue" == color) {
      return "assets/images/report/img_qiang.png";
    }
    if ("red" == color) {
      return "assets/images/report/img_luo.png";
    }
  }

  static String getReportDetailIndexIcon(int index) {
    switch (index % 4) {
      case 0:
        return "assets/images/report/icon_report_item_1.png";
      case 1:
        return "assets/images/report/icon_report_item_2.png";
      case 2:
        return "assets/images/report/icon_report_item_3.png";
      case 3:
        return "assets/images/report/icon_report_item_4.png";
      default:
        return "assets/images/report/icon_report_item_4.png";
    }
  }

  static String getReportListIcon(String id) {
    switch (id) {
      case "jibingshaicha":
        return "assets/images/report/banner_jibingshaicha.png";
      case "jiankangfengxian":
        return "assets/images/report/banner_jiankang.png";
      case "pifuguanli":
        return "assets/images/report/banner_pifuguanli.png";
      case "jibingshaicha":
        return "assets/images/report/banner_shenhghuozhidao.png";
      case "tizhitedian":
        return "assets/images/report/banner_tizhi.png";
      case "xinlirenzhi":
        return "assets/images/report/banner_xinlirenzhi.png";
      case "yingyangxuqiu":
        return "assets/images/report/banner_yingyangxuq.png";
      case "daixienengli":
        return "assets/images/report/banner_yinshidaixie.png";
      case "yongyaozhidao":
        return "assets/images/report/banner_yongyao.png";
      case "yundongjianshen":
        return "assets/images/report/banner_yundong.png";
      default:
        return "assets/images/report/banner_jibingshaicha.png";
    }
  }

  static getTipColor(String color) {
    if ("green" == color) {
      return LinearGradient(colors: [
        Color(0xFF47FEDB),
        Color(0xFF23CFAF),
      ]);
    }
    if ("blue" == color) {
      return LinearGradient(colors: [
        Color(0xFF5EECFD),
        Color(0xFF248DFA),
      ]);
    }
    if ("red" == color) {
      return LinearGradient(colors: [
        Color(0xFFFE8B8C),
        Color(0xFFFE4343),
      ]);
    }
  }

  static String getReportResultCircle(int color) {
    if (0 == color % 6) {
      return "assets/images/report/icon_report_item_green.png";
    }
    if (1 == color % 6) {
      return "assets/images/report/icon_report_item_blue.png";
    }
    if (2 == color % 6) {
      return "assets/images/report/icon_report_item_yellow.png";
    }
    if (3 == color % 6) {
      return "assets/images/report/icon_report_item_red.png";
    }
    if (4 == color % 6) {
      return "assets/images/report/icon_report_item_zi.png";
    }
    if (5 == color % 6) {
      return "assets/images/report/icon_report_item_orange.png";
    }
    return "assets/images/report/icon_report_item_green.png";
  }

  static String getReportResultCircle3(int color) {
    if (0 == color % 3) {
      return "assets/images/report/icon_report_item_green.png";
    }
    if (1 == color % 3) {
      return "assets/images/report/icon_report_item_blue.png";
    }
    return "assets/images/report/icon_report_item_red.png";
  }

  static Color getColor(int index) {
    if (0 == index % 6) {
      //绿色
      return ColorConstant.bg_24D780;
    }
    if (1 == index % 6) {
      //蓝色
      return ColorConstant.bg_017AF6;
    }
    if (2 == index % 6) {
      //黄色
      return ColorConstant.bg_FFBE00;
    }
    if (3 == index % 6) {
      //黄色
      return ColorConstant.bg_FD7A7A;
    }
    if (4 == index % 6) {
      //黄色
      return ColorConstant.bg_B57AFD;
    }
    if (5 == index % 6) {
      //黄色
      return ColorConstant.bg_FFDD00;
    }
    //绿色
    return ColorConstant.bg_24D780;
  }

  static Color getColor3(int index) {
    if (0 == index % 3) {
      //绿色
      return ColorConstant.bg_24D780;
    }
    if (1 == index % 3) {
      //蓝色
      return ColorConstant.bg_017AF6;
    }
    //橙色
    return ColorConstant.bg_FD7A7A;
  }
}
