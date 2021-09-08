class MyReportListPage {
  int id;
  int createdAt;
  int updatedAt;
  int uid;
  String serialNum;
  String targetName;
  String targetSex;
  String targetBirthday;
  String targetPhone;
  int orderId;
  int fileId;
  String pdfUrl;
  int pdfUrlAt;
  String url;

  MyReportListPage(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.uid,
        this.serialNum,
        this.targetName,
        this.targetSex,
        this.targetBirthday,
        this.targetPhone,
        this.orderId,
        this.fileId,
        this.pdfUrl,
        this.pdfUrlAt,
        this.url});

  MyReportListPage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uid = json['uid'];
    serialNum = json['serial_num'];
    targetName = json['target_name'];
    targetSex = json['target_sex'];
    targetBirthday = json['target_birthday'];
    targetPhone = json['target_phone'];
    orderId = json['order_id'];
    fileId = json['file_id'];
    pdfUrl = json['pdf_url'];
    pdfUrlAt = json['pdf_url_at'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['uid'] = this.uid;
    data['serial_num'] = this.serialNum;
    data['target_name'] = this.targetName;
    data['target_sex'] = this.targetSex;
    data['target_birthday'] = this.targetBirthday;
    data['target_phone'] = this.targetPhone;
    data['order_id'] = this.orderId;
    data['file_id'] = this.fileId;
    data['pdf_url'] = this.pdfUrl;
    data['pdf_url_at'] = this.pdfUrlAt;
    data['url'] = this.url;
    return data;
  }
}
