import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/widget/home_recommend_widget.dart';

class ContentTabItem extends StatefulWidget {
  const ContentTabItem({Key key}) : super(key: key);

  @override
  _ContentTabItemState createState() => _ContentTabItemState();
}

class _ContentTabItemState extends State<ContentTabItem> {
  List types = [28, 29, 30];
  int indexOf = 0;
  List<Archives> datas;
  int pageSize = 5;
  bool expend = false;
  @override
  void initState() {
    super.initState();
    getHttp();
  }

  getHttp() {
    Map<String, dynamic> map = new HashMap();
    map['cid'] = types[indexOf];
    if (28 == types[indexOf]) {
      map['tag'] = '精选';
      map['page_size'] = pageSize;
    }

    HttpUtils.requestHttp(
      ApiConstant.contentList,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        try {
          ContentModel contentModel = ContentModel.fromJson(result);
          if (null != contentModel &&
              null != contentModel.archives &&
              contentModel.archives.length > 5 &&
              !expend) {
            datas = contentModel.archives.take(5);
          } else {
            datas = contentModel.archives;
          }
          setState(() {});
        } catch (e) {
          print(e);
        }
      },
      onError: (code, error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    indexOf = HomeRecommendWidget.of(context);
    return datas == null
        ? Text("")
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 15, bottom: 15),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: datas.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _getItemWidget(index),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  staggeredTileBuilder: (int index) =>
                      datas[index].viewStyle == 1
                          ? StaggeredTile.extent(2, 185)
                          : StaggeredTile.extent(1, 200),
                ),
              ),
              MaterialButton(
                minWidth: 184,
                height: 40,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: ColorConstant.TextMainColor),
                ),
                color: ColorConstant.WhiteColor,
                onPressed: () {
                  setState(() {
                    expend = !expend;
                    pageSize = expend ? 10 : 5;
                    getHttp();
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(!expend ? "加载更多" : "收起",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.TextMainColor,
                        )),
                    Image.asset(
                      !expend
                          ? "assets/images/home/icon_next_down.png"
                          : "assets/images/home/icon_next_up.png",
                      height: 16,
                      width: 16,
                    )
                  ],
                ),
              )
            ],
          );
  }

  Widget _getItemWidget(int index) {
    return datas[index].viewStyle == 1
        ? _getItemWidgetType1(datas[index])
        : _getItemWidgetType2(datas[index]);
  }

  //短的
  Widget _getItemWidgetType2(Archives item) {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstant.bg_F7F7F8,
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              CommonUtils.toUrl(
                  context: context, type: item.linkType, url: item.linkUrl);
            },
            child: PhysicalModel(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14), topLeft: Radius.circular(14)),
              clipBehavior: Clip.antiAlias,
              child: new CachedNetworkImage(
                width: double.infinity,
                // 设置根据宽度计算高度
                height: 112,
                // 图片地址
                imageUrl: CommonUtils.splicingUrl(item.imageUrl),
                // 填充方式为cover
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => Text(""),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Text(
              item.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 8, bottom: 14),
            alignment: Alignment.bottomLeft,
            child: Text(
              "Z基因App",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ColorConstant.Text_5E6F88,
              ),
            ),
          ))
        ],
      ),
    );
  }

  //长的
  Widget _getItemWidgetType1(Archives item) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (indexOf == 0)
              Container(
                margin: EdgeInsets.only(right: 9),
                padding: EdgeInsets.fromLTRB(7, 1, 7, 3),
                decoration: BoxDecoration(
                  color: ColorConstant.Text_5FC88F,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Text(
                  item.category.categoryName,
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.WhiteColor,
                  ),
                ),
              ),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: GestureDetector(
            onTap: () {
              CommonUtils.toUrl(
                  context: context, type: item.linkType, url: item.linkUrl);
            },
            child: PhysicalModel(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              child: new CachedNetworkImage(
                width: double.infinity,
                // 设置根据宽度计算高度
                height: 152,
                // 图片地址
                imageUrl: CommonUtils.splicingUrl(item.imageUrl),
                // 填充方式为cover
                fit: BoxFit.fill,
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/home/img_default2.png"),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies==" +
        HomeRecommendWidget.of(context, listen: false).toString());

    var index = HomeRecommendWidget.of(context, listen: false);
    if (index != indexOf) {
      indexOf = index;
      getHttp();
    }
  }
}
