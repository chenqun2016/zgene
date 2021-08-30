import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zgene/constant/color_constant.dart';

class ExploreNav extends StatelessWidget {
  List<String> contents = ["怎样的运动与饮食方案最适合我？", "会不会遗传某种疾病给下一代", "我吃什么药会有副作用吗？"];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "开启探索之旅",
              style: TextStyle(
                  fontSize: 18,
                  color: ColorConstant.TextMainBlack,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: contents.length,
                itemBuilder: (BuildContext context, int index) {
                  return _item(index);
                }),
          )
        ],
      ),
    );
  }

  Widget _item(position) {
    return Container(
        margin: EdgeInsets.only(left: 16, top: 10),
        width: 136,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 37),
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 14),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        contents[position],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorConstant.TextMainBlack,
                            fontWeight: FontWeight.bold),
                      )),
                  Text(
                    "共12项",
                    style: TextStyle(
                        fontSize: 13, color: ColorConstant.Text_8E9AB),
                  )
                ],
              ),
            ),
            Image.asset(
              "assets/images/home/icon_test_01.png",
              height: 90,
              width: 90,
            )
          ],
        ));
  }
}
