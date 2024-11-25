// To parse this JSON data, do
//
//     final guideItineraryDetailResponse = guideItineraryDetailResponseFromJson(jsonString);

import 'dart:convert';

GuideItineraryDetailResponse guideItineraryDetailResponseFromJson(String str) =>
    GuideItineraryDetailResponse.fromJson(json.decode(str));

String guideItineraryDetailResponseToJson(GuideItineraryDetailResponse data) =>
    json.encode(data.toJson());

class GuideItineraryDetailResponse {
  bool success;
  int statusCode;
  Data data;
  String message;

  GuideItineraryDetailResponse({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory GuideItineraryDetailResponse.fromJson(Map<String, dynamic> json) =>
      GuideItineraryDetailResponse(
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
  int id;
  int travellerUserId;
  String firstName;
  String lastName;
  String email;
  String? destination;
  int status;
  int isComplete;
  int isCancelled;
  int finalPaid;
  int initialPaid;
  TravellerDetails travellerDetails;
  Itinerary? itinerary;
  List<BookingTrackHistory> bookingTrackHistories;
  String? dateDetails;
  String slotDetails;
  dynamic preferredCurrency;
  int price;
  String country;
  String state;
  String city;
  String finalPaymentDate;

  Data({
    required this.id,
    required this.travellerUserId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.destination,
    required this.status,
    required this.isComplete,
    required this.isCancelled,
    required this.finalPaid,
    required this.initialPaid,
    required this.travellerDetails,
    this.itinerary,
    required this.bookingTrackHistories,
    this.dateDetails,
    required this.slotDetails,
    this.preferredCurrency,
    required this.price,
    required this.country,
    required this.state,
    required this.city,
    required this.finalPaymentDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        travellerUserId: json["traveller_user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        destination: json["destination"],
        status: json["status"],
        isComplete: json["is_completed"],
        isCancelled: json["is_cancelled"],
        finalPaid: json["final_paid"],
        initialPaid: json["initial_paid"],
        travellerDetails: TravellerDetails.fromJson(json["travellerDetails"]),
        itinerary: json["itinerary"] != null
            ? Itinerary.fromJson(json["itinerary"])
            : null,
        bookingTrackHistories: List<BookingTrackHistory>.from(
            json["booking_track_histories"]
                .map((x) => BookingTrackHistory.fromJson(x))),
        dateDetails: json["dateDetails"],
        slotDetails: json["slotDetails"],
        preferredCurrency: json["preferred_currency"],
        price: json["price"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        finalPaymentDate:json["finalPaymentDate"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "traveller_user_id": travellerUserId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "destination": destination,
        "status": status,
        "is_completed": isComplete,
        "is_cancelled": isCancelled,
        "final_paid": finalPaid,
        "initial_paid": initialPaid,
        "travellerDetails": travellerDetails.toJson(),
        "itinerary": itinerary!.toJson(),
        "booking_track_histories":
            List<dynamic>.from(bookingTrackHistories.map((x) => x.toJson())),
        "dateDetails": dateDetails,
        "slotDetails": slotDetails,
        "preferred_currency": preferredCurrency,
        "price": price,
        "country": country,
        "state": state,
        "city": city,
        "finalPaymentDate": finalPaymentDate,
      };
}

class BookingTrackHistory {
  String key;
  String value;
  DateTime createdAt;

  BookingTrackHistory({
    required this.key,
    required this.value,
    required this.createdAt,
  });

  factory BookingTrackHistory.fromJson(Map<String, dynamic> json) =>
      BookingTrackHistory(
        key: json["key"],
        value: json["value"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "createdAt": createdAt.toIso8601String(),
      };
}

class Itinerary {
  int? id;
  String? descriptions;
  String? title;
  String? price;
  String? finalPrice;
  String? currency;

  Itinerary({
    this.id,
    this.descriptions,
    this.title,
    this.price,
    this.finalPrice,
    this.currency,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        id: json["id"],
        descriptions: json["descriptions"],
        title: json["title"],
        price: json["price"],
        finalPrice: json["final_price"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descriptions": descriptions,
        "title": title,
        "final_price": finalPrice,
        "currency": currency,
      };
}

class TravellerDetails {
  int id;
  UserDetail? userDetail;

  TravellerDetails({
    required this.id,
    this.userDetail,
  });

  factory TravellerDetails.fromJson(Map<String, dynamic> json) =>
      TravellerDetails(
        id: json["id"],
        userDetail: json["user_detail"] != null
            ? UserDetail.fromJson(json["user_detail"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_detail": userDetail!.toJson(),
      };
}

class UserDetail {
  String? profilePicture;

  UserDetail({
    this.profilePicture,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        profilePicture:
            json["profile_picture"] != null ? json["profile_picture"] : null,
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
      };
}
