import 'dart:collection';

import 'package:getuiflut/getuiflut.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/util/sp_utils.dart';

class GetNoticeCount {
  static obtain() {
    if (SpUtils().getStorageDefault(SpConstant.IsLogin, false)) {
      Map<String, dynamic> map = new HashMap();
      map['notice_type'] = 0;
      HttpUtils.requestHttp(
        ApiConstant.userNoticeCount,
        parameters: map,
        method: HttpUtils.GET,
        onSuccess: (result) {
          print(result);
          Getuiflut().setLocalBadge(result);
        },
        onError: (code, error) {
          print(error);
        },
      );
    } else {
      Getuiflut().setLocalBadge(0);
    }
  }
}
