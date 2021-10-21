import 'dart:collection';

import 'package:getuiflut/getuiflut.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/http/http_utils.dart';

class GetNoticeCount {
  static obtain() {
    print("--------------------------");

    Map<String, dynamic> map = new HashMap();
    map['notice_type'] = 0;
    HttpUtils.requestHttp(
      ApiConstant.userNoticeCount,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) {
        Getuiflut().setLocalBadge(result);
      },
      onError: (code, error) {
        print(error);
      },
    );
  }
}
