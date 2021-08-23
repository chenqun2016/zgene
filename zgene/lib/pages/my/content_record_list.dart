

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/content_record_model.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/refresh_config_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

///内容记录列表（收藏，浏览记录，点赞，消费记录）
class ContentRecordList extends StatefulWidget {
  final int type;

  ContentRecordList({Key key, this.type}) : super(key: key);

  @override
  _ContentRecordListState createState() => _ContentRecordListState();
}

class _ContentRecordListState extends State<ContentRecordList>
    with AutomaticKeepAliveClientMixin {
  Map<String, dynamic> responseString;
  List list = [];
  List tempList = [];
  int page = 1;
  EasyRefreshController _controller;
  int errorCode=0;//0.正常 1.暂无数据 2.错误 3.没有网络
  var lastTime;//最后点击的时间

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }

  ///获取内容列表
  getHttp() async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      if(page==1&&list.length==0){
        errorCode=3;
        _controller=null;
        setState(() {
        });
      }
      return;
    }
    Map<String, dynamic> map = new HashMap();
    map["page"] = page;
    map["page_size"] = CommonConstant.PAGE_SIZE;
    String url = "";
    switch (widget.type) {
      case 1: //历史
        url = ApiConstant.userHistoryList;
        break;
      case 2: //收藏
        url = ApiConstant.favoritesRecordList;
        break;
      case 3: //点赞
        url = ApiConstant.goodRecordList;
        break;
      case 4: //消费
        url = ApiConstant.buyRecordList;
        break;
    }

    HttpUtils.requestHttp(
      url,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) {
        List<ContentRecordModel> tempList = result
            .map((m) => new ContentRecordModel.fromJson(m))
            .toList()
            .cast<ContentRecordModel>();

        //判断是不是暂无数据
        if(page==1&&list.length==0&&tempList.length==0){
          errorCode=1;
          _controller=null;
          setState(() {
          });
          return;
        }
        //设置正常状态
        errorCode=0;
        if(_controller==null) {
          _controller = EasyRefreshController();
        }
        if (page == 1) {
          list.clear();
        }
        page++;
        int length = list.length;
        list.insertAll(length, tempList);
        if (tempList.length >= CommonConstant.PAGE_SIZE) {
          _controller.finishLoad(noMore: false);
          print("noMore:false");
        } else {
          _controller.finishLoad(noMore: true);
          print("noMore:true");
        }
        setState(() {});
      },
      onError: (code, error) {
        if(page==1&&list.length==0){
          errorCode=2;
          _controller=null;
          setState(() {
          });
        }
      },
    );
  }

  ///点击事件
  _onTapEvent(int index) {
    Archive archives = list[index].archive;
    Map<String, dynamic> map = new HashMap();
    map["id"] = archives.id;
    map["chid"] = archives.chid;
    if (archives.chid == 4) {
      //1：视频 ，2：音频， 3：文章 ，4：合集
      // NavigatorUtils.push(context, AlbumDetailPage(params: map));
    } else {
      // NavigatorUtils.push(context, ArticleDetailPage(params: map));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ColorConstant.WhiteColor,
      body: errorCode!=0?UiUitls.getErrorPage(type:errorCode,onClick: (){
        if(lastTime==null){
          lastTime=DateTime.now();
          page=1;
          getHttp();
        }else{
          //可以点击
          if(TimeUtils.intervalClick(lastTime,2)){
            lastTime=DateTime.now();
            page=1;
            getHttp();
          }
        }
      })
          :EasyRefresh(
        // 是否开启控制结束加载
        enableControlFinishLoad: false,
        firstRefresh: true,
        // 控制器
        controller: _controller,
        header: RefreshConfigUtils.classicalHeader(),
        // 自定义顶部上啦加载
        footer: RefreshConfigUtils.classicalFooter(),
        child: _listView,
        //下拉刷新事件回调
        onRefresh: () async {
          page = 1;
          // 获取数据
          getHttp();
          await Future.delayed(Duration(seconds: 1), () {
            // 重置刷新状态 【没错，这里用的是resetLoadState】
            _controller.resetLoadState();
          });
        },
        // 上拉加载事件回调
        onLoad: () async {
          await Future.delayed(Duration(seconds: 1), () {
            // 获取数据
            getHttp();
            // 结束加载
            // _controller.finishLoad();
            // _controller.finishLoad(noMore:true);
          });
        },
      ),
    );
  }

  ///列表
  Widget get _listView {
    return Container(
      margin: EdgeInsets.all(0),
      color: ColorConstant.WhiteColor,
      child: ListView.separated(
        itemCount: list.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          Archive archives = list[index].archive;
          int chid = archives.chid; //1：视频 ，2：音频， 3：文章 ，4：合集
          String imageUrl = archives.imageUrl;
          switch (chid) {
            case 1: //视频
              return _itemVideoView(index);
              break;
            case 2: //音频
              return _itemAudioView(index);
              break;
            case 3:
              if (imageUrl.isEmpty) {
                return _itemArticleView(index); //文章无图
              } else {
                return _itemArticlePictureView(index); //文章有图
              }
              break;
            case 4: //合集
              return _itemCollectionView(index);
              break;
            default:
              return Text("");
              break;
          }
        },
        //分割器构造器
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1.0,
            indent: 15,
            endIndent: 15,
            color: ColorConstant.LineMainColor,
          );
        },
      ),
    );
  }

  ///文章无图片的种类
  _itemArticleView(int index) {
    Archive archives = list[index].archive;
    return GestureDetector(
      onTap: () {
        _onTapEvent(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Visibility(
                        visible: archives.isTop,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                          child: Image(
                            image: AssetImage(
                                "assets/images/home/icon_home_top.png"),
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                    WidgetSpan(
                      child: Visibility(
                        visible: archives.coin != 0,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                          child: Image(
                            image: AssetImage(
                                "assets/images/home/icon_home_money.png"),
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: archives.title,
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorConstant.TextMainColor,
                      ),
                    ),
                  ],
                ),
                maxLines: 3,
              ),
            ),
            _bottomView(index),
          ],
        ),
      ),
    );
  }

  ///文章有图片的种类
  _itemArticlePictureView(int index) {
    Archive archives = list[index].archive;
    return GestureDetector(
      onTap: () {
        _onTapEvent(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 86,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 125, 0),
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Visibility(
                                visible: archives.isTop,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/home/icon_home_top.png"),
                                    height: 16,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                            WidgetSpan(
                              child: Visibility(
                                visible: archives.coin != 0,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/home/icon_home_money.png"),
                                    height: 16,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: archives.title,
                              style: TextStyle(
                                fontSize: 18,
                                color: ColorConstant.TextMainColor,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/home/img_default2.png',
                          image: CommonUtils.splicingUrl(archives.imageUrl),
                          width: 115,
                          height: 86,
                          fadeInDuration: TimeUtils.fadeInDuration(),
                          fadeOutDuration: TimeUtils.fadeOutDuration(),
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/home/img_default2.png',
                              width: 115,
                              height: 86,
                              fit: BoxFit.cover,
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            _bottomView(index),
          ],
        ),
      ),
    );
  }

  ///视频的种类
  _itemVideoView(int index) {
    Archive archives = list[index].archive;
    return GestureDetector(
      onTap: () {
        _onTapEvent(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Visibility(
                        visible: archives.isTop,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                          child: Image(
                            image: AssetImage(
                                "assets/images/home/icon_home_top.png"),
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                    WidgetSpan(
                      child: Visibility(
                        visible: archives.coin != 0,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                          child: Image(
                            image: AssetImage(
                                "assets/images/home/icon_home_money.png"),
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: archives.title,
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorConstant.TextMainColor,
                      ),
                    ),
                  ],
                ),
                maxLines: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/home/img_default2.png',
                          image: CommonUtils.splicingUrl(archives.imageUrl),
                          width: double.infinity,
                          height: 193,
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          fadeInDuration: TimeUtils.fadeInDuration(),
                          fadeOutDuration: TimeUtils.fadeOutDuration(),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/home/img_default2.png',
                              width: double.infinity,
                              height: 193,
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                            );
                          }),
                    ),
                  ),
                  Positioned(
                    child: Image(
                      image: AssetImage(
                          "assets/images/home/icon_home_video_play.png"),
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              ),
            ),
            _bottomView(index),
          ],
        ),
      ),
    );
  }

  ///音频的种类
  _itemAudioView(int index) {
    Archive archives = list[index].archive;
    return GestureDetector(
      onTap: () {
        _onTapEvent(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.fromLTRB(5, 5, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: Image(
                          image: AssetImage(
                              "assets/images/home/bg_home_audio.png"),
                          width: 104,
                          height: 104,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        child: Container(
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                                placeholder:
                                'assets/images/home/img_default1.png',
                                image:
                                CommonUtils.splicingUrl(archives.imageUrl),
                                width: 66,
                                height: 66,
                                fit: BoxFit.cover,
                                fadeInDuration: TimeUtils.fadeInDuration(),
                                fadeOutDuration: TimeUtils.fadeOutDuration(),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/home/img_default1.png',
                                    width: 66,
                                    height: 66,
                                    fit: BoxFit.cover,
                                  );
                                }),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          child: Image(
                            image: AssetImage(
                                "assets/images/home/icon_home_audio_play.png"),
                            width: 66,
                            height: 66,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                          child: Image(
                            image: AssetImage(
                                "assets/images/home/icon_home_audio.png"),
                            width: 30,
                            height: 25,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 10,
                    left: 0,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(110, 0, 0, 0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Visibility(
                                visible: archives.isTop,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/home/icon_home_top.png"),
                                    height: 16,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                            WidgetSpan(
                              child: Visibility(
                                visible: archives.coin != 0,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/home/icon_home_money.png"),
                                    height: 16,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: archives.title,
                              style: TextStyle(
                                fontSize: 18,
                                color: ColorConstant.TextMainColor,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: _bottomView(index),
            ),
          ],
        ),
      ),
    );
  }

  ///合集的种类
  _itemCollectionView(int index) {
    Archive archives = list[index].archive;
    return GestureDetector(
      onTap: () {
        _onTapEvent(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: ColorConstant.BgColor,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.fromLTRB(0, 15, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                  child: Image(
                    image: AssetImage(
                        "assets/images/home/icon_home_album_tag.png"),
                    height: 20,
                    width: 40,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Visibility(
                              visible: archives.isTop,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                                child: Image(
                                  image: AssetImage(
                                      "assets/images/home/icon_home_top.png"),
                                  height: 16,
                                  width: 16,
                                ),
                              ),
                            ),
                          ),
                          WidgetSpan(
                            child: Visibility(
                              visible: archives.coin != 0,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 5, 1),
                                child: Image(
                                  image: AssetImage(
                                      "assets/images/home/icon_home_money.png"),
                                  height: 16,
                                  width: 16,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: archives.title,
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorConstant.TextMainColor,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 193,
              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                    right: 0,
                    child: Image(
                      image: AssetImage(
                          "assets/images/home/icon_home_album_right.png"),
                      height: 193,
                      width: 22,
                    ),
                  ),
                  Positioned(
                    left: 15,
                    right: 18,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/home/img_default2.png',
                          image: CommonUtils.splicingUrl(archives.imageUrl),
                          width: double.infinity,
                          height: 193,
                          fit: BoxFit.cover,
                          fadeInDuration: TimeUtils.fadeInDuration(),
                          fadeOutDuration: TimeUtils.fadeOutDuration(),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/home/img_default2.png',
                              width: double.infinity,
                              height: 193,
                              fit: BoxFit.cover,
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: _bottomView(index),
            ),
          ],
        ),
      ),
    );
  }

  ///底部显示时间和评论点赞浏览数
  _bottomView(int index) {
    Archive archives = list[index].archive;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned(
            child: Text(
              TimeUtils.getTimeText(archives.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: ColorConstant.TextSecondColor,
              ),
            ),
          ),
          Positioned(
              right: 0,
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: Image(
                          image: AssetImage(
                              "assets/images/home/icon_home_comment.png"),
                          height: 12,
                          width: 12,
                        ),
                      ),
                      Text(
                        CommonUtils.getCountText(archives.countComment),
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstant.TextSecondColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 0, 4, 0),
                        child: Image(
                          image: AssetImage(
                              "assets/images/home/icon_comment_good_n.png"),
                          height: 12,
                          width: 12,
                        ),
                      ),
                      Text(
                        CommonUtils.getCountText(archives.countDigg),
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstant.TextSecondColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 0, 4, 0),
                        child: Image(
                          image: AssetImage(
                              "assets/images/home/icon_home_look.png"),
                          height: 15,
                          width: 12,
                        ),
                      ),
                      Text(
                        CommonUtils.getCountText(archives.count),
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstant.TextSecondColor,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
