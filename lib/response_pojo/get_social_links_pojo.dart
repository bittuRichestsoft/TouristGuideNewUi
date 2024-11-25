// To parse this JSON data, do
//
//     final getSocialLinksPojo = getSocialLinksPojoFromJson(jsonString);

import 'dart:convert';

GetSocialLinksPojo getSocialLinksPojoFromJson(String str) =>
    GetSocialLinksPojo.fromJson(json.decode(str));

String getSocialLinksPojoToJson(GetSocialLinksPojo data) =>
    json.encode(data.toJson());

class GetSocialLinksPojo {
  bool? success;
  int? statusCode;
  List<SocialLinksData>? data;
  String? message;

  GetSocialLinksPojo({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory GetSocialLinksPojo.fromJson(Map<String, dynamic> json) =>
      GetSocialLinksPojo(
        success: json["success"],
        statusCode: json["statusCode"],
        data: json["data"] == null
            ? []
            : List<SocialLinksData>.from(
                json["data"]!.map((x) => SocialLinksData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class SocialLinksData {
  String? key;
  String? section;
  String? value;
  int? status;

  SocialLinksData({
    this.key,
    this.section,
    this.value,
    this.status,
  });

  factory SocialLinksData.fromJson(Map<String, dynamic> json) =>
      SocialLinksData(
        key: json["key"],
        section: json["section"],
        value: json["value"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "section": section,
        "value": value,
        "status": status,
      };
}
