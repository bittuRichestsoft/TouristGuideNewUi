import 'dart:convert';

GetSearchExperienceResponse getSearchExpRespFromJson(String str) =>
    GetSearchExperienceResponse.fromJson(json.decode(str));

String getSearchExpRespToJson(GetSearchExperienceResponse data) =>
    json.encode(data.toJson());

class GetSearchExperienceResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GetSearchExperienceResponse(
      {this.success, this.statusCode, this.data, this.message});

  GetSearchExperienceResponse.fromJson(Map<String, dynamic> json) {
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
  Details? details;

  Data({this.details});

  Data.fromJson(Map<String, dynamic> json) {
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  int? count;
  List<Rows>? rows;

  Details({this.count, this.rows});

  Details.fromJson(Map<String, dynamic> json) {
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
  String? postType;
  String? title;
  dynamic activities;
  String? schedule;
  String? location;
  String? country;
  String? state;
  String? city;
  String? transportType;
  bool? accessibility;
  int? maxPeople;
  int? minPeople;
  String? startingTime;
  String? duration;
  String? meetingPoint;
  String? dropOffPoint;
  int? price;
  String? heroImage;
  String? description;
  dynamic overview;
  String? createdAt;
  int? longitude;
  int? rating;
  int? latitude;
  int? likesCount;
  User? user;
  List<PostImages>? postImages;
  List<PostsLikes>? postsLikes;
  List<PostsActivities>? postsActivities;

  Rows(
      {this.id,
      this.postType,
      this.title,
      this.activities,
      this.schedule,
      this.location,
      this.country,
      this.state,
      this.city,
      this.transportType,
      this.accessibility,
      this.maxPeople,
      this.minPeople,
      this.startingTime,
      this.duration,
      this.meetingPoint,
      this.dropOffPoint,
      this.price,
      this.heroImage,
      this.description,
      this.overview,
      this.createdAt,
      this.longitude,
      this.rating,
      this.latitude,
      this.likesCount,
      this.user,
      this.postImages,
      this.postsLikes,
      this.postsActivities});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['post_type'];
    title = json['title'];
    activities = json['activities'];
    schedule = json['schedule'];
    location = json['location'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    transportType = json['transport_type'];
    accessibility = json['accessibility'];
    maxPeople = json['max_people'];
    minPeople = json['min_people'];
    startingTime = json['starting_time'];
    duration = json['duration'];
    meetingPoint = json['meeting_point'];
    dropOffPoint = json['drop_off_point'];
    price = json['price'];
    heroImage = json['hero_image'];
    description = json['description'];
    overview = json['overview'];
    createdAt = json['createdAt'];
    longitude = json['longitude'];
    rating = json['rating'];
    latitude = json['latitude'];
    likesCount = json['likesCount'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['post_images'] != null) {
      postImages = <PostImages>[];
      json['post_images'].forEach((v) {
        postImages!.add(new PostImages.fromJson(v));
      });
    }
    if (json['posts_likes'] != null) {
      postsLikes = <PostsLikes>[];
      json['posts_likes'].forEach((v) {
        postsLikes!.add(new PostsLikes.fromJson(v));
      });
    }
    if (json['posts_activities'] != null) {
      postsActivities = <PostsActivities>[];
      json['posts_activities'].forEach((v) {
        postsActivities!.add(new PostsActivities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_type'] = this.postType;
    data['title'] = this.title;
    data['activities'] = this.activities;
    data['schedule'] = this.schedule;
    data['location'] = this.location;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['transport_type'] = this.transportType;
    data['accessibility'] = this.accessibility;
    data['max_people'] = this.maxPeople;
    data['min_people'] = this.minPeople;
    data['starting_time'] = this.startingTime;
    data['duration'] = this.duration;
    data['meeting_point'] = this.meetingPoint;
    data['drop_off_point'] = this.dropOffPoint;
    data['price'] = this.price;
    data['hero_image'] = this.heroImage;
    data['description'] = this.description;
    data['overview'] = this.overview;
    data['createdAt'] = this.createdAt;
    data['longitude'] = this.longitude;
    data['rating'] = this.rating;
    data['latitude'] = this.latitude;
    data['likesCount'] = this.likesCount;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.postImages != null) {
      data['post_images'] = this.postImages!.map((v) => v.toJson()).toList();
    }
    if (this.postsLikes != null) {
      data['posts_likes'] = this.postsLikes!.map((v) => v.toJson()).toList();
    }
    if (this.postsActivities != null) {
      data['posts_activities'] =
          this.postsActivities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? lastName;
  String? email;
  String? avgRating;
  UserDetail? userDetail;
  List<RatingAndReviews>? ratingAndReviews;

  User(
      {this.id,
      this.name,
      this.lastName,
      this.email,
      this.avgRating,
      this.userDetail,
      this.ratingAndReviews});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['last_name'];
    email = json['email'];
    avgRating = json['avgRating'];
    userDetail = json['user_detail'] != null
        ? new UserDetail.fromJson(json['user_detail'])
        : null;
    if (json['rating_and_reviews'] != null) {
      ratingAndReviews = <RatingAndReviews>[];
      json['rating_and_reviews'].forEach((v) {
        ratingAndReviews!.add(new RatingAndReviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['avgRating'] = this.avgRating;
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.toJson();
    }
    if (this.ratingAndReviews != null) {
      data['rating_and_reviews'] =
          this.ratingAndReviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDetail {
  String? profilePicture;
  int? price;
  String? preferredCurrency;
  String? bio;
  String? coverPicture;

  UserDetail(
      {this.profilePicture,
      this.price,
      this.preferredCurrency,
      this.bio,
      this.coverPicture});

  UserDetail.fromJson(Map<String, dynamic> json) {
    profilePicture = json['profile_picture'];
    price = json['price'];
    preferredCurrency = json['preferred_currency'];
    bio = json['bio'];
    coverPicture = json['cover_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_picture'] = this.profilePicture;
    data['price'] = this.price;
    data['preferred_currency'] = this.preferredCurrency;
    data['bio'] = this.bio;
    data['cover_picture'] = this.coverPicture;
    return data;
  }
}

class RatingAndReviews {
  String? userName;
  String? userEmail;
  int? ratings;
  String? reviewMessage;
  int? status;

  RatingAndReviews(
      {this.userName,
      this.userEmail,
      this.ratings,
      this.reviewMessage,
      this.status});

  RatingAndReviews.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userEmail = json['user_email'];
    ratings = json['ratings'];
    reviewMessage = json['review_message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['ratings'] = this.ratings;
    data['review_message'] = this.reviewMessage;
    data['status'] = this.status;
    return data;
  }
}

class PostImages {
  int? id;
  String? url;

  PostImages({this.id, this.url});

  PostImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

class PostsLikes {
  int? id;
  User? user;

  PostsLikes({this.id, this.user});

  PostsLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class PostsActivities {
  int? id;

  PostsActivities({this.id});

  PostsActivities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
