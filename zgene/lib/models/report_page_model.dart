// To parse this JSON data, do
//
//     final reportPageModel = reportPageModelFromJson(jsonString);

import 'dart:convert';

ReportPageModel reportPageModelFromJson(String str) =>
    ReportPageModel.fromJson(json.decode(str));

String reportPageModelToJson(ReportPageModel data) =>
    json.encode(data.toJson());

class ReportPageModel {
  ReportPageModel({
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
  CollectorBatch collectorBatch;

  factory ReportPageModel.fromJson(Map<String, dynamic> json) =>
      ReportPageModel(
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
        collectorBatch: CollectorBatch.fromJson(json["collector_batch"]),
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
        "collector_batch": collectorBatch.toJson(),
      };
}

class CollectorBatch {
  CollectorBatch({
    this.id,
    this.createdAtv,
    this.updatedAt,
    this.productId,
    this.productName,
    this.productType,
    this.nums,
    this.status,
  });

  int id;
  int createdAtv;
  int updatedAt;
  int productId;
  String productName;
  String productType;
  int nums;
  int status;

  factory CollectorBatch.fromJson(Map<String, dynamic> json) => CollectorBatch(
        id: json["id"],
        createdAtv: json["created_atv"],
        updatedAt: json["updated_at"],
        productId: json["product_Id"],
        productName: json["product_name"],
        productType: json["product_type"],
        nums: json["nums"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_atv": createdAtv,
        "updated_at": updatedAt,
        "product_Id": productId,
        "product_name": productName,
        "product_type": productType,
        "nums": nums,
        "status": status,
      };
}
