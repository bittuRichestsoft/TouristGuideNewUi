// To parse this JSON data, do
//
//     final guideTransactionDataPojo = guideTransactionDataPojoFromJson(jsonString);

import 'dart:convert';

GuideTransactionDataPojo guideTransactionDataPojoFromJson(String str) =>
    GuideTransactionDataPojo.fromJson(json.decode(str));

String guideTransactionDataPojoToJson(GuideTransactionDataPojo data) =>
    json.encode(data.toJson());

class GuideTransactionDataPojo {
  bool success;
  int statusCode;
  Data data;
  String message;

  GuideTransactionDataPojo({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory GuideTransactionDataPojo.fromJson(Map<String, dynamic> json) =>
      GuideTransactionDataPojo(
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
  int? id;
  int? touristGuideUserId;
  int? travellerUserId;
  String? destination;
  DateTime? bookingStart;
  DateTime? bookingEnd;
  String? bookingSlotStart;
  String? bookingSlotEnd;
  dynamic totalBookingPrice;
  dynamic initialPaid;
  dynamic finalPaid;
  List<Payment>? payments;
  TravellerDetails? travellerDetails;
  User? user;
  int? totalCountedHours;
  int? remainingAmount;
  dynamic totalAmountTopay;
  dynamic totalAmountWithdrawStatus;

  Data({
    this.id,
    this.touristGuideUserId,
    this.travellerUserId,
    this.destination,
    this.bookingStart,
    this.bookingEnd,
    this.bookingSlotStart,
    this.bookingSlotEnd,
    this.totalBookingPrice,
    this.initialPaid,
    this.finalPaid,
    this.payments,
    this.travellerDetails,
    this.user,
    this.totalCountedHours,
    this.remainingAmount,
    this.totalAmountTopay,
    this.totalAmountWithdrawStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        touristGuideUserId: json["tourist_guide_user_id"],
        travellerUserId: json["traveller_user_id"],
        destination: json["destination"],
        bookingStart: DateTime.parse(json["booking_start"]),
        bookingEnd: DateTime.parse(json["booking_end"]),
        bookingSlotStart: json["booking_slot_start"],
        bookingSlotEnd: json["booking_slot_end"],
        totalBookingPrice: json["total_booking_price"],
        initialPaid: json["initial_paid"],
        finalPaid: json["final_paid"],
        payments: List<Payment>.from(
            json["payments"].map((x) => Payment.fromJson(x))),
        travellerDetails: TravellerDetails.fromJson(json["travellerDetails"]),
        user: User.fromJson(json["user"]),
        totalCountedHours: json["TotalCountedHours"],
        remainingAmount: json["remainingAmount"],
        totalAmountTopay: json["totalAmountTopay"],
        totalAmountWithdrawStatus: json["totalAmountWithdrawStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tourist_guide_user_id": touristGuideUserId,
        "traveller_user_id": travellerUserId,
        "destination": destination,
        "booking_start":
            "${bookingStart!.year.toString().padLeft(4, '0')}-${bookingStart!.month.toString().padLeft(2, '0')}-${bookingStart!.day.toString().padLeft(2, '0')}",
        "booking_end":
            "${bookingEnd!.year.toString().padLeft(4, '0')}-${bookingEnd!.month.toString().padLeft(2, '0')}-${bookingEnd!.day.toString().padLeft(2, '0')}",
        "booking_slot_start": bookingSlotStart,
        "booking_slot_end": bookingSlotEnd,
        "total_booking_price": totalBookingPrice,
        "initial_paid": initialPaid,
        "final_paid": finalPaid,
        "payments": List<dynamic>.from(payments!.map((x) => x.toJson())),
        "travellerDetails": travellerDetails!.toJson(),
        "user": user!.toJson(),
        "TotalCountedHours": totalCountedHours,
        "remainingAmount": remainingAmount,
        "totalAmountTopay": totalAmountTopay,
        "totalAmountWithdrawStatus": totalAmountWithdrawStatus,
      };
}

class Payment {
  int id;
  String senderCurrency;
  int amount;
  String transactionId;
  int paymentStatus;
  String mode;
  String paymentType;
  dynamic withdrawPaymentStatus;
  String createdAt;
  String updatedAt;

  Payment({
    required this.id,
    required this.senderCurrency,
    required this.amount,
    required this.transactionId,
    required this.paymentStatus,
    required this.mode,
    required this.paymentType,
    required this.withdrawPaymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        senderCurrency: json["sender_currency"],
        amount: json["amount"],
        transactionId: json["transaction_id"],
        paymentStatus: json["payment_status"],
        mode: json["mode"],
        paymentType: json["payment_type"],
        withdrawPaymentStatus: json["withdraw_payment_status"],
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
        "withdraw_payment_status": withdrawPaymentStatus,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class TravellerDetails {
  int id;
  String name;
  String lastName;
  String email;
  TravellerDetailsUserDetail? userDetail;

  TravellerDetails({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    this.userDetail,
  });

  factory TravellerDetails.fromJson(Map<String, dynamic> json) =>
      TravellerDetails(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        userDetail: json["user_detail"] != null
            ? TravellerDetailsUserDetail.fromJson(json["user_detail"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "email": email,
        "user_detail": userDetail!.toJson(),
      };
}

class TravellerDetailsUserDetail {
  String? profilePicture;

  TravellerDetailsUserDetail({
    this.profilePicture,
  });

  factory TravellerDetailsUserDetail.fromJson(Map<String, dynamic> json) =>
      TravellerDetailsUserDetail(
        profilePicture:
            json["profile_picture"] != null ? json["profile_picture"] : null,
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
      };
}

class User {
  int id;
  UserUserDetail userDetail;

  User({
    required this.id,
    required this.userDetail,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userDetail: UserUserDetail.fromJson(json["user_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_detail": userDetail.toJson(),
      };
}

class UserUserDetail {
  int price;

  UserUserDetail({
    required this.price,
  });

  factory UserUserDetail.fromJson(Map<String, dynamic> json) => UserUserDetail(
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
      };
}
