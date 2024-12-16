// To parse this JSON data, do
//
//     final travellerMyBookingsResponse = travellerMyBookingsResponseFromJson(jsonString);
import "dart:convert";

TravellerMyBookingsResponse travellerMyBookingsResponseFromJson(String str) =>
    TravellerMyBookingsResponse.fromJson(json.decode(str));
String travellerMyBookingsResponseToJson(TravellerMyBookingsResponse data) =>
    json.encode(data.toJson());

class TravellerMyBookingsResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  TravellerMyBookingsResponse(
      {this.success, this.statusCode, this.data, this.message});

  TravellerMyBookingsResponse.fromJson(Map<String, dynamic> json) {
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
  dynamic cancelNotes;
  int? isCanceled;
  int? isCancledBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  User? user;
  Post? post;
  String? noOfDays;
  String? bookingStart;
  String? bookingEnd;
  String? bookingSlotStart;
  String? bookingSlotEnd;

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
      this.post,
      this.noOfDays,
      this.bookingStart,
      this.bookingEnd,
      this.bookingSlotStart,
      this.bookingSlotEnd});

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
    noOfDays = json['NoOfDays'];
    bookingStart = json['booking_start'];
    bookingEnd = json['booking_end'];
    bookingSlotStart = json['booking_slot_start'];
    bookingSlotEnd = json['booking_slot_end'];
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
    data['NoOfDays'] = this.noOfDays;
    data['booking_start'] = this.bookingStart;
    data['booking_end'] = this.bookingEnd;
    data['booking_slot_start'] = this.bookingSlotStart;
    data['booking_slot_end'] = this.bookingSlotEnd;
    return data;
  }
}

class User {
  String? name;
  String? lastName;
  String? email;
  UserDetail? userDetail;
  String? avgRatings;
  dynamic givenRating;

  User(
      {this.name,
      this.lastName,
      this.email,
      this.userDetail,
      this.avgRatings,
      this.givenRating});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lastName = json['last_name'];
    email = json['email'];
    userDetail = json['user_detail'] != null
        ? new UserDetail.fromJson(json['user_detail'])
        : null;
    avgRatings = json['AvgRatings'];
    givenRating = json['givenRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.toJson();
    }
    data['AvgRatings'] = this.avgRatings;
    data['givenRating'] = this.givenRating;
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
