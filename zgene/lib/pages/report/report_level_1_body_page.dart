import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/models/report_des_model.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/my_inherited_widget.dart';

class ReportLevel1BodyPage extends StatefulWidget {
  final String id;
  String serialNum;
  final String type;
  final List<Items> tags;

  ReportLevel1BodyPage({Key key, this.id, this.serialNum, this.type, this.tags})
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
    var tag = data.tag;
    Items item;

    ///用药指导是2个标签，其他都是3个
    if (widget.tags.length == 2) {
      if (null != tag) {
        if ("-1" == tag || "0" == tag) {
          item = widget.tags[0];
        } else {
          item = widget.tags[1];
        }
      } else if (null != data.conclusion) {
        if ("高风险" == data.conclusion) {
          item = widget.tags[1];
        } else {
          item = widget.tags[0];
        }
      }
    } else {
      ///其他
      if (null != tag) {
        if ("-1" == tag) {
          item = widget.tags[0];
        } else if ("0" == tag) {
          item = widget.tags[1];
        } else {
          item = widget.tags[2];
        }
      } else if (null != data.conclusion) {
        if ("高风险" == data.conclusion) {
          item = widget.tags[2];
        } else if ("一般风险" == data.conclusion) {
          item = widget.tags[1];
        } else {
          item = widget.tags[0];
        }
      }
    }

    return GestureDetector(
      onTap: () {
        CommonUtils.toUrl(
            context: context,
            type: 2,
            url: CommonConstant.ROUT_report_detail +
                "?itemid=${data.itemid}&id=${widget.id}");
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
                UiUitls.getAssetIcon(item.color),
                width: 22,
                height: 22,
              ),
              Padding(
                padding: EdgeInsets.only(left: 6, right: 28),
                child: Text(
                  item.title,
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
