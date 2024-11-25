// To parse this JSON data, do
//
//     final notificationsResponse = notificationsResponseFromJson(jsonString);

import 'dart:convert';

NotificationsResponse notificationsResponseFromJson(String str) => NotificationsResponse.fromJson(json.decode(str));

String notificationsResponseToJson(NotificationsResponse data) => json.encode(data.toJson());

class NotificationsResponse {
    bool success;
    int statusCode;
    Data data;
    String message;

    NotificationsResponse({
        required this.success,
        required this.statusCode,
        required this.data,
        required this.message,
    });

    factory NotificationsResponse.fromJson(Map<String, dynamic> json) => NotificationsResponse(
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
    List<Row> rows;
    int unreadPaymentNotificationsCount;
    int unreadBookingNotificationsCount;

    Data({
        required this.count,
        required this.rows,
        required this.unreadPaymentNotificationsCount,
        required this.unreadBookingNotificationsCount,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: List<Row>.from(json["rows"].map((x) => Row.fromJson(x))),
        unreadPaymentNotificationsCount: json["unreadPaymentNotificationsCount"],
        unreadBookingNotificationsCount: json["unreadBookingNotificationsCount"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
        "unreadPaymentNotificationsCount": unreadPaymentNotificationsCount,
        "unreadBookingNotificationsCount": unreadBookingNotificationsCount,
    };
}

class Row {
    int id;
    int fromUserId;
    String title;
    String description;
    int status;
    String moduleType;
    int moduleTypeId;
    DateTime createdAt;
    String timeAgo;

    Row({
        required this.id,
        required this.fromUserId,
        required this.title,
        required this.description,
        required this.status,
        required this.moduleType,
        required this.moduleTypeId,
        required this.createdAt,
        required this.timeAgo,
    });

    factory Row.fromJson(Map<String, dynamic> json) => Row(
        id: json["id"],
        fromUserId: json["from_user_id"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        moduleType: json["module_type"],
        moduleTypeId: json["module_type_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        timeAgo: json["timeAgo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "from_user_id": fromUserId,
        "title": title,
        "description": description,
        "status": status,
        "module_type": moduleType,
        "module_type_id": moduleTypeId,
        "createdAt": createdAt.toIso8601String(),
        "timeAgo": timeAgo,
    };
}
