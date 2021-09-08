class MessageModel {
  int nid;
  Content content;
  int uid;
  int senderId;
  Sender sender;
  int isRead;

  MessageModel(
      {this.nid,
      this.content,
      this.uid,
      this.senderId,
      this.sender,
      this.isRead});

  MessageModel.fromJson(Map<String, dynamic> json) {
    nid = json['nid'];
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
    uid = json['uid'];
    senderId = json['sender_id'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nid'] = this.nid;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    data['uid'] = this.uid;
    data['sender_id'] = this.senderId;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    data['is_read'] = this.isRead;
    return data;
  }
}

class Content {
  int id;
  int createdAt;
  int updatedAt;
  String title;
  String content;
  int relationType;
  int relationId;
  Null relationObject;
  int noticeType;
  int reciverId;
  int senderId;
  int linkType;
  String linkUrl;

  Content(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.title,
      this.content,
      this.relationType,
      this.relationId,
      this.relationObject,
      this.noticeType,
      this.reciverId,
      this.senderId,
      this.linkType,
      this.linkUrl});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    content = json['content'];
    relationType = json['relation_type'];
    relationId = json['relation_id'];
    relationObject = json['relation_object'];
    noticeType = json['notice_type'];
    reciverId = json['reciver_id'];
    senderId = json['sender_id'];
    linkType = json['link_type'];
    linkUrl = json['link_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    data['content'] = this.content;
    data['relation_type'] = this.relationType;
    data['relation_id'] = this.relationId;
    data['relation_object'] = this.relationObject;
    data['notice_type'] = this.noticeType;
    data['reciver_id'] = this.reciverId;
    data['sender_id'] = this.senderId;
    data['link_type'] = this.linkType;
    data['link_url'] = this.linkUrl;
    return data;
  }
}

class Sender {
  int id;
  int createdAt;
  int updatedAt;
  int ugid;
  UserGroup userGroup;
  String username;
  String nickname;
  int gender;
  String passwordPay;
  String mobile;
  String email;
  String lastLoginIp;
  String registerIp;
  String avatar;
  int coin;
  String intro;
  int point;
  int status;
  Null devices;
  SecurityQuestion securityQuestion;

  Sender(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.ugid,
      this.userGroup,
      this.username,
      this.nickname,
      this.gender,
      this.passwordPay,
      this.mobile,
      this.email,
      this.lastLoginIp,
      this.registerIp,
      this.avatar,
      this.coin,
      this.intro,
      this.point,
      this.status,
      this.devices,
      this.securityQuestion});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ugid = json['ugid'];
    userGroup = json['user_group'] != null
        ? new UserGroup.fromJson(json['user_group'])
        : null;
    username = json['username'];
    nickname = json['nickname'];
    gender = json['gender'];
    passwordPay = json['password_pay'];
    mobile = json['mobile'];
    email = json['email'];
    lastLoginIp = json['last_login_ip'];
    registerIp = json['register_ip'];
    avatar = json['avatar'];
    coin = json['coin'];
    intro = json['intro'];
    point = json['point'];
    status = json['status'];
    devices = json['devices'];
    securityQuestion = json['security_question'] != null
        ? new SecurityQuestion.fromJson(json['security_question'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['ugid'] = this.ugid;
    if (this.userGroup != null) {
      data['user_group'] = this.userGroup.toJson();
    }
    data['username'] = this.username;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['password_pay'] = this.passwordPay;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['last_login_ip'] = this.lastLoginIp;
    data['register_ip'] = this.registerIp;
    data['avatar'] = this.avatar;
    data['coin'] = this.coin;
    data['intro'] = this.intro;
    data['point'] = this.point;
    data['status'] = this.status;
    data['devices'] = this.devices;
    if (this.securityQuestion != null) {
      data['security_question'] = this.securityQuestion.toJson();
    }
    return data;
  }
}

class UserGroup {
  int id;
  int createdAt;
  int updatedAt;
  String groupname;
  String remark;

  UserGroup(
      {this.id, this.createdAt, this.updatedAt, this.groupname, this.remark});

  UserGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    groupname = json['groupname'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['groupname'] = this.groupname;
    data['remark'] = this.remark;
    return data;
  }
}

class SecurityQuestion {
  int id;
  int createdAt;
  int updatedAt;
  String question;

  SecurityQuestion({this.id, this.createdAt, this.updatedAt, this.question});

  SecurityQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['question'] = this.question;
    return data;
  }
}
