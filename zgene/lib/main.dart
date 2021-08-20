import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zgene/pages/splash_page.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/restart_widget.dart';

void main() async {
  //提前初始化flutter
  WidgetsFlutterBinding.ensureInitialized();
  //初始化SharedPreferences
  await SpUtils().initStorage();
  //设置透明状态栏
  UiUitls.setTransparentStatus();
  //初始化基础库.
  _initSDK();
  //设置手机竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

void _initSDK() {

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestartWidget(
        child: MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    ));
  }
}
