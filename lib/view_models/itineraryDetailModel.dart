// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/response_pojo/traveller_itineraryDetail_response.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import '../api_requests/itineraryDetailRequest.dart';
import '../app_constants/app_strings.dart';
import '../view/all_dialogs/api_success_dialog.dart';
import 'package:Siesta/app_constants/app_routes.dart';

class TravellerItineraryDetailModel extends BaseViewModel {
  //String? guideId;
  TravellerItineraryDetailModel(viewContext, bookId) {
    bookedId = bookId;
    gettravellerItineraryDetail(viewContext, bookId);
  }
  int? bookedId;
  final MyItineraryDetailRequest _myItineraryDetailRequest =
      MyItineraryDetailRequest();
  BuildContext? viewContext;
  TravellerItineraryDetailResponse? travellerItineraryDetailResponse;
  List<BookingTrackHistory>? bookingTrackHistories = [];
  final counterNotifier1 = ValueNotifier<int>(0);
  bool isCancelButtonEnable = true;
  TextEditingController editQuoteController = TextEditingController();

  void gettravellerItineraryDetail(viewContext, bookingId) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _myItineraryDetailRequest.getItineraryDetail(
          booking_id: bookingId.toString());
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        notifyListeners();
        travellerItineraryDetailResponse =
            travellerItineraryDetailResponseFromJson(apiResponse.body);

        bookingTrackHistories =
            travellerItineraryDetailResponse!.data!.bookingTrackHistories;
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

  void requestForItinerary(viewContext) async {
    setBusy(true);
    notifyListeners();
    counterNotifier1.value++;
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _myItineraryDetailRequest.requestItinerary(
          context: viewContext,
          booking_id: bookedId.toString(),
          description: editQuoteController.text);

      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        editQuoteController.text = "";
        notifyListeners();
        counterNotifier1.value++;
        Navigator.pushReplacementNamed(
            viewContext, AppRoutes.travellerHomePageTab4);
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 400) {
        setBusy(false);
        notifyListeners();
        counterNotifier1.value++;
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        notifyListeners();
        counterNotifier1.value++;
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void travellerRejectItinerary(viewContext, description) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _myItineraryDetailRequest.rejectItinerary(
          context: viewContext,
          booking_id: bookedId.toString(),
          description: description);

      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
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

  void travellerAcceptItinerary(viewContext) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _myItineraryDetailRequest.acceptItinerary(
          context: viewContext, booking_id: bookedId.toString());

      debugPrint("travellerAcceptItinerary---- ${apiResponse.body}");

      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
        Navigator.pop(viewContext);
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
