import 'dart:convert';

GetGuideProfileResponse getGuideProfileResponseFromJson(String str) =>
    GetGuideProfileResponse.fromJson(json.decode(str));

String getGuideProfileResponseToJson(GetGuideProfileResponse data) =>
    json.encode(data.toJson());

class GetGuideProfileResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GetGuideProfileResponse(
      {this.success, this.statusCode, this.data, this.message});

  GetGuideProfileResponse.fromJson(Map<String, dynamic> json) {
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
  GuideDetails? guideDetails;

  Data(
      {this.reviews,
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
      this.guideDetails});

  Data.fromJson(Map<String, dynamic> json) {
    reviews = json['Reviews'];
    avgRatings = json['AvgRatings'];
    ratings = json['Ratings'];
    star5Ratings = json['Star5Ratings'];
    star4Ratings = json['Star4Ratings'];
    star3Ratings = json['Star3Ratings'];
    star2Ratings = json['Star2Ratings'];
    star1Ratings = json['Star1Ratings'];
    percentage5Ratings = json['percentage5Ratings'];
    percentage4Ratings = json['percentage4Ratings'];
    percentage3Ratings = json['percentage3Ratings'];
    percentage2Ratings = json['percentage2Ratings'];
    percentage1Ratings = json['percentage1Ratings'];
    moreReviews = json['moreReviews'];
    guideDetails = json['guideDetails'] != null
        ? new GuideDetails.fromJson(json['guideDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Reviews'] = this.reviews;
    data['AvgRatings'] = this.avgRatings;
    data['Ratings'] = this.ratings;
    data['Star5Ratings'] = this.star5Ratings;
    data['Star4Ratings'] = this.star4Ratings;
    data['Star3Ratings'] = this.star3Ratings;
    data['Star2Ratings'] = this.star2Ratings;
    data['Star1Ratings'] = this.star1Ratings;
    data['percentage5Ratings'] = this.percentage5Ratings;
    data['percentage4Ratings'] = this.percentage4Ratings;
    data['percentage3Ratings'] = this.percentage3Ratings;
    data['percentage2Ratings'] = this.percentage2Ratings;
    data['percentage1Ratings'] = this.percentage1Ratings;
    data['moreReviews'] = this.moreReviews;
    if (this.guideDetails != null) {
      data['guideDetails'] = this.guideDetails!.toJson();
    }
    return data;
  }
}

class GuideDetails {
  int? id;
  String? name;
  String? lastName;
  String? email;
  String? countryCode;
  String? countryCodeIso;
  int? phone;
  int? availability;
  int? notificationStatus;
  String? pincode;
  String? country;
  String? state;
  String? city;
  int? isVerified;
  int? status;
  UserDetail? userDetail;
  List<GuideActivities>? guideActivities;
  List<UserDocumentUrl>? userDocumentUrl;

  GuideDetails(
      {this.id,
      this.name,
      this.lastName,
      this.email,
      this.countryCode,
      this.countryCodeIso,
      this.phone,
      this.availability,
      this.notificationStatus,
      this.pincode,
      this.country,
      this.state,
      this.city,
      this.isVerified,
      this.status,
      this.userDetail,
      this.guideActivities,
      this.userDocumentUrl});

  GuideDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['last_name'];
    email = json['email'];
    countryCode = json['country_code'];
    countryCodeIso = json['country_code_iso'];
    phone = json['phone'];
    availability = json['availability'];
    notificationStatus = json['notification_status'];
    pincode = json['pincode'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    isVerified = json['is_verified'];
    status = json['status'];
    userDetail = json['user_detail'] != null
        ? new UserDetail.fromJson(json['user_detail'])
        : null;
    if (json['guide_activities'] != null) {
      guideActivities = <GuideActivities>[];
      json['guide_activities'].forEach((v) {
        guideActivities!.add(new GuideActivities.fromJson(v));
      });
    }
    if (json['user_document_url'] != null) {
      userDocumentUrl = <UserDocumentUrl>[];
      json['user_document_url'].forEach((v) {
        userDocumentUrl!.add(new UserDocumentUrl.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['country_code_iso'] = this.countryCodeIso;
    data['phone'] = this.phone;
    data['availability'] = this.availability;
    data['notification_status'] = this.notificationStatus;
    data['pincode'] = this.pincode;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['is_verified'] = this.isVerified;
    data['status'] = this.status;
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.toJson();
    }
    if (this.guideActivities != null) {
      data['guide_activities'] =
          this.guideActivities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDetail {
  String? profilePicture;
  dynamic price;
  String? preferredCurrency;
  String? bio;
  String? coverPicture;
  String? hostSinceYears;
  String? hostSinceMonths;
  String? pronouns;

  UserDetail(
      {this.profilePicture,
      this.price,
      this.preferredCurrency,
      this.bio,
      this.coverPicture,
      this.hostSinceYears,
      this.hostSinceMonths,
      this.pronouns});

  UserDetail.fromJson(Map<String, dynamic> json) {
    profilePicture = json['profile_picture'];
    price = json['price'];
    preferredCurrency = json['preferred_currency'];
    bio = json['bio'];
    coverPicture = json['cover_picture'];
    hostSinceYears = json['host_since_years'];
    hostSinceMonths = json['host_since_months'];
    pronouns = json['pronouns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_picture'] = this.profilePicture;
    data['price'] = this.price;
    data['preferred_currency'] = this.preferredCurrency;
    data['bio'] = this.bio;
    data['cover_picture'] = this.coverPicture;
    data['host_since_years'] = this.hostSinceYears;
    data['host_since_months'] = this.hostSinceMonths;
    data['pronouns'] = this.pronouns;
    return data;
  }
}

class GuideActivities {
  int? id;
  Activity? activity;

  GuideActivities({this.id, this.activity});

  GuideActivities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activity = json['activity'] != null
        ? new Activity.fromJson(json['activity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.activity != null) {
      data['activity'] = this.activity!.toJson();
    }
    return data;
  }
}

class Activity {
  int? id;
  String? title;

  Activity({this.id, this.title});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class UserDocumentUrl {
  int? id;
  String? documentUrl;

  UserDocumentUrl({this.id, this.documentUrl});

  UserDocumentUrl.fromJson(Map<String, dynamic> json) {
    documentUrl = json['document_url'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_url'] = this.documentUrl;
    data['id'] = this.id;
    return data;
  }
}
