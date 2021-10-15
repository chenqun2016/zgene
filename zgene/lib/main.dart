import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/config_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/setting_model.dart';
import 'package:zgene/pages/bindcollector/qr_scanner_page.dart';
import 'package:zgene/pages/home/article_detail.dart';
import 'package:zgene/pages/my/my_about_us.dart';
import 'package:zgene/pages/my/my_contant_us.dart';
import 'package:zgene/pages/splash_page.dart';
import 'package:zgene/pages/tabs/buy_page.dart';
import 'package:zgene/pages/tabs/report_page.dart';
import 'package:zgene/plugin/method_channel_plugin.dart';
import 'package:zgene/util/chineseCupertino.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/getui_Utils.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/restart_widget.dart';

import 'configure.dart' if (dart.library.html) 'configure_web.dart';
import 'event/event_bus.dart';
import 'pages/login/main_login.dart';
import 'pages/my/my_address_list.dart';
import 'pages/my/my_commonQus.dart';
import 'pages/my/my_info_page.dart';
import 'pages/my/my_message_list.dart';
import 'pages/my/my_order_list.dart';
import 'pages/my/my_report_page.dart';
import 'pages/my/order_detail.dart';
import 'pages/my/order_step_page.dart';
import 'pages/my/sendBack_acquisition.dart';
import 'pages/report/report_list_page.dart';

void main() async {
  configureApp();
  //提前初始化flutter
  WidgetsFlutterBinding.ensureInitialized();
  //滚动性能优化 1.22.0
  // GestureBinding.instance.resamplingEnabled = true;
  //初始化SharedPreferences
  await SpUtils().initStorage();
  //设置透明状态栏
  UiUitls.setTransparentStatus();

  //设置手机竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    getSetting();
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final eventBus = CommonUtils.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!PlatformUtils.isWeb) {
      registerWxApi(
          appId: ConfigConstant.wxAppKey, //查看微信开放平台
          doOnAndroid: true,
          doOnIOS: true,
          universalLink: ConfigConstant.universalLink //查看微信开放平台
          );
      _installFluwx();

      WidgetsBinding.instance.addObserver(this);
      weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
        if (res is WeChatAuthResponse) {
          int errCode = res.errCode;
          // MyLogUtil.d('微信登录返回值：ErrCode :$errCode  code:${res.code}');
          if (errCode == 0) {
            String code = res.code;
            print('wxwxwxwxwxwxwx' + code);
            //把微信登录返回的code传给后台，剩下的事就交给后台处理
            print("+++++++++++++++++++++++++++++");
            // NotificationCenter.instance
            //     .postNotification(NotificationName.WxCode, code);
            bus.emit(CommonConstant.WxCode, code);

            // wxLoginHttp(code);
            // showToast("用户同意授权成功");
          } else if (errCode == -4) {
            // showToast("用户拒绝授权");
            print('wxwxwxwxwxwxwx用户拒绝授权');
          } else if (errCode == -2) {
            // showToast("用户取消授权");
            print('wxwxwxwxwxwxwx用户取消授权');
          }
        }
      });
    } else {
      webLogin();
    }
    if (PlatformUtils.isIOS) {
      Getuiflut().startSdk(
          appId: "LtFmCuKHpj7dr8CM6ExQw5",
          appKey: "7b0CKZK1Ol85XkOGlmv4H8",
          appSecret: "ulNNxALdjl7gXekPjnR8D1");
    }

    GetuiUtils.initGetuiSdk();
    GetuiUtils.config();
    // GetuiUtils.getClientId();
    GetuiUtils.bindAlias();
    if (PlatformUtils.isAndroid) {
      Getuiflut().turnOnPush();
    }
    MethodChannelPlugin.registHandler();
  }

  _installFluwx() async {
    var result = await isWeChatInstalled;
    CommonConstant.Is_WeChat_Installed = result;

    if (result) {
      print('该手机上安装了微信');
    } else {
      print('该手机上未安装微信');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("-didChangeAppLifecycleState-" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive:
        // jpush.setBadge(0);
        // GetuiUtils.resetBadge();
        // bus.on(CommonConstant.MessagePush, (arg) {
        //   print("090909090909090");
        //   print(arg);
        //   CommonUtils.globalToUrl(type: arg["type"], url: arg["url"]);
        // });
        Getuiflut().setBadge(0);

        print("前后台更改"); // 处于这种状态的应用程序应该假设它们可能在任何时候暂停
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        Future.delayed(Duration(seconds: 1), () {
          CommonConstant.AppLifecycleStateResumed = true;
        });
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        CommonConstant.AppLifecycleStateResumed = false;
        break;
      case AppLifecycleState.detached: // APP结束时调用
        CommonConstant.AppLifecycleStateResumed = false;
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    bus.off(CommonConstant.WxCode);
  }

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
        child: MaterialApp(
      title: CommonConstant.AppName,
      navigatorKey: Global.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: TabNavigator(),
      home: SplashPage(),
      builder: EasyLoading.init(),
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        ChineseCupertinoLocalizations.delegate, // 自定义的delegate

        DefaultCupertinoLocalizations.delegate, // 目前只包含英文

        // 下面两个是Material widgets的delegate, 包含中文
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('zh', 'Hans'), // China
        const Locale('zh', ''), // China
        // ... other locales the app supports
      ],
      onGenerateRoute: (settings) {
        // 支持web页面通过地址来跳转对应的详情页面
        var u = Uri.parse(settings.name);

        if (u.path == CommonConstant.ROUT_article_detail) {
          var url = ApiConstant.getH5DetailUrl(u.queryParameters["id"]);

          return MaterialPageRoute(
            builder: (context) {
              return ArticleDetailView(
                title: "文章详情",
                url: url,
              );
            },
          );
        } else if (u.path == CommonConstant.ROUT_about) {
          // 支持about页面跳转
          return MaterialPageRoute(
            builder: (context) {
              return ScreenUtilInit(
                  designSize: Size(375, 812), builder: () => AboutUsPage());
            },
          );
        }

        return null;
      },
      //注册路由表
      routes: {
        CommonConstant.ROUT_article_detail: (context) =>
            ArticleDetailView(), //文章详情
        CommonConstant.ROUT_report: (context) => ReportPage(), //报告
        CommonConstant.ROUT_report_detail: (context) => ReportListPage(), //报告详情
        CommonConstant.ROUT_login: (context) => MainLoginPage(), //登录
        CommonConstant.ROUT_my_message: (context) => MyMessagePage(), //消息
        CommonConstant.ROUT_my_address: (context) => MyAddressListPage(), //我的地址
        CommonConstant.ROUT_my_info: (context) => MyInfoPage(), //我的资料
        CommonConstant.ROUT_my_order: (context) => MyOrderListPage(), //我的订单
        CommonConstant.ROUT_order_step_detail: (context) =>
            OrderStepPage(), //订单步骤详情
        CommonConstant.ROUT_order_detail: (context) => OrderDetailPage(), //订单详情
        CommonConstant.ROUT_bind_collector: (context) =>
            QRScannerView(), //绑定采集器
        CommonConstant.ROUT_back_collector: (context) =>
            SendBackAcquisitionPage(), //回寄采集器
        CommonConstant.ROUT_kefu: (context) => contantUsPage(), //联系客服
        CommonConstant.ROUT_about: (context) => ScreenUtilInit(
            designSize: Size(375, 812), builder: () => AboutUsPage()), //关于我们
        CommonConstant.ROUT_buy: (context) => BuyPage(), //购买页面
        CommonConstant.ROUT_common_question: (context) =>
            CommonQusListPage(), //常见问题
        CommonConstant.ROUT_my_report_list: (context) => MyReportPage(), //我的报告
      },
    ));
  }
}

//配置项
Future<void> getSetting() async {
  //  ;
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
          if (item.name == SpConstant.appAboutusDescription) {
            spUtils.setStorage(SpConstant.appAboutusDescription, item.value);
          }
          if (item.name == SpConstant.appAboutusDescription) {
            spUtils.setStorage(SpConstant.appAboutusDescription, item.value);
          }
          if (item.name == SpConstant.appLatestVersion) {
            spUtils.setStorage(SpConstant.appLatestVersion, item.value);
          }
          if (item.name == SpConstant.appKefuQq) {
            spUtils.setStorage(SpConstant.appKefuQq, item.value);
          }
          if (item.name == SpConstant.appServiceTime) {
            spUtils.setStorage(SpConstant.appServiceTime, item.value);
          }
          if (item.name == SpConstant.appShareIcon) {
            spUtils.setStorage(SpConstant.appShareIcon, item.value);
          }
          if (item.name == SpConstant.appShareSubtitle) {
            spUtils.setStorage(SpConstant.appShareSubtitle, item.value);
          }
          if (item.name == SpConstant.appProductStepAid) {
            spUtils.setStorage(SpConstant.appProductStepAid, item.value);
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

    //Z基因配置读取
    CommonConstant.appAsalesRules = spUtils.getStorageDefault(
        SpConstant.appAsalesRules, CommonConstant.defaultAppAsalesRules);
    CommonConstant.appReceiveAddress = spUtils.getStorageDefault(
        SpConstant.appReceiveAddress, "江西省南昌市高新区南昌国家医药国际创新园联合研究院14号楼");
    CommonConstant.appReceiveName =
        spUtils.getStorageDefault(SpConstant.appReceiveName, "周子芳");
    CommonConstant.appReceivePhone =
        spUtils.getStorageDefault(SpConstant.appReceivePhone, "0791-88829758");
    CommonConstant.appReceivePtype =
        spUtils.getStorageDefault(SpConstant.appReceivePtype, "到付即可");
  } catch (e) {
    print(e);
  }
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
