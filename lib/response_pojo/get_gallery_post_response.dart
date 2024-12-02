import 'dart:convert';

GetGalleryPostResponse getGalleryPostRespFromJson(String str) =>
    GetGalleryPostResponse.fromJson(json.decode(str));

String getGalleryPostRespToJson(GetGalleryPostResponse data) =>
    json.encode(data.toJson());

class GetGalleryPostResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GetGalleryPostResponse(
      {this.success, this.statusCode, this.data, this.message});

  GetGalleryPostResponse.fromJson(Map<String, dynamic> json) {
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
  int? count;
  List<Rows>? rows;
  int? totalCounts;

  Data({this.count, this.rows, this.totalCounts});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
    totalCounts = json['totalCounts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['totalCounts'] = this.totalCounts;
    return data;
  }
}

class Rows {
  int? id;
  String? title;
  String? heroImage;
  String? description;
  String? location;
  int? likesCount;
  String? createdAt;
  int? likedPost;
  List<GalleryMedia>? galleryMedia;

  Rows(
      {this.id,
      this.title,
      this.heroImage,
      this.description,
      this.location,
      this.likesCount,
      this.createdAt,
      this.likedPost,
      this.galleryMedia});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    heroImage = json['hero_image'];
    description = json['description'];
    location = json['location'];
    likesCount = json['likesCount'];
    createdAt = json['createdAt'];
    likedPost = json['likedPost'];
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
    data['likedPost'] = this.likedPost;
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
