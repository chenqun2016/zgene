import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/setting_model.dart';
import 'package:zgene/pages/splash_page.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/restart_widget.dart';

void main() async {
  //提前初始化flutter
  WidgetsFlutterBinding.ensureInitialized();
  //滚动性能优化 1.22.0
  // GestureBinding.instance.resamplingEnabled = true;
  //初始化SharedPreferences
  await SpUtils().initStorage();
  //设置透明状态栏
  UiUitls.setTransparentStatus();

  //设置手机竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    getSetting();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestartWidget(
        child: MaterialApp(
      title: CommonConstant.AppName,
      navigatorKey: Global.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      builder: EasyLoading.init(),
      localizationsDelegates: [
        // 本地化的代理类
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // 美国英语
        const Locale('zh', 'CN'), // 中文简体
        //其它Locales
      ],
    ));
  }
}

//配置项
Future<void> getSetting() async {
  // EasyLoading.show(status: 'loading...');
  HttpUtils.CONNECTTIMEOUT = 3000;
  HttpUtils.RECEIVETIMEOUT = 3000;

  // bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
  // if (!isNetWorkAvailable) {
  //   setHttpTime();
  //   return;
  // }

  HttpUtils.requestHttp(
    ApiConstant.settings,
    method: HttpUtils.GET,
    onSuccess: (data) {
      try {
        setHttpTime();

        List<SettingModel> tempList = data
            .map((m) => new SettingModel.fromJson(m))
            .toList()
            .cast<SettingModel>();
        var spUtils = SpUtils();

        for (var item in tempList) {
          if (item.name == SpConstant.contactWx) {
            spUtils.setStorage(SpConstant.contactWx, item.value);
          }
          if (item.name == SpConstant.contactWxQrcode) {
            spUtils.setStorage(SpConstant.contactWxQrcode, item.value);
          }
          if (item.name == SpConstant.appLogoBanner) {
            spUtils.setStorage(SpConstant.appLogoBanner, item.value);
          }
          if (item.name == SpConstant.SpMainColor) {
            spUtils.setStorage(SpConstant.SpMainColor, item.value);
          }
          if (item.name == SpConstant.SpMainColorlight) {
            spUtils.setStorage(SpConstant.SpMainColorlight, item.value);
          }
          if (item.name == SpConstant.SvcMsgStatus) {
            spUtils.setStorage(
                SpConstant.SvcMsgStatus, item.value.toLowerCase());
          }
          // Z基因配置接口
          if (item.name == SpConstant.appAsalesRules) {
            spUtils.setStorage(SpConstant.appAsalesRules, item.value);
          }
          if (item.name == SpConstant.appReceiveAddress) {
            spUtils.setStorage(SpConstant.appReceiveAddress, item.value);
          }
          if (item.name == SpConstant.appReceiveName) {
            spUtils.setStorage(SpConstant.appReceiveName, item.value);
          }
          if (item.name == SpConstant.appReceivePhone) {
            spUtils.setStorage(SpConstant.appReceivePhone, item.value);
          }
          if (item.name == SpConstant.appReceivePtype) {
            spUtils.setStorage(SpConstant.appReceivePtype, item.value);
          }
        }
      } catch (e) {
        print(e);
      }
      setConfiguration();
    },
    onError: (code, error) {
      setHttpTime();
      setConfiguration();
      // EasyLoading.showError(error  "");
    },
  );
}

setConfiguration() {
  var spUtils = SpUtils();
  try {
    CommonConstant.THEME_COLOR = int.parse(
        spUtils.getStorageDefault(SpConstant.SpMainColor, 0xFF2E9CF9));
    CommonConstant.THEME_COLOR_GRADIENT_START = int.parse(
        spUtils.getStorageDefault(SpConstant.SpMainColorlight, 0xFF65B8FF));
    CommonConstant.App_Contact_Wx_Qrcode =
        spUtils.getStorageDefault(SpConstant.contactWxQrcode, "");
    CommonConstant.App_Logo_Banner =
        spUtils.getStorageDefault(SpConstant.appLogoBanner, "");
    CommonConstant.App_Contact_Wx_Code =
        spUtils.getStorageDefault(SpConstant.contactWx, "Support_DiVMS");

    CommonConstant.Svc_Msg_Status =
        spUtils.getStorageDefault(SpConstant.SvcMsgStatus, false);
  } catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}

///设置app超时时间
setHttpTime() {
  HttpUtils.CONNECTTIMEOUT = 8000;
  HttpUtils.RECEIVETIMEOUT = 8000;
  HttpUtils.clear();
}
