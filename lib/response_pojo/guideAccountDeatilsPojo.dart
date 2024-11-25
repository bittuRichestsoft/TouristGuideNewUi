// To parse this JSON data, do
//
//     final guideGetAccountDetailsPojo = guideGetAccountDetailsPojoFromJson(jsonString);

import 'dart:convert';

GuideGetAccountDetailsPojo guideGetAccountDetailsPojoFromJson(String str) => GuideGetAccountDetailsPojo.fromJson(json.decode(str));

String guideGetAccountDetailsPojoToJson(GuideGetAccountDetailsPojo data) => json.encode(data.toJson());

class GuideGetAccountDetailsPojo {
  bool success;
  int statusCode;
  Data data;
  String message;

  GuideGetAccountDetailsPojo({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory GuideGetAccountDetailsPojo.fromJson(Map<String, dynamic> json) => GuideGetAccountDetailsPojo(
    success: json["success"],
    statusCode: json["statusCode"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  String key;
  String value;
  int status;

  Data({
    required this.key,
    required this.value,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    key: json["key"],
    value: json["value"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
    "status": status,
  };
}
