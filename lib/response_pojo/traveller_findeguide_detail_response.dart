// To parse this JSON data, do
//
//     final travellerFindGuideDetailResponse = travellerFindGuideDetailResponseFromJson(jsonString);

import 'dart:convert';

TravellerFindGuideDetailResponse travellerFindGuideDetailResponseFromJson(
        String str) =>
    TravellerFindGuideDetailResponse.fromJson(json.decode(str));

String travellerFindGuideDetailResponseToJson(
        TravellerFindGuideDetailResponse data) =>
    json.encode(data.toJson());

class TravellerFindGuideDetailResponse {
  bool success;
  int statusCode;
  GuideDetailData data;
  String message;

  TravellerFindGuideDetailResponse({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory TravellerFindGuideDetailResponse.fromJson(
          Map<String, dynamic> json) =>
      TravellerFindGuideDetailResponse(
        success: json["success"],
        statusCode: json["statusCode"],
        data: GuideDetailData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data.toJson(),
        "message": message,
      };
}

class GuideDetailData {
  int? reviews;
  String? avgRatings;
  int? ratings;
  int? star5Ratings;
  int? star4Ratings;
  int? star3Ratings;
  int? star2Ratings;
  int? star1Ratings;
  int? percentage5Ratings;
  int? percentage4Ratings;
  int? percentage3Ratings;
  int? percentage2Ratings;
  int? percentage1Ratings;
  int? moreReviews;
  List<MediaFile>? mediaFiles;
  GuideDetails? guideDetails;

  GuideDetailData({
    this.reviews,
    this.avgRatings,
    this.ratings,
    this.star5Ratings,
    this.star4Ratings,
    this.star3Ratings,
    this.star2Ratings,
    this.star1Ratings,
    this.percentage5Ratings,
    this.percentage4Ratings,
    this.percentage3Ratings,
    this.percentage2Ratings,
    this.percentage1Ratings,
    this.moreReviews,
    this.mediaFiles,
    this.guideDetails,
  });

  factory GuideDetailData.fromJson(Map<String, dynamic> json) =>
      GuideDetailData(
        reviews: json["Reviews"],
        avgRatings: json["AvgRatings"],
        ratings: json["Ratings"],
        star5Ratings: json["Star5Ratings"],
        star4Ratings: json["Star4Ratings"],
        star3Ratings: json["Star3Ratings"],
        star2Ratings: json["Star2Ratings"],
        star1Ratings: json["Star1Ratings"],
        percentage5Ratings: json["percentage5Ratings"],
        percentage4Ratings: json["percentage4Ratings"],
        percentage3Ratings: json["percentage3Ratings"],
        percentage2Ratings: json["percentage2Ratings"],
        percentage1Ratings: json["percentage1Ratings"],
        moreReviews: json["moreReviews"],
        mediaFiles: List<MediaFile>.from(
            json["media_files"].map((x) => MediaFile.fromJson(x))),
        guideDetails: GuideDetails.fromJson(json["GuideDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "Reviews": reviews,
        "AvgRatings": avgRatings,
        "Ratings": ratings,
        "Star5Ratings": star5Ratings,
        "Star4Ratings": star4Ratings,
        "Star3Ratings": star3Ratings,
        "Star2Ratings": star2Ratings,
        "Star1Ratings": star1Ratings,
        "percentage5Ratings": percentage5Ratings,
        "percentage4Ratings": percentage4Ratings,
        "percentage3Ratings": percentage3Ratings,
        "percentage2Ratings": percentage2Ratings,
        "percentage1Ratings": percentage1Ratings,
        "moreReviews": moreReviews,
        "media_files": List<dynamic>.from(mediaFiles!.map((x) => x.toJson())),
        "GuideDetails": guideDetails!.toJson(),
      };
}

class GuideDetails {
  int? id;
  String? name;
  String? lastName;
  String? country;
  String? state;
  String? city;
  UserHasRole? userHasRole;
  UserDetail? userDetail;
  List<RatingAndReview>? ratingAndReviews;

  GuideDetails({
    this.id,
    this.name,
    this.lastName,
    this.country,
    this.state,
    this.city,
    this.userHasRole,
    this.userDetail,
    this.ratingAndReviews,
  });

  factory GuideDetails.fromJson(Map<String, dynamic> json) => GuideDetails(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        userHasRole: UserHasRole.fromJson(json["user_has_role"]),
        userDetail: json["user_detail"] != null
            ? UserDetail.fromJson(json["user_detail"])
            : null,
        ratingAndReviews: List<RatingAndReview>.from(
            json["rating_and_reviews"].map((x) => RatingAndReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "country": country,
        "state": state,
        "city": city,
        "user_has_role": userHasRole!.toJson(),
        "user_detail": userDetail!.toJson(),
        "rating_and_reviews":
            List<dynamic>.from(ratingAndReviews!.map((x) => x.toJson())),
      };
}

class RatingAndReview {
  String? userName;
  String? userEmail;
  int? ratings;
  String? reviewMessage;
  int? status;
  DateTime? ratingGivenAt;
  RatingGivenUserDetails? ratingGivenUserDetails;

  RatingAndReview({
    this.userName,
    this.userEmail,
    this.ratings,
    this.reviewMessage,
    this.status,
    this.ratingGivenAt,
    this.ratingGivenUserDetails,
  });

  factory RatingAndReview.fromJson(Map<String, dynamic> json) =>
      RatingAndReview(
        userName: json["user_name"],
        userEmail: json["user_email"],
        ratings: json["ratings"],
        reviewMessage: json["review_message"],
        status: json["status"],
        ratingGivenAt: DateTime.parse(json["ratingGivenAt"]),
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
        "ratingGivenAt": ratingGivenAt!.toIso8601String(),
        "ratingGivenUserDetails": ratingGivenUserDetails?.toJson(),
      };
}

class RatingGivenUserDetails {
  int? id;
  RatingGivenUserDetailsUserDetail? userDetail;

  RatingGivenUserDetails({
    this.id,
    this.userDetail,
  });

  factory RatingGivenUserDetails.fromJson(Map<String, dynamic> json) =>
      RatingGivenUserDetails(
        id: json["id"],
        userDetail: json["user_detail"] != null
            ? RatingGivenUserDetailsUserDetail.fromJson(json["user_detail"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_detail": userDetail!.toJson(),
      };
}

class RatingGivenUserDetailsUserDetail {
  String? profilePicture;

  RatingGivenUserDetailsUserDetail({
    this.profilePicture,
  });

  factory RatingGivenUserDetailsUserDetail.fromJson(
          Map<String, dynamic> json) =>
      RatingGivenUserDetailsUserDetail(
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
      };
}

class UserDetail {
  String? bio;
  String? profilePicture;
  int? price;

  UserDetail({
    this.bio,
    this.profilePicture,
    this.price,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        bio: json["bio"],
        profilePicture:
            json["profile_picture"] != null ? json["profile_picture"] : null,
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "profile_picture": profilePicture,
        "price": price,
      };
}

class UserHasRole {
  int? roleId;
  Role? role;

  UserHasRole({
    this.roleId,
    this.role,
  });

  factory UserHasRole.fromJson(Map<String, dynamic> json) => UserHasRole(
        roleId: json["role_id"],
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "role_id": roleId,
        "role": role!.toJson(),
      };
}

class Role {
  String? name;

  Role({
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class MediaFile {
  String? destinationTitle;
  List<String>? fileUrls;

  MediaFile({
    this.destinationTitle,
    this.fileUrls,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        destinationTitle: json["destination_title"],
        fileUrls: List<String>.from(json["file_urls"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "destination_title": destinationTitle,
        "file_urls": List<dynamic>.from(fileUrls!.map((x) => x)),
      };
}
