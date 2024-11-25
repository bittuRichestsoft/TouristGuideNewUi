// To parse this JSON data, do
//
//     final ratingReviewPojo = ratingReviewPojoFromJson(jsonString);

import 'dart:convert';

RatingReviewPojo ratingReviewPojoFromJson(String str) =>
    RatingReviewPojo.fromJson(json.decode(str));

String ratingReviewPojoToJson(RatingReviewPojo data) =>
    json.encode(data.toJson());

class RatingReviewPojo {
  bool? success;
  int? statusCode;
  RatingReviewData? data;
  String? message;

  RatingReviewPojo({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory RatingReviewPojo.fromJson(Map<String, dynamic> json) =>
      RatingReviewPojo(
        success: json["success"],
        statusCode: json["statusCode"],
        data: json["data"] == null
            ? null
            : RatingReviewData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data?.toJson(),
        "message": message,
      };
}

class RatingReviewData {
  int? count;
  List<RatingReviewList>? rows;

  RatingReviewData({
    this.count,
    this.rows,
  });

  factory RatingReviewData.fromJson(Map<String, dynamic> json) =>
      RatingReviewData(
        count: json["count"],
        rows: json["rows"] == null
            ? []
            : List<RatingReviewList>.from(
                json["rows"]!.map((x) => RatingReviewList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class RatingReviewList {
  String? userName;
  String? userEmail;
  int? ratings;
  String? reviewMessage;
  int? status;
  String? ratingGivenAt;
  RatingGivenUserDetails? ratingGivenUserDetails;

  RatingReviewList({
    this.userName,
    this.userEmail,
    this.ratings,
    this.reviewMessage,
    this.status,
    this.ratingGivenAt,
    this.ratingGivenUserDetails,
  });

  factory RatingReviewList.fromJson(Map<String, dynamic> json) =>
      RatingReviewList(
        userName: json["user_name"],
        userEmail: json["user_email"],
        ratings: json["ratings"],
        reviewMessage: json["review_message"],
        status: json["status"],
        ratingGivenAt: json["ratingGivenAt"],
        ratingGivenUserDetails: json["ratingGivenUserDetails"] == null
            ? null
            : RatingGivenUserDetails.fromJson(json["ratingGivenUserDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "user_email": userEmail,
        "ratings": ratings,
        "review_message": reviewMessage,
        "status": status,
        "ratingGivenAt": ratingGivenAt,
        "ratingGivenUserDetails": ratingGivenUserDetails?.toJson(),
      };
}

class RatingGivenUserDetails {
  int? id;
  UserDetail? userDetail;

  RatingGivenUserDetails({
    this.id,
    this.userDetail,
  });

  factory RatingGivenUserDetails.fromJson(Map<String, dynamic> json) =>
      RatingGivenUserDetails(
        id: json["id"],
        userDetail: json["user_detail"] == null
            ? null
            : UserDetail.fromJson(json["user_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_detail": userDetail?.toJson(),
      };
}

class UserDetail {
  String? profilePicture;

  UserDetail({
    this.profilePicture,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
      };
}
