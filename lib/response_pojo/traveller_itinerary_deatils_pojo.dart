// To parse this JSON data, do
//
//     final travellerItineraryDetailsNew = travellerItineraryDetailsNewFromJson(jsonString);

import 'dart:convert';

TravellerItineraryDetailsNew travellerItineraryDetailsNewFromJson(String str) => TravellerItineraryDetailsNew.fromJson(json.decode(str));

String travellerItineraryDetailsNewToJson(TravellerItineraryDetailsNew data) => json.encode(data.toJson());

class TravellerItineraryDetailsNew {
  bool success;
  int statusCode;
  Data data;
  String message;

  TravellerItineraryDetailsNew({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory TravellerItineraryDetailsNew.fromJson(Map<String, dynamic> json) => TravellerItineraryDetailsNew(
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
  int touristGuideUserId;
  String destination;
  int status;
  int isCompleted;
  User user;
  Itinerary itinerary;
  List<dynamic> bookingTrackHistories;
  String dateDetails;
  String slotDetails;
  String preferredCurrency;
  int price;

  Data({
    required this.id,
    required this.touristGuideUserId,
    required this.destination,
    required this.status,
    required this.isCompleted,
    required this.user,
    required this.itinerary,
    required this.bookingTrackHistories,
    required this.dateDetails,
    required this.slotDetails,
    required this.preferredCurrency,
    required this.price,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    touristGuideUserId: json["tourist_guide_user_id"],
    destination: json["destination"],
    status: json["status"],
    isCompleted: json["is_completed"],
    user: User.fromJson(json["user"]),
    itinerary: Itinerary.fromJson(json["itinerary"]),
    bookingTrackHistories: List<dynamic>.from(json["booking_track_histories"].map((x) => x)),
    dateDetails: json["dateDetails"],
    slotDetails: json["slotDetails"],
    preferredCurrency: json["preferred_currency"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tourist_guide_user_id": touristGuideUserId,
    "destination": destination,
    "status": status,
    "is_completed": isCompleted,
    "user": user.toJson(),
    "itinerary": itinerary.toJson(),
    "booking_track_histories": List<dynamic>.from(bookingTrackHistories.map((x) => x)),
    "dateDetails": dateDetails,
    "slotDetails": slotDetails,
    "preferred_currency": preferredCurrency,
    "price": price,
  };
}

class Itinerary {
  int id;
  String descriptions;
  String title;
  String price;
  String currency;
  String pdfUrl;

  Itinerary({
    required this.id,
    required this.descriptions,
    required this.title,
    required this.price,
    required this.currency,
    required this.pdfUrl,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    id: json["id"],
    descriptions: json["descriptions"],
    title: json["title"],
    price: json["price"],
    currency: json["currency"],
    pdfUrl: json["pdf_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "descriptions": descriptions,
    "title": title,
    "price": price,
    "currency": currency,
    "pdf_url": pdfUrl,
  };
}

class User {
  String name;
  String lastName;
  String email;
  UserDetail userDetail;

  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.userDetail,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    lastName: json["last_name"],
    email: json["email"],
    userDetail: UserDetail.fromJson(json["user_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "last_name": lastName,
    "email": email,
    "user_detail": userDetail.toJson(),
  };
}

class UserDetail {
  String profilePicture;
  int completePrice;
  String preferredCurrency;

  UserDetail({
    required this.profilePicture,
    required this.completePrice,
    required this.preferredCurrency,
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
