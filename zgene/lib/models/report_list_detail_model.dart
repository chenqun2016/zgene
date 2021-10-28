class ReportListDetailModel {
  String scode;
  String itemid;
  String chname;
  String enname;
  String conclusion;
  String type;
  List<Genetic> genetic;
  Predisposition predisposition;
  String genes;
  String dsystem;
  String disDesc;
  String disFactor;
  String disSymptom;
  String disScreening;
  String disAdvice;
  var rate;
  var maleRate;
  var femaleRate;
  List<Gene> gene;
  String tag;
  String explain;
  String advice;
  String traitsDesc;
  List<Distribution> distribution;
  var risk;
  String adaptAge;
  String isshow;
  String sex;
  var minRisk;
  var maxRisk;
  var upRate;
  var sameRate;
  var lowRate;
  String disHeritability;
  String disHeritabilityMale;
  String disHeritabilityFemale;
  String disReference;
  String comname;
  String goodsname;
  String drugType;
  String ageRange;
  String drugDesc;
  String drugToxic;
  String drugReaction;
  String drugInteraction;

  ReportListDetailModel(
      {this.scode,
      this.itemid,
      this.chname,
      this.enname,
      this.conclusion,
      this.type,
      this.genetic,
      this.predisposition,
      this.genes,
      this.dsystem,
      this.disDesc,
      this.disFactor,
      this.disSymptom,
      this.disScreening,
      this.disAdvice,
      this.rate,
      this.maleRate,
      this.femaleRate,
      this.gene,
      this.tag,
      this.explain,
      this.advice,
      this.traitsDesc,
      this.distribution,
      this.risk,
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
      this.disReference,
      this.comname,
      this.goodsname,
      this.drugType,
      this.ageRange,
      this.drugDesc,
      this.drugToxic,
      this.drugReaction,
      this.drugInteraction});

  ReportListDetailModel.fromJson(Map<String, dynamic> json) {
    scode = json['scode'];
    itemid = json['itemid'];
    chname = json['chname'];
    enname = json['enname'];
    conclusion = json['conclusion'];
    type = json['type'];
    if (json['genetic'] != null) {
      genetic = new List<Genetic>();
      json['genetic'].forEach((v) {
        genetic.add(new Genetic.fromJson(v));
      });
    }
    predisposition = json['predisposition'] != null
        ? new Predisposition.fromJson(json['predisposition'])
        : null;
    genes = json['genes'];
    dsystem = json['dsystem'];
    disDesc = json['dis_desc'];
    disFactor = json['dis_factor'];
    disSymptom = json['dis_symptom'];
    disScreening = json['dis_screening'];
    disAdvice = json['dis_advice'];
    rate = json['rate'];
    maleRate = json['male_rate'];
    femaleRate = json['female_rate'];
    if (json['gene'] != null) {
      gene = new List<Gene>();
      json['gene'].forEach((v) {
        gene.add(new Gene.fromJson(v));
      });
    }
    tag = json['tag'];
    explain = json['explain'];
    advice = json['advice'];
    traitsDesc = json['traits_desc'];
    if (json['distribution'] != null) {
      distribution = new List<Distribution>();
      json['distribution'].forEach((v) {
        distribution.add(new Distribution.fromJson(v));
      });
    }
    risk = json['risk'];
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
    disReference = json['dis_reference'];
    comname = json['comname'];
    goodsname = json['goodsname'];
    drugType = json['drug_type'];
    ageRange = json['age_range'];
    drugDesc = json['drug_desc'];
    drugToxic = json['drug_toxic'];
    drugReaction = json['drug_reaction'];
    drugInteraction = json['drug_interaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scode'] = this.scode;
    data['itemid'] = this.itemid;
    data['chname'] = this.chname;
    data['enname'] = this.enname;
    data['conclusion'] = this.conclusion;
    data['type'] = this.type;
    if (this.genetic != null) {
      data['genetic'] = this.genetic.map((v) => v.toJson()).toList();
    }
    if (this.predisposition != null) {
      data['predisposition'] = this.predisposition.toJson();
    }
    data['genes'] = this.genes;
    data['dsystem'] = this.dsystem;
    data['dis_desc'] = this.disDesc;
    data['dis_factor'] = this.disFactor;
    data['dis_symptom'] = this.disSymptom;
    data['dis_screening'] = this.disScreening;
    data['dis_advice'] = this.disAdvice;
    data['rate'] = this.rate;
    data['male_rate'] = this.maleRate;
    data['female_rate'] = this.femaleRate;
    if (this.gene != null) {
      data['gene'] = this.gene.map((v) => v.toJson()).toList();
    }
    data['tag'] = this.tag;
    data['explain'] = this.explain;
    data['advice'] = this.advice;
    data['traits_desc'] = this.traitsDesc;
    if (this.distribution != null) {
      data['distribution'] = this.distribution.map((v) => v.toJson()).toList();
    }
    data['risk'] = this.risk;
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
    data['dis_reference'] = this.disReference;
    data['comname'] = this.comname;
    data['goodsname'] = this.goodsname;
    data['drug_type'] = this.drugType;
    data['age_range'] = this.ageRange;
    data['drug_desc'] = this.drugDesc;
    data['drug_toxic'] = this.drugToxic;
    data['drug_reaction'] = this.drugReaction;
    data['drug_interaction'] = this.drugInteraction;
    return data;
  }
}

class Genetic {
  String scode;
  String itemid;
  String gene;
  String transcript;
  String nucleotide;
  String aminoAcid;
  String homo;
  String hGMD;
  String clivar;
  String interval;
  String result;

  Genetic(
      {this.scode,
      this.itemid,
      this.gene,
      this.transcript,
      this.nucleotide,
      this.aminoAcid,
      this.homo,
      this.hGMD,
      this.clivar,
      this.interval,
      this.result});

  Genetic.fromJson(Map<String, dynamic> json) {
    scode = json['scode'];
    itemid = json['itemid'];
    gene = json['gene'];
    transcript = json['transcript'];
    nucleotide = json['nucleotide'];
    aminoAcid = json['amino_acid'];
    homo = json['homo'];
    hGMD = json['HGMD'];
    clivar = json['clivar'];
    interval = json['interval'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scode'] = this.scode;
    data['itemid'] = this.itemid;
    data['gene'] = this.gene;
    data['transcript'] = this.transcript;
    data['nucleotide'] = this.nucleotide;
    data['amino_acid'] = this.aminoAcid;
    data['homo'] = this.homo;
    data['HGMD'] = this.hGMD;
    data['clivar'] = this.clivar;
    data['interval'] = this.interval;
    data['result'] = this.result;
    return data;
  }
}

class Predisposition {
  String scode;
  String itemid;
  var risk;
  var rate;
  var minRisk;
  var maxRisk;
  var upRate;
  var sameRate;
  var lowRate;
  String genes;

  Predisposition(
      {this.scode,
      this.itemid,
      this.risk,
      this.rate,
      this.minRisk,
      this.maxRisk,
      this.upRate,
      this.sameRate,
      this.lowRate,
      this.genes});

  Predisposition.fromJson(Map<String, dynamic> json) {
    scode = json['scode'];
    itemid = json['itemid'];
    risk = json['risk'];
    rate = json['rate'];
    minRisk = json['min_risk'];
    maxRisk = json['max_risk'];
    upRate = json['up_rate'];
    sameRate = json['same_rate'];
    lowRate = json['low_rate'];
    genes = json['genes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scode'] = this.scode;
    data['itemid'] = this.itemid;
    data['risk'] = this.risk;
    data['rate'] = this.rate;
    data['min_risk'] = this.minRisk;
    data['max_risk'] = this.maxRisk;
    data['up_rate'] = this.upRate;
    data['same_rate'] = this.sameRate;
    data['low_rate'] = this.lowRate;
    data['genes'] = this.genes;
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

class Distribution {
  String scode;
  String itemid;
  var rate;
  String title;
  String conclusion;
  String tag;

  Distribution(
      {this.scode,
      this.itemid,
      this.rate,
      this.title,
      this.conclusion,
      this.tag});

  Distribution.fromJson(Map<String, dynamic> json) {
    scode = json['scode'];
    itemid = json['itemid'];
    rate = json['rate'];
    title = json['title'];
    conclusion = json['conclusion'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scode'] = this.scode;
    data['itemid'] = this.itemid;
    data['rate'] = this.rate;
    data['title'] = this.title;
    data['conclusion'] = this.conclusion;
    data['tag'] = this.tag;
    return data;
  }
}
