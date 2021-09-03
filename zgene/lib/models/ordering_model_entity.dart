class OrderingModelEntity {
  String appid;
  String noncestr;
  int order_id;
  String package;
  String partnerid;
  int pay_type;
  String platform;
  String prepayid;
  String sign;
  int timestamp;

  OrderingModelEntity(
      this.appid,
      this.noncestr,
      this.order_id,
      this.package,
      this.partnerid,
      this.pay_type,
      this.platform,
      this.prepayid,
      this.sign,
      this.timestamp);

  OrderingModelEntity.fromJson(Map<String, dynamic> json) {
    this.appid = json['appid'];
    this.noncestr = json['noncestr'];
    this.order_id = json['order_id'];
    this.package = json['package'];
    this.partnerid = json['partnerid'];
    this.pay_type = json['pay_type'];
    this.platform = json['platform'];
    this.prepayid = json['prepayid'];
    this.sign = json['sign'];
    this.timestamp = json['timestamp'];
  }
}
