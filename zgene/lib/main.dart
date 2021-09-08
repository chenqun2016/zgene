import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluwx/fluwx.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/setting_model.dart';
import 'package:zgene/pages/home/article_detail.dart';
import 'package:zgene/pages/home/video_nav.dart';
import 'package:zgene/pages/my/my_about_us.dart';
import 'package:zgene/pages/my/my_contant_us.dart';
import 'package:zgene/pages/splash_page.dart';
import 'package:zgene/pages/tabs/report_page.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/notification_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/restart_widget.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';
import 'constant/app_notification.dart';
import 'models/msg_event.dart';
import 'pages/bindcollector/bind_collector_page.dart';
import 'pages/bindcollector/bind_step_1.dart';
import 'pages/bindcollector/bind_step_2.dart';
import 'pages/bindcollector/bind_step_3.dart';
import 'pages/home/explore_nav.dart';
import 'pages/home/local_nav.dart';
import 'pages/home/problem_nav.dart';
import 'pages/home/video_page.dart';
import 'pages/login/bindPhone_login.dart';
import 'pages/login/getVFCode_login.dart';
import 'pages/login/main_login.dart';
import 'pages/login/phone_login.dart';
import 'pages/my/add_address_page.dart';
import 'pages/my/my_address_list.dart';
import 'pages/my/my_editor_name.dart';
import 'pages/my/my_info_page.dart';
import 'pages/my/my_message_list.dart';
import 'pages/my/my_order_list.dart';
import 'pages/my/my_set.dart';
import 'pages/my/order_detail.dart';
import 'pages/my/order_step_page.dart';
import 'pages/my/ordering_page.dart';
import 'pages/my/sendBack_acquisition.dart';
import 'pages/my/show_selectPicker.dart';
import 'pages/report/report_list_page.dart';
import 'pages/tabs/buy_page.dart';

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

  registerWxApi(
      appId: CommonConstant.wxAppKey,
      universalLink: CommonConstant.universalLink);
  //设置手机竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    getSetting();
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
    registerWxApi(
        appId: CommonConstant.wxAppKey, //查看微信开放平台
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: CommonConstant.universalLink //查看微信开放平台
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
          NotificationCenter.instance
              .postNotification(NotificationName.WxCode, code);
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
        print("前后台更改"); // 处于这种状态的应用程序应该假设它们可能在任何时候暂停
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
      //注册路由表
      routes: {
        "/article_detail": (context) => ArticleDetailView(), //文章详情
        "/report": (context) => ReportPage(), //报告
        "/report_detail": (context) => null, //报告详情
        "/login": (context) => MainLoginPage(), //登录
        "/my_message": (context) => MyMessagePage(), //消息
        "/my_address": (context) => MyAddressListPage(), //我的地址
        "/my_info": (context) => MyInfoPage(), //我的资料
        "/my_order": (context) => MyOrderListPage(), //我的订单
        "/order_step_detail": (context) => OrderStepPage(), //订单步骤详情
        "/order_detail": (context) => OrderDetailPage(), //订单详情
        "/bind_collector": (context) => BindCollectorPage(), //绑定采集器
        "/back_collector": (context) => SendBackAcquisitionPage(), //回寄采集器
        "/kefu": (context) => contantUsPage(), //联系客服
        "/about": (context) => AboutUsPage(), //关于我们
      },
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
