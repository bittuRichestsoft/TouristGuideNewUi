// To parse this JSON data, do
//
//     final waitingStatusRes = waitingStatusResFromJson(jsonString);

import 'dart:convert';

WaitingStatusRes waitingStatusResFromJson(String str) =>
    WaitingStatusRes.fromJson(json.decode(str));

String waitingStatusResToJson(WaitingStatusRes data) =>
    json.encode(data.toJson());

class WaitingStatusRes {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  WaitingStatusRes({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory WaitingStatusRes.fromJson(Map<String, dynamic> json) =>
      WaitingStatusRes(
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
  bool? waitingList;

  Data({
    this.waitingList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        waitingList: json["waiting_list"],
      );

  Map<String, dynamic> toJson() => {
        "waiting_list": waitingList,
      };
}
