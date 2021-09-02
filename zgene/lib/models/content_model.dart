
///内容model
class ContentModel {
  List<Archives> _archives;
  int _total;

  ContentModel({List<Archives> archives, int total}) {
    this._archives = archives;
    this._total = total;
  }

  List<Archives> get archives => _archives;
  set archives(List<Archives> archives) => _archives = archives;
  int get total => _total;
  set total(int total) => _total = total;

  ContentModel.fromJson(Map<String, dynamic> json) {
    if (json['archives'] != null) {
      _archives = new List<Archives>();
      json['archives'].forEach((v) {
        _archives.add(new Archives.fromJson(v));
      });
    }
    _total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._archives != null) {
      data['archives'] = this._archives.map((v) => v.toJson()).toList();
    }
    data['total'] = this._total;
    return data;
  }
}

class Archives {
  int _id;
  int _createdAt;
  int _updatedAt;
  int _cid;
  Category _category;
  int _chid;
  Channel _channel;
  int _uid;
  String _title;
  String _titleShort;
  String _description;
  String _keywords;
  String _seoUrl;
  String _imageUrl;
  String _videoUrl;
  String _audioUrl;
  String _source;
  String _sourceUrl;
  String _author;
  int _coin;
  int _sortRank;
  int _count;
  int _countComment;
  int _duration;
  int _countDigg;
  bool _isTop;
  Null _tags;
  int _linkType;
  String _linkUrl;

  Archives(
      {int id,
        int createdAt,
        int updatedAt,
        int cid,
        Category category,
        int chid,
        Channel channel,
        int uid,
        String title,
        String titleShort,
        String description,
        String keywords,
        String seoUrl,
        String imageUrl,
        String videoUrl,
        String audioUrl,
        String source,
        String sourceUrl,
        String author,
        int coin,
        int sortRank,
        int count,
        int countComment,
        int duration,
        int countDigg,
        bool isTop,
        int linkType,
        String linkUrl,
        Null tags}) {
    this._id = id;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._cid = cid;
    this._category = category;
    this._chid = chid;
    this._channel = channel;
    this._uid = uid;
    this._title = title;
    this._titleShort = titleShort;
    this._description = description;
    this._keywords = keywords;
    this._seoUrl = seoUrl;
    this._imageUrl = imageUrl;
    this._videoUrl = videoUrl;
    this._audioUrl = audioUrl;
    this._source = source;
    this._sourceUrl = sourceUrl;
    this._author = author;
    this._coin = coin;
    this._sortRank = sortRank;
    this._count = count;
    this._countComment = countComment;
    this._duration = duration;
    this._countDigg=countDigg;
    this._isTop=isTop;
    this._tags = tags;
    this._linkType=linkType;
    this._linkUrl = linkUrl;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get createdAt => _createdAt;
  set createdAt(int createdAt) => _createdAt = createdAt;
  int get updatedAt => _updatedAt;
  set updatedAt(int updatedAt) => _updatedAt = updatedAt;
  int get cid => _cid;
  set cid(int cid) => _cid = cid;
  Category get category => _category;
  set category(Category category) => _category = category;
  int get chid => _chid;
  set chid(int chid) => _chid = chid;
  Channel get channel => _channel;
  set channel(Channel channel) => _channel = channel;
  int get uid => _uid;
  set uid(int uid) => _uid = uid;
  String get title => _title;
  set title(String title) => _title = title;
  String get titleShort => _titleShort;
  set titleShort(String titleShort) => _titleShort = titleShort;
  String get description => _description;
  set description(String description) => _description = description;
  String get keywords => _keywords;
  set keywords(String keywords) => _keywords = keywords;
  String get seoUrl => _seoUrl;
  set seoUrl(String seoUrl) => _seoUrl = seoUrl;
  String get imageUrl => _imageUrl;
  set imageUrl(String imageUrl) => _imageUrl = imageUrl;
  String get videoUrl => _videoUrl;
  set videoUrl(String videoUrl) => _videoUrl = videoUrl;
  String get audioUrl => _audioUrl;
  set audioUrl(String audioUrl) => _audioUrl = audioUrl;
  String get source => _source;
  set source(String source) => _source = source;
  String get sourceUrl => _sourceUrl;
  set sourceUrl(String sourceUrl) => _sourceUrl = sourceUrl;
  String get author => _author;
  set author(String author) => _author = author;
  int get coin => _coin;
  set coin(int coin) => _coin = coin;
  int get sortRank => _sortRank;
  set sortRank(int sortRank) => _sortRank = sortRank;
  int get count => _count;
  set count(int count) => _count = count;
  int get countComment => _countComment;
  set countComment(int countComment) => _countComment = countComment;
  int get duration => _duration;
  set duration(int duration) => _duration = duration;
  int get countDigg => _countDigg;
  set countDigg(int countDigg) => _countDigg = countDigg;
  bool get isTop => _isTop;
  set isTop(bool isTop) => _isTop = isTop;
  Null get tags => _tags;
  set tags(Null tags) => _tags = tags;
  int get linkType => _linkType;
  set linkType(int linkType) => _linkType = linkType;
  String get linkUrl => _linkUrl;
  set linkUrl(String linkUrl) => _linkUrl = linkUrl;

  Archives.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _cid = json['cid'];
    _category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    _chid = json['chid'];
    _channel =
    json['channel'] != null ? new Channel.fromJson(json['channel']) : null;
    _uid = json['uid'];
    _title = json['title'];
    _titleShort = json['title_short'];
    _description = json['description'];
    _keywords = json['keywords'];
    _seoUrl = json['seo_url'];
    _imageUrl = json['image_url'];
    _videoUrl = json['video_url'];
    _audioUrl = json['audio_url'];
    _source = json['source'];
    _sourceUrl = json['source_url'];
    _author = json['author'];
    _coin = json['coin'];
    _sortRank = json['sort_rank'];
    _count = json['count'];
    _countComment = json['count_comment'];
    _duration = json['duration'];
    _countDigg = json['count_digg'];
    _isTop = json['is_top'];
    _tags = json['tags'];
    _linkType = json['link_type'];
    _linkUrl = json['link_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['cid'] = this._cid;
    if (this._category != null) {
      data['category'] = this._category.toJson();
    }
    data['chid'] = this._chid;
    if (this._channel != null) {
      data['channel'] = this._channel.toJson();
    }
    data['uid'] = this._uid;
    data['title'] = this._title;
    data['title_short'] = this._titleShort;
    data['description'] = this._description;
    data['keywords'] = this._keywords;
    data['seo_url'] = this._seoUrl;
    data['image_url'] = this._imageUrl;
    data['video_url'] = this._videoUrl;
    data['audio_url'] = this._audioUrl;
    data['source'] = this._source;
    data['source_url'] = this._sourceUrl;
    data['author'] = this._author;
    data['coin'] = this._coin;
    data['sort_rank'] = this._sortRank;
    data['count'] = this._count;
    data['count_comment'] = this._countComment;
    data['duration'] = this._duration;
    data['count_digg'] = this._countDigg;
    data['count_digg'] = this._countDigg;
    data['is_top'] = this._isTop;
    data['link_type'] = this._linkType;
    data['link_url'] = this._linkUrl;
    return data;
  }
}

class Category {
  int _id;
  int _createdAt;
  int _updatedAt;
  int _parentCid;
  int _topCid;
  int _chid;
  int _total;
  String _step;
  String _categoryName;
  String _keywords;
  String _seoTitle;
  String _description;
  String _seoUrl;
  int _sortRank;
  bool _isHidden;
  String _templateList;
  String _templateArchive;
  String _body;

  Category(
      {int id,
        int createdAt,
        int updatedAt,
        int parentCid,
        int topCid,
        int chid,
        int total,
        String step,
        String categoryName,
        String keywords,
        String seoTitle,
        String description,
        String seoUrl,
        int sortRank,
        bool isHidden,
        String templateList,
        String templateArchive,
        String body}) {
    this._id = id;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._parentCid = parentCid;
    this._topCid = topCid;
    this._chid = chid;
    this._total = total;
    this._step = step;
    this._categoryName = categoryName;
    this._keywords = keywords;
    this._seoTitle = seoTitle;
    this._description = description;
    this._seoUrl = seoUrl;
    this._sortRank = sortRank;
    this._isHidden = isHidden;
    this._templateList = templateList;
    this._templateArchive = templateArchive;
    this._body = body;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get createdAt => _createdAt;
  set createdAt(int createdAt) => _createdAt = createdAt;
  int get updatedAt => _updatedAt;
  set updatedAt(int updatedAt) => _updatedAt = updatedAt;
  int get parentCid => _parentCid;
  set parentCid(int parentCid) => _parentCid = parentCid;
  int get topCid => _topCid;
  set topCid(int topCid) => _topCid = topCid;
  int get chid => _chid;
  set chid(int chid) => _chid = chid;
  int get total => _total;
  set total(int total) => _total = total;
  String get step => _step;
  set step(String step) => _step = step;
  String get categoryName => _categoryName;
  set categoryName(String categoryName) => _categoryName = categoryName;
  String get keywords => _keywords;
  set keywords(String keywords) => _keywords = keywords;
  String get seoTitle => _seoTitle;
  set seoTitle(String seoTitle) => _seoTitle = seoTitle;
  String get description => _description;
  set description(String description) => _description = description;
  String get seoUrl => _seoUrl;
  set seoUrl(String seoUrl) => _seoUrl = seoUrl;
  int get sortRank => _sortRank;
  set sortRank(int sortRank) => _sortRank = sortRank;
  bool get isHidden => _isHidden;
  set isHidden(bool isHidden) => _isHidden = isHidden;
  String get templateList => _templateList;
  set templateList(String templateList) => _templateList = templateList;
  String get templateArchive => _templateArchive;
  set templateArchive(String templateArchive) =>
      _templateArchive = templateArchive;
  String get body => _body;
  set body(String body) => _body = body;

  Category.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _parentCid = json['parent_cid'];
    _topCid = json['top_cid'];
    _chid = json['chid'];
    _total = json['total'];
    _step = json['step'];
    _categoryName = json['category_name'];
    _keywords = json['keywords'];
    _seoTitle = json['seo_title'];
    _description = json['description'];
    _seoUrl = json['seo_url'];
    _sortRank = json['sort_rank'];
    _isHidden = json['is_hidden'];
    _templateList = json['template_list'];
    _templateArchive = json['template_archive'];
    _body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['parent_cid'] = this._parentCid;
    data['top_cid'] = this._topCid;
    data['chid'] = this._chid;
    data['total'] = this._total;
    data['step'] = this._step;
    data['category_name'] = this._categoryName;
    data['keywords'] = this._keywords;
    data['seo_title'] = this._seoTitle;
    data['description'] = this._description;
    data['seo_url'] = this._seoUrl;
    data['sort_rank'] = this._sortRank;
    data['is_hidden'] = this._isHidden;
    data['template_list'] = this._templateList;
    data['template_archive'] = this._templateArchive;
    data['body'] = this._body;
    return data;
  }
}

class Channel {
  int _id;
  int _createdAt;
  int _updatedAt;
  String _name;
  String _addonTable;
  String _title;

  Channel(
      {int id,
        int createdAt,
        int updatedAt,
        String name,
        String addonTable,
        String title}) {
    this._id = id;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._name = name;
    this._addonTable = addonTable;
    this._title = title;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get createdAt => _createdAt;
  set createdAt(int createdAt) => _createdAt = createdAt;
  int get updatedAt => _updatedAt;
  set updatedAt(int updatedAt) => _updatedAt = updatedAt;
  String get name => _name;
  set name(String name) => _name = name;
  String get addonTable => _addonTable;
  set addonTable(String addonTable) => _addonTable = addonTable;
  String get title => _title;
  set title(String title) => _title = title;

  Channel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _name = json['name'];
    _addonTable = json['addon_table'];
    _title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['name'] = this._name;
    data['addon_table'] = this._addonTable;
    data['title'] = this._title;
    return data;
  }
}
