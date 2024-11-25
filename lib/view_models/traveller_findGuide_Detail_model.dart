import 'dart:convert';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/response_pojo/traveller_findeguide_detail_response.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import '../api_requests/traveller_find_guide.dart';
import '../app_constants/app_strings.dart';
import '../utility/preference_util.dart';
import '../view/all_dialogs/api_success_dialog.dart';

class TravellerFindGuideDetailModel extends BaseViewModel {
  TravellerFindGuideDetailModel(viewContext, guideId) {
    gettouristGuideDetail(viewContext, guideId);
  }
  final FindGuideRequest _findGuideRequest = FindGuideRequest();
  BuildContext? viewContext;
  TravellerFindGuideDetailResponse? travellerFindGuideDetailResponse;
  List<RatingAndReview>? ratingAndReviewList = [];

  void gettouristGuideDetail(viewContext, gId) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse =
      await _findGuideRequest.guideDetail(id: gId.toString());

      debugPrint(
          "gettouristGuideDetailgettouristGuideDetail---- ${apiResponse.body}");

      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        notifyListeners();
        travellerFindGuideDetailResponse =
            travellerFindGuideDetailResponseFromJson(apiResponse.body);
        ratingAndReviewList = travellerFindGuideDetailResponse!
            .data.guideDetails!.ratingAndReviews;
        await PreferenceUtil().setGuideLocationDetails(
            travellerFindGuideDetailResponse!.data.guideDetails!.country
                .toString(),
            travellerFindGuideDetailResponse!.data.guideDetails!.state
                .toString(),
            travellerFindGuideDetailResponse!.data.guideDetails!.city
                .toString());
      } else if (status == 400) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  successDialog(String from, BuildContext context, String message) {
    GlobalUtility.showDialogFunction(
        context,
        ApiSuccessDialog(
            imagepath: AppImages().pngImages.ivRegisterVerified,
            titletext: message,
            buttonheading: AppStrings().Okay,
            isPng: true,
            fromWhere: from));
  }
}

