class ReportListDetailModel {
  String scode;
  String itemid;
  String chname;
  String enname;
  String dsystem;
  double risk;
  double rate;
  String conclusion;
  String adaptAge;
  String isshow;
  String sex;
  double minRisk;
  double maxRisk;
  double upRate;
  double sameRate;
  double lowRate;
  String disHeritability;
  String disHeritabilityMale;
  String disHeritabilityFemale;
  String disDesc;
  String disFactor;
  String disSymptom;
  String disScreening;
  String disAdvice;
  int maleRate;
  int femaleRate;
  List<Gene> gene;
  String disReference;

  ReportListDetailModel(
      {this.scode,
      this.itemid,
      this.chname,
      this.enname,
      this.dsystem,
      this.risk,
      this.rate,
      this.conclusion,
      this.adaptAge,
      this.isshow,
      this.sex,
      this.minRisk,
      this.maxRisk,
      this.upRate,
      this.sameRate,
      this.lowRate,
      this.disHeritability,
      this.disHeritabilityMale,
      this.disHeritabilityFemale,
      this.disDesc,
      this.disFactor,
      this.disSymptom,
      this.disScreening,
      this.disAdvice,
      this.maleRate,
      this.femaleRate,
      this.gene,
      this.disReference});

  ReportListDetailModel.fromJson(Map<String, dynamic> json) {
    scode = json['scode'];
    itemid = json['itemid'];
    chname = json['chname'];
    enname = json['enname'];
    dsystem = json['dsystem'];
    risk = json['risk'];
    rate = json['rate'];
    conclusion = json['conclusion'];
    adaptAge = json['adapt_age'];
    isshow = json['isshow'];
    sex = json['sex'];
    minRisk = json['min_risk'];
    maxRisk = json['max_risk'];
    upRate = json['up_rate'];
    sameRate = json['same_rate'];
    lowRate = json['low_rate'];
    disHeritability = json['dis_heritability'];
    disHeritabilityMale = json['dis_heritability_male'];
    disHeritabilityFemale = json['dis_heritability_female'];
    disDesc = json['dis_desc'];
    disFactor = json['dis_factor'];
    disSymptom = json['dis_symptom'];
    disScreening = json['dis_screening'];
    disAdvice = json['dis_advice'];
    maleRate = json['male_rate'];
    femaleRate = json['female_rate'];
    if (json['gene'] != null) {
      gene = new List<Gene>();
      json['gene'].forEach((v) {
        gene.add(new Gene.fromJson(v));
      });
    }
    disReference = json['dis_reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scode'] = this.scode;
    data['itemid'] = this.itemid;
    data['chname'] = this.chname;
    data['enname'] = this.enname;
    data['dsystem'] = this.dsystem;
    data['risk'] = this.risk;
    data['rate'] = this.rate;
    data['conclusion'] = this.conclusion;
    data['adapt_age'] = this.adaptAge;
    data['isshow'] = this.isshow;
    data['sex'] = this.sex;
    data['min_risk'] = this.minRisk;
    data['max_risk'] = this.maxRisk;
    data['up_rate'] = this.upRate;
    data['same_rate'] = this.sameRate;
    data['low_rate'] = this.lowRate;
    data['dis_heritability'] = this.disHeritability;
    data['dis_heritability_male'] = this.disHeritabilityMale;
    data['dis_heritability_female'] = this.disHeritabilityFemale;
    data['dis_desc'] = this.disDesc;
    data['dis_factor'] = this.disFactor;
    data['dis_symptom'] = this.disSymptom;
    data['dis_screening'] = this.disScreening;
    data['dis_advice'] = this.disAdvice;
    data['male_rate'] = this.maleRate;
    data['female_rate'] = this.femaleRate;
    if (this.gene != null) {
      data['gene'] = this.gene.map((v) => v.toJson()).toList();
    }
    data['dis_reference'] = this.disReference;
    return data;
  }
}

class Gene {
  String scode;
  String about;
  String itemid;
  String chr;
  String locStart;
  String locEnd;
  String rs;
  String geneName;
  String geneRef;
  String genotype;
  String repute;
  String locid;
  String type;
  String inheritType;
  String hgvs;
  String result;
  String conclusion;
  String summary;
  String reliability;

  Gene(
      {this.scode,
      this.about,
      this.itemid,
      this.chr,
      this.locStart,
      this.locEnd,
      this.rs,
      this.geneName,
      this.geneRef,
      this.genotype,
      this.repute,
      this.locid,
      this.type,
      this.inheritType,
      this.hgvs,
      this.result,
      this.conclusion,
      this.summary,
      this.reliability});

  Gene.fromJson(Map<String, dynamic> json) {
    scode = json['scode'];
    about = json['about'];
    itemid = json['itemid'];
    chr = json['chr'];
    locStart = json['loc_start'];
    locEnd = json['loc_end'];
    rs = json['rs'];
    geneName = json['gene_name'];
    geneRef = json['gene_ref'];
    genotype = json['genotype'];
    repute = json['repute'];
    locid = json['locid'];
    type = json['type'];
    inheritType = json['inherit_type'];
    hgvs = json['hgvs'];
    result = json['result'];
    conclusion = json['conclusion'];
    summary = json['summary'];
    reliability = json['reliability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scode'] = this.scode;
    data['about'] = this.about;
    data['itemid'] = this.itemid;
    data['chr'] = this.chr;
    data['loc_start'] = this.locStart;
    data['loc_end'] = this.locEnd;
    data['rs'] = this.rs;
    data['gene_name'] = this.geneName;
    data['gene_ref'] = this.geneRef;
    data['genotype'] = this.genotype;
    data['repute'] = this.repute;
    data['locid'] = this.locid;
    data['type'] = this.type;
    data['inherit_type'] = this.inheritType;
    data['hgvs'] = this.hgvs;
    data['result'] = this.result;
    data['conclusion'] = this.conclusion;
    data['summary'] = this.summary;
    data['reliability'] = this.reliability;
    return data;
  }
}
