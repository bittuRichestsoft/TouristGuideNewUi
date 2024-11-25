// To parse this JSON data, do
//
//     final stripePaymentInitial = stripePaymentInitialFromJson(jsonString);

import 'dart:convert';

StripePaymentInitial stripePaymentInitialFromJson(String str) =>
    StripePaymentInitial.fromJson(json.decode(str));

String stripePaymentInitialToJson(StripePaymentInitial data) =>
    json.encode(data.toJson());

class StripePaymentInitial {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  StripePaymentInitial({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory StripePaymentInitial.fromJson(Map<String, dynamic> json) =>
      StripePaymentInitial(
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
  String? clientSecret;
  String? status;
  String? transactionId;
  String? clientSecretFinal;
  String? statusFinal;
  String? transactionIdFinal;

  Data({
    this.clientSecret,
    this.status,
    this.transactionId,
    this.clientSecretFinal,
    this.statusFinal,
    this.transactionIdFinal,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        clientSecret: json["client_secret"],
        status: json["status"],
        transactionId: json["transactionId"],
        clientSecretFinal: json["client_secret_final"],
        statusFinal: json["status_final"],
        transactionIdFinal: json["transactionId_final"],
      );

  Map<String, dynamic> toJson() => {
        "client_secret": clientSecret,
        "status": status,
        "transactionId": transactionId,
        "client_secret_final": clientSecretFinal,
        "status_final": statusFinal,
        "transactionId_final": transactionIdFinal,
      };
}
