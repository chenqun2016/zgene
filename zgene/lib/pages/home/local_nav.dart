import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/bindcollector/bind_collector_page.dart';
import 'package:zgene/pages/my/add_address_page.dart';
import 'package:zgene/pages/my/order_step_page.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'home_getHttp.dart';

class LocalNav extends StatefulWidget {
  @override
  _LocalNavState createState() => _LocalNavState();
}

class _LocalNavState extends State<LocalNav> {
  List goldList = [];

  @override
  void initState() {
    super.initState();
    HomeGetHttp(9, (result) {
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
      margin: EdgeInsets.only(top: 16, left: 15, right: 15),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
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
        print("1111111111111111111111111111111111");
        print(archives.linkType);
        CommonUtils.toUrl(
            context: context, type: archives.linkType, url: archives.linkUrl);
        // if (0 == index) {
        //   NavigatorUtil.push(context, BindCollectorPage());
        // }
        // if (1 == index) {
        //   NavigatorUtil.push(context, OrderStepPage());
        // }
        // if (2 == index) {
        //   NavigatorUtil.push(context, AddAddressPage());
        // }
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
