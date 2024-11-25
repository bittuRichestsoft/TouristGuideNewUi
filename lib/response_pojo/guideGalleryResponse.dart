// To parse this JSON data, do
//
//     final guideGalleryResponse = guideGalleryResponseFromJson(jsonString);

import 'dart:convert';

GuideGalleryResponse guideGalleryResponseFromJson(String str) => GuideGalleryResponse.fromJson(json.decode(str));

String guideGalleryResponseToJson(GuideGalleryResponse data) => json.encode(data.toJson());

class GuideGalleryResponse {
    bool success;
    int statusCode;
    List<Datum> data;
    String message;

    GuideGalleryResponse({
        required this.success,
        required this.statusCode,
        required this.data,
        required this.message,
    });

    factory GuideGalleryResponse.fromJson(Map<String, dynamic> json) => GuideGalleryResponse(
        success: json["success"],
        statusCode: json["statusCode"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class Datum {
    String destinationTitle;
    List<FileUrl> fileUrls;

    Datum({
        required this.destinationTitle,
        required this.fileUrls,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        destinationTitle: json["destination_title"],
        fileUrls: List<FileUrl>.from(json["file_urls"].map((x) => FileUrl.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "destination_title": destinationTitle,
        "file_urls": List<dynamic>.from(fileUrls.map((x) => x.toJson())),
    };
}

class FileUrl {
    int id;
    String galleryImgUrl;

    FileUrl({
        required this.id,
        required this.galleryImgUrl,
    });

    factory FileUrl.fromJson(Map<String, dynamic> json) => FileUrl(
        id: json["id"],
        galleryImgUrl: json["gallery_img_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "gallery_img_url": galleryImgUrl,
    };
}
