import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zgene/pages/splash_page.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/restart_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtils().initStorage();
  UiUitls.setTransparentStatus();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
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
