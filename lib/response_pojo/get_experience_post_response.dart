import 'dart:convert';

GetExperiencePostResponse getExperiencePostRespFromJson(String str) =>
    GetExperiencePostResponse.fromJson(json.decode(str));

String getExperiencePostRespToJson(GetExperiencePostResponse data) =>
    json.encode(data.toJson());

class GetExperiencePostResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GetExperiencePostResponse(
      {this.success, this.statusCode, this.data, this.message});

  GetExperiencePostResponse.fromJson(Map<String, dynamic> json) {
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
  int? totalCounts;

  Data({this.count, this.rows, this.totalCounts});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
    totalCounts = json['totalCounts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['totalCounts'] = this.totalCounts;
    return data;
  }
}

class Rows {
  int? id;
  String? postType;
  String? title;
  String? activities;
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
  int? likesCount;
  int? likedPost;
  List<PostImages>? postImages;
  List<PostsLikes>? postsLikes;

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
      this.likesCount,
      this.likedPost,
      this.postImages,
      this.postsLikes});

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
    likesCount = json['likesCount'];
    likedPost = json['likedPost'];
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
    data['likesCount'] = this.likesCount;
    data['likedPost'] = this.likedPost;
    if (this.postImages != null) {
      data['post_images'] = this.postImages!.map((v) => v.toJson()).toList();
    }
    if (this.postsLikes != null) {
      data['posts_likes'] = this.postsLikes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostImages {
  int? id;
  String? url;
  String? mediaType;

  PostImages({this.id, this.url, this.mediaType});

  PostImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['media_type'] = this.mediaType;
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

class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}
