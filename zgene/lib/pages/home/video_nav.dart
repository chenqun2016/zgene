import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/pages/home/video_page.dart';
import 'package:zgene/util/common_utils.dart';

class VideoNav extends StatefulWidget {
  @override
  _VideoNavState createState() => _VideoNavState();
}

class _VideoNavState extends State<VideoNav>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List aloneList = [];

  @override
  void initState() {
    super.initState();
    // bus.on(CommonConstant.HomeRefush, (arg) {
    getHttp();
    // });
  }

  getHttp() {
    HomeGetHttp(12, (result) {
      ContentModel contentModel = ContentModel.fromJson(result);
      aloneList.clear();
      setState(() {
        aloneList = contentModel.archives;
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
    if (aloneList.length == 0) {
      return Text("");
    } else {
      print("video img==" + aloneList[0].imageUrl);
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
                  NavigatorUtil.push(
                      context, VideoPage(linkUrl: aloneList[0].linkUrl));
                },
                child: PhysicalModel(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: new CachedNetworkImage(
                    // width: 80,
                    // 设置根据宽度计算高度
                    height:
                        (169 / 343) * (MediaQuery.of(context).size.width - 30),
                    // 图片地址
                    imageUrl: CommonUtils.splicingUrl(aloneList[0].imageUrl),
                    // 填充方式为cover
                    fit: BoxFit.fill,

                    errorWidget: (context, url, error) => new Container(
                      child: new Image.asset(
                        'assets/images/home/img_default2.png',
                        height: 90,
                        width: 90,
                      ),
                    ),
                  ),
                  //  FadeInImage.assetNetwork(
                  //     placeholder: 'assets/images/home/img_default2.png',
                  //     image: CommonUtils.splicingUrl(aloneList[0].imageUrl),
                  //     height: 168,
                  //     fadeInDuration: TimeUtils.fadeInDuration(),
                  //     fadeOutDuration: TimeUtils.fadeOutDuration(),
                  //     fit: BoxFit.fill,
                  //     imageErrorBuilder: (context, error, stackTrace) {
                  //       return Image.asset(
                  //         'assets/images/home/img_default2.png',
                  //         width: 90,
                  //         height: 90,
                  //         fit: BoxFit.fill,
                  //       );
                  //     }),
                  // Image.asset(
                  //   "assets/images/banner.png",
                  //   height: 168,
                  //   fit: BoxFit.fill,
                  // ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: _item(context, 1),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: _item(context, 2),
                )
              ],
            ),
          )
        ],
      );
    }
  }

  _item(BuildContext context, int index) {
    if (index > (aloneList.length - 1)) {
      return Text("");
    } else {
      Archives archives = aloneList[index];
      return GestureDetector(
        onTap: () {
          CommonUtils.toUrl(
              context: context,
              type: archives.linkType,
              url: archives.linkUrl,
              archives: archives);
        },
        child: Container(
          height: (153 / 165) * ((MediaQuery.of(context).size.width - 30) / 2),
          margin: EdgeInsets.only(top: 17),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(
                    CommonUtils.splicingUrl(aloneList[index].imageUrl))),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            //
            // image: DecorationImage(
            //     fit: BoxFit.fill,
            //     image: index % 2 == 0
            //         ? AssetImage("assets/images/home/img_jiyinjieguo.png")
            //         : AssetImage("assets/images/home/img_jiyinjieguo2.png")),
            // borderRadius: BorderRadius.all(
            //   Radius.circular(10),
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                archives.title,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 16,
                  color: index % 2 == 0
                      ? ColorConstant.Text_776359
                      : ColorConstant.Text_64747F,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              Expanded(
                child: Text(""),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "去看看",
                    style: TextStyle(
                        fontSize: 14.5,
                        color: index % 2 == 0
                            ? ColorConstant.Text_776359
                            : ColorConstant.Text_64747F,
                        fontWeight: FontWeight.w500),
                  ),
                  Image.asset(
                    "assets/images/home/icon_to.png",
                    height: 16,
                    width: 16,
                  )
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
