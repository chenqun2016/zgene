
import 'dart:async';

import 'package:flutter/material.dart';

class CountDownWidget extends StatefulWidget {
  var isSkip = false;
  final onCountDownFinishCallBack;

  CountDownWidget({Key? key, @required this.onCountDownFinishCallBack})
      : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();

}

class _CountDownWidgetState extends State<CountDownWidget> {
  var _seconds = 6;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_seconds',
      style: TextStyle(fontSize: 17.0),
    );
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
      if(widget.isSkip){
        widget.onCountDownFinishCallBack(true);
        _cancelTimer();
        return;
      }
      if (_seconds <= 1) {
        widget.onCountDownFinishCallBack(true);
        _cancelTimer();
        return;
      }
      _seconds--;
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }
}
