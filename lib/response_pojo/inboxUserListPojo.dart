// To parse this JSON data, do
//
//     final inboxUserListResponse = inboxUserListResponseFromJson(jsonString);

import 'dart:convert';

InboxUserListResponse inboxUserListResponseFromJson(String str) =>
    InboxUserListResponse.fromJson(json.decode(str));

String inboxUserListResponseToJson(InboxUserListResponse data) =>
    json.encode(data.toJson());

class InboxUserListResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  InboxUserListResponse({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory InboxUserListResponse.fromJson(Map<String, dynamic> json) =>
      InboxUserListResponse(
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
  int? counts;
  List<InboxMessage>? rows;

  Data({
    this.counts,
    this.rows,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        counts: json["counts"],
        rows: json["rows"] == null
            ? []
            : List<InboxMessage>.from(
                json["rows"]!.map((x) => InboxMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "counts": counts,
        "rows": rows == null
            ? []
            : List<InboxMessage>.from(rows!.map((x) => x.toJson())),
      };
}

class InboxMessage {
  int? id;
  String? subjectText;
  int? createdBy;
  int? participantId;
  int? status;
  String? lastMessage;
  int? messageType;
  int? lastMessageBy;
  String? updatedAt;
  LastMessageUserDetails? lastMessageUserDetails;

  InboxMessage({
    this.id,
    this.subjectText,
    this.createdBy,
    this.participantId,
    this.status,
    this.lastMessage,
    this.messageType,
    this.lastMessageBy,
    this.updatedAt,
    this.lastMessageUserDetails,
  });

  factory InboxMessage.fromJson(Map<String, dynamic> json) => InboxMessage(
        id: json["id"],
        subjectText: json["subject_text"],
        createdBy: json["created_by"],
        participantId: json["participant_id"],
        status: json["status"],
        lastMessage: json["last_message"],
        messageType: json["message_type"],
        lastMessageBy: json["last_message_by"],
        updatedAt: json["updatedAt"],
        lastMessageUserDetails: json["lastMessageUserDetails"] == null
            ? null
            : LastMessageUserDetails.fromJson(json["lastMessageUserDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject_text": subjectText,
        "created_by": createdBy,
        "participant_id": participantId,
        "status": status,
        "last_message": lastMessage,
        "message_type": messageType,
        "last_message_by": lastMessageBy,
        "updatedAt": updatedAt,
        "lastMessageUserDetails": lastMessageUserDetails?.toJson(),
      };
}

class LastMessageUserDetails {
  int? id;
  String? name;
  String? lastName;
  UserDetail? userDetail;

  LastMessageUserDetails({
    this.id,
    this.name,
    this.lastName,
    this.userDetail,
  });

  factory LastMessageUserDetails.fromJson(Map<String, dynamic> json) =>
      LastMessageUserDetails(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        userDetail: json["user_detail"] == null
            ? null
            : UserDetail.fromJson(json["user_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
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
