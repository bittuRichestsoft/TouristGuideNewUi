import 'dart:convert';

GetPostDetailResponse getPostDetailRespFromJson(String str) =>
    GetPostDetailResponse.fromJson(json.decode(str));

String getPostDetailRespToJson(GetPostDetailResponse data) =>
    json.encode(data.toJson());

class GetPostDetailResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  GetPostDetailResponse(
      {this.success, this.statusCode, this.data, this.message});

  GetPostDetailResponse.fromJson(Map<String, dynamic> json) {
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
  PostDetails? postDetails;
  SimilarPosts? similarPosts;

  Data({this.postDetails, this.similarPosts});

  Data.fromJson(Map<String, dynamic> json) {
    postDetails = json['postDetails'] != null
        ? new PostDetails.fromJson(json['postDetails'])
        : null;
    similarPosts = json['similarPosts'] != null
        ? new SimilarPosts.fromJson(json['similarPosts'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postDetails != null) {
      data['postDetails'] = this.postDetails!.toJson();
    }
    if (this.similarPosts != null) {
      data['similarPosts'] = this.similarPosts!.toJson();
    }
    return data;
  }
}

class PostDetails {
  int? id;
  String? postType;
  String? title;
  dynamic activities;
  String? schedule;
  String? transportType;
  bool? accessibility;
  int? maxPeople;
  int? minPeople;
  String? location;
  String? startingTime;
  String? duration;
  String? meetingPoint;
  String? dropOffPoint;
  int? price;
  String? heroImage;
  String? description;
  String? country;
  String? state;
  String? city;
  dynamic overview;
  String? createdAt;
  int? likesCount;
  User? user;
  List<PostImages>? postImages;
  List<PostsLikes>? postsLikes;
  List<PostsActivities>? postsActivities;

  PostDetails(
      {this.id,
      this.postType,
      this.title,
      this.activities,
      this.schedule,
      this.transportType,
      this.accessibility,
      this.maxPeople,
      this.minPeople,
      this.location,
      this.startingTime,
      this.duration,
      this.meetingPoint,
      this.dropOffPoint,
      this.price,
      this.heroImage,
      this.description,
      this.country,
      this.state,
      this.city,
      this.overview,
      this.createdAt,
      this.likesCount,
      this.user,
      this.postImages,
      this.postsLikes,
      this.postsActivities});

  PostDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['post_type'];
    title = json['title'];
    activities = json['activities'];
    schedule = json['schedule'];
    transportType = json['transport_type'];
    accessibility = json['accessibility'];
    maxPeople = json['max_people'];
    minPeople = json['min_people'];
    location = json['location'];
    startingTime = json['starting_time'];
    duration = json['duration'];
    meetingPoint = json['meeting_point'];
    dropOffPoint = json['drop_off_point'];
    price = json['price'];
    heroImage = json['hero_image'];
    description = json['description'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    overview = json['overview'];
    createdAt = json['createdAt'];
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
    data['transport_type'] = this.transportType;
    data['accessibility'] = this.accessibility;
    data['max_people'] = this.maxPeople;
    data['min_people'] = this.minPeople;
    data['location'] = this.location;
    data['starting_time'] = this.startingTime;
    data['duration'] = this.duration;
    data['meeting_point'] = this.meetingPoint;
    data['drop_off_point'] = this.dropOffPoint;
    data['price'] = this.price;
    data['hero_image'] = this.heroImage;
    data['description'] = this.description;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['overview'] = this.overview;
    data['createdAt'] = this.createdAt;
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
  dynamic avgRating;
  UserDetail? userDetail;
  List<dynamic>? ratingAndReviews;

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
    /*if (json['rating_and_reviews'] != null) {
      ratingAndReviews = <Null>[];
      json['rating_and_reviews'].forEach((v) {
        ratingAndReviews!.add(new .fromJson(v));
      });
    }*/
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
  String? hostSinceYears;
  String? hostSinceMonths;

  UserDetail(
      {this.profilePicture,
      this.price,
      this.preferredCurrency,
      this.bio,
      this.coverPicture,
      this.hostSinceYears,
      this.hostSinceMonths});

  UserDetail.fromJson(Map<String, dynamic> json) {
    profilePicture = json['profile_picture'];
    price = json['price'];
    preferredCurrency = json['preferred_currency'];
    bio = json['bio'];
    coverPicture = json['cover_picture'];
    hostSinceYears = json['host_since_years'];
    hostSinceMonths = json['host_since_months'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_picture'] = this.profilePicture;
    data['price'] = this.price;
    data['preferred_currency'] = this.preferredCurrency;
    data['bio'] = this.bio;
    data['cover_picture'] = this.coverPicture;
    data['host_since_years'] = this.hostSinceYears;
    data['host_since_months'] = this.hostSinceMonths;
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

class PostsActivities {
  int? id;
  Activity? activity;

  PostsActivities({this.id, this.activity});

  PostsActivities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activity = json['activity'] != null
        ? new Activity.fromJson(json['activity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.activity != null) {
      data['activity'] = this.activity!.toJson();
    }
    return data;
  }
}

class Activity {
  int? id;
  String? title;

  Activity({this.id, this.title});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class SimilarPosts {
  int? count;
  List<Rows>? rows;

  SimilarPosts({this.count, this.rows});

  SimilarPosts.fromJson(Map<String, dynamic> json) {
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
  String? activities;
  String? schedule;
  String? transportType;
  bool? accessibility;
  int? maxPeople;
  int? minPeople;
  String? startingTime;
  String? duration;
  String? meetingPoint;
  String? dropOffPoint;
  int? price;
  String? location;
  String? heroImage;
  String? description;
  String? country;
  String? state;
  String? city;
  dynamic overview;
  String? createdAt;
  int? likesCount;
  User? user;
  List<PostImages>? postImages;
  List<PostsLikes>? postsLikes;

  Rows(
      {this.id,
      this.postType,
      this.title,
      this.activities,
      this.schedule,
      this.transportType,
      this.accessibility,
      this.maxPeople,
      this.minPeople,
      this.startingTime,
      this.duration,
      this.meetingPoint,
      this.dropOffPoint,
      this.price,
      this.location,
      this.heroImage,
      this.description,
      this.country,
      this.state,
      this.city,
      this.overview,
      this.createdAt,
      this.likesCount,
      this.user,
      this.postImages,
      this.postsLikes});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['post_type'];
    title = json['title'];
    activities = json['activities'];
    schedule = json['schedule'];
    transportType = json['transport_type'];
    accessibility = json['accessibility'];
    maxPeople = json['max_people'];
    minPeople = json['min_people'];
    startingTime = json['starting_time'];
    duration = json['duration'];
    meetingPoint = json['meeting_point'];
    dropOffPoint = json['drop_off_point'];
    price = json['price'];
    location = json['location'];
    heroImage = json['hero_image'];
    description = json['description'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    overview = json['overview'];
    createdAt = json['createdAt'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_type'] = this.postType;
    data['title'] = this.title;
    data['activities'] = this.activities;
    data['schedule'] = this.schedule;
    data['transport_type'] = this.transportType;
    data['accessibility'] = this.accessibility;
    data['max_people'] = this.maxPeople;
    data['min_people'] = this.minPeople;
    data['starting_time'] = this.startingTime;
    data['duration'] = this.duration;
    data['meeting_point'] = this.meetingPoint;
    data['drop_off_point'] = this.dropOffPoint;
    data['price'] = this.price;
    data['location'] = this.location;
    data['hero_image'] = this.heroImage;
    data['description'] = this.description;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['overview'] = this.overview;
    data['createdAt'] = this.createdAt;
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
    return data;
  }
}
