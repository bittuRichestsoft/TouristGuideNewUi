// To parse this JSON data, do
//
//     final getTravellerProfileResponse = getTravellerProfileResponseFromJson(jsonString);

import 'dart:convert';

GetTravellerProfileResponse getTravellerProfileResponseFromJson(String str) =>
    GetTravellerProfileResponse.fromJson(json.decode(str));

String getTravellerProfileResponseToJson(GetTravellerProfileResponse data) =>
    json.encode(data.toJson());

class GetTravellerProfileResponse {
  bool success;
  int statusCode;
  Data? data;
  String message;

  GetTravellerProfileResponse({
    required this.success,
    required this.statusCode,
    this.data,
    required this.message,
  });

  factory GetTravellerProfileResponse.fromJson(Map<String, dynamic> json) =>
      GetTravellerProfileResponse(
        success: json["success"],
        statusCode: json["statusCode"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data!.toJson(),
        "message": message,
      };
}

class Data {
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
  String? bio;
  bool? waitingList;
  UserDetail? userDetail;
  List<UserDocumentUrl>? userDocumentUrl;

  Data({
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
    this.bio,
    this.userDetail,
    this.userDocumentUrl,
    this.waitingList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        countryCode: json["country_code"],
        countryCodeIso: json["country_code_iso"],
        phone: json["phone"],
        availability: json["availability"],
        notificationStatus: json["notification_status"],
        pincode: json["pincode"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        bio: json["bio"],
        waitingList: json["waiting_list"],
        userDetail: json["user_detail"] != null
            ? UserDetail.fromJson(json["user_detail"])
            : null,
        userDocumentUrl: List<UserDocumentUrl>.from(
            json["user_document_url"].map((x) => UserDocumentUrl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "last_name": lastName,
        "email": email,
        "country_code": countryCode,
        "country_code_iso": countryCodeIso,
        "phone": phone,
        "availability": availability,
        "notification_status": notificationStatus,
        "pincode": pincode,
        "country": country,
        "state": state,
        "city": city,
        "bio": bio,
        "waiting_list": waitingList,
        "user_detail": userDetail!.toJson(),
        "user_document_url":
            List<dynamic>.from(userDocumentUrl!.map((x) => x.toJson())),
      };
}

class UserDetail {
  String? profilePicture;
  int? price;
  String? preferredCurrency;
  String? bio;

  UserDetail({
    this.profilePicture,
    this.price,
    this.preferredCurrency,
    this.bio,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        profilePicture: json["profile_picture"],
        price: json["price"],
        preferredCurrency: json["preferred_currency"],
        bio: json["bio"],
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
        "price": price,
        "preferred_currency": preferredCurrency,
        "bio": bio,
      };
}

class UserDocumentUrl {
  String documentUrl;

  UserDocumentUrl({
    required this.documentUrl,
  });

  factory UserDocumentUrl.fromJson(Map<String, dynamic> json) =>
      UserDocumentUrl(
        documentUrl: json["document_url"],
      );

  Map<String, dynamic> toJson() => {
        "document_url": documentUrl,
      };
}
