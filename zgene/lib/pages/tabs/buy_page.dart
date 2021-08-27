import 'package:flutter/material.dart';
import 'package:zgene/pages/bindcollector/bind_step_3.dart';
///首页购买页面
class BuyPage extends StatefulWidget {
  @override
  _BuyPageState createState() => _BuyPageState();
}


class _BuyPageState extends State<BuyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BindStep3(),
      ),
    );
  }
}