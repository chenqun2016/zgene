import 'common_constant.dart';

///api路径
class ApiConstant {
  ///********************************** 自媒体流 *****************************///
  //获取用户详情、修改用户信息
  static const String userInfo = "/api/v1/user/info";

  //商品详情页，内容推荐列表
  static const String productDetailRecommends =
      "/api/v1/archive/:aid/recommends";
  //内容列表
  static const String contentList = "/api/v1/archives";
  //分类列表
  static const String categories = "/api/v1/categories";
  //内容详情
  static const String contentDetail = "/api/v1/archive";
//阅读全部消息
  static const String readMessage = "/api/v1/user/notice/readall";
//设置消息已读
  static const String noticeRead = "/api/v2/notice/read";

  ///********************************* 用户 *****************************///
  //隐私政策
  static const String privacy = "/privacy";
  //获取未读消息数量
  static const String userNoticeCount = "/api/v1/user/notice/count";
  //用户头像上传
  static const String userAvatar = "/api/v1/user/avatar";

  //用户隐私
  static const String agreement = "/agreement";

  //用户隐私
  static const String payLink = "/service/pay/#/pages/CoinRecharge/index";

//地址查询
  static const String userAddresses = "/api/v1/user/addresses";

  //地址添加
  static const String userAddAddress = "/api/v1/user/address";
  //地址添加
  static const String userDeleteAddress = "/api/v1/user/address/:id";

  ///********************************** 登录 *****************************///
  //配置
  static const String settings = "/api/v1/settings";

  //获取验证码
  static const String loginSms = "/api/v1/login/sms";
//获取验证码
  static const String smscode = "/api/v1/user/smscode";
  //手机号登录
  static const String loginApp_phone = "/api/v1/user/login/app_phone";
  //手机号登录
  static const String user_sms_code = "/api/v1/user/sms/:code";
  //手机号绑定
  static const String bindAppPhone = "/api/v1/user/bind/mobile";
  //微信联合登录
  static const String login_wx = "/api/v1/user/login/wx";
  //绑定微信
  static const String bind_wx = "/api/v1/user/bind/wx";
  //解绑微信
  static const String unbind_wx = "/api/v1/user/unbind/wx";
  //苹果联合登录
  static const String login_apple = "/api/v1/user/login/apple";
  //采集器列表
  static const String collector_list = "/api/v2/collector/list";
  //采集器详情
  static const String collector_detail = "/api/v2/collector/detail";
  //隐私政策
  // static const String privacys = CommonConstant.BASE_API + ApiConstant.privacy;

  //用户协议
  // static const String agreements =
  //     CommonConstant.BASE_API + ApiConstant.agreement;

  //用户协议
  static const String payLinks = CommonConstant.BASE_API + ApiConstant.payLink;

  ///********************************* 消息 *****************************///
  //消息列表
  static const String messageList = "/api/v1/user/notices";

  ///********************************* 订单 *****************************///
  //下单
  static const String ordering = "/api/v1/order/create";
  //绑定采集器
  static const String bindColector = "/api/v1/order/bind";

  //订单列表
  static const String orderList = "/api/v1/order/list";
  //订单详情
  static const String orderDetail = "/api/v1/order/detail";

  //消息列表
  static const String orderReturn = "/api/v1/order/return";

  //获取订单当前状态
  static const String orderStatus = "/api/v1/order/status";

  //采集器id验证
  static const String numCheck = "/api/v1/order/check";

  ///********************************* 报告 *****************************///

  //报告详情
  static const String reportDetail = "/api/v2/report/:id/detail";
  //报告列表
  static const String reportList = "/api/v2/report/:id/list";
  //首页我的报告
  static const String reportSummary = "/api/v2/report/summary";

  //基因报告列表
  static const String reports = "/api/v1/gene/reports";

  //智能客服地址
  // static const String smartServiceUrl =
  //     "http://chat.ahcdialogchat.com/chat/h5/chatLink.html?channelId=llHC67";
  static const String smartServiceUrl = CommonConstant.BASE_API + "/kefu";

  //H5地址，直接webview加载
  static String getH5DetailUrl(id) {
    return CommonConstant.BASE_API + "/archive/embed/$id";
  }

  //H5地址，直接webview加载
  static String getH5ShareUrl(id) {
    return CommonConstant.BASE_API + "/archive/share/$id";
  }

  //获取顺丰物流H5地址
  static String getSFH5DetailUrl(id) {
    return CommonConstant.BASE_API + "/user/sf?nu=$id";
  }

  //获取pdf的H5地址
  static String getPDFH5DetailUrl(id) {
    return CommonConstant.BASE_API + "/user/pdf?cid=$id";
  }
}
