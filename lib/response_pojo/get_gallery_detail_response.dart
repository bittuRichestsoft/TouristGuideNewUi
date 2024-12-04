import 'dart:convert';

GetGalleryDetailResponse getGalleryDetailRespFromJson(String str) =>
    GetGalleryDetailResponse.fromJson(json.decode(str));

String getGalleryDetailRespToJson(GetGalleryDetailResponse data) =>
    json.encode(data.toJson());

class GetGalleryDetailResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GetGalleryDetailResponse(
      {this.success, this.statusCode, this.data, this.message});

  GetGalleryDetailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  GalleryDetails? galleryDetails;

  Data({this.galleryDetails});

  Data.fromJson(Map<String, dynamic> json) {
    galleryDetails = json['galleryDetails'] != null
        ? new GalleryDetails.fromJson(json['galleryDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.galleryDetails != null) {
      data['galleryDetails'] = this.galleryDetails!.toJson();
    }
    return data;
  }
}

class GalleryDetails {
  int? id;
  String? title;
  String? heroImage;
  String? description;
  String? location;
  int? likesCount;
  String? createdAt;
  List<GalleryMedia>? galleryMedia;

  GalleryDetails(
      {this.id,
      this.title,
      this.heroImage,
      this.description,
      this.location,
      this.likesCount,
      this.createdAt,
      this.galleryMedia});

  GalleryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    heroImage = json['hero_image'];
    description = json['description'];
    location = json['location'];
    likesCount = json['likesCount'];
    createdAt = json['createdAt'];
    if (json['gallery_media'] != null) {
      galleryMedia = <GalleryMedia>[];
      json['gallery_media'].forEach((v) {
        galleryMedia!.add(new GalleryMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['hero_image'] = this.heroImage;
    data['description'] = this.description;
    data['location'] = this.location;
    data['likesCount'] = this.likesCount;
    data['createdAt'] = this.createdAt;
    if (this.galleryMedia != null) {
      data['gallery_media'] =
          this.galleryMedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GalleryMedia {
  int? id;
  String? url;
  String? mediaType;

  GalleryMedia({this.id, this.url, this.mediaType});

  GalleryMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['media_type'] = this.mediaType;
    return data;
  }
}
