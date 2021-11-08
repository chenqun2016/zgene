class ReportSampleModel {
  String msg;
  String name;
  String sex;

  ReportSampleModel({this.msg, this.name, this.sex});

  ReportSampleModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    name = json['name'];
    sex = json['sex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['name'] = this.name;
    data['sex'] = this.sex;
    return data;
  }
}
