import 'dart:convert';

class NavigationModel {
  final String status;
  final List<WebItem> data;

  NavigationModel({
    required this.status,
    required this.data,
  });

  factory NavigationModel.fromRawJson(String str) => NavigationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NavigationModel.fromJson(Map<String, dynamic> json) => NavigationModel(
    status: json["status"],
    data: List<WebItem>.from(json["data"].map((x) => WebItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class WebItem {
  final int id;
  final String name;
  final String image;
  final String type;
  final String url;
  final dynamic urlDark;
  final String target;
  final dynamic htmlTag;
  final int showHeader;
  final int showFooter;
  final DateTime createdAt;
  final DateTime updatedAt;

  WebItem({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.url,
    required this.urlDark,
    required this.target,
    required this.htmlTag,
    required this.showHeader,
    required this.showFooter,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WebItem.fromRawJson(String str) => WebItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebItem.fromJson(Map<String, dynamic> json) => WebItem(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    type: json["type"],
    url: json["url"],
    urlDark: json["url_dark"],
    target: json["target"],
    htmlTag: json["html_tag"],
    showHeader: json["show_header"],
    showFooter: json["show_footer"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "type": type,
    "url": url,
    "url_dark": urlDark,
    "target": target,
    "html_tag": htmlTag,
    "show_header": showHeader,
    "show_footer": showFooter,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
