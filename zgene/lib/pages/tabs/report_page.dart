import 'package:flutter/material.dart';
import 'package:zgene/pages/login/main_login.dart';
import 'package:zgene/pages/my/sendBack_acquisition.dart';

///首页报告
class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            child: Container(
              margin: EdgeInsets.all(100),
              child: Text("登录",
                  style: TextStyle(
                    // fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainLoginPage()));
            },
          ),
          Container(
            margin: EdgeInsets.all(100),
            child: TextButton(
              child: Text("回寄采集器",
                  style: TextStyle(
                    // fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  )),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SendBackAcquisitionPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
