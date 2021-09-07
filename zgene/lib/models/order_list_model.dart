class OrderListmodel {
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
  BillInfo billInfo;
  ProdInfo prodInfo;
  RevAddress revAddress;
  dynamic sendAddress;

  OrderListmodel(
      {this.id,
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
        this.billInfo,
        this.prodInfo,
        this.revAddress,
        this.sendAddress});

  OrderListmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uid = json['uid'];
    prodId = json['prod_id'];
    submitTime = json['submit_time'];
    doneTime = json['done_time'];
    status = json['status'];
    amount = json['amount'];
    price = json['price'];
    nums = json['nums'];
    payType = json['pay_type'];
    cancelStatus = json['cancel_status'];
    cancelSubmitTime = json['cancel_submit_time'];
    cancelDoneTime = json['cancel_done_time'];
    sfNo = json['sf_no'];
    reSfNo = json['re_sf_no'];
    remark = json['remark'];
    billInfo = json['bill_info'] != null
        ? new BillInfo.fromJson(json['bill_info'])
        : null;
    prodInfo = json['prod_info'] != null
        ? new ProdInfo.fromJson(json['prod_info'])
        : null;
    revAddress = json['rev_address'] != null
        ? new RevAddress.fromJson(json['rev_address'])
        : null;
    sendAddress = json['send_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['uid'] = this.uid;
    data['prod_id'] = this.prodId;
    data['submit_time'] = this.submitTime;
    data['done_time'] = this.doneTime;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['price'] = this.price;
    data['nums'] = this.nums;
    data['pay_type'] = this.payType;
    data['cancel_status'] = this.cancelStatus;
    data['cancel_submit_time'] = this.cancelSubmitTime;
    data['cancel_done_time'] = this.cancelDoneTime;
    data['sf_no'] = this.sfNo;
    data['re_sf_no'] = this.reSfNo;
    data['remark'] = this.remark;
    if (this.billInfo != null) {
      data['bill_info'] = this.billInfo.toJson();
    }
    if (this.prodInfo != null) {
      data['prod_info'] = this.prodInfo.toJson();
    }
    if (this.revAddress != null) {
      data['rev_address'] = this.revAddress.toJson();
    }
    data['send_address'] = this.sendAddress;
    return data;
  }
}

class BillInfo {
  String billType;
  String remark;
  String email;
  String company;
  String numbers;

  BillInfo(
      {this.billType, this.remark, this.email, this.company, this.numbers});

  BillInfo.fromJson(Map<String, dynamic> json) {
    billType = json['bill_type'];
    remark = json['remark'];
    email = json['email'];
    company = json['company'];
    numbers = json['numbers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_type'] = this.billType;
    data['remark'] = this.remark;
    data['email'] = this.email;
    data['company'] = this.company;
    data['numbers'] = this.numbers;
    return data;
  }
}

class ProdInfo {
  String name;
  String images;

  ProdInfo({this.name, this.images});

  ProdInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['images'] = this.images;
    return data;
  }
}

class RevAddress {
  String province;
  String city;
  String county;
  String address;
  String rcvName;
  String rcvPhone;

  RevAddress(
      {this.province,
        this.city,
        this.county,
        this.address,
        this.rcvName,
        this.rcvPhone});

  RevAddress.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    city = json['city'];
    county = json['county'];
    address = json['address'];
    rcvName = json['rcv_name'];
    rcvPhone = json['rcv_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['province'] = this.province;
    data['city'] = this.city;
    data['county'] = this.county;
    data['address'] = this.address;
    data['rcv_name'] = this.rcvName;
    data['rcv_phone'] = this.rcvPhone;
    return data;
  }
}
