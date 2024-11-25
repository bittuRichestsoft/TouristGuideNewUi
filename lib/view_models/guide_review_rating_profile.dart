import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../api_requests/guideUpdateProfileRequest.dart';
import '../app_constants/app_strings.dart';
import '../response_pojo/guide_ratings_review_pojo.dart';
import '../utility/globalUtility.dart';

class GuideProfileReviewRating extends BaseViewModel {
  GuideProfileReviewRating(viewContext, int page) {
    getGuideReviewDetails(viewContext, page);
  }
  List<RatingReviewList> ratingReviewList = [];
  int pageCount = 1;
  int total = 0;
  ScrollController pageSC = ScrollController();
  void getGuideReviewDetails(viewContext, int page) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await GuideUpdateProfileRequest()
          .getRatingAndReviews(pageNo: page, numberOfRows: 10);
      debugPrint("Get Rating Review RESPONSE---- ${apiResponse.body}");
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        RatingReviewPojo ratingReviewPojo =
            ratingReviewPojoFromJson(apiResponse.body);

        total = ratingReviewPojo.data!.count!;
        if (pageCount == 1) {
          ratingReviewList = [];
          ratingReviewList = ratingReviewPojo.data!.rows!;
        } else {
          ratingReviewList.addAll(ratingReviewPojo.data!.rows!);
          pageSC.animateTo(pageSC.position.maxScrollExtent,
              duration: const Duration(seconds: 1), curve: Curves.linear);
        }
        notifyListeners();

        setBusy(false);
      } else if (status == 400) {
        setBusy(false);
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }
}
