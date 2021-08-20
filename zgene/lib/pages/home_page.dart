import 'package:flutter/material.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/util/sp_utils.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var spUtils = SpUtils();
  bool isFirst = true;
  @override
  void initState() {
    super.initState();

    isFirst = spUtils.getStorageDefault(SpConstant.SpIsFirst, true);
    if (isFirst) {
      spUtils.setStorage(SpConstant.SpIsFirst, false);
      isFirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("首页"),
      ),
    );
  }
}
