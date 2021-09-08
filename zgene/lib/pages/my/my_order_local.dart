import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/pages/home/home_getHttp.dart';

import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/time_utils.dart';

class MyoRderNav extends StatefulWidget {
  @override
  _MyoRderNavState createState() => _MyoRderNavState();
}

class _MyoRderNavState extends State<MyoRderNav> {
  List goldList = [];

  @override
  void initState() {
    super.initState();
    HomeGetHttp(19, (result) {
      ContentModel contentModel = ContentModel.fromJson(result);
      goldList.clear();
      setState(() {
        goldList = contentModel.archives;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 11),
      margin: EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: _items(context),
    );
  }

  _items(BuildContext context) {
    if (goldList == null) return null;
    List<Widget> items = [];
    for (var i = 0; i < goldList.length; i++) {
      items.add(_item(context, i));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  Widget _item(BuildContext context, int index) {
    Archives archives = goldList[index];
    return GestureDetector(
      onTap: () {
        CommonUtils.toUrl(
            context: context, type: archives.linkType, url: archives.linkUrl);
      },
      child: Column(
        children: <Widget>[
          FadeInImage.assetNetwork(
              placeholder: 'assets/images/home/img_default2.png',
              image: CommonUtils.splicingUrl(archives.imageUrl),
              width: 80,
              height: 80,
              fadeInDuration: TimeUtils.fadeInDuration(),
              fadeOutDuration: TimeUtils.fadeOutDuration(),
              fit: BoxFit.fill,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/home/img_default2.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.fill,
                );
              }),
          Text(
            archives.title,
            style: TextStyle(fontSize: 13, color: ColorConstant.TextMainBlack),
          )
        ],
      ),
    );
  }
}
