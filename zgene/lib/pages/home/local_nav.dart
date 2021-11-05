import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/statistics_constant.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/umeng_utils.dart';

import 'home_getHttp.dart';

class LocalNav extends StatefulWidget {
  @override
  _LocalNavState createState() => _LocalNavState();
}

class _LocalNavState extends State<LocalNav>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List goldList = [];

  @override
  void initState() {
    super.initState();
    // bus.on(CommonConstant.HomeRefush, (arg) {
    getHttp();
    // });
  }

  getHttp() {
    HomeGetHttp(9, (result) {
      ContentModel contentModel = ContentModel.fromJson(result);
      goldList.clear();
      setState(() {
        goldList = contentModel.archives;
      });
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    super.dispose();
    // bus.off(CommonConstant.HomeRefush);
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
        UmengUtils.onEvent(StatisticsConstant.HOME_TOP, {
          StatisticsConstant.KEY_UMENG_L2:
              StatisticsConstant.HOME_FEATURE + (index + 1).toString()
        });
        print(archives.linkType);
        CommonUtils.toUrl(
            context: context,
            type: archives.linkType,
            url: archives.linkUrl,
            archives: archives);
        // if (0 == index) {
        //   NavigatorUtil.push(context, QRScannerView());
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
          // FadeInImage.assetNetwork(
          //     placeholder: 'assets/images/home/img_default2.png',
          //     image: CommonUtils.splicingUrl(archives.imageUrl),
          //     width: 80,
          //     height: 80,
          //     fadeInDuration: TimeUtils.fadeInDuration(),
          //     fadeOutDuration: TimeUtils.fadeOutDuration(),
          //     fit: BoxFit.fill,
          //     imageErrorBuilder: (context, error, stackTrace) {
          //       return Image.asset(
          //         'assets/images/home/img_default2.png',
          //         width: 80,
          //         height: 80,
          //         fit: BoxFit.fill,
          //       );
          //     }),
          new CachedNetworkImage(
            width: 80,
            // 设置根据宽度计算高度
            height: 80,
            // 图片地址
            imageUrl: CommonUtils.splicingUrl(archives.imageUrl),
            // 填充方式为cover
            fit: BoxFit.fill,

            errorWidget: (context, url, error) => new Container(
              child: new Image.asset(
                'assets/images/home/img_default2.png',
                height: 80,
                width: 80,
              ),
            ),
          ),
          Text(
            archives.title,
            style: TextStyle(
                fontSize: 13,
                color: ColorConstant.TextMainBlack,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
