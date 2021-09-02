// To parse this JSON data, do
//
//     final addressListModel = addressListModelFromJson(jsonString);

import 'dart:convert';

List<AddressListModel> addressListModelFromJson(String str) =>
    List<AddressListModel>.from(
        json.decode(str).map((x) => AddressListModel.fromJson(x)));

String addressListModelToJson(List<AddressListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressListModel {
  AddressListModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.uid,
    this.province,
    this.city,
    this.county,
    this.address,
    this.order,
    this.rcvName,
    this.rcvPhone,
  });

  int id;
  int createdAt;
  int updatedAt;
  int uid;
  String province;
  String city;
  String county;
  String address;
  int order;
  String rcvName;
  String rcvPhone;

  factory AddressListModel.fromJson(Map<String, dynamic> json) =>
      AddressListModel(
        id: json["id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        uid: json["uid"],
        province: json["province"],
        city: json["city"],
        county: json["county"],
        address: json["address"],
        order: json["order"],
        rcvName: json["rcv_name"],
        rcvPhone: json["rcv_phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "uid": uid,
        "province": province,
        "city": city,
        "county": county,
        "address": address,
        "order": order,
        "rcv_name": rcvName,
        "rcv_phone": rcvPhone,
      };
}
