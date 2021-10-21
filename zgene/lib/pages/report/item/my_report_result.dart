import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/pages/report/item/report_result_item1.dart';
import 'package:zgene/pages/report/item/report_result_item2.dart';
import 'package:zgene/pages/report/item/report_result_item_text.dart';

class MyReportResult extends StatefulWidget {
  const MyReportResult({Key key}) : super(key: key);

  @override
  _MyReportResultState createState() => _MyReportResultState();
}

class _MyReportResultState extends State<MyReportResult>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 6,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      itemBuilder: (BuildContext context, int index) {
        return _buildSliverItem(context, index);
      },
    );
  }

  Widget _buildSliverItem(context, index) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Image.asset(
                  _getIndexIcon(index),
                  height: 60,
                  width: 60,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  left: index + 1 >= 10 ? 20 : 25,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.WhiteColor),
                  ),
                ),
                Positioned(
                  left: 48,
                  child: Text(
                    _getTitle(index),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.TextMainBlack),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: _buildItemItem(context, index),
          )
        ],
      ),
    );
  }

  String _getTitle(index) {
    switch (index) {
      case 0:
        return "患病倍数";
      case 1:
        return "人群占比";
      case 2:
        return "疾病概述";
      case 3:
        return "致病因素";
      case 4:
        return "早期症状";
      case 5:
        return "体检筛查";
      default:
        return "";
    }
  }

  Widget _buildItemItem(context, index) {
    if (0 == index) {
      return ReportResultItem1();
    }
    if (1 == index) {
      return ReportRusultItem2();
    }
    return ReportResultItemText();
  }

  String _getIndexIcon(int index) {
    switch (index % 4) {
      case 0:
        return "assets/images/report/icon_report_item_1.png";
      case 1:
        return "assets/images/report/icon_report_item_2.png";
      case 2:
        return "assets/images/report/icon_report_item_3.png";
      case 3:
        return "assets/images/report/icon_report_item_4.png";
      default:
        return "assets/images/report/icon_report_item_4.png";
    }
  }
}
