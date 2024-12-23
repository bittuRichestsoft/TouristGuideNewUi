// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:Siesta/response_pojo/get_gallery_post_response.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../app_constants/app_strings.dart';
import '../../app_constants/shared_preferences.dart';
import '../../main.dart';
import '../../utility/globalUtility.dart';

enum Status { error, loading, initialised }

class GuideGalleryModel extends BaseViewModel implements Initialisable {
  List<Rows> galleryPostList = [];

  int pageNo = 1;
  int totalGalleryPost = 0;
  late var scrollController;
  bool isLoadMore = false;

  Status _status = Status.loading;
  Status get status => _status;

  String errorMsg = "Some error occurred";

  @override
  void initialise() async {
    scrollController = ScrollController()..addListener(pagination);
    getGalleryPosts();
  }

  void pagination() {
    if ((scrollController.position.maxScrollExtent ==
        scrollController.offset)) {
      if (totalGalleryPost > galleryPostList.length) {
        isLoadMore = true;
        pageNo++;
        notifyListeners();
        getGalleryPosts();
      }
    }
  }

  Future<void> getGalleryPosts() async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        String userId = prefs.getString(SharedPreferenceValues.id) ?? "0";

        if (pageNo == 1) {
          _status = Status.loading;
          notifyListeners();
        }
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getGalleryPosts +
                "?id=$userId&page_no=$pageNo&number_of_rows=5&user_id=$userId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        _status = Status.initialised;

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          GetGalleryPostResponse getGalleryPostResponse =
              getGalleryPostRespFromJson(apiResponse.body);

          totalGalleryPost = getGalleryPostResponse.data!.totalCounts ?? 0;

          if (pageNo == 1) {
            galleryPostList = getGalleryPostResponse.data!.rows!;
          } else {
            galleryPostList.addAll(getGalleryPostResponse.data!.rows!);
          }
        } else if (status == 400) {
          _status = Status.error;
          errorMsg = "Some error occurred";
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          _status = Status.error;
          errorMsg = "Un authentication";
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        _status = Status.error;
        errorMsg = AppStrings().INTERNET;
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      _status = Status.error;
      errorMsg = AppStrings.someErrorOccurred;
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
    }
  }
}
