class ReportSummaryModel {
  String code;
  String name;
  int count;
  String img;
  int risk_count;

  ReportSummaryModel(
      {this.code, this.name, this.count, this.img, this.risk_count});

  ReportSummaryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    count = json['count'];
    img = json['img'];
    risk_count = json['risk_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['count'] = this.count;
    data['img'] = this.img;
    data['risk_count'] = this.risk_count;
    return data;
  }
}
