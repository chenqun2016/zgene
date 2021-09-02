///api路径
class ApiConstant {
  static const String BASE_API = "http://zgene.divms.com";

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
  ///********************************** 登录 *****************************///
  //配置
  static const String settings = "/api/v1/settings";
  //隐私政策
  static const String privacys = BASE_API + ApiConstant.privacy;
  //用户协议
  static const String agreements = BASE_API + ApiConstant.agreement;
  //用户协议
  static const String payLinks = BASE_API + ApiConstant.payLink;
}
