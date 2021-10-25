import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/util/common_utils.dart';

class CourseNav extends StatefulWidget {
  const CourseNav({Key key}) : super(key: key);

  @override
  _CourseNavState createState() => _CourseNavState();
}

class _CourseNavState extends State<CourseNav>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List contentList = [];
  @override
  void initState() {
    super.initState();
    getHttp();
  }

  //TODO  更换新的接口参数
  getHttp() {
    Map<String, dynamic> map = new HashMap();
    map['cid'] = 34;
    map['order_by'] = 1;
    HttpUtils.requestHttp(
      ApiConstant.contentList,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        print(result);
        ContentModel contentModel = ContentModel.fromJson(result);
        contentList.clear();
        setState(() {
          contentList = contentModel.archives;
        });
      },
      onError: (code, error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "大家都在看",
            style: TextStyle(
                fontSize: 18,
                color: ColorConstant.TextMainBlack,
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(top: 0, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(children: [
              Image.asset(
                "assets/images/home/icon_home_course.png",
                height: 52,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount: contentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _item(index);
                  }),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _item(index) {
    Archives archives = contentList[index];
    return GestureDetector(
      onTap: () {
        CommonUtils.toUrl(
            context: context, type: archives.linkType, url: archives.linkUrl);
      },
      child: Column(
        children: [
          if (0 != index)
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Divider(
                height: 1,
              ),
            ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getIndex(index),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      archives.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorConstant.TextMainBlack,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (index < 3)
                  Image.asset(
                    "assets/images/home/icon_redu.png",
                    height: 18,
                    width: 18,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getIndex(index) {
    Widget w;
    if (0 == index) {
      w = Image.asset(
        "assets/images/home/icon_home_course_1.png",
        height: 34,
        width: 34,
      );
    } else if (1 == index) {
      w = Image.asset(
        "assets/images/home/icon_home_course_2.png",
        height: 34,
        width: 34,
      );
    } else if (2 == index) {
      w = Image.asset(
        "assets/images/home/icon_home_course_3.png",
        height: 34,
        width: 34,
      );
    } else {
      w = Container(
          height: 34,
          width: 34,
          alignment: Alignment.center,
          child: Text(
            "${index + 1}",
            style: TextStyle(
                fontSize: 16,
                color: ColorConstant.TextMainBlack,
                fontWeight: FontWeight.bold),
          ));
    }
    return w;
  }
}
