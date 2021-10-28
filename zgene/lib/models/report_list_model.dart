class ReportListModel {
  String group;
  List<ReportDataList> dataList;

  ReportListModel({this.group, this.dataList});

  ReportListModel.fromJson(Map<String, dynamic> json) {
    group = json['group'];
    if (json['data_list'] != null) {
      dataList = new List<ReportDataList>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group'] = this.group;
    if (this.dataList != null) {
      data['data_list'] = this.dataList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportDataList {
  String scode;
  String itemid;
  String chname;
  String enname;
  String comname;
  String goodsname;
  String dsystem;
  String conclusion;
  String tag;
  String adaptAge;
  String drugType;
  String ageRange;
  String drugDesc;
  String drugToxic;
  String drugReaction;
  String drugInteraction;
  dynamic gene;

  ReportDataList(
      {this.scode,
      this.itemid,
      this.chname,
      this.enname,
      this.comname,
      this.goodsname,
      this.dsystem,
      this.conclusion,
      this.tag,
      this.adaptAge,
      this.drugType,
      this.ageRange,
      this.drugDesc,
      this.drugToxic,
      this.drugReaction,
      this.drugInteraction,
      this.gene});

  ReportDataList.fromJson(Map<String, dynamic> json) {
    scode = json['scode'];
    itemid = json['itemid'];
    chname = json['chname'];
    enname = json['enname'];
    comname = json['comname'];
    goodsname = json['goodsname'];
    dsystem = json['dsystem'];
    conclusion = json['conclusion'];
    tag = json['tag'];
    adaptAge = json['adapt_age'];
    drugType = json['drug_type'];
    ageRange = json['age_range'];
    drugDesc = json['drug_desc'];
    drugToxic = json['drug_toxic'];
    drugReaction = json['drug_reaction'];
    drugInteraction = json['drug_interaction'];
    gene = json['gene'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scode'] = this.scode;
    data['itemid'] = this.itemid;
    data['chname'] = this.chname;
    data['enname'] = this.enname;
    data['comname'] = this.comname;
    data['goodsname'] = this.goodsname;
    data['dsystem'] = this.dsystem;
    data['conclusion'] = this.conclusion;
    data['tag'] = this.tag;
    data['adapt_age'] = this.adaptAge;
    data['drug_type'] = this.drugType;
    data['age_range'] = this.ageRange;
    data['drug_desc'] = this.drugDesc;
    data['drug_toxic'] = this.drugToxic;
    data['drug_reaction'] = this.drugReaction;
    data['drug_interaction'] = this.drugInteraction;
    data['gene'] = this.gene;
    return data;
  }
}
