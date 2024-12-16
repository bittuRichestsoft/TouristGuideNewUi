import 'dart:convert';

import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/response_pojo/custom_pojos/media_type_pojo.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../app_constants/app_strings.dart';
import '../../main.dart';
import '../../response_pojo/get_post_detail_response.dart';
import '../../utility/globalUtility.dart';

enum Status { error, loading, initialised }

class PostDetailModel extends BaseViewModel implements Initialisable {
  final String postid;
  PostDetailModel({required this.postid});

  PostDetails? postDetail;
  List<Rows> similarExperienceList = [];

  String userType = prefs.getString(SharedPreferenceValues.roleName) ?? "";

  Status _status = Status.loading;
  Status get status => _status;

  String errorMsg = "Some error occurred";

  List<MediaTypePojo> mediaList = [];

  @override
  void initialise() {
    debugPrint("Initialised");
    getPostDetailAPI(postid);
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

  Future<void> getPostDetailAPI(String postId) async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        _status = Status.loading;
        notifyListeners();

        final apiResponse = await ApiRequest()
            .getWithHeader("${Api.getPostDetail}/$postId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          _status = Status.initialised;
          GetPostDetailResponse getPostDetailResponse =
              getPostDetailRespFromJson(apiResponse.body);

          postDetail = getPostDetailResponse.data!.postDetails;

          mediaList = [MediaTypePojo(mediaUrl: postDetail!.heroImage ?? "")];
          mediaList.addAll(postDetail!.postImages!.map((e) => MediaTypePojo(
              mediaUrl: e.url ?? "",
              mediaType: e.mediaType ?? "image",
              id: e.id!)));

          if (userType == "TRAVELLER") {
            similarExperienceList =
                getPostDetailResponse.data?.similarPosts?.rows ?? [];
          }
        } else if (status == 400) {
          _status = Status.error;
          errorMsg = "Some error occurred";

          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          _status = Status.error;
          errorMsg = "Un authentication";

          GlobalUtility().handleSessionExpire(context);
        } else {
          _status = Status.error;
          errorMsg = "Some error occurred";

          GlobalUtility.showToast(context, message);
        }
      } else {
        _status = Status.error;
        errorMsg = AppStrings().INTERNET;

        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
    }
  }

  Future<void> bookExperienceAPI({
    required String localiteId,
    required String firstName,
    required String lastName,
    required String location,
    required String startDate,
    required String endDate,
    required String startTime,
    required String notes,
    required String noOfPeople,
  }) async {
    BuildContext context = navigatorKey.currentContext!;

    try {
      GlobalUtility().showLoader(context);
      if (await GlobalUtility.isConnected()) {
        Map map = {
          "traveller_id": prefs.getString(SharedPreferenceValues.id) ?? "",
          "localite_id": localiteId,
          "experience_id": postid,
          "price":
              ((postDetail?.price ?? 1) * int.parse(noOfPeople)).toString(),
          "booking_title": postDetail?.title ?? "",
          "first_name": firstName,
          "last_name": lastName,
          "location": location,
          "start_date": startDate,
          "end_date": endDate,
          "start_time": startTime,
          "notes": notes,
          "no_of_people": noOfPeople
        };

        final apiResponse = await ApiRequest()
            .postWithMap(map, Api.bookExperience)
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          GlobalUtility.showToast(context, message);
          Navigator.pop(context);
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        } else {
          GlobalUtility.showToast(context, message);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
      GlobalUtility().closeLoaderDialog(context);
    }
  }
}
