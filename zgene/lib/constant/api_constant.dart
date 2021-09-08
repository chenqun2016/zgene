import 'common_constant.dart';

///api路径
class ApiConstant {
  ///********************************** 自媒体流 *****************************///
  //获取用户详情、修改用户信息
  static const String userInfo = "/api/v1/user/info";
  //内容列表
  static const String contentList = "/api/v1/archives";
  //分类列表
  static const String categories = "/api/v1/categories";
  //内容详情
  static const String contentDetail = "/api/v1/archive";
//阅读全部消息
  static const String readMessage = "/api/v1/user/notice/readall";

  ///********************************* 用户 *****************************///
  //隐私政策
  static const String privacy = "/privacy";
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

  //手机号登录
  static const String loginApp_phone = "/api/v1/user/login/app_phone";
  //手机号绑定
  static const String bindAppPhone = "/api/v1/user/bind/mobile";
  //手机号登录
  static const String login_wx = "/api/v1/user/login/wx";

  //隐私政策
  static const String privacys = CommonConstant.BASE_API + ApiConstant.privacy;

  //用户协议
  static const String agreements =
      CommonConstant.BASE_API + ApiConstant.agreement;

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

  //消息列表
  static const String orderReturn = "/api/v1/order/return";


  //H5地址，直接webview加载
  static String getH5DetailUrl(id) {
    return CommonConstant.BASE_API + "/archive/embed/$id";
  }
  //获取顺丰物流H5地址
  static String getSFH5DetailUrl(id) {
    return CommonConstant.BASE_API+"/user/sf?nu=$id";
  }
}
