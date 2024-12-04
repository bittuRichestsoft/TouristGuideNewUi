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

class TouristProfileModel extends BaseViewModel implements Initialisable {
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

  @override
  void initialise() {
    getProfileAPI();
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
      if (await GlobalUtility.isConnected()) {
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.guideGetProfile)
            .timeout(const Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
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
      notifyListeners();
    }
  }

  Future<void> getGalleryPosts() async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        String userId = prefs.getString(SharedPreferenceValues.id) ?? "0";

        GlobalUtility().showLoaderDialog(context);
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getGalleryPosts +
                "?id=$userId&page_no=1&number_of_rows=3&user_id=$userId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        GlobalUtility().closeLoaderDialog(context);

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

        GlobalUtility().showLoaderDialog(context);
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getGeneralPosts +
                "?page_no=1&number_of_rows=1&id=$userId&user_id=$userId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        GlobalUtility().closeLoaderDialog(context);

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

        GlobalUtility().showLoaderDialog(context);
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getExperiencePosts +
                "?page_no=1&number_of_rows=3&id=$userId&user_id=$userId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        GlobalUtility().closeLoaderDialog(context);

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
}
