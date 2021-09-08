// To parse this JSON data, do
//
//     final userInfoModel = userInfoModelFromJson(jsonString);

import 'dart:convert';

UserInfoModel userInfoModelFromJson(String str) =>
    UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel {
  UserInfoModel({
    this.avatar,
    this.bindApple,
    this.bindWx,
    this.coin,
    this.gender,
    this.groupId,
    this.groupName,
    this.id,
    this.intro,
    this.mobile,
    this.nickname,
  });

  String avatar;
  bool bindApple;
  bool bindWx;
  int coin;
  int gender;
  int groupId;
  String groupName;
  int id;
  String intro;
  String mobile;
  String nickname;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        avatar: json["avatar"],
        bindApple: json["bind_apple"],
        bindWx: json["bind_wx"],
        coin: json["coin"],
        gender: json["gender"],
        groupId: json["group_id"],
        groupName: json["group_name"],
        id: json["id"],
        intro: json["intro"],
        mobile: json["mobile"],
        nickname: json["nickname"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "bind_apple": bindApple,
        "bind_wx": bindWx,
        "coin": coin,
        "gender": gender,
        "group_id": groupId,
        "group_name": groupName,
        "id": id,
        "intro": intro,
        "mobile": mobile,
        "nickname": nickname,
      };
}
