class ArchiveDesModel {
  Addon addon;
  Archive archive;
  Attachment attachment;
  Status status;

  ArchiveDesModel({this.addon, this.archive, this.attachment, this.status});

  ArchiveDesModel.fromJson(Map<String, dynamic> json) {
    addon = json['addon'] != null ? new Addon.fromJson(json['addon']) : null;
    archive =
        json['archive'] != null ? new Archive.fromJson(json['archive']) : null;
    attachment = json['attachment'] != null
        ? new Attachment.fromJson(json['attachment'])
        : null;
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addon != null) {
      data['addon'] = this.addon.toJson();
    }
    if (this.archive != null) {
      data['archive'] = this.archive.toJson();
    }
    if (this.attachment != null) {
      data['attachment'] = this.attachment.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    return data;
  }
}

class Addon {
  int aid;
  int stock;
  List<Archives> archives;

  Addon({this.aid, this.stock, this.archives});

  Addon.fromJson(Map<String, dynamic> json) {
    stock = json['stock'];
    aid = json['aid'];
    if (json['archives'] != null) {
      archives = new List<Archives>();
      json['archives'].forEach((v) {
        archives.add(new Archives.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aid'] = this.aid;
    data['stock'] = this.stock;
    if (this.archives != null) {
      data['archives'] = this.archives.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Archives {
  int id;
  int createdAt;
  int updatedAt;
  int cid;
  int chid;
  int uid;
  String title;
  String titleShort;
  String description;
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
  Null tags;
  bool isTop;
  String template;
  int linkType;
  String linkUrl;

  Archives(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.cid,
      this.chid,
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
      this.isTop,
      this.template,
      this.linkType,
      this.linkUrl});

  Archives.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cid = json['cid'];
    chid = json['chid'];
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
    tags = json['tags'];
    isTop = json['is_top'];
    template = json['template'];
    linkType = json['link_type'];
    linkUrl = json['link_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['cid'] = this.cid;
    data['chid'] = this.chid;
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
    data['tags'] = this.tags;
    data['is_top'] = this.isTop;
    data['template'] = this.template;
    data['link_type'] = this.linkType;
    data['link_url'] = this.linkUrl;
    return data;
  }
}

class Archive {
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
  String description;
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
  List<dynamic> tags;
  bool isTop;
  String template;
  int linkType;
  String linkUrl;

  Archive(
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
      this.isTop,
      this.template,
      this.linkType,
      this.linkUrl});

  Archive.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cid = json['cid'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
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
      tags = [];
      json['tags'].forEach((v) {
        tags.add(v);
      });
    }
    isTop = json['is_top'];
    template = json['template'];
    linkType = json['link_type'];
    linkUrl = json['link_url'];
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
    data['template'] = this.template;
    data['link_type'] = this.linkType;
    data['link_url'] = this.linkUrl;
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

class Attachment {
  String shareUrl;

  Attachment({this.shareUrl});

  Attachment.fromJson(Map<String, dynamic> json) {
    shareUrl = json['share_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['share_url'] = this.shareUrl;
    return data;
  }
}

class Status {
  bool digged;
  bool favored;
  bool purchased;

  Status({this.digged, this.favored, this.purchased});

  Status.fromJson(Map<String, dynamic> json) {
    digged = json['digged'];
    favored = json['favored'];
    purchased = json['purchased'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['digged'] = this.digged;
    data['favored'] = this.favored;
    data['purchased'] = this.purchased;
    return data;
  }
}
