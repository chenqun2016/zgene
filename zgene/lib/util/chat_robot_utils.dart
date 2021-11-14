import 'dart:convert';

import 'package:base/navigator/navigator_util.dart';
import 'package:base/util/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/widget/base_web.dart';

class ChatRobotUtils {
  ///智能语音
  ///url 拼接规则 url="对话链接(例:https://团队ID.ahc.ink/chat.html)?+"headHidden=1( 1则为隐藏title 不传则不隐藏)"+"&传递顾客参数(例如：customer={})"+"&其它参数（可选择 例如：uniqueId=会员唯一ID）"
  static void showChatH5(BuildContext context) async {
    var spUtils = SpUtils();
    var customerMap = {
      "名称": spUtils.getStorage(SpConstant.UserName).toString(),
      "手机": spUtils.getStorage(SpConstant.UserMobile).toString()
    };
    String customer = json.encode(customerMap);

    String uniqueId = spUtils.getStorage(SpConstant.AppUdid);
    if (null == uniqueId || uniqueId.isEmpty) {
      uniqueId = spUtils.getStorage(SpConstant.Uid);
    }
    String url = ApiConstant.smartServiceUrl +
        "?headHidden=1" +
        "&uniqueId=$uniqueId" +
        "&customer=$customer";

    print("url==" + url);
    NavigatorUtil.push(
        context,
        BaseWebView(
          url: url,
          title: "智能客服",
          isShare: false,
        ));
  }
}
