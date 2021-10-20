import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zgene/constant/color_constant.dart';

class ReportRusultItem2 extends StatefulWidget {
  const ReportRusultItem2({Key key}) : super(key: key);

  @override
  _ReportRusultItem2State createState() => _ReportRusultItem2State();
}

class _ReportRusultItem2State extends State<ReportRusultItem2> {
  var data = [0, 1, 2];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30),
          child: data.length <= 3
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: data.map((e) => _circleItem(e)).toList(),
                )
              : _circleOneItem(),
        ),
        ...data.map((e) => _item(e)).toList(),
      ],
    );
  }

  //TODO 未实现
  Widget _circleOneItem() {
    return Text("s");
  }

  Widget _circleItem(int index) {
    return CircularPercentIndicator(
      radius: 70.0,
      lineWidth: 10.0,
      backgroundWidth: 9,
      animation: true,
      animationDuration: 1000,
      percent: 0.7,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: _getColor(index),
      backgroundColor: _getColor(index).withAlpha(50),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              _getAssetIcon(index),
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
        Container(
          height: 1,
          margin: EdgeInsets.only(left: 40),
          color: Color(0x32B2BAC6),
        )
      ],
    );
  }

  String _getAssetIcon(int color) {
    if (0 == color % 4) {
      return "assets/images/report/icon_report_item_green.png";
    }
    if (1 == color % 4) {
      return "assets/images/report/icon_report_item_blue.png";
    }
    if (2 == color % 4) {
      return "assets/images/report/icon_report_item_red.png";
    }
    if (3 == color % 4) {
      return "assets/images/report/icon_report_item_yellow.png";
    }
  }

  Color _getColor(int index) {
    if (0 == index % 4) {
      return ColorConstant.bg_42F5D3;
    }
    if (1 == index % 4) {
      return ColorConstant.bg_017AF6;
    }
    if (2 == index % 4) {
      return ColorConstant.bg_FD7A7A;
    }
    return ColorConstant.bg_42F5D3;
  }
}
