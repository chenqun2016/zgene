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
  var steps = [0, 1, 2];
  int _position = 0;
  bool canNextClick = false;

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = false;
    backImgPath = "assets/images/mine/img_bg_my.png";
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          _titlebar(),
          _stepper(),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: MaterialButton(
              height: 55,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27)),
              minWidth: double.infinity,
              disabledColor: Colors.white,
              color: ColorConstant.TextMainColor,
              onPressed: canNextClick
                  ? () {
                      if (_position < steps.length - 1) {
                        setState(() {
                          _position++;
                          if(_position != steps.length - 1){
                            canNextClick = false;
                          }
                        });
                      } else {
                        //绑定成功

                      }
                    }
                  : null,
              child: Text(_getBottomText(_position),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: canNextClick ? Colors.white : ColorConstant.Divider,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  _getBottomText(position) {
    if (position == steps.length - 1) {
      return "开始采样";
    } else {
      return "下一步";
    }
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
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ))
        ],
      ),
    );
  }

  _stepper() {
    return EStepper(
      stepperWidth: 240,
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
      type: EStepperType.horizontal,
      steps: steps.map(
        (s) {
          bool isActive = s == _position;
          return EStep(
            state: _getState(s),
            content: _getContent(s),
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

  _getState(index) {
    if (_position == index) return EStepState.editing;
    if (_position > index) return EStepState.complete;
    return EStepState.indexed;
  }

  _getContent(int s) {
    if (0 == s) {
      return BindStep1(_onChangeNextButtomState);
    }
    if (1 == s) {
      return BindStep2(_onChangeNextButtomState);
    }
    if (2 == s) {
      return BindStep3();
    }
  }

  _onChangeNextButtomState(bool canNext){
    setState(() {
      canNextClick = canNext;
    });
  }
}
