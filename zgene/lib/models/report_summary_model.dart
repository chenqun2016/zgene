class ReportSummaryModel {
  String code;
  String name;
  int count;
  String img;

  ReportSummaryModel({this.code, this.name, this.count, this.img});

  ReportSummaryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    count = json['count'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['count'] = this.count;
    data['img'] = this.img;
    return data;
  }
}
