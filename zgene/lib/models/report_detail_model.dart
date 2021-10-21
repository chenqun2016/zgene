// To parse this JSON data, do
//
//     final reportDetailModel = reportDetailModelFromJson(jsonString);

import 'dart:convert';

ReportDetailModel reportDetailModelFromJson(String str) =>
    ReportDetailModel.fromJson(json.decode(str));

String reportDetailModelToJson(ReportDetailModel data) =>
    json.encode(data.toJson());

class ReportDetailModel {
  ReportDetailModel({
    this.id,
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
    this.url,
    this.status,
    this.batchId,
    this.collectorBatch,
  });

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
  String url;
  int status;
  int batchId;
  dynamic collectorBatch;

  factory ReportDetailModel.fromJson(Map<String, dynamic> json) =>
      ReportDetailModel(
        id: json["id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        uid: json["uid"],
        serialNum: json["serial_num"],
        targetName: json["target_name"],
        targetSex: json["target_sex"],
        targetBirthday: json["target_birthday"],
        targetPhone: json["target_phone"],
        orderId: json["order_id"],
        fileId: json["file_id"],
        url: json["url"],
        status: json["status"],
        batchId: json["batch_id"],
        collectorBatch: json["collector_batch"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "uid": uid,
        "serial_num": serialNum,
        "target_name": targetName,
        "target_sex": targetSex,
        "target_birthday": targetBirthday,
        "target_phone": targetPhone,
        "order_id": orderId,
        "file_id": fileId,
        "url": url,
        "status": status,
        "batch_id": batchId,
        "collector_batch": collectorBatch,
      };
}
