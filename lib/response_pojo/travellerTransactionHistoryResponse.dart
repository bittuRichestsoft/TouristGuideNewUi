// To parse this JSON data, do
//
//     final travellerTransactionHistoryResponse = travellerTransactionHistoryResponseFromJson(jsonString);

import 'dart:convert';

TravellerTransactionHistoryResponse travellerTransactionHistoryResponseFromJson(
        String str) =>
    TravellerTransactionHistoryResponse.fromJson(json.decode(str));

String travellerTransactionHistoryResponseToJson(
        TravellerTransactionHistoryResponse data) =>
    json.encode(data.toJson());

class TravellerTransactionHistoryResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  TravellerTransactionHistoryResponse({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory TravellerTransactionHistoryResponse.fromJson(
          Map<String, dynamic> json) =>
      TravellerTransactionHistoryResponse(
        success: json["success"],
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data!.toJson(),
        "message": message,
      };
}

class Data {
  int count;
  List<TransationList> rows;

  Data({
    required this.count,
    required this.rows,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: List<TransationList>.from(
            json["rows"].map((x) => TransationList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class TransationList {
  int? id;
  int? bookingId;
  String? senderCurrency;
  int? amount;
  String? transactionId;
  String? paymentType;
  int? paymentStatus;
  String? mode;
  DateTime? createdAt;
  DateTime? updatedAt;
  BookingDetails? bookingDetails;

  TransationList({
    this.id,
    this.bookingId,
    this.senderCurrency,
    this.amount,
    this.transactionId,
    this.paymentType,
    this.paymentStatus,
    this.mode,
    this.createdAt,
    this.updatedAt,
    this.bookingDetails,
  });

  factory TransationList.fromJson(Map<String, dynamic> json) => TransationList(
        id: json["id"],
        bookingId: json["booking_id"],
        senderCurrency: json["sender_currency"],
        amount: json["amount"],
        transactionId: json["transaction_id"],
        paymentType: json["payment_type"],
        paymentStatus: json["payment_status"],
        mode: json["mode"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        bookingDetails: BookingDetails.fromJson(json["bookingDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "sender_currency": senderCurrency,
        "amount": amount,
        "transaction_id": transactionId,
        "payment_status": paymentStatus,
        "payment_type": paymentType,
        "mode": mode,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "bookingDetails": bookingDetails!.toJson(),
      };
}

class BookingDetails {
  int id;
  User user;

  BookingDetails({
    required this.id,
    required this.user,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
        id: json["id"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
      };
}

class User {
  String? name;
  String? lastName;
  String? email;

  User({
    this.name,
    this.lastName,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "last_name": lastName,
        "email": email,
      };
}
