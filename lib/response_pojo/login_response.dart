// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool? success;
  int? statusCode;
  LoginData? data;
  String? message;

  LoginResponse({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"],
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : LoginData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data?.toJson(),
        "message": message,
      };
}

class LoginData {
  int? id;
  String? name;
  String? lastName;
  String? email;
  String? roleName;
  String? countryCode;
  String? countryCodeIso;
  String? phone;
  String? state;
  String? city;
  String? country;
  int? availability;
  int? notificationStatus;
  dynamic pincode;
  dynamic price;
  dynamic preferredCurrency;
  dynamic profilePicture;
  dynamic bio;
  List<dynamic>? userDocuments;
  String? accessToken;
  bool? waitingList;

  LoginData({
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

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        roleName: json["role_name"],
        countryCode: json["country_code"],
        countryCodeIso: json["country_code_iso"],
        phone: json["phone"].toString(),
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
            : List<dynamic>.from(json["userDocuments"]!.map((x) => x)),
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
            : List<dynamic>.from(userDocuments!.map((x) => x)),
        "access_token": accessToken,
        "waiting_list": waitingList,
      };
}
