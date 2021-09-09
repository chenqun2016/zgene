///app公共常量
class CommonConstant {
  static const String BASE_API = "http://zgene.divms.com";
  // static const String BASE_API = "http://192.168.110.70:8998";
  //APP名称
  static const String AppName = "Z基因";
//隐私政策
  static const String privacy = BASE_API + "/privacy";
  //用户协议
  static const String agreement = BASE_API + "/agreement";
  //APP版本号
  static const String AppVersion = "1.0.0";

  //android包名
  static const String AndroidAppId = "com.divms.app";

  //iOSAppId
  static const String iOSAppId = "";
  //iOSAppId
  static const String refreshMine = "refreshMine";
  //主题颜色
  static int THEME_COLOR = 0xFF2E9CF9;
  //主题颜色渐变起始颜色
  static int THEME_COLOR_GRADIENT_START = 0xFF65B8FF;
  //客服微信
  static String App_Contact_Wx_Code = "Support_DiVMS";
  //客服二维码
  static String App_Contact_Wx_Qrcode = "";
  //验证码服务状态
  static bool Svc_Msg_Status = false;
  //Logo_Banner
  static String App_Logo_Banner = "";
  //分页数量
  static const int PAGE_SIZE10 = 10;
  static const int PAGE_SIZE = 20;
  static const String Privacy_Text =
      "   欢迎使用「DiVMS」APP，我们非常重视您的个人信息和隐私保护，在您使用「DiVMS」APP之前，请您务必审慎阅读《隐私政策》和《用户协议》，并充分理解协议条款内容。我们将严格按照您同意的各项条款使用您的个人信息，以便为您提供更好的服务。";

  //Z基因项目相关
  //售后规则
  static const String defaultAppAsalesRules =
      """1、取消订单：订单状态仅在「待发货」状态下可取消订单，取消订单则需要联系客户进行处理。
2、退款/退货规则：签收商品15日天内，扣除我司发货运费15元，可退款/货；签收超过15天，不可申请退货/款。
3、退货要求：塑封包装完好、所退商品保持完好无损、配件齐全，且不影响二次销售；被拆开封膜、被绑定过、被使用过、遭人为破坏或污损的商品不提供退货/款服务。
4、保价有效期：购买成功并付款后15天内
5、差价返还：所有官方渠道成功购买的订单，可按跟客服沟通的官方售价申请差价返还。
6、规则实施日期及解释：本规则自2021年9月10日起实施，最终解释权归上海晓得基因科技有限公司所有，了解更详细规则请联系客服。
7、申请方式：您可以在工作日的10点至18点间进行客服咨询，客服QQ：1256019395。
  """;
  static String appAsalesRules = "";
  //回寄收件地址
  static String appReceiveAddress = "";
  //回寄收件人
  static String appReceiveName = "";
  //回寄电话
  static String appReceivePhone = "";
  //回寄付费方式
  static String appReceivePtype = "";

  //Ios universalLink
  static String universalLink = "https://www.divms.com/";
  //微信appKey
  static String wxAppKey = "wx5efe242ed516d3c1";
  //isWeChatInstalled
  static bool Is_WeChat_Installed = false;
}
