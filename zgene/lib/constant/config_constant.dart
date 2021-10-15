///配置常量
class ConfigConstant {
  static String jpushAppKey = "190887df88f6e5cb4dad5653";
  //微信appKey
  static String wxAppKey = "wx3ff0faf398eaa755";
  //微信Secret
  static String wxAppSecret = "6231e9cf0c8406101b59168b97568a61";

  //Ios universalLink
  static String universalLink = "https://www.z-gene.cn/";

  //android包名
  static const String AndroidAppId = "com.jt.zgene";
  //iOSAppId
  static const String iOSAppId = "1585616415";

  //友盟androidKey
  static String umengAndroidKey = "614d843866b59330aa6f3255";
  //友盟iosKey
  static String umengIosKey = "614d892966b59330aa6f5127";

  ///多渠道打包用到的参数
  static const APP_CHANNEL =
      String.fromEnvironment('APP_CHANNEL', defaultValue: "zgene");
}
