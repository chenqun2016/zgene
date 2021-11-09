import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/report_list_detail_model.dart';
import 'package:zgene/pages/report/item/report_result_item1.dart';
import 'package:zgene/pages/report/item/report_result_item2.dart';
import 'package:zgene/pages/report/item/report_result_item_text.dart';
import 'package:zgene/util/ui_uitls.dart';

///报告详情页：检测结果tab
class ReportResult extends StatefulWidget {
  ReportListDetailModel reportData;
  int topType;
  ReportResult({Key key, this.reportData, this.topType}) : super(key: key);

  @override
  _ReportResultState createState() => _ReportResultState();
}

class _ReportResultState extends State<ReportResult>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var renqunzhanbi;

  ///人群占比  3个圈
  List<Distribution> distribution;
  @override
  void initState() {
    ///人群占比  3个圈
    if (null != widget.reportData.lowRate &&
        null != widget.reportData.sameRate &&
        null != widget.reportData.upRate &&
        (widget.reportData.lowRate != 0 ||
            widget.reportData.sameRate != 0 ||
            widget.reportData.upRate != 0)) {
      distribution = [];
      distribution.add(Distribution(
          rate: double.parse(widget.reportData.lowRate.toString()),
          title: "比我低"));
      distribution.add(Distribution(
          rate: double.parse(widget.reportData.sameRate.toString()),
          title: "和我一样"));
      distribution.add(Distribution(
          rate: double.parse(widget.reportData.upRate.toString()),
          title: "比我高"));
    }
    if (null != widget.reportData.predisposition &&
        null != widget.reportData.predisposition.lowRate &&
        null != widget.reportData.predisposition.sameRate &&
        null != widget.reportData.predisposition.upRate &&
        (widget.reportData.predisposition.lowRate != 0 ||
            widget.reportData.predisposition.sameRate != 0 ||
            widget.reportData.predisposition.upRate != 0)) {
      distribution = [];
      distribution.add(Distribution(
          rate:
              double.parse(widget.reportData.predisposition.lowRate.toString()),
          title: "比我低"));
      distribution.add(Distribution(
          rate: double.parse(
              widget.reportData.predisposition.sameRate.toString()),
          title: "和我一样"));
      distribution.add(Distribution(
          rate:
              double.parse(widget.reportData.predisposition.upRate.toString()),
          title: "比我高"));
    }

    if (null != widget.reportData.distribution) {
      widget.reportData.distribution.forEach((element) {
        if (widget.reportData.tag == element.tag) {
          var per = (element.rate * 100).toStringAsFixed(2);
          renqunzhanbi = "$per%的人和我一样";
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      children: [
        ///患病倍数
        if (widget.topType == 0 &&
            null != widget.reportData.risk &&
            null != widget.reportData.minRisk &&
            null != widget.reportData.maxRisk &&
            (widget.reportData.risk != 0 ||
                widget.reportData.minRisk != 0 ||
                widget.reportData.maxRisk != 0))
          _buildSliverItem(
              context,
              index++,
              "患病倍数",
              ReportResultItem1(
                maxRisk: widget.reportData.maxRisk,
                minRisk: widget.reportData.minRisk,
                risk: widget.reportData.risk,
              )),

        ///患病倍数  不同的接口参数
        if (widget.topType == 0 &&
            null != widget.reportData.predisposition &&
            null != widget.reportData.predisposition.risk &&
            null != widget.reportData.predisposition.minRisk &&
            null != widget.reportData.predisposition.maxRisk &&
            (widget.reportData.predisposition.risk != 0 ||
                widget.reportData.predisposition.minRisk != 0 ||
                widget.reportData.predisposition.maxRisk != 0))
          _buildSliverItem(
              context,
              index++,
              "患病倍数",
              ReportResultItem1(
                maxRisk: widget.reportData.predisposition.maxRisk,
                minRisk: widget.reportData.predisposition.minRisk,
                risk: widget.reportData.predisposition.risk,
              )),

        ///人群占比
        if (null != widget.reportData.distribution)
          _buildSliverItem(
              context,
              index++,
              renqunzhanbi + "",
              ReportRusultItem2(
                distribution: widget.reportData.distribution,
                tag: widget.reportData.tag,
              )),

        ///人群占比  不同的接口参数
        if (null != distribution)
          _buildSliverItem(
              context,
              index++,
              "人群占比",
              ReportRusultItem2(
                  distribution: distribution, tag: widget.reportData.tag)),

        ///疾病报告 ；疾病报告
        if (null != widget.reportData.disDesc)
          _buildSliverItem(
              context,
              index++,
              "疾病报告",
              ReportResultItemText(
                text: widget.reportData.disDesc,
              )),

        ///疾病报告 ；致病因素
        if (null != widget.reportData.disFactor)
          _buildSliverItem(
              context,
              index++,
              "致病因素",
              ReportResultItemText(
                text: widget.reportData.disFactor,
              )),

        ///疾病报告 ；早期症状
        if (null != widget.reportData.disSymptom)
          _buildSliverItem(
              context,
              index++,
              "早期症状",
              ReportResultItemText(
                text: widget.reportData.disSymptom,
              )),

        ///疾病报告 ；体检筛查
        if (null != widget.reportData.disScreening)
          _buildSliverItem(
              context,
              index++,
              "体检筛查",
              ReportResultItemText(
                text: widget.reportData.disScreening,
              )),

        ///个体特质报告 ；特质基因描述(小贴士)
        if (null != widget.reportData.traitsDesc)
          _buildSliverItem(
              context,
              index++,
              "特质基因描述",
              ReportResultItemText(
                text: widget.reportData.traitsDesc,
              )),

        ///个体特质报告 ；生活建议
        if (null != widget.reportData.advice)
          _buildSliverItem(
            context,
            index++,
            "生活建议",
            ReportResultItemText(
              text: widget.reportData.advice,
            ),
          ),

        ///药物报告 ；药物适用症状
        if (null != widget.reportData.drugDesc)
          _buildSliverItem(
            context,
            index++,
            "药物适用症状",
            ReportResultItemText(
              text: widget.reportData.drugDesc,
            ),
          ),

        ///药物报告 ；药理/毒理作用
        if (null != widget.reportData.drugToxic)
          _buildSliverItem(
            context,
            index++,
            "药理/毒理作用",
            ReportResultItemText(
              text: widget.reportData.drugToxic,
            ),
          ),

        ///药物报告 ；不良反应/毒副作用
        if (null != widget.reportData.drugReaction)
          _buildSliverItem(
            context,
            index++,
            "不良反应/毒副作用",
            ReportResultItemText(
              text: widget.reportData.drugReaction,
            ),
          ),

        ///药物报告 ；药物的相互作用
        if (null != widget.reportData.drugInteraction)
          _buildSliverItem(
            context,
            index++,
            "药物的相互作用",
            ReportResultItemText(
              text: widget.reportData.drugInteraction,
            ),
          ),
      ],
    );
  }

  Widget _buildSliverItem(context, index, title, Widget child) {
    print("index==" + index.toString());
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
                  UiUitls.getReportDetailIndexIcon(index),
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
                    title,
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
            padding: EdgeInsets.only(top: 15, bottom: 0),
            margin: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: child,
          )
        ],
      ),
    );
  }
}
