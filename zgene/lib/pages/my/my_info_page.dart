import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/ui_uitls.dart';

///我的资料
class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage>
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
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
                            image:
                                AssetImage("assets/images/mine/icon_back.png"),
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "个人资料",
                          style: TextStyle(
                            color: ColorConstant.TextMainBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _getMyInfo(),
                _editorMyInfo(),
              ],
            ),
            Positioned(
                bottom: 40,
                left: 16,
                right: 16,
                height: 55,
                child: RaisedButton(
                  color: ColorConstant.TextMainColor,
                  child: Text(
                    "保存",
                    style: TextStyle(
                      color: ColorConstant.WhiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  onPressed: () {
                    _onTapEvent(5);
                  },
                )),
          ],
        ),
      ),
    );
  }

  ///个人信息
  _getMyInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 22, 32, 22),
      margin: EdgeInsets.only(bottom: 16, top: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.only(right: 13),
            child: Image(
              image: AssetImage("assets/images/mine/img_my_avatar.png"),
              height: 66,
              width: 66,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jack",
                style: TextStyle(
                  fontSize: 28,
                  color: ColorConstant.TextMainBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "世界那么大，我想去看看。",
                style: TextStyle(
                  fontSize: 15,
                  color: ColorConstant.TextThreeColor,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  ///编辑个人资料
  _editorMyInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 18, 16, 18),
      margin: EdgeInsets.only(bottom: 80),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _onTapEvent(2);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "头像",
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
                    )),
                Positioned(
                  right: 22,
                  child: Image(
                    image: AssetImage("assets/images/mine/img_my_avatar.png"),
                    height: 45,
                    width: 45,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _onTapEvent(3);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "用户名称",
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
                    )),
                Positioned(
                  right: 22,
                  top: 12,
                  child: Text(
                    "Jack",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstant.TextThreeColor,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                  width: double.infinity,
                  height: 45,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "性别",
                    style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
                  )),
              // Positioned(
              //   right: 22,
              //   top: 12,
              //   child: Row(
              //     children: [
              //       RadioListTile(
              //           title: Text("第三个单选按钮"),
              //           value: 3,
              //           groupValue: radioValue,
              //           onChanged: (value){
              //             setState(() {
              //               radioValue = value;
              //             });
              //           }
              //       )
              //     ],
              //   ),
              // ),
              Positioned(
                right: 0,
                top: 15,
                child: Image(
                  image: AssetImage("assets/images/mine/icon_my_right.png"),
                  height: 16,
                  width: 16,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _onTapEvent(4);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "简介",
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
                    )),
                Positioned(
                  right: 22,
                  top: 12,
                  child: Text(
                    "选填",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstant.TextThreeColor,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///点击事件
  _onTapEvent(index) {
    switch (index) {
      case 1: //返回
        Navigator.pop(context);
        break;
      case 2: //头像
        UiUitls.showToast("头像");
        break;
      case 3: //用户名称
        UiUitls.showToast("用户名称");
        break;
      case 4: //简介
        UiUitls.showToast("简介");
        break;
      case 5: //保存
        UiUitls.showToast("保存");
        break;
    }
  }
}
