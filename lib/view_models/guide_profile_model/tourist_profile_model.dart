import 'dart:convert';

import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../app_constants/app_strings.dart';
import '../../main.dart';
import '../../response_pojo/get_gallery_post_response.dart';
import '../../utility/globalUtility.dart';

class TouristProfileModel extends BaseViewModel implements Initialisable {
  List<Rows> galleryPostList = [];

  @override
  void initialise() {}

  Future<void> getGalleryPosts() async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        int userId = prefs.getInt(SharedPreferenceValues.guideId) ?? 0;

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
          GetGalleryPostResponse getGalleryPostResponse =
              getGalleryPostRespFromJson(apiResponse.body);

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
}
