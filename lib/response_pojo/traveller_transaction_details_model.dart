// To parse this JSON data, do
//
//     final transactionViewDetail = transactionViewDetailFromJson(jsonString);

import 'dart:convert';

TransactionViewDetail transactionViewDetailFromJson(String str) =>
    TransactionViewDetail.fromJson(json.decode(str));

String transactionViewDetailToJson(TransactionViewDetail data) =>
    json.encode(data.toJson());

class TransactionViewDetail {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  TransactionViewDetail({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory TransactionViewDetail.fromJson(Map<String, dynamic> json) =>
      TransactionViewDetail(
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
  int? travellerUserId;
  int? status;
  dynamic destination;
  DateTime? bookingStart;
  DateTime? bookingEnd;
  String? bookingSlotStart;
  String? bookingSlotEnd;
  int? isCompleted;
  int? totalBookingPrice;
  int? initialPaid;
  int? finalPaid;
  String? country;
  String? state;
  String? city;
  String? familyType;
  String? activities;
  List<Payment>? payments;
  Itinerary? itinerary;
  User? user;
  int? remainingAmount;

  Data({
    this.id,
    this.touristGuideUserId,
    this.travellerUserId,
    this.status,
    this.destination,
    this.bookingStart,
    this.bookingEnd,
    this.bookingSlotStart,
    this.bookingSlotEnd,
    this.isCompleted,
    this.totalBookingPrice,
    this.initialPaid,
    this.finalPaid,
    this.country,
    this.state,
    this.city,
    this.familyType,
    this.activities,
    this.payments,
    this.itinerary,
    this.user,
    this.remainingAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        touristGuideUserId: json["tourist_guide_user_id"],
        travellerUserId: json["traveller_user_id"],
        status: json["status"],
        destination: json["destination"],
        bookingStart: json["booking_start"] == null
            ? null
            : DateTime.parse(json["booking_start"]),
        bookingEnd: json["booking_end"] == null
            ? null
            : DateTime.parse(json["booking_end"]),
        bookingSlotStart: json["booking_slot_start"],
        bookingSlotEnd: json["booking_slot_end"],
        isCompleted: json["is_completed"],
        totalBookingPrice: json["total_booking_price"],
        initialPaid: json["initial_paid"],
        finalPaid: json["final_paid"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        familyType: json["family_type"],
        activities: json["activities"],
        payments: json["payments"] == null
            ? []
            : List<Payment>.from(
                json["payments"]!.map((x) => Payment.fromJson(x))),
        itinerary: json["itinerary"] == null
            ? null
            : Itinerary.fromJson(json["itinerary"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        remainingAmount: json["remainingAmount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tourist_guide_user_id": touristGuideUserId,
        "traveller_user_id": travellerUserId,
        "status": status,
        "destination": destination,
        "booking_start":
            "${bookingStart!.year.toString().padLeft(4, '0')}-${bookingStart!.month.toString().padLeft(2, '0')}-${bookingStart!.day.toString().padLeft(2, '0')}",
        "booking_end":
            "${bookingEnd!.year.toString().padLeft(4, '0')}-${bookingEnd!.month.toString().padLeft(2, '0')}-${bookingEnd!.day.toString().padLeft(2, '0')}",
        "booking_slot_start": bookingSlotStart,
        "booking_slot_end": bookingSlotEnd,
        "is_completed": isCompleted,
        "total_booking_price": totalBookingPrice,
        "initial_paid": initialPaid,
        "final_paid": finalPaid,
        "country": country,
        "state": state,
        "city": city,
        "family_type": familyType,
        "activities": activities,
        "payments": payments == null
            ? []
            : List<dynamic>.from(payments!.map((x) => x.toJson())),
        "itinerary": itinerary?.toJson(),
        "user": user?.toJson(),
        "remainingAmount": remainingAmount,
      };
}

class Itinerary {
  int? id;
  String? price;
  String? currency;
  String? finalPrice;

  Itinerary({
    this.id,
    this.price,
    this.currency,
    this.finalPrice,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        id: json["id"],
        price: json["price"],
        currency: json["currency"],
        finalPrice: json["final_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "currency": currency,
        "final_price": finalPrice,
      };
}

class Payment {
  int? id;
  String? senderCurrency;
  int? amount;
  String? transactionId;
  int? paymentStatus;
  String? mode;
  String? paymentType;
  String? createdAt;
  String? updatedAt;

  Payment({
    this.id,
    this.senderCurrency,
    this.amount,
    this.transactionId,
    this.paymentStatus,
    this.mode,
    this.paymentType,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        senderCurrency: json["sender_currency"],
        amount: json["amount"],
        transactionId: json["transaction_id"],
        paymentStatus: json["payment_status"],
        mode: json["mode"],
        paymentType: json["payment_type"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_currency": senderCurrency,
        "amount": amount,
        "transaction_id": transactionId,
        "payment_status": paymentStatus,
        "mode": mode,
        "payment_type": paymentType,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class User {
  int? id;
  String? name;
  String? lastName;
  String? email;
  UserDetail? userDetail;

  User({
    this.id,
    this.name,
    this.lastName,
    this.email,
    this.userDetail,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        userDetail: json["user_detail"] == null
            ? null
            : UserDetail.fromJson(json["user_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "email": email,
        "user_detail": userDetail?.toJson(),
      };
}

class UserDetail {
  String? profilePicture;
  int? price;

  UserDetail({
    this.profilePicture,
    this.price,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        profilePicture: json["profile_picture"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
        "price": price,
      };
}
