import 'dart:convert';

import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/response_pojo/get_experience_post_response.dart'
    as exp_resp;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../app_constants/app_strings.dart';
import '../../main.dart';
import '../../response_pojo/get_gallery_post_response.dart' as gallery_resp;
import '../../response_pojo/get_guide_profile_response.dart';
import '../../utility/globalUtility.dart';

enum Status { error, loading, initialised }

class PreviewProfileModel extends BaseViewModel implements Initialisable {
  final Map<String, dynamic> argData;
  PreviewProfileModel({required this.argData});

  List<gallery_resp.Rows> galleryPostList = [];
  List<exp_resp.Rows> experiencePostList = [];
  List<exp_resp.Rows> generalPostList = [];

  String? coverImageUrl;
  String? profileImageUrl;
  String? nameText;
  String? bioText;
  String? hostSinceYear;
  String? hostSinceMonth;
  String? avgRating;
  String? profileUrl;
  bool isFollowed = false;

  bool? isMe;
  String? guideId;

  Status _status = Status.loading;
  Status get status => _status;

  String errorMsg = "Some error occurred";

  @override
  void initialise() {
    isMe = argData["userId"] == prefs.getString(SharedPreferenceValues.id);
    guideId = argData["userId"];

    debugPrint("Is me: $isMe   ${argData["userId"]}");

    if (isMe == true) {
      getProfileAPI();
    } else {
      getGuideProfileAPI();
    }

    getGalleryPosts();
    getGeneralPosts();
    getExperiencePosts();
  }

  int calculateYear({required String y, required String m}) {
    int years = int.parse(y);
    int months = int.parse(m);
    // Get the current date
    DateTime now = DateTime.now();

    // Subtract the years and months
    DateTime updatedDate =
        DateTime(now.year - years, now.month - months, now.day);

    // Return the year
    return updatedDate.year;
  }

  Future<void> getProfileAPI() async {
    BuildContext context = navigatorKey.currentContext!;

    try {
      // GlobalUtility().showLoaderDialog(navigatorKey.currentContext!);
      if (await GlobalUtility.isConnected()) {
        _status = Status.loading;
        notifyListeners();

        final apiResponse = await ApiRequest()
            .getWithHeader(Api.guideGetProfile)
            .timeout(const Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          _status = Status.initialised;
          GetGuideProfileResponse getGuideProfileResponse =
              getGuideProfileResponseFromJson(apiResponse.body);

          coverImageUrl = getGuideProfileResponse
              .data!.guideDetails!.userDetail!.coverPicture;
          profileImageUrl = getGuideProfileResponse
              .data!.guideDetails!.userDetail!.profilePicture;
          nameText =
              "${getGuideProfileResponse.data!.guideDetails!.name ?? ""} ${getGuideProfileResponse.data!.guideDetails!.lastName ?? ""}";
          bioText = getGuideProfileResponse.data!.guideDetails!.userDetail!.bio;
          hostSinceYear = getGuideProfileResponse
              .data!.guideDetails!.userDetail!.hostSinceYears;
          hostSinceMonth = getGuideProfileResponse
              .data!.guideDetails!.userDetail!.hostSinceMonths;
          avgRating = getGuideProfileResponse.data!.avgRatings ?? "0";
          profileUrl = getGuideProfileResponse.data!.url ?? "";
        } else if (status == 400) {
          errorMsg = "Some error occurred";
          _status = Status.error;
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          errorMsg = "Session Expired";
          _status = Status.error;
          GlobalUtility().handleSessionExpire(context);
        } else {
          errorMsg = "Some error occurred";
          _status = Status.error;
        }
      } else {
        _status = Status.error;
        errorMsg = AppStrings().INTERNET;
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      _status = Status.error;
      debugPrint("$runtimeType error : $e");
      errorMsg = "Some error occurred";
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      // GlobalUtility().closeLoaderDialog(context);
      notifyListeners();
    }
  }

  Future<void> getGuideProfileAPI() async {
    BuildContext context = navigatorKey.currentContext!;

    try {
      // GlobalUtility().showLoaderDialog(navigatorKey.currentContext!);
      if (await GlobalUtility.isConnected()) {
        _status = Status.loading;
        notifyListeners();

        String myId = prefs.getString(SharedPreferenceValues.id) ?? "";

        final apiResponse = await ApiRequest()
            .getWithHeader(
                "${Api.getOtherGuideProfile}?guideId=$guideId&userId=$myId")
            .timeout(const Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          _status = Status.initialised;

          GetGuideProfileResponse getGuideProfileResponse =
              getGuideProfileResponseFromJson(apiResponse.body);

          coverImageUrl = getGuideProfileResponse
              .data?.guideDetails?.userDetail?.coverPicture;
          profileImageUrl = getGuideProfileResponse
              .data?.guideDetails?.userDetail?.profilePicture;
          nameText =
              "${getGuideProfileResponse.data?.guideDetails?.name ?? ""} ${getGuideProfileResponse.data!.guideDetails!.lastName ?? ""}";
          bioText = getGuideProfileResponse.data?.guideDetails?.userDetail?.bio;
          hostSinceYear = getGuideProfileResponse
              .data?.guideDetails?.userDetail?.hostSinceYears;
          hostSinceMonth = getGuideProfileResponse
              .data?.guideDetails?.userDetail?.hostSinceMonths;
          avgRating = getGuideProfileResponse.data?.avgRatings ?? "0";
          profileUrl = getGuideProfileResponse.data?.url ?? "";
          isFollowed = getGuideProfileResponse.data?.isFollowed ?? false;
        } else if (status == 400) {
          errorMsg = "Some error occurred";
          _status = Status.error;
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          errorMsg = "Session Expired";
          _status = Status.error;
          GlobalUtility().handleSessionExpire(context);
        } else {
          errorMsg = "Some error occurred";
          _status = Status.error;
        }
      } else {
        errorMsg = AppStrings().INTERNET;
        _status = Status.error;
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      errorMsg = "Some error occurred";
      _status = Status.error;
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      // GlobalUtility().closeLoaderDialog(context);
      notifyListeners();
    }
  }

  Future<void> getGalleryPosts() async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        String userId = prefs.getString(SharedPreferenceValues.id) ?? "0";

        // GlobalUtility().showLoaderDialog(context);
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getGalleryPosts +
                "?id=$guideId&page_no=1&number_of_rows=3&user_id=$userId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        // GlobalUtility().closeLoaderDialog(context);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          gallery_resp.GetGalleryPostResponse getGalleryPostResponse =
              gallery_resp.getGalleryPostRespFromJson(apiResponse.body);

          galleryPostList = getGalleryPostResponse.data!.rows!;
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getGeneralPosts() async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        String userId = prefs.getString(SharedPreferenceValues.id) ?? "0";

        // GlobalUtility().showLoaderDialog(context);
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getGeneralPosts +
                "?page_no=1&number_of_rows=1&id=$guideId&user_id=$userId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        // GlobalUtility().closeLoaderDialog(context);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          exp_resp.GetExperiencePostResponse getExperiencePostResponse =
              exp_resp.getExperiencePostRespFromJson(apiResponse.body);

          generalPostList = getExperiencePostResponse.data!.rows!;
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getExperiencePosts() async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        String userId = prefs.getString(SharedPreferenceValues.id) ?? "0";

        // GlobalUtility().showLoaderDialog(context);
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getExperiencePosts +
                "?page_no=1&number_of_rows=3&id=$guideId&user_id=$userId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        // GlobalUtility().closeLoaderDialog(context);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          exp_resp.GetExperiencePostResponse getExperiencePostResponse =
              exp_resp.getExperiencePostRespFromJson(apiResponse.body);

          experiencePostList = getExperiencePostResponse.data!.rows!;
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
    }
  }

  // follow guide
  Future<void> followGuideAPI() async {
    BuildContext context = navigatorKey.currentContext!;

    try {
      GlobalUtility().showLoaderDialog(navigatorKey.currentContext!);
      if (await GlobalUtility.isConnected()) {
        String myId = prefs.getString(SharedPreferenceValues.id) ?? "";

        Map map = {"follower_id": myId, "followed_id": guideId};

        final apiResponse = await ApiRequest()
            .postWithMap(map, Api.followGuide)
            .timeout(const Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          isFollowed = true;
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        } else {}
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(context);
      notifyListeners();
    }
  }

  // un follow guide
  Future<void> unFollowGuideAPI() async {
    BuildContext context = navigatorKey.currentContext!;

    try {
      GlobalUtility().showLoaderDialog(navigatorKey.currentContext!);
      if (await GlobalUtility.isConnected()) {
        String myId = prefs.getString(SharedPreferenceValues.id) ?? "";

        Map map = {"follower_id": myId, "followed_id": guideId};

        final apiResponse = await ApiRequest()
            .postWithMap(map, Api.unFollowGuide)
            .timeout(const Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          isFollowed = false;
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        } else {}
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(context);
      notifyListeners();
    }
  }
}
