import 'package:flutter/material.dart';
import 'package:zgene/util/sp_utils.dart';
import 'navigator/tab_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtils().initStorage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    );
  }
}
