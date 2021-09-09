// To parse this JSON data, do
//
//     final orderListmodel = orderListmodelFromJson(jsonString);

import 'dart:convert';

OrderListmodel orderListmodelFromJson(String str) =>
    OrderListmodel.fromJson(json.decode(str));

String orderListmodelToJson(OrderListmodel data) => json.encode(data.toJson());

class OrderListmodel {
  OrderListmodel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.uid,
    this.prodId,
    this.submitTime,
    this.doneTime,
    this.status,
    this.amount,
    this.price,
    this.nums,
    this.payType,
    this.cancelStatus,
    this.cancelSubmitTime,
    this.cancelDoneTime,
    this.sfNo,
    this.reSfNo,
    this.remark,
    this.collectorInfo,
    this.billInfo,
    this.prodInfo,
    this.revAddress,
    this.sendAddress,
  });

  int id;
  int createdAt;
  int updatedAt;
  int uid;
  int prodId;
  int submitTime;
  int doneTime;
  int status;
  int amount;
  int price;
  int nums;
  int payType;
  int cancelStatus;
  int cancelSubmitTime;
  int cancelDoneTime;
  String sfNo;
  String reSfNo;
  String remark;
  CollectorInfo collectorInfo;
  BillInfo billInfo;
  ProdInfo prodInfo;
  RevAddress revAddress;
  dynamic sendAddress;

  factory OrderListmodel.fromJson(Map<String, dynamic> json) => OrderListmodel(
        id: json["id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        uid: json["uid"],
        prodId: json["prod_id"],
        submitTime: json["submit_time"],
        doneTime: json["done_time"],
        status: json["status"],
        amount: json["amount"],
        price: json["price"],
        nums: json["nums"],
        payType: json["pay_type"],
        cancelStatus: json["cancel_status"],
        cancelSubmitTime: json["cancel_submit_time"],
        cancelDoneTime: json["cancel_done_time"],
        sfNo: json["sf_no"],
        reSfNo: json["re_sf_no"],
        remark: json["remark"],
        collectorInfo: CollectorInfo.fromJson(json["collector_info"]),
        billInfo: BillInfo.fromJson(json["bill_info"]),
        prodInfo: ProdInfo.fromJson(json["prod_info"]),
        revAddress: RevAddress.fromJson(json["rev_address"]),
        sendAddress: json["send_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "uid": uid,
        "prod_id": prodId,
        "submit_time": submitTime,
        "done_time": doneTime,
        "status": status,
        "amount": amount,
        "price": price,
        "nums": nums,
        "pay_type": payType,
        "cancel_status": cancelStatus,
        "cancel_submit_time": cancelSubmitTime,
        "cancel_done_time": cancelDoneTime,
        "sf_no": sfNo,
        "re_sf_no": reSfNo,
        "remark": remark,
        "collector_info": collectorInfo.toJson(),
        "bill_info": billInfo.toJson(),
        "prod_info": prodInfo.toJson(),
        "rev_address": revAddress.toJson(),
        "send_address": sendAddress,
      };
}

class BillInfo {
  BillInfo({
    this.billType,
    this.remark,
    this.email,
    this.company,
    this.numbers,
  });

  String billType;
  String remark;
  String email;
  String company;
  String numbers;

  factory BillInfo.fromJson(Map<String, dynamic> json) => BillInfo(
        billType: json["bill_type"],
        remark: json["remark"],
        email: json["email"],
        company: json["company"],
        numbers: json["numbers"],
      );

  Map<String, dynamic> toJson() => {
        "bill_type": billType,
        "remark": remark,
        "email": email,
        "company": company,
        "numbers": numbers,
      };
}

class CollectorInfo {
  CollectorInfo({
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

  factory CollectorInfo.fromJson(Map<String, dynamic> json) => CollectorInfo(
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
      };
}

class ProdInfo {
  ProdInfo({
    this.name,
    this.images,
  });

  String name;
  String images;

  factory ProdInfo.fromJson(Map<String, dynamic> json) => ProdInfo(
        name: json["name"],
        images: json["images"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "images": images,
      };
}

class RevAddress {
  RevAddress({
    this.province,
    this.city,
    this.county,
    this.address,
    this.rcvName,
    this.rcvPhone,
  });

  String province;
  String city;
  String county;
  String address;
  String rcvName;
  String rcvPhone;

  factory RevAddress.fromJson(Map<String, dynamic> json) => RevAddress(
        province: json["province"],
        city: json["city"],
        county: json["county"],
        address: json["address"],
        rcvName: json["rcv_name"],
        rcvPhone: json["rcv_phone"],
      );

  Map<String, dynamic> toJson() => {
        "province": province,
        "city": city,
        "county": county,
        "address": address,
        "rcv_name": rcvName,
        "rcv_phone": rcvPhone,
      };
}
