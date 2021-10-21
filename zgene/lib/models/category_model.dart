class CategoryModel {
  List<Categories> categories;

  CategoryModel({this.categories});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int id;
  int createdAt;
  int updatedAt;
  int parentCid;
  int topCid;
  int chid;
  int total;
  Channel channel;
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

  Categories(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.parentCid,
      this.topCid,
      this.chid,
      this.total,
      this.channel,
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

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    parentCid = json['parent_cid'];
    topCid = json['top_cid'];
    chid = json['chid'];
    total = json['total'];
    channel =
        json['channel'] != null ? new Channel.fromJson(json['channel']) : null;
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
    if (this.channel != null) {
      data['channel'] = this.channel.toJson();
    }
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
