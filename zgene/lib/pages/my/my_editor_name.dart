import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/ui_uitls.dart';

///编辑姓名
class MyEditorPage extends StatefulWidget {
  @override
  _MyEditorPageState createState() => _MyEditorPageState();
}

class _MyEditorPageState extends State<MyEditorPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mine/img_bg_my.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.only(top: 48),
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    width: 40,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        _onTapEvent(1);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Image(
                        image: AssetImage("assets/images/mine/icon_back.png"),
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "修改用户名称",
                      style: TextStyle(
                        color: ColorConstant.TextMainBlack,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _onTapEvent(2);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        "完成",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.TextMainBlack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              margin: EdgeInsets.fromLTRB(0, 17, 0, 0),
              height: 47,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextField(
                        // controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: "请输入用户名称",
                          border: InputBorder.none,
                          isCollapsed: true,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: ColorConstant.TextMainGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        textAlign: TextAlign.left,
                        textInputAction: TextInputAction.search,
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorConstant.TextMainBlack,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        onSubmitted: (value) {
                          _onTapEvent(2);
                        },
                        autocorrect: true,
                        autofocus: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      // textEditingController.clear();
                    },
                    child: Image(
                      image:
                      AssetImage("assets/images/mine/icon_quxiao.png"),
                      height: 18,
                      width: 18,
                    ),
                  ),
                ],
              ),


            ),
          ],
        ),
      ),
    );
  }

  ///点击事件
  _onTapEvent(index) {
    switch (index) {
      case 1: //返回
        Navigator.pop(context);
        break;
      case 2: //完成
        UiUitls.showToast("完成");
        break;
    }
  }
}
