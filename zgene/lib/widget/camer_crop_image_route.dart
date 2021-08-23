import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:zgene/constant/color_constant.dart';

class CropImageRoute extends StatefulWidget {
  CropImageRoute(this.image);

  File image; //原始图片路径

  @override
  _CropImageRouteState createState() => new _CropImageRouteState();
}

class _CropImageRouteState extends State<CropImageRoute> {
  double baseLeft; //图片左上角的x坐标
  double baseTop; //图片左上角的y坐标
  double imageWidth; //图片宽度，缩放后会变化
  double imageScale = 1; //图片缩放比例
  Image imageView;
  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorConstant.MainBlack,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Crop.file(
              widget.image,
              key: cropKey,
              aspectRatio: 1.0,
              alwaysShowGrid: true,
            ),
          ),
          TextButton(
            onPressed: () {
              _crop(widget.image);
            },
            child: Text(
              '完成',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: ColorConstant.WhiteColor,
              ),
            ),
          )
        ],
      ),
    ));
  }

  Future<void> _crop(File originalFile) async {
    final crop = cropKey.currentState;
    final area = crop.area;
    if (area == null) {
      //裁剪结果为空
      print('裁剪不成功');
    }
    await ImageCrop.requestPermissions().then((value) {
      if (value) {
        ImageCrop.cropImage(
          file: originalFile,
          area: crop.area,
        ).then((value) {
          // upload(value);
          Navigator.pop(context, value);
        }).catchError(() {
          print('裁剪不成功');
          Navigator.pop(context, '');
        });
      } else {
        // Navigator.pop(context, originalFile); //这里的url在上一页调用的result可以拿到
        Navigator.pop(context, originalFile);
        // upload(originalFile);
      }
    });
  }
}
