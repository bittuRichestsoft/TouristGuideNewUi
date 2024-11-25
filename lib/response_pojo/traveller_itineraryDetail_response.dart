// To parse this JSON data, do
//
//     final travellerItineraryDetailResponse = travellerItineraryDetailResponseFromJson(jsonString);

import 'dart:convert';

TravellerItineraryDetailResponse travellerItineraryDetailResponseFromJson(
        String str) =>
    TravellerItineraryDetailResponse.fromJson(json.decode(str));

String travellerItineraryDetailResponseToJson(
        TravellerItineraryDetailResponse data) =>
    json.encode(data.toJson());

class TravellerItineraryDetailResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  TravellerItineraryDetailResponse({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory TravellerItineraryDetailResponse.fromJson(
          Map<String, dynamic> json) =>
      TravellerItineraryDetailResponse(
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
  int? touristGuideUserId;
  dynamic destination;
  int? status;
  int? isCompleted;
  String? country;
  String? state;
  String? city;
  String? familyType;
  String? activities;
  User? user;
  Itinerary? itinerary;
  List<BookingTrackHistory>? bookingTrackHistories;
  String? dateDetails;
  String? slotDetails;
  String? preferredCurrency;
  int? price;
  bool? isEligibleToPay;

  Data({
    this.id,
    this.touristGuideUserId,
    this.destination,
    this.status,
    this.isCompleted,
    this.country,
    this.state,
    this.city,
    this.familyType,
    this.activities,
    this.user,
    this.itinerary,
    this.bookingTrackHistories,
    this.dateDetails,
    this.slotDetails,
    this.preferredCurrency,
    this.price,
    this.isEligibleToPay,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        touristGuideUserId: json["tourist_guide_user_id"],
        destination: json["destination"],
        status: json["status"],
        isCompleted: json["is_completed"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        familyType: json["family_type"],
        activities: json["activities"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        itinerary: json["itinerary"] == null
            ? null
            : Itinerary.fromJson(json["itinerary"]),
        bookingTrackHistories: json["booking_track_histories"] == null
            ? []
            : List<BookingTrackHistory>.from(json["booking_track_histories"]!
                .map((x) => BookingTrackHistory.fromJson(x))),
        dateDetails: json["dateDetails"],
        slotDetails: json["slotDetails"],
        preferredCurrency: json["preferred_currency"],
        price: json["price"],
        isEligibleToPay: json["isEligibleToPay"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tourist_guide_user_id": touristGuideUserId,
        "destination": destination,
        "status": status,
        "is_completed": isCompleted,
        "country": country,
        "state": state,
        "city": city,
        "family_type": familyType,
        "activities": activities,
        "user": user?.toJson(),
        "itinerary": itinerary?.toJson(),
        "booking_track_histories": bookingTrackHistories == null
            ? []
            : List<dynamic>.from(bookingTrackHistories!.map((x) => x.toJson())),
        "dateDetails": dateDetails,
        "slotDetails": slotDetails,
        "preferred_currency": preferredCurrency,
        "price": price,
        "isEligibleToPay": isEligibleToPay,
      };
}

class BookingTrackHistory {
  String? key;
  String? value;
  String? createdAt;

  BookingTrackHistory({
    this.key,
    this.value,
    this.createdAt,
  });

  factory BookingTrackHistory.fromJson(Map<String, dynamic> json) =>
      BookingTrackHistory(
        key: json["key"],
        value: json["value"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "createdAt": createdAt,
      };
}

class Itinerary {
  int? id;
  String? descriptions;
  String? title;
  String? price;
  String? currency;
  String? pdfUrl;
  String? finalPrice;

  Itinerary({
    this.id,
    this.descriptions,
    this.title,
    this.price,
    this.currency,
    this.pdfUrl,
    this.finalPrice,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        id: json["id"],
        descriptions: json["descriptions"],
        title: json["title"],
        price: json["price"],
        currency: json["currency"],
        pdfUrl: json["pdf_url"],
        finalPrice: json["final_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descriptions": descriptions,
        "title": title,
        "price": price,
        "currency": currency,
        "pdf_url": pdfUrl,
        "final_price": finalPrice,
      };
}

class User {
  String? name;
  String? lastName;
  String? email;
  UserDetail? userDetail;

  User({
    this.name,
    this.lastName,
    this.email,
    this.userDetail,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        userDetail: json["user_detail"] == null
            ? null
            : UserDetail.fromJson(json["user_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "last_name": lastName,
        "email": email,
        "user_detail": userDetail?.toJson(),
      };
}

class UserDetail {
  String? profilePicture;
  int? completePrice;
  String? preferredCurrency;

  UserDetail({
    this.profilePicture,
    this.completePrice,
    this.preferredCurrency,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        profilePicture: json["profile_picture"],
        completePrice: json["complete_price"],
        preferredCurrency: json["preferred_currency"],
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
        "complete_price": completePrice,
        "preferred_currency": preferredCurrency,
      };
}
