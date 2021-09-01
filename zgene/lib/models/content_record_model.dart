///内容各种记录（收藏，点赞，消费，浏览历史）
class ContentRecordModel {
  int id;
  int createdAt;
  int updatedAt;
  int aid;
  Archive archive;
  int uid;

  ContentRecordModel(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.aid,
      this.archive,
      this.uid});

  ContentRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    aid = json['aid'];
    archive =
        json['archive'] != null ? new Archive.fromJson(json['archive']) : null;
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['aid'] = this.aid;
    if (this.archive != null) {
      data['archive'] = this.archive.toJson();
    }
    data['uid'] = this.uid;
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
  String linkUrl;
  int linkType;
  String author;
  int coin;
  int sortRank;
  int count;
  int countComment;
  int countDigg;
  int duration;
  List<Tags> tags;
  bool isTop;

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
      this.linkType,
      this.linkUrl,
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
    linkType = json['link_type'];
    linkUrl = json['link_url'];
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
    data['link_type'] = this.linkType;
    data['link_url'] = this.linkUrl;
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
