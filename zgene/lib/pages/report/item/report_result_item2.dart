import 'package:base/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zgene/models/report_list_detail_model.dart';
import 'package:zgene/util/image_color_utils.dart';

class ReportRusultItem2 extends StatefulWidget {
  List<Distribution> distribution;
  var tag;
  ReportRusultItem2({Key key, this.distribution, this.tag}) : super(key: key);

  @override
  _ReportRusultItem2State createState() => _ReportRusultItem2State();
}

class _ReportRusultItem2State extends State<ReportRusultItem2> {
  List<Distribution> data;
  @override
  void initState() {
    data = widget.distribution;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 30),
            child: data.length >= 4
                ? _circleFourItem()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: data.map<Widget>((e) => _circleItem(e)).toList(),
                  ),
          ),
          ...data.map<Widget>((e) => _item(e)).toList(),
        ],
      ),
    );
  }

  Widget _getCricleItem(progress, index) {
    return CircularPercentIndicator(
      radius: 110.0,
      lineWidth: 16.0,
      backgroundWidth: 14,
      animation: true,
      animationDuration: 1000,
      percent: (progress > 0.95 && progress < 1) ? 0.95 : progress,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: ImageColorUtils.getColor(index),
      backgroundColor: Colors.transparent,
    );
  }

  //进度条
  Widget _circleFourItem() {
    List<Widget> widgetList = [];
    double progress = 0;

    data.forEach((element) {
      progress += element.rate;
      widgetList.add(_getCricleItem(progress, data.indexOf(element)));
    });

    return Stack(
      children: widgetList.reversed.toList(),
    );
  }

  //进度条
  Widget _circleItem(Distribution e) {
    var index = data.indexOf(e);
    return CircularPercentIndicator(
      radius: 80.0,
      lineWidth: 10.0,
      backgroundWidth: 9,
      animation: true,
      animationDuration: 1000,
      startAngle: 0,
      percent: (e.rate > 0.95 && e.rate < 1) ? 0.95 : e.rate,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: data.length <= 3
          ? ImageColorUtils.getColor3(index)
          : ImageColorUtils.getColor(index),
      backgroundColor: (data.length <= 3
              ? ImageColorUtils.getColor3(index)
              : ImageColorUtils.getColor(index))
          .withAlpha(50),
      center: Text.rich(TextSpan(children: [
        TextSpan(
            text: "${(e.rate * 100).toStringAsFixed(2)}",
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

  Widget _item(Distribution e) {
    var index = data.indexOf(e);
    var r = (e.rate * 100).toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 15),
      child: Column(
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
                data.length <= 3
                    ? ImageColorUtils.getReportResultCircle3(index)
                    : ImageColorUtils.getReportResultCircle(index),
                height: 24,
                width: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 6, top: 14, bottom: 14, right: 10),
                child: Text(
                  "$r%的人",
                  style: TextStyle(
                      color: _getColor(e, index),
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
              ),
              Expanded(
                  child: Text(
                e.title,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: _getColor(e, index),
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
              ))
            ],
          ),
        ],
      ),
    );
  }

  Color _getColor(Distribution e, index) {
    var color = data.length <= 3
        ? ImageColorUtils.getColor3(index)
        : ImageColorUtils.getColor(index);
    if (e.title == "和我一样") {
      return color;
    }
    if (null != e.tag && null != widget.tag && (e.tag == widget.tag)) {
      return color;
    }
    return ColorConstant.Text_5E6F88;
  }
}
