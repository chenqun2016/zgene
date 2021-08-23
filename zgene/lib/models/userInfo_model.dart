class UserInfoModel {
  String avatar;
  int coin;
  int gender;
  int id;
  String intro;
  String nickname;

  UserInfoModel(
      {this.avatar,
      this.coin,
      this.gender,
      this.id,
      this.intro,
      this.nickname});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    coin = json['coin'];
    gender = json['gender'];
    id = json['id'];
    intro = json['intro'];
    nickname = json['nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['coin'] = this.coin;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['intro'] = this.intro;
    data['nickname'] = this.nickname;
    return data;
  }
}
