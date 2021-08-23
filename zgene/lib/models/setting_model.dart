class SettingModel {
  String name;
  String label;
  String description;
  int groupId;
  String elementType;
  String options;
  String type;
  String value;
  int sortRank;

  SettingModel(
      {this.name,
      this.label,
      this.description,
      this.groupId,
      this.elementType,
      this.options,
      this.type,
      this.value,
      this.sortRank});

  SettingModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    description = json['description'];
    groupId = json['group_id'];
    elementType = json['element_type'];
    options = json['options'];
    type = json['type'];
    value = json['value'];
    sortRank = json['sort_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['label'] = this.label;
    data['description'] = this.description;
    data['group_id'] = this.groupId;
    data['element_type'] = this.elementType;
    data['options'] = this.options;
    data['type'] = this.type;
    data['value'] = this.value;
    data['sort_rank'] = this.sortRank;
    return data;
  }
}
