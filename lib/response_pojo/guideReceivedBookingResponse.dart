// To parse this JSON data, do
//
//     final guideReceivedBookingResponse = guideReceivedBookingResponseFromJson(jsonString);

import 'dart:convert';

GuideReceivedBookingResponse guideReceivedBookingResponseFromJson(String str) => GuideReceivedBookingResponse.fromJson(json.decode(str));

String guideReceivedBookingResponseToJson(GuideReceivedBookingResponse data) => json.encode(data.toJson());

class GuideReceivedBookingResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GuideReceivedBookingResponse({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory GuideReceivedBookingResponse.fromJson(Map<String, dynamic> json) => GuideReceivedBookingResponse(
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
  int? count;
  List<GuideReceivedBookingData>? rows;

  Data({
    this.count,
    this.rows,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    count: json["count"],
    rows: json["rows"] == null ? [] : List<GuideReceivedBookingData>.from(json["rows"]!.map((x) => GuideReceivedBookingData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
  };
}

class GuideReceivedBookingData {
  int? id;
  int? touristGuideUserId;
  int? travellerUserId;
  String? firstName;
  String? lastName;
  String? email;
  dynamic destination;
  String? country;
  String? state;
  String? city;
  String? countryCode;
  String? countryCodeIso;
  int? phone;
  String? bookingStart;
  String? bookingEnd;
  String? bookingSlotStart;
  String? bookingSlotEnd;
  int? status;
  int? totalBookingPrice;
  int? initialPaid;
  int? finalPaid;
  String? bookingConfirmedTime;
  int? isCancelled;
  dynamic bookingCancelledTime;
  int? isCompleted;
  dynamic completedTime;
  int? numberOfPeople;
  String? familyType;
  String? activities;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  TravellerDetails? travellerDetails;
  Itinerary? itinerary;
  String? noOfDays;

  GuideReceivedBookingData({
    this.id,
    this.touristGuideUserId,
    this.travellerUserId,
    this.firstName,
    this.lastName,
    this.email,
    this.destination,
    this.country,
    this.state,
    this.city,
    this.countryCode,
    this.countryCodeIso,
    this.phone,
    this.bookingStart,
    this.bookingEnd,
    this.bookingSlotStart,
    this.bookingSlotEnd,
    this.status,
    this.totalBookingPrice,
    this.initialPaid,
    this.finalPaid,
    this.bookingConfirmedTime,
    this.isCancelled,
    this.bookingCancelledTime,
    this.isCompleted,
    this.completedTime,
    this.numberOfPeople,
    this.familyType,
    this.activities,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.travellerDetails,
    this.itinerary,
    this.noOfDays,
  });

  factory GuideReceivedBookingData.fromJson(Map<String, dynamic> json) => GuideReceivedBookingData(
    id: json["id"],
    touristGuideUserId: json["tourist_guide_user_id"],
    travellerUserId: json["traveller_user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    destination: json["destination"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    countryCode: json["country_code"],
    countryCodeIso: json["country_code_iso"],
    phone: json["phone"],
    bookingStart: json["booking_start"],
    bookingEnd: json["booking_end"],
    bookingSlotStart: json["booking_slot_start"],
    bookingSlotEnd: json["booking_slot_end"],
    status: json["status"],
    totalBookingPrice: json["total_booking_price"],
    initialPaid: json["initial_paid"],
    finalPaid: json["final_paid"],
    bookingConfirmedTime: json["booking_confirmed_time"],
    isCancelled: json["is_cancelled"],
    bookingCancelledTime: json["booking_cancelled_time"],
    isCompleted: json["is_completed"],
    completedTime: json["completed_time"],
    numberOfPeople: json["number_of_people"],
    familyType: json["family_type"],
    activities: json["activities"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    deletedAt: json["deleted_at"],
    travellerDetails: json["travellerDetails"] == null ? null : TravellerDetails.fromJson(json["travellerDetails"]),
    itinerary: json["itinerary"] == null ? null : Itinerary.fromJson(json["itinerary"]),
    noOfDays: json["NoOfDays"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tourist_guide_user_id": touristGuideUserId,
    "traveller_user_id": travellerUserId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "destination": destination,
    "country": country,
    "state": state,
    "city": city,
    "country_code": countryCode,
    "country_code_iso": countryCodeIso,
    "phone": phone,
    "booking_start": bookingStart,
    "booking_end": bookingEnd,
    "booking_slot_start": bookingSlotStart,
    "booking_slot_end": bookingSlotEnd,
    "status": status,
    "total_booking_price": totalBookingPrice,
    "initial_paid": initialPaid,
    "final_paid": finalPaid,
    "booking_confirmed_time": bookingConfirmedTime,
    "is_cancelled": isCancelled,
    "booking_cancelled_time": bookingCancelledTime,
    "is_completed": isCompleted,
    "completed_time": completedTime,
    "number_of_people": numberOfPeople,
    "family_type": familyType,
    "activities": activities,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "deleted_at": deletedAt,
    "travellerDetails": travellerDetails?.toJson(),
    "itinerary": itinerary?.toJson(),
    "NoOfDays": noOfDays,
  };
}

class Itinerary {
  String? descriptions;

  Itinerary({
    this.descriptions,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    descriptions: json["descriptions"],
  );

  Map<String, dynamic> toJson() => {
    "descriptions": descriptions,
  };
}

class TravellerDetails {
  int? id;
  UserDetail? userDetail;

  TravellerDetails({
    this.id,
    this.userDetail,
  });

  factory TravellerDetails.fromJson(Map<String, dynamic> json) => TravellerDetails(
    id: json["id"],
    userDetail: json["user_detail"] == null ? null : UserDetail.fromJson(json["user_detail"]),
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
