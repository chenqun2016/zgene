import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/home/video_page.dart';

class VideoNav extends StatelessWidget {
  List<String> contents = ["得知基因结果，能做什么？", "生活中有哪些意想不到的事，是由基因决定的？"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 24, left: 15),
          child: Text(
            "解锁独一无二的你",
            style: TextStyle(
                fontSize: 18,
                color: ColorConstant.TextMainBlack,
                fontWeight: FontWeight.bold),
          ),
        ),
        FractionallySizedBox(
          //撑满父布局的宽度
          widthFactor: 1,
          child: Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: GestureDetector(
              onTap: () {
                NavigatorUtil.push(context, VideoPage());
              },
              child: PhysicalModel(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  "assets/images/banner.png",
                  height: 168,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: [
              Expanded(
                child: _item(context, 0),
              ),
              Expanded(
                child: _item(context, 1),
              )
            ],
          ),
        )
      ],
    );
  }

  _item(BuildContext context, int index) {
    return Container(
      height: 153,
      margin: EdgeInsets.only(top: 17),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image: index % 2 == 0
                ? AssetImage("assets/images/home/img_jiyinjieguo.png")
                : AssetImage("assets/images/home/img_jiyinjieguo2.png")),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Text(
        contents[index],
        style: TextStyle(
            fontSize: 16,
            color: index % 2 == 0
                ? ColorConstant.Text_776359
                : ColorConstant.Text_64747F,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
