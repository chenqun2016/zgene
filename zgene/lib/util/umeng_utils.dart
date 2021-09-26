import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zgene/constant/config_constant.dart';
import 'package:zgene/util/platform_utils.dart';

///友盟统计工具类
class UmengUtils {
  static void onEvent(String event, Map<String, dynamic> properties) {
    if (PlatformUtils.isIOS || PlatformUtils.isAndroid) {
      UmengCommonSdk.onEvent(event, properties);
    }
  }

  static void initCommon() {
    if (PlatformUtils.isIOS || PlatformUtils.isAndroid) {
      // //初始化组件化基础库, 所有友盟业务SDK都必须调用此初始化接口。
      UmengCommonSdk.initCommon(
          ConfigConstant.umengAndroidKey, ConfigConstant.umengIosKey, 'zgene');
      UmengCommonSdk.setPageCollectionModeAuto();
    }
  }
}
