// To parse this JSON data, do
//
//     final guideTransactionListPojo = guideTransactionListPojoFromJson(jsonString);

import 'dart:convert';

GuideTransactionListPojo guideTransactionListPojoFromJson(String str) =>
    GuideTransactionListPojo.fromJson(json.decode(str));

String guideTransactionListPojoToJson(GuideTransactionListPojo data) =>
    json.encode(data.toJson());

class GuideTransactionListPojo {
  bool success;
  int statusCode;
  Data data;
  String message;

  GuideTransactionListPojo({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory GuideTransactionListPojo.fromJson(Map<String, dynamic> json) =>
      GuideTransactionListPojo(
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
  int count;
  List<GuideTransListData> rows;
  dynamic totalPayment;

  Data({
    required this.count,
    required this.rows,
    required this.totalPayment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      count: json["count"],
      rows: List<GuideTransListData>.from(
          json["rows"].map((x) => GuideTransListData.fromJson(x))),
      totalPayment: json["totalPayment"]);

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
        "totalPayment": totalPayment,
      };
}

class GuideTransListData {
  int id;
  int bookingId;
  String senderCurrency;
  int amount;
  String transactionId;
  String paymentType;
  int paymentStatus;
  String mode;
  String createdAt;
  String updatedAt;
  BookingDetails bookingDetails;

  GuideTransListData({
    required this.id,
    required this.bookingId,
    required this.senderCurrency,
    required this.amount,
    required this.transactionId,
    required this.paymentType,
    required this.paymentStatus,
    required this.mode,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingDetails,
  });

  factory GuideTransListData.fromJson(Map<String, dynamic> json) =>
      GuideTransListData(
        id: json["id"],
        bookingId: json["booking_id"],
        senderCurrency: json["sender_currency"],
        amount: json["amount"],
        transactionId: json["transaction_id"],
        paymentType: json["payment_type"],
        paymentStatus: json["payment_status"],
        mode: json["mode"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        bookingDetails: BookingDetails.fromJson(json["bookingDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "sender_currency": senderCurrency,
        "amount": amount,
        "transaction_id": transactionId,
        "payment_type": paymentType,
        "payment_status": paymentStatus,
        "mode": mode,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "bookingDetails": bookingDetails.toJson(),
      };
}

class BookingDetails {
  int id;
  int touristGuideUserId;
  int travellerUserId;
  TravellerDetails travellerDetails;

  BookingDetails({
    required this.id,
    required this.touristGuideUserId,
    required this.travellerUserId,
    required this.travellerDetails,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
        id: json["id"],
        touristGuideUserId: json["tourist_guide_user_id"],
        travellerUserId: json["traveller_user_id"],
        travellerDetails: TravellerDetails.fromJson(json["travellerDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tourist_guide_user_id": touristGuideUserId,
        "traveller_user_id": travellerUserId,
        "travellerDetails": travellerDetails.toJson(),
      };
}

class TravellerDetails {
  int id;
  String name;
  String lastName;
  String email;

  TravellerDetails({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
  });

  factory TravellerDetails.fromJson(Map<String, dynamic> json) =>
      TravellerDetails(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "email": email,
      };
}
