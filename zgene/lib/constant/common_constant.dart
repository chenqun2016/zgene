import 'package:zgene/constant/sp_constant.dart';

///app公共常量
class CommonConstant {
  static const String BASE_API = SpConstant.DevelopApi;
  //APP名称
  static const String AppName = "Z基因";
//APP名称
  static const String AppVer = "1.0.0";
//隐私政策
  static const String privacy = BASE_API + "/privacy";

  //用户协议
  static const String agreement = BASE_API + "/agreement";

  //APP版本号
  static const String AppVersion = "1.0.0";

  //android包名
  // static const String AndroidAppId = "com.divms.app";

  //iOSAppId
  static const String iOSAppId = "";

  //iOSAppId
  static const String refreshMine = "refreshMine";

  //iOSAppId
  static const String refreshACPross = "refreshACPross";
  //通知
  static const String WxCode = "WxCode";
  static const String WxCodeSet = "WxCodeSet";
  static const String MessagePush = "MessagePush";
  //首页刷新通知名
  static const String HomeRefush = "HomeRefush";
  //主题颜色
  static int THEME_COLOR = 0xFF2E9CF9;

  //主题颜色渐变起始颜色
  static int THEME_COLOR_GRADIENT_START = 0xFF65B8FF;

  //软件是否前台
  static bool AppLifecycleStateResumed = false;

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
      "欢迎使用Z基因APP，您应当阅读并遵守《用户协议》、《个人信息保护政策》，请您务必审慎阅读，充分理解各条款内容。如您未满18周岁，请在法定监护人的陪同下阅读，并特别注意未成年人使用条款。如您继续使用我们APP，将视为您同意我们的条款。";
  static const String Privacy_Text2 = """ 
为保证应用的各项功能正常使用，在您使用应用的过程中，我们会向您申请以下应用权限：

1、获取手机唯一标识（包括IMEI和设备MAC地址），用于应用安装数据统计，以及用于通知您检测结果变更；

2、摄像头、位置及手机存储权限，用于实现扫码、分享等功能时使用。

我们不会默认开启这些权限，只有在您授权后才会使用。
  """;

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
  // static String universalLink = "https://www.divms.com/";

  //微信appKey
  // static String wxAppKey = "wx5efe242ed516d3c1";

  //isWeChatInstalled
  static bool Is_WeChat_Installed = false;

  //isInWechatWeb 是否在微信
  static bool isInWechatWeb = false;
  static bool isInWechatMini = false;
  static String wechatWebOpenID = "";

  static const String ROUT_article_detail = "/article_detail";
  static const String ROUT_report = "/report";
  static const String ROUT_report_detail = "/report_detail";
  static const String ROUT_login = "/login";
  static const String ROUT_my_message = "/my_message";
  static const String ROUT_my_address = "/my_address";
  static const String ROUT_my_info = "/my_info";
  static const String ROUT_my_order = "/my_order";
  static const String ROUT_order_step_detail = "/order_step_detail";
  static const String ROUT_order_detail = "/order_detail";
  static const String ROUT_bind_collector = "/bind_collector";
  static const String ROUT_back_collector = "/back_collector";
  static const String ROUT_kefu = "/kefu";
  static const String ROUT_about = "/about";
  static const String ROUT_buy = "/buy";
  static const String ROUT_buy_detail = "/buy_detail";
  static const String ROUT_common_question = "/common_question";
  static const String ROUT_my_report_list = "/my_report";

  static const String JWT = "jwt";

  static const String BUS_BUYPAGE = "bus_buypage";
}
