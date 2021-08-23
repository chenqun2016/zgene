///返回数据统一封装的
class BaseResponse {
  int code;
  String msg;
  dynamic result;
  BaseResponse({this.code, this.msg, this.result});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}
