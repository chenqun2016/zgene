import 'package:flutter/material.dart';
import 'package:zgene/pages/login/main_login.dart';

///首页报告
class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text("登录",
              style: TextStyle(
                // fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
              )),
          onPressed: () {
            print(123);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainLoginPage()));
          },
        ),
      ),
    );
  }
}
