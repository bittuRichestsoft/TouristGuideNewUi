// To parse this JSON data, do
//
//     final getMessagesResponse = getMessagesResponseFromJson(jsonString);

import 'dart:convert';

GetMessagesResponse getMessagesResponseFromJson(String str) =>
    GetMessagesResponse.fromJson(json.decode(str));

String getMessagesResponseToJson(GetMessagesResponse data) =>
    json.encode(data.toJson());

class GetMessagesResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GetMessagesResponse({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory GetMessagesResponse.fromJson(Map<String, dynamic> json) =>
      GetMessagesResponse(
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
  String? subjectText;
  int? createdBy;
  int? participantId;
  int? status;
  String? updatedAt;
  List<Message>? messages;
  ReceiverMessageDetails? receiverMessageDetails;
  int? totalMessageCount;

  Data({
    this.id,
    this.subjectText,
    this.createdBy,
    this.participantId,
    this.status,
    this.updatedAt,
    this.messages,
    this.receiverMessageDetails,
    this.totalMessageCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        subjectText: json["subject_text"],
        createdBy: json["created_by"],
        participantId: json["participant_id"],
        status: json["status"],
        updatedAt: json["updatedAt"],
        messages: json["messages"] == null
            ? []
            : List<Message>.from(
                json["messages"]!.map((x) => Message.fromJson(x))),
        receiverMessageDetails: json["receiverMessageDetails"] == null
            ? null
            : ReceiverMessageDetails.fromJson(json["receiverMessageDetails"]),
        totalMessageCount: json["totalMessageCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject_text": subjectText,
        "created_by": createdBy,
        "participant_id": participantId,
        "status": status,
        "updatedAt": updatedAt,
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
        "receiverMessageDetails": receiverMessageDetails?.toJson(),
        "totalMessageCount": totalMessageCount,
      };
}

class Message {
  int? id;
  int? senderUserId;
  int? receiverUserId;
  String? messageText;
  int? status;
  int? messageType;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Message({
    this.id,
    this.senderUserId,
    this.receiverUserId,
    this.messageText,
    this.status,
    this.messageType,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        senderUserId: json["sender_user_id"],
        receiverUserId: json["receiver_user_id"],
        messageText: json["message_text"],
        status: json["status"],
        messageType: json["message_type"],
        deletedAt: json["deleted_at"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_user_id": senderUserId,
        "receiver_user_id": receiverUserId,
        "message_text": messageText,
        "status": status,
        "message_type": messageType,
        "deleted_at": deletedAt,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class ReceiverMessageDetails {
  int? id;
  String? name;
  String? lastName;
  String? email;
  UserDetail? userDetail;

  ReceiverMessageDetails({
    this.id,
    this.name,
    this.lastName,
    this.email,
    this.userDetail,
  });

  factory ReceiverMessageDetails.fromJson(Map<String, dynamic> json) =>
      ReceiverMessageDetails(
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
