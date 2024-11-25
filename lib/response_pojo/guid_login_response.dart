// To parse this JSON data, do
//
//     final guideLoginResponse = guideLoginResponseFromJson(jsonString);

import 'dart:convert';

GuideLoginResponse guideLoginResponseFromJson(String str) =>
    GuideLoginResponse.fromJson(json.decode(str));

String guideLoginResponseToJson(GuideLoginResponse data) =>
    json.encode(data.toJson());

class GuideLoginResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GuideLoginResponse({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory GuideLoginResponse.fromJson(Map<String, dynamic> json) =>
      GuideLoginResponse(
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
  int? id;
  String? name;
  String? lastName;
  String? email;
  String? roleName;
  String? countryCode;
  String? countryCodeIso;
  int? phone;
  String? state;
  String? city;
  String? country;
  int? availability;
  int? notificationStatus;
  String? pincode;
  int? price;
  String? preferredCurrency;
  String? profilePicture;
  String? bio;
  List<UserDocument>? userDocuments;
  String? accessToken;
  bool? waitingList;

  Data({
    this.id,
    this.name,
    this.lastName,
    this.email,
    this.roleName,
    this.countryCode,
    this.countryCodeIso,
    this.phone,
    this.state,
    this.city,
    this.country,
    this.availability,
    this.notificationStatus,
    this.pincode,
    this.price,
    this.preferredCurrency,
    this.profilePicture,
    this.bio,
    this.userDocuments,
    this.accessToken,
    this.waitingList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        roleName: json["role_name"],
        countryCode: json["country_code"],
        countryCodeIso: json["country_code_iso"],
        phone: json["phone"],
        state: json["state"],
        city: json["city"],
        country: json["country"],
        availability: json["availability"],
        notificationStatus: json["notification_status"],
        pincode: json["pincode"],
        price: json["price"],
        preferredCurrency: json["preferred_currency"],
        profilePicture: json["profile_picture"],
        bio: json["bio"],
        userDocuments: json["userDocuments"] == null
            ? []
            : List<UserDocument>.from(
                json["userDocuments"]!.map((x) => UserDocument.fromJson(x))),
        accessToken: json["access_token"],
        waitingList: json["waiting_list"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "email": email,
        "role_name": roleName,
        "country_code": countryCode,
        "country_code_iso": countryCodeIso,
        "phone": phone,
        "state": state,
        "city": city,
        "country": country,
        "availability": availability,
        "notification_status": notificationStatus,
        "pincode": pincode,
        "price": price,
        "preferred_currency": preferredCurrency,
        "profile_picture": profilePicture,
        "bio": bio,
        "userDocuments": userDocuments == null
            ? []
            : List<dynamic>.from(userDocuments!.map((x) => x.toJson())),
        "access_token": accessToken,
        "waiting_list": waitingList,
      };
}

class UserDocument {
  int? id;
  String? documentUrl;

  UserDocument({
    this.id,
    this.documentUrl,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) => UserDocument(
        id: json["id"],
        documentUrl: json["document_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "document_url": documentUrl,
      };
}
