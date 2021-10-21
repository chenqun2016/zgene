// To parse this JSON data, do
//
//     final reportListModel = reportListModelFromJson(jsonString);

import 'dart:convert';

ReportListModel reportListModelFromJson(String str) =>
    ReportListModel.fromJson(json.decode(str));

String reportListModelToJson(ReportListModel data) =>
    json.encode(data.toJson());

class ReportListModel {
  ReportListModel({
    this.code,
    this.result,
  });

  double code;
  List<Result> result;

  factory ReportListModel.fromJson(Map<String, dynamic> json) =>
      ReportListModel(
        code: json["code"].toDouble(),
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.serialNum,
    this.batchId,
    this.productName,
    this.status,
    this.targetName,
  });

  double id;
  String serialNum;
  double batchId;
  String productName;
  double status;
  String targetName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"].toDouble(),
        serialNum: json["serial_num"],
        batchId: json["batch_id"].toDouble(),
        productName: json["product_name"],
        status: json["status"].toDouble(),
        targetName: json["target_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serial_num": serialNum,
        "batch_id": batchId,
        "product_name": productName,
        "status": status,
        "target_name": targetName,
      };
}
