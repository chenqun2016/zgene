import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/ui_uitls.dart';

class ReportRusultItem2 extends StatefulWidget {
  const ReportRusultItem2({Key key}) : super(key: key);

  @override
  _ReportRusultItem2State createState() => _ReportRusultItem2State();
}

class _ReportRusultItem2State extends State<ReportRusultItem2> {
  var data = [0.1, 0.2, 0.4, 0.3];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30),
          child: data.length == 4
              ? _circleFourItem()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: data
                      .map<Widget>((e) => _circleItem(data.indexOf(e)))
                      .toList(),
                ),
        ),
        ...data.map<Widget>((e) => _item(data.indexOf(e))).toList(),
      ],
    );
  }

  //进度条
  Widget _circleFourItem() {
    var progress3 = data[3];
    var progress2 = data[3] + data[2];
    var progress1 = data[3] + data[2] + data[1];

    return Stack(
      children: [
        CircularPercentIndicator(
          radius: 110.0,
          lineWidth: 16.0,
          backgroundWidth: 14,
          animation: true,
          animationDuration: 1000,
          percent: progress1,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: UiUitls.getColor(3),
          backgroundColor: UiUitls.getColor(0),
        ),
        CircularPercentIndicator(
          radius: 110.0,
          lineWidth: 16.0,
          backgroundWidth: 14,
          animation: true,
          animationDuration: 1000,
          percent: progress2,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: UiUitls.getColor(2),
          backgroundColor: Colors.transparent,
        ),
        CircularPercentIndicator(
          radius: 110.0,
          lineWidth: 16.0,
          backgroundWidth: 14,
          animation: true,
          animationDuration: 1000,
          percent: progress3,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: UiUitls.getColor(1),
          backgroundColor: Colors.transparent,
        )
      ],
    );
  }

  //进度条
  Widget _circleItem(int index) {
    return CircularPercentIndicator(
      radius: 70.0,
      lineWidth: 10.0,
      backgroundWidth: 9,
      animation: true,
      animationDuration: 1000,
      percent: 0.7,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: UiUitls.getColor(index),
      backgroundColor: UiUitls.getColor(index).withAlpha(50),
      center: Text.rich(TextSpan(children: [
        TextSpan(
            text: "$index",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: ColorConstant.bg_2D3142)),
        TextSpan(
          text: "%",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10.0,
              color: ColorConstant.bg_2D3142),
        ),
      ])),
    );
  }

  Widget _item(int index) {
    return Column(
      children: [
        if (0 != index)
          Container(
            height: 1,
            margin: EdgeInsets.only(left: 40),
            color: Color(0x32B2BAC6),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              UiUitls.getReportResultCircle(index),
              height: 24,
              width: 24,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 14, bottom: 14),
              child: Text(
                "6.44%的人",
                style: TextStyle(
                    color: index == 2
                        ? ColorConstant.MainBlueColor
                        : ColorConstant.Text_5E6F88,
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
              ),
            )),
            Text(
              "比我低",
              style: TextStyle(
                  color: index == 2
                      ? ColorConstant.MainBlueColor
                      : ColorConstant.Text_5E6F88,
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
            )
          ],
        ),
      ],
    );
  }
}
