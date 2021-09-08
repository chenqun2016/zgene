///消息事件
class MsgEvent {
  int type;
  dynamic msg;

  MsgEvent(this.type, this.msg);
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
