import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';

class MyReportScienceDetail extends StatefulWidget {
  const MyReportScienceDetail({Key key}) : super(key: key);

  @override
  _MyReportScienceDetailState createState() => _MyReportScienceDetailState();
}

class _MyReportScienceDetailState extends State<MyReportScienceDetail>
    with AutomaticKeepAliveClientMixin {
  List data = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  List wenxian = [
    "Roura E. Salivary leptin and TAS1R2/TAS1R3 polymorphisms are related to sweet taste sensitivity and carbohydrate intake from a buffet meal in healthy young adults[J]. British Journal of Nutrition, 2017:1.",
    "Alcohol and aldehyde dehydrogenase. Alcohol Alcohol",
  ];
  var geneSize = 5;
  var limit =
      """本检测结果根据已发表的论文成果计算得到, 从基因层面对您进行评估受限于当前人类认知水平和科技手段等因素, 本检测无法覆盖与该项目相关的所有基因位点;
      您的表现型由基因、环境等共同作用决定，我们的检测结果可能无法正确反映您的现状；""";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 90.0),
      child: Column(
        children: [
          _item1(),
          _item2(),
          _item3(),
        ],
      ),
    );
  }

  Widget _item3() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/report/img_report_science_3.png",
                  height: 46,
                  width: 46,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "参考文献",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.text_112950),
                  ),
                )
              ],
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 20),
              children: wenxian.map((e) => _item3Item(e)).toList(),
            ),
          ],
        ));
  }

  Widget _item3Item(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${wenxian.indexOf(text) + 1}、",
          style: TextStyle(
              color: ColorConstant.Text_5E6F88,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              fontSize: 12),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 15),
          child: Text(
            text,
            style: TextStyle(
                color: ColorConstant.Text_5E6F88,
                letterSpacing: 2,
                fontSize: 12),
          ),
        )),
      ],
    );
  }

  Widget _item2() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/report/img_report_science_2.png",
                height: 46,
                width: 46,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "检测限制 ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.text_112950),
                ),
              )
            ],
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(colors: [
                  Color(0xFFEDF3F6),
                  Color(0xFFEBEFF1).withAlpha(25),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Text(
                limit,
                style: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    letterSpacing: 2,
                    fontSize: 15),
              )),
        ],
      ),
    );
  }

  Widget _item1() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: "10",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: ColorConstant.text_112950)),
                TextSpan(
                  text: "个",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      color: ColorConstant.text_112950),
                ),
              ])),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: "2",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: ColorConstant.bg_EA4335)),
                TextSpan(
                  text: "个",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      color: ColorConstant.bg_EA4335),
                ),
              ]))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  " 共检测的点位 ",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.Text_5E6F88),
                ),
                Text(
                  "风险变异的点位",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.Text_5E6F88),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
                gradient: LinearGradient(colors: [
                  Color(0xFF5FC88F).withAlpha(40),
                  Color(0xFF5FC88F).withAlpha(0),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  " 基因 ",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.Text_5FC88F),
                ),
                Text(
                  "位点",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.Text_5FC88F),
                ),
                Text(
                  "基因型",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.Text_5FC88F),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(colors: [
                Color(0xFFEDF3F6),
                Color(0xFFEBEFF1).withAlpha(25),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: data
                  .getRange(0, geneSize)
                  .map((e) => _getItem1Item())
                  .toList(),
            ),
          ),
          if (geneSize < data.length)
            InkWell(
              onTap: () {
                setState(() {
                  geneSize = data.length;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/report/icon_jiantou_down.png",
                  height: 18,
                  width: 18,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _getItem1Item() {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.only(left: 20, right: 25, top: 18),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              child: Text(
                "ALDH2",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.text_112950),
              )),
          Positioned(
              left: 0,
              right: 0,
              child: Text(
                "rs671",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.text_112950),
              )),
          Positioned(
              right: 0,
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: "C/",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.text_112950)),
                TextSpan(
                  text: "C",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: ColorConstant.bg_EA4335),
                ),
              ])))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
