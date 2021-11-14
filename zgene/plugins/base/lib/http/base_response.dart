///返回数据统一封装的类
class BaseResponse {
  int? code;
  String? msg;
  dynamic result;
  BaseResponse({this.code, this.msg, this.result});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    data['result'] = result;
    return data;
  }
}
