import 'dart:convert';

TravellerTransactionViewResponse travellerTransactionViewResponseFromJson(String str) => TravellerTransactionViewResponse.fromJson(json.decode(str));

String travellerTransactionViewResponseToJson(TravellerTransactionViewResponse data) => json.encode(data.toJson());

class TravellerTransactionViewResponse {
    bool success;
    int statusCode;
    Data data;
    String message;

    TravellerTransactionViewResponse({
        required this.success,
        required this.statusCode,
        required this.data,
        required this.message,
    });

    factory TravellerTransactionViewResponse.fromJson(Map<String, dynamic> json) => TravellerTransactionViewResponse(
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
    int id;
    int touristGuideUserId;
    int travellerUserId;
    String destination;
    DateTime bookingStart;
    DateTime bookingEnd;
    String bookingSlotStart;
    String bookingSlotEnd;
    List<Payment> payments;
    User user;
    int totalCountedHours;
    int remainingAmount;

    Data({
        required this.id,
        required this.touristGuideUserId,
        required this.travellerUserId,
        required this.destination,
        required this.bookingStart,
        required this.bookingEnd,
        required this.bookingSlotStart,
        required this.bookingSlotEnd,
        required this.payments,
        required this.user,
        required this.totalCountedHours,
        required this.remainingAmount,
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
        payments: List<Payment>.from(json["payments"].map((x) => Payment.fromJson(x))),
        user: User.fromJson(json["user"]),
        totalCountedHours: json["TotalCountedHours"],
        remainingAmount: json["remainingAmount"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tourist_guide_user_id": touristGuideUserId,
        "traveller_user_id": travellerUserId,
        "destination": destination,
        "booking_start": "${bookingStart.year.toString().padLeft(4, '0')}-${bookingStart.month.toString().padLeft(2, '0')}-${bookingStart.day.toString().padLeft(2, '0')}",
        "booking_end": "${bookingEnd.year.toString().padLeft(4, '0')}-${bookingEnd.month.toString().padLeft(2, '0')}-${bookingEnd.day.toString().padLeft(2, '0')}",
        "booking_slot_start": bookingSlotStart,
        "booking_slot_end": bookingSlotEnd,
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
        "user": user.toJson(),
        "TotalCountedHours": totalCountedHours,
        "remainingAmount": remainingAmount,
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
    DateTime createdAt;
    DateTime updatedAt;

    Payment({
        required this.id,
        required this.senderCurrency,
        required this.amount,
        required this.transactionId,
        required this.paymentStatus,
        required this.mode,
        required this.paymentType,
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
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sender_currency": senderCurrency,
        "amount": amount,
        "transaction_id": transactionId,
        "payment_status": paymentStatus,
        "mode": mode,
        "payment_type": paymentType,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class User {
    int id;
    String name;
    String lastName;
    String email;
    UserDetail userDetail;

    User({
        required this.id,
        required this.name,
        required this.lastName,
        required this.email,
        required this.userDetail,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        userDetail: UserDetail.fromJson(json["user_detail"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "email": email,
        "user_detail": userDetail.toJson(),
    };
}

class UserDetail {
    String profilePicture;
    int price;

    UserDetail({
        required this.profilePicture,
        required this.price,
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
