// ignore_for_file: override_on_non_overriding_member, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/response_pojo/guideItineraryDetailResponse.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../api_requests/guideItineraryDetailRequest.dart';
import '../../app_constants/app_strings.dart';
import '../../view/all_dialogs/api_success_dialog.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class GuideItineraryDetailModel extends BaseViewModel {
  //String? guideId;
  GuideItineraryDetailModel(viewContext, bookId) {
    bookedId = bookId;
    getGuideItineraryDetail(viewContext, bookId);
  }
  int? bookedId;
  final GuideItineraryDetailRequest _guideItineraryDetailRequest =
      GuideItineraryDetailRequest();
  BuildContext? viewContext;
  GuideItineraryDetailResponse? guideItineraryDetailResponse;
  List<BookingTrackHistory>? bookingTrackHistories = [];
  String? dropDownValue = "Ongoing";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController advanceAmount = TextEditingController();
  TextEditingController finalPayment = TextEditingController();
  TextEditingController createItinerary = TextEditingController();
  final HtmlEditorController htmlEditorController = HtmlEditorController();
  final counterNotifier = ValueNotifier<int>(0);
  bool issubmitButtonEnable = false;
  final counterNotifier1 = ValueNotifier<int>(0);
  bool isCancelButtonEnable = true;
  bool isCompletedBooking = false;
  TextEditingController cancelReasonController = TextEditingController();

  String noteDate = "";

  calculateDate() {
    String dateRange =
        guideItineraryDetailResponse!.data.dateDetails.toString();
    List<String> dateParts = dateRange.split(' - ');
    String startDateString =
        dateParts[0].replaceAll(RegExp(r'(st|nd|rd|th)'), '');

    //----
    DateFormat format = DateFormat("d MMM, y");
    DateFormat format2 = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ");
    DateTime paymentDate =
        format2.parse(guideItineraryDetailResponse!.data.finalPaymentDate);

    DateTime startDate = format.parse(startDateString);
    //---

    DateTime futureDate = paymentDate.add(const Duration(days: 30));

    if (startDate.isBefore(futureDate)) {
      DateFormat format = DateFormat("yyyy-MM-dd");
      String dateString = format.format(startDate);
      noteDate = dateString;
      debugPrint("SHOW DATE START :-- $noteDate");
    } else {
      DateFormat format = DateFormat("yyyy-MM-dd");
      String dateString = format.format(futureDate);
      noteDate = dateString;
      debugPrint("SHOW DATE PAYMENT :-- $noteDate");
    }
  }

  void getGuideItineraryDetail(viewContext, bookingId) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _guideItineraryDetailRequest
          .getGuideItineraryDetail(bookingId: bookingId.toString());

      log("getGuideItinerary Detail getGuideItineraryDetail---- ${apiResponse.body}");

      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        notifyListeners();
        guideItineraryDetailResponse =
            guideItineraryDetailResponseFromJson(apiResponse.body);
        bookingTrackHistories =
            guideItineraryDetailResponse!.data.bookingTrackHistories;
        if (guideItineraryDetailResponse!.data.finalPaymentDate != "") {
          calculateDate();
        }

        if (guideItineraryDetailResponse?.data.status == 1 ||
            guideItineraryDetailResponse?.data.status == 3 ||
            guideItineraryDetailResponse?.data.status == 5 ||
            guideItineraryDetailResponse?.data.status == 7 ||
            guideItineraryDetailResponse?.data.status == 9) {
          dropDownValue = "Cancelled";
          notifyListeners();
        } else if (guideItineraryDetailResponse?.data.status == 4 &&
            guideItineraryDetailResponse?.data.isComplete == 0) {
          dropDownValue = "Ongoing";
          notifyListeners();
        } else if (guideItineraryDetailResponse?.data.status == 4 &&
            guideItineraryDetailResponse?.data.isComplete == 1) {
          dropDownValue = "Completed";
          notifyListeners();
        } else if (guideItineraryDetailResponse?.data.status == 1 &&
            guideItineraryDetailResponse?.data.isComplete == 0) {
          dropDownValue = "Cancelled";
          notifyListeners();
        } else if (guideItineraryDetailResponse?.data.status == 0 ||
            guideItineraryDetailResponse?.data.status == 2 ||
            guideItineraryDetailResponse?.data.status == 6 ||
            guideItineraryDetailResponse?.data.status == 8) {
          dropDownValue = "Ongoing";
          notifyListeners();
        } else if (guideItineraryDetailResponse?.data.finalPaid == 0 &&
            guideItineraryDetailResponse?.data.isComplete == 0 &&
            guideItineraryDetailResponse?.data.initialPaid != 0) {
          dropDownValue = "Payment Processed";
          notifyListeners();
        } else {
          dropDownValue = "Completed";
          notifyListeners();
        }
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

  void guideEditItinerary(viewContext, bookingId) async {
    String? ckEditorText = await htmlEditorController.getText();
    setBusy(true);
    notifyListeners();
    counterNotifier.value++;
    if (await GlobalUtility.isConnected()) {
      Response apiResponse =
          await _guideItineraryDetailRequest.guideEditItinerary(
        context: viewContext,
        bookingId: bookingId.toString(),
        title: nameController.text,
        advancePrice: advanceAmount.text,
        finalPrice: finalPayment.text,
        currency: "USD",
        itineraryText: ckEditorText,
      );
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Map checkData = jsonData['data'];
      if (status == 200 && checkData.isEmpty == false) {
        setBusy(false);
        notifyListeners();
        counterNotifier.value++;
        GlobalUtility.showToast(viewContext, message);
        Navigator.pop(viewContext);
      } else if (status == 400) {
        setBusy(false);
        notifyListeners();
        counterNotifier.value++;
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        notifyListeners();
        counterNotifier.value++;
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      } else if (status == 200 && checkData.isEmpty) {
        setBusy(false);
        notifyListeners();
        counterNotifier.value++;
        GlobalUtility.showToast(viewContext, message);
        getGuideItineraryDetail(viewContext, bookingId);
        Navigator.pop(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void guideRejectItinerary(viewContext) async {
    setBusy(true);
    notifyListeners();
    counterNotifier1.value++;
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _guideItineraryDetailRequest.rejectItinerary(
          context: viewContext,
          bookingId: bookedId.toString(),
          description: "guide cancel itinerary");

      debugPrint(
          "guideRejectItineraryguideRejectItinerary---- ${apiResponse.body}");

      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Map checkData = jsonData['data'];

      if (status == 200 && checkData.isEmpty == false) {
        setBusy(false);
        dropDownValue = "Cancelled";
        notifyListeners();
        counterNotifier1.value++;
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
      } else if (status == 200 && checkData.isEmpty == true) {
        setBusy(false);
        notifyListeners();
        counterNotifier1.value++;
        GlobalUtility.showToast(viewContext, message);
        Navigator.pushReplacementNamed(
            viewContext, AppRoutes.touristGuideHome1);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void paymentProceedApi(BuildContext viewContext, int bookingId) async {
    setBusy(true);
    if (await GlobalUtility.isConnected()) {
      Response apiResponse =
          await _guideItineraryDetailRequest.guidePaymentProceed(
        bookingId: bookingId.toString(),
      );

      Map jsonData = jsonDecode(apiResponse.body);
      debugPrint(
          "PAYMENT PROCEED ---- ${apiResponse.body} \n MAp --- $bookingId");
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (status == 200) {
        dropDownValue = "Payment Processed";
        getGuideItineraryDetail(viewContext, bookingId);
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

  void completeBookingApi(BuildContext viewContext, int bookingId) async {
    setBusy(true);
    if (await GlobalUtility.isConnected()) {
      Response apiResponse =
          await _guideItineraryDetailRequest.guideCompleteBooking(
        bookingId: bookingId.toString(),
      );

      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (status == 200) {
        isCompletedBooking = true;
        dropDownValue = "Completed";
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
