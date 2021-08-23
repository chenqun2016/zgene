import 'dart:collection';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/userInfo_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zgene/widget/camer_crop_image_route.dart';
import 'my_nickname_change.dart';

////个人信息修改页面
class MyInformation extends StatefulWidget {
  UserInfoModel userInfo = UserInfoModel();
  MyInformation({Key key, this.userInfo}) : super(key: key);

  @override
  _MyInformationState createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  String _avatatHttp = "";

  String _gender = "";
  String _nickName = "";
  int _selectGender = 0;
  String _introduction = "";

  final cropKey = GlobalKey<CropState>();

  @override
  void initState() {
    super.initState();
    switch (widget.userInfo.gender) {
      case 0:
        _gender = "未选择";
        _selectGender = 0;
        break;
      case 1:
        _gender = "男";
        _selectGender = 1;
        break;
      case -1:
        _gender = "女";
        _selectGender = -1;
        break;
      default:
        _gender = "未选择";
        _selectGender = 0;
        break;
    }
    _nickName = widget.userInfo.nickname != "" ? widget.userInfo.nickname : "";
    _avatatHttp = widget.userInfo.avatar;
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(height: 228, child: changeavatarView(context)),
          ),
          SliverToBoxAdapter(
            child: Container(height: 124, child: changeInfoView(context)),
          ),
          SliverToBoxAdapter(
            child:
                Container(height: 203, child: changeIntroductionView(context)),
          ),
        ],
      ),
    );
  }

  Widget changeavatarView(BuildContext context) {
    return Container(
      height: 228,
      width: double.infinity,
      color: ColorConstant.WhiteColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 15,
              top: 54,
            ),
            width: 32,
            height: 16,
            child: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                // NavigatorUtils.goBack(context);
                Navigator.pop(context, null);
              },
              icon: ImageIcon(
                AssetImage("assets/images/mine/icon_mine_backArrow.png"),
                size: 16,
                color: ColorConstant.MainBlack,
              ),
            ),
          ),
          Expanded(child: Container()),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 52,
                ),
                child: Text(
                  "个人信息",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextMainColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 23),
                child: Stack(
                  children: [
                    ClipOval(
                      child: FadeInImage.assetNetwork(
                          placeholder:
                              'assets/images/home/img_default_avatar.png',
                          image: CommonUtils.splicingUrl(_avatatHttp),
                          width: 69,
                          height: 69,
                          fit: BoxFit.cover,
                          fadeInDuration: TimeUtils.fadeInDuration(),
                          fadeOutDuration: TimeUtils.fadeOutDuration(),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/home/img_default_avatar.png",
                              height: 69,
                              width: 69,
                            );
                          }),
                    ),
                    Container(
                        // color: Colors.red[200],
                        child: GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: Image(
                        image: AssetImage(
                            "assets/images/mine/icon_mine_avatarTop.png"),
                        width: 70,
                        height: 70,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "点击更换头像",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.TextMainColor,
                  ),
                ),
              )
            ],
          ),
          Expanded(child: Container()),
          Container(
            margin: EdgeInsets.only(
              right: 15,
              top: 52,
            ),
            height: 22,
            width: 32,
            child: TextButton(
              onPressed: () {
                modificationUserInfo();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Text(
                "保存",
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.TextMainGray,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget changeInfoView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      color: ColorConstant.WhiteColor,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final result = await NavigatorUtil.push(context, nikeNameChange(
                nikeName: widget.userInfo.nickname,
              ));

              if (result != "") {
                _nickName = result;
              } else {}
              setState(() {});
            },
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 18, left: 15),
                  height: 22,
                  child: Text(
                    "昵称",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.TextMainColor,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(top: 18, right: 5, left: 15),
                  height: 22,
                  child: Text(
                    _nickName,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.TextMainColor,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18, right: 5),
                  width: 22,
                  height: 22,
                  // color: Colors.red[200],
                  child: IconButton(
                    onPressed: null,
                    icon: ImageIcon(
                      AssetImage(
                          "assets/images/mine/icon_mine_infoGoArrow.png"),
                      size: 11,
                      color: ColorConstant.ArrowMainGray,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 18, 15, 0),
            height: 1,
            color: ColorConstant.LineMainColor,
          ),
          GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return new SimpleDialog(
                    title: new Text('请选择性别'),
                    children: <Widget>[
                      new SimpleDialogOption(
                        child: new Text('男'),
                        onPressed: () {
                          _gender = "男";
                          _selectGender = 1;
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      ),
                      new SimpleDialogOption(
                        child: new Text('女'),
                        onPressed: () {
                          _gender = "女";
                          _selectGender = -1;
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 18, left: 15),
                  height: 22,
                  child: Text(
                    "性别",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.TextMainColor,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(top: 18, right: 5, left: 15),
                  height: 22,
                  child: Text(
                    _gender,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.TextMainColor,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18, right: 5),
                  width: 22,
                  height: 22,
                  // color: Colors.red[200],
                  child: IconButton(
                    onPressed: null,
                    icon: ImageIcon(
                      AssetImage(
                          "assets/images/mine/icon_mine_infoGoArrow.png"),
                      size: 11,
                      color: ColorConstant.ArrowMainGray,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget changeIntroductionView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      color: ColorConstant.WhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 18, left: 15),
            child: Text(
              "简介",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: ColorConstant.TextMainColor,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: TextField(
              onChanged: (value) {
                _introduction = value;
              },
              maxLines: 4,
              maxLength: 200,
              showCursor: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  // labelText: "简介",
                  hintText: widget.userInfo.intro == ""
                      ? "去填写"
                      : widget.userInfo.intro,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: ColorConstant.TextMainGray, fontSize: 16.0)),
            ),
          )
        ],
      ),
    );
  }

  Future getImage(bool isTakePhoto) async {
    Navigator.pop(context);
    try {
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
      print("模拟器不支持相机！");
    }
  }

  void cropImage(File originalImage) async {
    File result = await NavigatorUtil.push(context, CropImageRoute(originalImage));

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

  //保存信息
  modificationUserInfo() {
    Map<String, dynamic> map = new HashMap();
    map["nickname"] = _nickName;
    map["gender"] = _selectGender;
    map["avatar"] = _avatatHttp;
    map["intro"] = _introduction;
    EasyLoading.show(status: 'loading...');

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
        spUtils.setStorage(SpConstant.UserCoins, userInfoModel.coin);
        Navigator.pop(context, widget.userInfo);
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
        print(error);
      },
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
