import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/userInfo_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/my/my_editor_name.dart';
import 'package:zgene/pages/my/my_introduction.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/screen_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/camer_crop_image_route.dart';

///我的资料
class MyInfoPage extends StatefulWidget {
  UserInfoModel userInfo = UserInfoModel();
  MyInfoPage({Key key, this.userInfo}) : super(key: key);

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  int sexType = 0;
  String _avatatHttp = "";
  String _nickName = "";
  String _introduction = "";

  @override
  void initState() {
    super.initState();
    switch (widget.userInfo.gender) {
      case 0:
        sexType = 0;
        break;
      case 1:
        sexType = 1;
        break;
      case -1:
        sexType = -1;
        break;
      default:
        sexType = 0;
        break;
    }
    _nickName = widget.userInfo.nickname != "" ? widget.userInfo.nickname : "";
    _avatatHttp = widget.userInfo.avatar;
    _introduction = widget.userInfo.intro;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mine/img_bg_my.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 48),
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        width: 40,
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            _onTapEvent(1);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Image(
                            image:
                                AssetImage("assets/images/mine/icon_back.png"),
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "个人资料",
                          style: TextStyle(
                            color: ColorConstant.TextMainBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _getMyInfo(),
                _editorMyInfo(),
              ],
            ),
            Positioned(
                bottom: 40,
                left: 6,
                right: 6,
                height: 55,
                child: RaisedButton(
                  color: ColorConstant.TextMainColor,
                  child: Text(
                    "保存",
                    style: TextStyle(
                      color: ColorConstant.WhiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  onPressed: () {
                    _onTapEvent(5);
                  },
                )),
          ],
        ),
      ),
    );
  }

  ///个人信息
  _getMyInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 22, 32, 22),
      margin: EdgeInsets.only(bottom: 16, top: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Container(
          //   margin: EdgeInsets.only(right: 13),
          //   child: Image(
          //     image: AssetImage("assets/images/mine/img_my_avatar.png"),
          //     height: 66,
          //     width: 66,
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(right: 14),
            child: ClipOval(
              child: _avatatHttp == ""
                  ? Image.asset(
                      'assets/images/mine/img_my_avatar.png',
                      height: 66,
                      width: 66,
                    )
                  : new CachedNetworkImage(
                      width: 66,
                      // 设置根据宽度计算高度
                      height: 66,
                      // 图片地址
                      imageUrl: CommonUtils.splicingUrl(_avatatHttp),
                      // 填充方式为cover
                      fit: BoxFit.fill,

                      errorWidget: (context, url, error) => new Container(
                        child: new Image.asset(
                          'assets/images/mine/img_my_avatar.png',
                          height: 66,
                          width: 66,
                        ),
                      ),
                    ),
              // FadeInImage.assetNetwork(
              //     placeholder: 'assets/images/mine/img_my_avatar.png',
              //     image: CommonUtils.splicingUrl(_avatatHttp),
              //     width: 66,
              //     height: 66,
              //     fit: BoxFit.cover,
              //     fadeInDuration: TimeUtils.fadeInDuration(),
              //     fadeOutDuration: TimeUtils.fadeOutDuration(),
              //     imageErrorBuilder: (context, error, stackTrace) {
              //       return Image.asset(
              //         "assets/images/mine/img_my_avatar.png",
              //         height: 66,
              //         width: 66,
              //       );
              //     }),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenUtils.screenW(context) - 190.w,
                child: Text(
                  _nickName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 28,
                    color: ColorConstant.TextMainBlack,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: ScreenUtils.screenW(context) - 190.w,
                child: Text(
                  _introduction == "" ? "暂无简介" : _introduction,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: ColorConstant.TextThreeColor,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  ///编辑个人资料
  _editorMyInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 18, 16, 18),
      margin: EdgeInsets.only(bottom: 80),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _onTapEvent(2);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "头像",
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
                    )),
                Positioned(
                  right: 22,
                  child:
                      // Image(
                      //   image: AssetImage("assets/images/mine/img_my_avatar.png"),
                      //   height: 45,
                      //   width: 45,
                      // ),
                      Container(
                    margin: EdgeInsets.only(right: 14),
                    child: ClipOval(
                      child: _avatatHttp == ""
                          ? Image.asset(
                              'assets/images/mine/img_my_avatar.png',
                              height: 45,
                              width: 45,
                            )
                          : new CachedNetworkImage(
                              width: 45,
                              // 设置根据宽度计算高度
                              height: 45,
                              // 图片地址
                              imageUrl: CommonUtils.splicingUrl(_avatatHttp),
                              // 填充方式为cover
                              fit: BoxFit.fill,

                              errorWidget: (context, url, error) =>
                                  new Container(
                                child: new Image.asset(
                                  'assets/images/mine/img_my_avatar.png',
                                  height: 45,
                                  width: 45,
                                ),
                              ),
                            ),
                      // FadeInImage.assetNetwork(
                      //     placeholder:
                      //         'assets/images/mine/img_my_avatar.png',
                      //     image: CommonUtils.splicingUrl(_avatatHttp),
                      //     width: 45,
                      //     height: 45,
                      //     fit: BoxFit.cover,
                      //     fadeInDuration: TimeUtils.fadeInDuration(),
                      //     fadeOutDuration: TimeUtils.fadeOutDuration(),
                      //     imageErrorBuilder: (context, error, stackTrace) {
                      //       return Image.asset(
                      //         "assets/images/mine/img_my_avatar.png",
                      //         height: 45,
                      //         width: 45,
                      //       );
                      //     }),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _onTapEvent(3);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "用户名称",
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
                    )),
                Positioned(
                  right: 22,
                  top: 12,
                  child: Container(
                    width: ScreenUtils.screenW(context) - 190.w,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _nickName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorConstant.TextThreeColor,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                  width: double.infinity,
                  height: 45,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "性别",
                    style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
                  )),
              Positioned(
                right: 0,
                top: 8,
                child: Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: sexType,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      onChanged: (value) {
                        setState(() {
                          sexType = value;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          sexType = 1;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 15), child: Text("男")),
                    ),
                    Radio(
                      value: -1,
                      groupValue: sexType,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      onChanged: (value) {
                        setState(() {
                          sexType = value;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          sexType = -1;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 15), child: Text("女")),
                    ),
                    Radio(
                      value: 0,
                      groupValue: sexType,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      onChanged: (value) {
                        setState(() {
                          sexType = value;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          sexType = 0;
                        });
                      },
                      child: Text("保密"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _onTapEvent(4);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "简介",
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
                    )),
                Positioned(
                  right: 22,
                  top: 12,
                  child: Text(
                    "选填",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstant.TextThreeColor,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///点击事件
  _onTapEvent(index) async {
    switch (index) {
      case 1: //返回
        Navigator.pop(context, null);
        break;
      case 2: //头像
        _pickImage();
        break;
      case 3: //用户名称
        final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyEditorPage(
                      nikeName: _nickName,
                    )));
        if (result != null) {
          print(result);
          _nickName = result;
        } else {}
        setState(() {});
        break;
      case 4: //简介
        final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyIntroductionPage(
                      introduction: _introduction,
                    )));
        if (result != null) {
          print(result);
          _introduction = result;
        } else {}
        setState(() {});
        break;
      case 5: //保存r
        modificationUserInfo();
        break;
    }
  }

//保存信息
  modificationUserInfo() {
    Map<String, dynamic> map = new HashMap();
    map["nickname"] = _nickName;
    map["gender"] = sexType;
    map["avatar"] = _avatatHttp;
    map["intro"] = _introduction;

    HttpUtils.requestHttp(
      ApiConstant.userInfo,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) {
        print(data.toString());
        getUserInfo();
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
      },
    );
  }

  getUserInfo() {
    HttpUtils.requestHttp(
      ApiConstant.userInfo,
      method: HttpUtils.GET,
      onSuccess: (data) {
        EasyLoading.showSuccess('保存成功');
        UserInfoModel userInfoModel = UserInfoModel.fromJson(data);
        widget.userInfo = userInfoModel;
        var spUtils = SpUtils();
        spUtils.setStorage(SpConstant.UserName, userInfoModel.nickname);
        spUtils.setStorage(SpConstant.UserAvatar, userInfoModel.avatar);
        spUtils.setStorage(SpConstant.userIntro, userInfoModel.intro);
        Navigator.pop(context, widget.userInfo);
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
        print(error);
      },
    );
  }

  Future getImage(bool isTakePhoto) async {
    Navigator.pop(context);
    try {
      if(!isTakePhoto && PlatformUtils.isAndroid){
        bool hasPermission =  await ImageCrop.requestPermissions();
        print("hasPermission=="+hasPermission.toString());
        if(!hasPermission){
          EasyLoading.showError("请先去设置打开相册权限。");
          return;
        }
      }
      final picker = ImagePicker();

      var image = await picker.getImage(
          source: isTakePhoto ? ImageSource.camera : ImageSource.gallery);

      if (image == null) {
        return;
      } else {
        print("成功了");

        cropImage(File(image.path));
      }
    } catch (e) {
      EasyLoading.showError("请先去设置打开相机或相册权限。");
    }
  }

  void cropImage(File originalImage) async {
    File result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CropImageRoute(originalImage)));

    if (result == null) {
      print('上传失败');
    } else {
      getUserAvatar(result);

      setState(() {});
    }
  }

  _pickImage() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 160,
              child: Column(
                children: <Widget>[
                  _takePhotoItem('拍照', true),
                  _takePhotoItem('从相册选择', false),
                ],
              ),
            ));
  }

  _takePhotoItem(String title, bool isTakePhoto) {
    print(isTakePhoto);
    return GestureDetector(
      child: ListTile(
        leading: Icon(
          isTakePhoto ? Icons.camera_alt : Icons.photo_library,
        ),
        title: Text(title),
        onTap: () => getImage(isTakePhoto),
      ),
    );
  }

  getUserAvatar(File file) async {
    String path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({
      //文件信息
      "file": await MultipartFile.fromFile(path, filename: name)
    });

    HttpUtils.requestHttp(
      ApiConstant.userAvatar,
      parameters: formData,
      method: HttpUtils.POST,
      onSuccess: (data) {
        EasyLoading.showSuccess('上传成功');
        _avatatHttp = data["url"];
        setState(() {});
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
        print(error);
      },
    );
  }
}
