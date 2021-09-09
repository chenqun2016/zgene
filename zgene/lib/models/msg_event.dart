///消息事件
class MsgEvent {
  int type;
  dynamic msg;
  dynamic arg;
  MsgEvent(this.type, this.msg ,{this.arg});
}

///点击个人中心事件
class selectMineEvent {
  selectMineEvent();
}

///微信登录回调
class WxEvent {
  String code;

  WxEvent(this.code);
}

///点击个人中心事件
class resultMineEvent {
  resultMineEvent();
}
