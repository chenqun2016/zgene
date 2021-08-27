import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/widget/my_stepper.dart';

import 'bind_step_1.dart';
import 'bind_step_2.dart';
import 'bind_step_3.dart';

class BindCollectorPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _BindCollectorPageState();
  }
}

class _BindCollectorPageState extends BaseWidgetState<BindCollectorPage> {
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = false;
    backImgPath = "assets/images/mine/img_bg_my.png";
  }

  @override
  Widget viewPageBody() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titlebar(),
          // _stepper(),
          // BindStep1(),
          // BindStep2(),
          BindStep3(),
        ],
      ),
    );
  }

  _titlebar() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 48),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image(
              image: AssetImage("assets/images/mine/icon_back.png"),
              height: 40,
              width: 40,
            ),
          ),
          Center(
              child: Text(
            "绑定采集器",
            style: TextStyle(
              color: ColorConstant.TextMainBlack,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )),
          Positioned(
              right: 0,
              child: Text(
                "采集引导",
                style: TextStyle(
                  color: ColorConstant.TextMainBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ))
        ],
      ),
    );
  }

  _stepper() {
    return CustomStepper(
      currentStep: _position,
      onStepTapped: (index) {
        setState(() {
          _position = index;
        });
      },
      onStepContinue: () {
        setState(() {
          if (_position < 2) {
            _position++;
          }
        });
      },
      onStepCancel: () {
        if (_position > 0) {
          setState(() {
            _position--;
          });
        }
      },
      type: CustomStepperType.horizontal,
      steps: steps.map(
        (s) {
          bool isActive = steps.indexOf(s) == _position;
          return CustomStep(
            state: _getState(steps.indexOf(s)),
            title: Text(""),
            content: Container(child: Text("你好啊你好啊你好啊你好啊"),),
            isActive: isActive,
          );
        },
      ).toList(),
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Container();
      },
    );
  }

  var steps = ['', '', ''];
  int _position = 0;

  _getState(index) {
    if (_position == index) return StepState.editing;
    if (_position > index) return StepState.complete;
    return StepState.indexed;
  }
}
