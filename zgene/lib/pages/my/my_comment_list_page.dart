import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/comment_record_model.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/refresh_config_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

///我的评论列表
class MyCommentListPage extends StatefulWidget {
  @override
  _MyCommentListPageState createState() => _MyCommentListPageState();
}

class _MyCommentListPageState extends State<MyCommentListPage>
    with AutomaticKeepAliveClientMixin {
  Map<String, dynamic> responseString;
  List list = [];
  List tempList = [];
  var isLoad = true;
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
    HttpUtils.requestHttp(
      ApiConstant.myCommentList,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) {
        List<CommentRecordModel> tempList = result
            .map((m) => new CommentRecordModel.fromJson(m))
            .toList()
            .cast<CommentRecordModel>();
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
        } else {
          _controller.finishLoad(noMore: true);
        }
        setState(() {});
      },
      onError: (code, error) {
        if(page==1&&list.length==0){
          _controller=null;
          errorCode=2;
          setState(() {
          });
        }
      },
    );
  }

  ///点击事件
  _onTapEvent(int type,CommentRecordModel commentRecordModel) {
    print(type);
    switch (type) {
      case 1: //评论
        Map<String, dynamic> map = new HashMap();
        map["id"] = commentRecordModel.target.id;
        map["chid"] = commentRecordModel.target.chid;
        // NavigatorUtil.push(context, ArticleDetailPage(params: map));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
      }):EasyRefresh(
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
          await Future.delayed(Duration(seconds: 1), () {
            // 获取数据
            getHttp();
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
            _controller.finishLoad();
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
          CommentRecordModel commentRecordModel=list[index];
          Target target=commentRecordModel.target;
          if(target.imageUrl.isEmpty){
            return _commentView(index);
          }else{
            return _commentPictureView(index);
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

  ///评论（有图）
  _commentPictureView(int index) {
    CommentRecordModel commentRecordModel = list[index];
    return GestureDetector(
      onTap: () {
        _onTapEvent(1,commentRecordModel);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/home/img_default_avatar.png',
                        image: CommonUtils.splicingUrl(commentRecordModel.author.avatar),
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        fadeInDuration: TimeUtils.fadeInDuration(),
                        fadeOutDuration: TimeUtils.fadeOutDuration(),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/home/img_default_avatar.png',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          );
                        }),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          commentRecordModel.author.nickname,
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorConstant.TextMainColor,
                          ),
                        ),
                        constraints: BoxConstraints(maxWidth: 200),
                        margin: EdgeInsets.fromLTRB(0, 2, 10, 0),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Text(
                          TimeUtils.getTimeText(commentRecordModel.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstant.TextSecondColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: double.infinity,
              child: Text(
                commentRecordModel.content,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConstant.TextMainColor,
                ),
                maxLines: 5,
              ),
            ),
            Container(
              width: double.infinity,
              height: 63,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Stack(
                children: [
                  Positioned(
                    top: 3,
                    left: 0,
                    right: 68,
                    child: Text(
                      commentRecordModel.target.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConstant.TextMainColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/home/img_default2.png',
                          image: CommonUtils.splicingUrl(commentRecordModel.target.imageUrl),
                          width: 58,
                          height: 43,
                          alignment: Alignment.bottomRight,
                          fit: BoxFit.cover,
                          fadeInDuration: TimeUtils.fadeInDuration(),
                          fadeOutDuration: TimeUtils.fadeOutDuration(),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/home/img_default2.png',
                              width: 58,
                              height: 43,
                              alignment: Alignment.bottomRight,
                              fit: BoxFit.cover,
                            );
                          }),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///评论（无图片）
  _commentView(int index) {
    CommentRecordModel commentRecordModel = list[index];
    return GestureDetector(
      onTap: () {
        _onTapEvent(1,commentRecordModel);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/home/img_default_avatar.png',
                        image: CommonUtils.splicingUrl(commentRecordModel.author.avatar),
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        fadeInDuration: TimeUtils.fadeInDuration(),
                        fadeOutDuration: TimeUtils.fadeOutDuration(),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/home/img_default_avatar.png',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          );
                        }),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          commentRecordModel.author.nickname,
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorConstant.TextMainColor,
                          ),
                        ),
                        constraints: BoxConstraints(maxWidth: 200),
                        margin: EdgeInsets.fromLTRB(0, 2, 10, 0),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Text(
                          TimeUtils.getTimeText(commentRecordModel.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstant.TextSecondColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                commentRecordModel.content,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConstant.TextMainColor,
                ),
                maxLines: 5,
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text(
                commentRecordModel.target.title,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConstant.TextMainColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
