class ReportDesModel {
  List<Items> items;

  ReportDesModel({this.items});

  ReportDesModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String title;
  int number;
  String color;

  Items({this.title, this.number, this.color});

  Items.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    number = json['number'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['number'] = this.number;
    data['color'] = this.color;
    return data;
  }
}
