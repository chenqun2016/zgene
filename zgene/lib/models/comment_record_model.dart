
///评论记录
class CommentRecordModel {
  int id;
  int createdAt;
  int updatedAt;
  int uid;
  Author author;
  int aid;
  int rcoId;
  Target target;
  int countDigg;
  int countReply;
  String content;
  int status;
  bool isDigged;

  CommentRecordModel(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.uid,
        this.author,
        this.aid,
        this.rcoId,
        this.target,
        this.countDigg,
        this.countReply,
        this.content,
        this.status,
        this.isDigged});

  CommentRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uid = json['uid'];
    author =
    json['author'] != null ?  new Author.fromJson(json['author']) : null;
    aid = json['aid'];
    rcoId = json['rco_id'];
    target =
    json['target'] != null ? new Target.fromJson(json['target']) : null;
    countDigg = json['count_digg'];
    countReply = json['count_reply'];
    content = json['content'];
    status = json['status'];
    isDigged = json['is_digged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['uid'] = this.uid;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['aid'] = this.aid;
    data['rco_id'] = this.rcoId;
    if (this.target != null) {
      data['target'] = this.target.toJson();
    }
    data['count_digg'] = this.countDigg;
    data['count_reply'] = this.countReply;
    data['content'] = this.content;
    data['status'] = this.status;
    data['is_digged'] = this.isDigged;
    return data;
  }
}

class Author {
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

  Author(
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

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ugid = json['ugid'];
    userGroup = json['user_group'] != null?
         new UserGroup.fromJson(json['user_group'])
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
    securityQuestion = json['security_question'] != null?
         new SecurityQuestion.fromJson(json['security_question'])
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

class Target {
  int id;
  int createdAt;
  int updatedAt;
  int cid;
  Category category;
  int chid;
  Channel channel;
  int uid;
  String title;
  String titleShort;
  String  description;
  String keywords;
  String seoUrl;
  String imageUrl;
  String videoUrl;
  String audioUrl;
  String source;
  String sourceUrl;
  String author;
  int coin;
  int sortRank;
  int count;
  int countComment;
  int countDigg;
  int duration;
  List<Tags> tags;
  bool isTop;

  Target(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.cid,
        this.category,
        this.chid,
        this.channel,
        this.uid,
        this.title,
        this.titleShort,
        this.description,
        this.keywords,
        this.seoUrl,
        this.imageUrl,
        this.videoUrl,
        this.audioUrl,
        this.source,
        this.sourceUrl,
        this.author,
        this.coin,
        this.sortRank,
        this.count,
        this.countComment,
        this.countDigg,
        this.duration,
        this.tags,
        this.isTop});

  Target.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cid = json['cid'];
    category = json['category'] != null?
         new Category.fromJson(json['category'])
        : null;
    chid = json['chid'];
    channel =
    json['channel'] != null ? new Channel.fromJson(json['channel']) : null;
    uid = json['uid'];
    title = json['title'];
    titleShort = json['title_short'];
    description = json['description'];
    keywords = json['keywords'];
    seoUrl = json['seo_url'];
    imageUrl = json['image_url'];
    videoUrl = json['video_url'];
    audioUrl = json['audio_url'];
    source = json['source'];
    sourceUrl = json['source_url'];
    author = json['author'];
    coin = json['coin'];
    sortRank = json['sort_rank'];
    count = json['count'];
    countComment = json['count_comment'];
    countDigg = json['count_digg'];
    duration = json['duration'];
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
    isTop = json['is_top'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['cid'] = this.cid;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['chid'] = this.chid;
    if (this.channel != null) {
      data['channel'] = this.channel.toJson();
    }
    data['uid'] = this.uid;
    data['title'] = this.title;
    data['title_short'] = this.titleShort;
    data['description'] = this.description;
    data['keywords'] = this.keywords;
    data['seo_url'] = this.seoUrl;
    data['image_url'] = this.imageUrl;
    data['video_url'] = this.videoUrl;
    data['audio_url'] = this.audioUrl;
    data['source'] = this.source;
    data['source_url'] = this.sourceUrl;
    data['author'] = this.author;
    data['coin'] = this.coin;
    data['sort_rank'] = this.sortRank;
    data['count'] = this.count;
    data['count_comment'] = this.countComment;
    data['count_digg'] = this.countDigg;
    data['duration'] = this.duration;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    data['is_top'] = this.isTop;
    return data;
  }
}

class Category {
  int id;
  int createdAt;
  int updatedAt;
  int parentCid;
  int topCid;
  int chid;
  int total;
  String step;
  String categoryName;
  String keywords;
  String seoTitle;
  String description;
  String seoUrl;
  int sortRank;
  bool isHidden;
  String templateList;
  String templateArchive;
  String body;

  Category(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.parentCid,
        this.topCid,
        this.chid,
        this.total,
        this.step,
        this.categoryName,
        this.keywords,
        this.seoTitle,
        this.description,
        this.seoUrl,
        this.sortRank,
        this.isHidden,
        this.templateList,
        this.templateArchive,
        this.body});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    parentCid = json['parent_cid'];
    topCid = json['top_cid'];
    chid = json['chid'];
    total = json['total'];
    step = json['step'];
    categoryName = json['category_name'];
    keywords = json['keywords'];
    seoTitle = json['seo_title'];
    description = json['description'];
    seoUrl = json['seo_url'];
    sortRank = json['sort_rank'];
    isHidden = json['is_hidden'];
    templateList = json['template_list'];
    templateArchive = json['template_archive'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['parent_cid'] = this.parentCid;
    data['top_cid'] = this.topCid;
    data['chid'] = this.chid;
    data['total'] = this.total;
    data['step'] = this.step;
    data['category_name'] = this.categoryName;
    data['keywords'] = this.keywords;
    data['seo_title'] = this.seoTitle;
    data['description'] = this.description;
    data['seo_url'] = this.seoUrl;
    data['sort_rank'] = this.sortRank;
    data['is_hidden'] = this.isHidden;
    data['template_list'] = this.templateList;
    data['template_archive'] = this.templateArchive;
    data['body'] = this.body;
    return data;
  }
}

class Channel {
  int id;
  int createdAt;
  int updatedAt;
  String name;
  String addonTable;
  String title;

  Channel(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.addonTable,
        this.title});

  Channel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    addonTable = json['addon_table'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['addon_table'] = this.addonTable;
    data['title'] = this.title;
    return data;
  }
}

class Tags {
  int id;
  int createdAt;
  int updatedAt;
  String name;
  String keywords;
  String seoTitle;
  int click;
  int count;
  String description;
  String seoUrl;

  Tags(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.keywords,
        this.seoTitle,
        this.click,
        this.count,
        this.description,
        this.seoUrl});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    keywords = json['keywords'];
    seoTitle = json['seo_title'];
    click = json['click'];
    count = json['count'];
    description = json['description'];
    seoUrl = json['seo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['keywords'] = this.keywords;
    data['seo_title'] = this.seoTitle;
    data['click'] = this.click;
    data['count'] = this.count;
    data['description'] = this.description;
    data['seo_url'] = this.seoUrl;
    return data;
  }
}
