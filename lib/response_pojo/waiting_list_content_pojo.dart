// To parse this JSON data, do
//
//     final waitingListContent = waitingListContentFromJson(jsonString);

import 'dart:convert';

WaitingListContent waitingListContentFromJson(String str) =>
    WaitingListContent.fromJson(json.decode(str));

String waitingListContentToJson(WaitingListContent data) =>
    json.encode(data.toJson());

class WaitingListContent {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  WaitingListContent({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory WaitingListContent.fromJson(Map<String, dynamic> json) =>
      WaitingListContent(
        success: json["success"],
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  String? section;
  Value? value;

  Data({
    this.section,
    this.value,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        section: json["section"],
        value: json["value"] == null ? null : Value.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "section": section,
        "value": value?.toJson(),
      };
}

class Value {
  String? email;
  String? title;
  String? description;
  BannerImage? bannerImage;

  Value({
    this.email,
    this.title,
    this.description,
    this.bannerImage,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        email: json["email"],
        title: json["title"],
        description: json["description"],
        bannerImage: json["banner_image"] == null
            ? null
            : BannerImage.fromJson(json["banner_image"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "title": title,
        "description": description,
        "banner_image": bannerImage?.toJson(),
      };
}

class BannerImage {
  String? uploadImageUrl;
  String? uploadImageResponseId;

  BannerImage({
    this.uploadImageUrl,
    this.uploadImageResponseId,
  });

  factory BannerImage.fromJson(Map<String, dynamic> json) => BannerImage(
        uploadImageUrl: json["upload_image_url"],
        uploadImageResponseId: json["upload_image_response_id"],
      );

  Map<String, dynamic> toJson() => {
        "upload_image_url": uploadImageUrl,
        "upload_image_response_id": uploadImageResponseId,
      };
}
