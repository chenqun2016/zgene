import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/my_inherited_widget.dart';

import 'report_level_2_page.dart';

class ReportLevel1BodyPage extends StatefulWidget {
  final String id;
  String serialNum;
  final String type;
  ReportLevel1BodyPage({Key key, this.id, this.serialNum, this.type})
      : super(key: key);

  @override
  _ReportLevel1BodyPageState createState() => _ReportLevel1BodyPageState();
}

class _ReportLevel1BodyPageState extends State<ReportLevel1BodyPage> {
  ScrollController listeningController;
  @override
  void initState() {
    listeningController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List data = MyInheritedWidget.of(context);
    return ListView.builder(
      controller: listeningController,
      shrinkWrap: true,
      itemCount: data.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, 12, 0, 20),
      itemBuilder: (BuildContext context, int index) {
        return _buildSliverItem(context, data[index], index);
      },
    );
  }

  Widget _buildSliverItem(context, data, index) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            ReportLevel2Page(
              id: widget.id,
              itemid: data.itemid,
              type: widget.type,
              serialNum: widget.serialNum,
            ));
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  data.chname,
                  style: TextStyle(
                      color: ColorConstant.TextMainBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ),
              Image.asset(
                UiUitls.getAssetIcon(data.tag == "1" ? "red" : "green"),
                width: 22,
                height: 22,
              ),
              Padding(
                padding: EdgeInsets.only(left: 6, right: 28),
                child: Text(
                  data.tag == "1" ? "需关注" : "正常",
                  style: TextStyle(
                      color: ColorConstant.Text_8E9AB,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ),
              Image.asset(
                "assets/images/mine/icon_my_name_right.png",
                width: 22,
                height: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies==" +
        MyInheritedWidget.of(context, listen: false).toString());
    if (listeningController?.hasClients) listeningController?.jumpTo(0);
  }
}
