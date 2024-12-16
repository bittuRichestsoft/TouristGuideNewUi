// To parse this JSON data, do
//
//     final guideReceivedBookingResponse = guideReceivedBookingResponseFromJson(jsonString);

import 'dart:convert';

GuideReceivedBookingResponse guideReceivedBookingResponseFromJson(String str) =>
    GuideReceivedBookingResponse.fromJson(json.decode(str));

String guideReceivedBookingResponseToJson(GuideReceivedBookingResponse data) =>
    json.encode(data.toJson());

class GuideReceivedBookingResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GuideReceivedBookingResponse(
      {this.success, this.statusCode, this.data, this.message});

  GuideReceivedBookingResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? count;
  List<Rows>? rows;

  Data({this.count, this.rows});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  int? id;
  int? travellerId;
  int? localiteId;
  int? experienceId;
  String? price;
  String? startTime;
  String? firstName;
  String? lastName;
  String? location;
  String? noOfPeople;
  String? startDate;
  String? endDate;
  String? notes;
  String? title;
  int? status;
  int? isCompleted;
  int? isPaymentCompleted;
  String? cancelNotes;
  int? isCanceled;
  int? isCancledBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  User? user;
  Post? post;

  Rows(
      {this.id,
      this.travellerId,
      this.localiteId,
      this.experienceId,
      this.price,
      this.startTime,
      this.firstName,
      this.lastName,
      this.location,
      this.noOfPeople,
      this.startDate,
      this.endDate,
      this.notes,
      this.title,
      this.status,
      this.isCompleted,
      this.isPaymentCompleted,
      this.cancelNotes,
      this.isCanceled,
      this.isCancledBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user,
      this.post});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    travellerId = json['traveller_id'];
    localiteId = json['localite_id'];
    experienceId = json['experience_id'];
    price = json['price'];
    startTime = json['start_time'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    location = json['location'];
    noOfPeople = json['no_of_people'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    notes = json['notes'];
    title = json['title'];
    status = json['status'];
    isCompleted = json['is_completed'];
    isPaymentCompleted = json['is_payment_completed'];
    cancelNotes = json['cancel_notes'];
    isCanceled = json['is_canceled'];
    isCancledBy = json['is_cancled_by'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['traveller_id'] = this.travellerId;
    data['localite_id'] = this.localiteId;
    data['experience_id'] = this.experienceId;
    data['price'] = this.price;
    data['start_time'] = this.startTime;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['location'] = this.location;
    data['no_of_people'] = this.noOfPeople;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['notes'] = this.notes;
    data['title'] = this.title;
    data['status'] = this.status;
    data['is_completed'] = this.isCompleted;
    data['is_payment_completed'] = this.isPaymentCompleted;
    data['cancel_notes'] = this.cancelNotes;
    data['is_canceled'] = this.isCanceled;
    data['is_cancled_by'] = this.isCancledBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.post != null) {
      data['post'] = this.post!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  UserDetail? userDetail;

  User({this.id, this.userDetail});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userDetail = json['user_detail'] != null
        ? new UserDetail.fromJson(json['user_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.toJson();
    }
    return data;
  }
}

class UserDetail {
  String? profilePicture;

  UserDetail({this.profilePicture});

  UserDetail.fromJson(Map<String, dynamic> json) {
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_picture'] = this.profilePicture;
    return data;
  }
}

class Post {
  String? duration;

  Post({this.duration});

  Post.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    return data;
  }
}

/*
class GuideReceivedBookingResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GuideReceivedBookingResponse({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory GuideReceivedBookingResponse.fromJson(Map<String, dynamic> json) => GuideReceivedBookingResponse(
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
  int? count;
  List<GuideReceivedBookingData>? rows;

  Data({
    this.count,
    this.rows,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    count: json["count"],
    rows: json["rows"] == null ? [] : List<GuideReceivedBookingData>.from(json["rows"]!.map((x) => GuideReceivedBookingData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
  };
}

class GuideReceivedBookingData {
  int? id;
  int? touristGuideUserId;
  int? travellerUserId;
  String? firstName;
  String? lastName;
  String? email;
  dynamic destination;
  String? country;
  String? state;
  String? city;
  String? countryCode;
  String? countryCodeIso;
  int? phone;
  String? bookingStart;
  String? bookingEnd;
  String? bookingSlotStart;
  String? bookingSlotEnd;
  int? status;
  int? totalBookingPrice;
  int? initialPaid;
  int? finalPaid;
  String? bookingConfirmedTime;
  int? isCancelled;
  dynamic bookingCancelledTime;
  int? isCompleted;
  dynamic completedTime;
  int? numberOfPeople;
  String? familyType;
  String? activities;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  TravellerDetails? travellerDetails;
  Itinerary? itinerary;
  String? noOfDays;

  GuideReceivedBookingData({
    this.id,
    this.touristGuideUserId,
    this.travellerUserId,
    this.firstName,
    this.lastName,
    this.email,
    this.destination,
    this.country,
    this.state,
    this.city,
    this.countryCode,
    this.countryCodeIso,
    this.phone,
    this.bookingStart,
    this.bookingEnd,
    this.bookingSlotStart,
    this.bookingSlotEnd,
    this.status,
    this.totalBookingPrice,
    this.initialPaid,
    this.finalPaid,
    this.bookingConfirmedTime,
    this.isCancelled,
    this.bookingCancelledTime,
    this.isCompleted,
    this.completedTime,
    this.numberOfPeople,
    this.familyType,
    this.activities,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.travellerDetails,
    this.itinerary,
    this.noOfDays,
  });

  factory GuideReceivedBookingData.fromJson(Map<String, dynamic> json) => GuideReceivedBookingData(
    id: json["id"],
    touristGuideUserId: json["tourist_guide_user_id"],
    travellerUserId: json["traveller_user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    destination: json["destination"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    countryCode: json["country_code"],
    countryCodeIso: json["country_code_iso"],
    phone: json["phone"],
    bookingStart: json["booking_start"],
    bookingEnd: json["booking_end"],
    bookingSlotStart: json["booking_slot_start"],
    bookingSlotEnd: json["booking_slot_end"],
    status: json["status"],
    totalBookingPrice: json["total_booking_price"],
    initialPaid: json["initial_paid"],
    finalPaid: json["final_paid"],
    bookingConfirmedTime: json["booking_confirmed_time"],
    isCancelled: json["is_cancelled"],
    bookingCancelledTime: json["booking_cancelled_time"],
    isCompleted: json["is_completed"],
    completedTime: json["completed_time"],
    numberOfPeople: json["number_of_people"],
    familyType: json["family_type"],
    activities: json["activities"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    deletedAt: json["deleted_at"],
    travellerDetails: json["travellerDetails"] == null ? null : TravellerDetails.fromJson(json["travellerDetails"]),
    itinerary: json["itinerary"] == null ? null : Itinerary.fromJson(json["itinerary"]),
    noOfDays: json["NoOfDays"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tourist_guide_user_id": touristGuideUserId,
    "traveller_user_id": travellerUserId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "destination": destination,
    "country": country,
    "state": state,
    "city": city,
    "country_code": countryCode,
    "country_code_iso": countryCodeIso,
    "phone": phone,
    "booking_start": bookingStart,
    "booking_end": bookingEnd,
    "booking_slot_start": bookingSlotStart,
    "booking_slot_end": bookingSlotEnd,
    "status": status,
    "total_booking_price": totalBookingPrice,
    "initial_paid": initialPaid,
    "final_paid": finalPaid,
    "booking_confirmed_time": bookingConfirmedTime,
    "is_cancelled": isCancelled,
    "booking_cancelled_time": bookingCancelledTime,
    "is_completed": isCompleted,
    "completed_time": completedTime,
    "number_of_people": numberOfPeople,
    "family_type": familyType,
    "activities": activities,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "deleted_at": deletedAt,
    "travellerDetails": travellerDetails?.toJson(),
    "itinerary": itinerary?.toJson(),
    "NoOfDays": noOfDays,
  };
}

class Itinerary {
  String? descriptions;

  Itinerary({
    this.descriptions,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    descriptions: json["descriptions"],
  );

  Map<String, dynamic> toJson() => {
    "descriptions": descriptions,
  };
}

class TravellerDetails {
  int? id;
  UserDetail? userDetail;

  TravellerDetails({
    this.id,
    this.userDetail,
  });

  factory TravellerDetails.fromJson(Map<String, dynamic> json) => TravellerDetails(
    id: json["id"],
    userDetail: json["user_detail"] == null ? null : UserDetail.fromJson(json["user_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
*/
