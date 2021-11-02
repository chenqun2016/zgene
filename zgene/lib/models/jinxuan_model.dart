class JinxuanModel {
  String title;
  String bgImg;
  String router;

  JinxuanModel({this.title, this.bgImg, this.router});

  JinxuanModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    bgImg = json['bg_img'];
    router = json['router'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['bg_img'] = this.bgImg;
    data['router'] = this.router;
    return data;
  }
}
