import 'package:flutter/cupertino.dart';
import 'package:zgene/util/base_widget.dart';

class SendBackAcquisitionPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _SendBackAcquisitionPageState();
  }
}

class _SendBackAcquisitionPageState
    extends BaseWidgetState<SendBackAcquisitionPage> {
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = true;
    backImgPath = "assets/images/mine/icon_sendBack_acquisitionBack.png";
    pageWidgetTitle = "回寄采集器";
    customRightBtnText = "采集引导";
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Container();
  }

  @override
  Future rightBtnTap(BuildContext context) {
    print(123);
  }
}
