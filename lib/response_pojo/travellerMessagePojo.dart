// To parse this JSON data, do
//
//     final travellerMessageUserResponse = travellerMessageUserResponseFromJson(jsonString);

import 'dart:convert';

TravellerMessageUserResponse travellerMessageUserResponseFromJson(String str) =>
    TravellerMessageUserResponse.fromJson(json.decode(str));

String travellerMessageUserResponseToJson(TravellerMessageUserResponse data) =>
    json.encode(data.toJson());

class TravellerMessageUserResponse {
  bool success;
  int statusCode;
  List<Datum> data;
  String message;

  TravellerMessageUserResponse({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory TravellerMessageUserResponse.fromJson(Map<String, dynamic> json) =>
      TravellerMessageUserResponse(
        success: json["success"],
        statusCode: json["statusCode"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int participantId;
  String email;
  String name;

  Datum({
    required this.participantId,
    required this.email,
    required this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        participantId: json["participant_id"],
        email: json["email"],
    name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "participant_id": participantId,
        "email": email,
        "name": name,
      };
}
