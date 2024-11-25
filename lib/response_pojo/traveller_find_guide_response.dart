// To parse this JSON data, do
//
//     final travellerFindGuideResponse = travellerFindGuideResponseFromJson(jsonString);

import 'dart:convert';

TravellerFindGuideResponse travellerFindGuideResponseFromJson(String str) => TravellerFindGuideResponse.fromJson(json.decode(str));

String travellerFindGuideResponseToJson(TravellerFindGuideResponse data) => json.encode(data.toJson());

class TravellerFindGuideResponse {
    bool success;
    int statusCode;
    Data data;
    String message;

    TravellerFindGuideResponse({
        required this.success,
        required this.statusCode,
        required this.data,
        required this.message,
    });

    factory TravellerFindGuideResponse.fromJson(Map<String, dynamic> json) => TravellerFindGuideResponse(
        success: json["success"],
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    int counts;
    List<Detail> details;

    Data({
        required this.counts,
        required this.details,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        counts: json["counts"],
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "counts": counts,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
    };
}

class Detail {
    int? userId;
    String? avgRatings;
    User? user;

    Detail({
        required this.userId,
        required this.avgRatings,
        required this.user,
    });

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        userId: json["user_id"],
        avgRatings: json["avg_ratings"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "avg_ratings": avgRatings,
        "user": user!.toJson(),
    };
}

class User {
    String? name;
    String? lastName;
    String? country;
    UserDetail? userDetail;

    User({
         this.name,
        this.lastName,
         this.country,
        this.userDetail,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        lastName: json["last_name"],
        country: json["country"],
        userDetail: json["user_detail"]!=null ? UserDetail.fromJson(json["user_detail"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "last_name": lastName,
        "country": country,
        "user_detail": userDetail!.toJson(),
    };
}

class UserDetail {
    String? bio;
    String? profilePicture;

    dynamic price;

    UserDetail({
         this.bio,
         this.profilePicture,
        this.price,
    });

    factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        bio: json["bio"],
        profilePicture: json["profile_picture"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "bio": bio,
        "profile_picture": profilePicture,
        "price": price,
    };
}
