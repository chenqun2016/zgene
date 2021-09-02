///api路径
class ApiConstant {
  static const String BASE_API = "https://zgene.divms.com";

  ///********************************** 自媒体流 *****************************///
  //内容列表
  static const String contentList = "/api/v1/archives";

  ///********************************* 用户 *****************************///
  //隐私政策
  static const String privacy = "/privacy";
  //用户隐私
  static const String agreement = "/agreement";
  //用户隐私
  static const String payLink = "/service/pay/#/pages/CoinRecharge/index";
//地址查询
  static const String userAddresses = "/api/v1/user/addresses";
//地址添加
  static const String userAddAddress = "/api/v1/user/address";

  ///********************************** 登录 *****************************///
  //配置
  static const String settings = "/api/v1/settings";
  //获取验证码
  static const String loginSms = "/api/v1/login/sms";
  //手机号登录
  static const String loginApp_phone = "/api/v1/user/login/app_phone";
  //隐私政策
  static const String privacys = BASE_API + ApiConstant.privacy;
  //用户协议
  static const String agreements = BASE_API + ApiConstant.agreement;
  //用户协议
  static const String payLinks = BASE_API + ApiConstant.payLink;

  ///********************************* 消息 *****************************///

  //消息列表
  static const String messageList = "/api/v1/user/notices";
}
