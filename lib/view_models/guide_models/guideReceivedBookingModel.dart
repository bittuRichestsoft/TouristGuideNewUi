import 'dart:convert';

import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/response_pojo/guideReceivedBookingResponse.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../api_requests/guideReceivedBooking.dart';
import '../../app_constants/app_strings.dart';
import '../../main.dart';
import '../../view/all_dialogs/api_success_dialog.dart';

class GuideReceivedBookingModel extends BaseViewModel {
  String? itineraryRe;
  GuideReceivedBookingModel(viewContext, itineraryRequired) {
    itineraryRe = itineraryRequired;
    if (itineraryRequired == "yes") {
      getMyBookings(viewContext, pageNo, "", [], itineraryRequired, "", "", "");
    } else if (itineraryRequired == "bookingHistory") {
      getMyBookings(
          viewContext, pageNo, "", [1, 2, 3, 4, 5, 6, 7, 8, 9], "", "", "", "");
    } else {
      getMyBookings(viewContext, pageNo, "", [0], "", "", "", "");
    }
  }
  ScrollController scrollController = ScrollController();

  final GuideReceivedBookingRequest _guideReceivedBookingRequest =
      GuideReceivedBookingRequest();
  BuildContext? viewContext;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController advanceAmount = TextEditingController();
  TextEditingController finalPayment = TextEditingController();
  TextEditingController createItinerary = TextEditingController();
  final HtmlEditorController htmlEditorController = HtmlEditorController();
  GuideReceivedBookingResponse? guideReceivedBookingResponse;
  List<Rows> guideReceivedBookingList = [];
  int pageNo = 1;
  int lastPage = 1;
  int filterselectedValue = 1;
  int selectRating = 0;
  bool isEmtyViewForBooking = false;
  bool isSearchRunnig = false;
  bool isFilter = false;
  final counterNotifier = ValueNotifier<int>(0);
  bool issubmitButtonEnable = false;
  final counterNotifier1 = ValueNotifier<int>(0);
  bool isCancelButtonEnable = true;
  TextEditingController cancelReasonController = TextEditingController();

  void getMyBookingsFilter(val) {
    isFilter = true;
    if (filterselectedValue == 1) {
      // all bookings
      var filter = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      getMyBookings(viewContext, pageNo, "", filter, "", "", "",
          "&completed_booking=[0,1]");
    } else if (filterselectedValue == 2) {
      // ongoing bookings
      var filter = [2, 4, 6, 8];
      getMyBookings(viewContext, pageNo, "", filter, "", "", "",
          "&completed_booking=[0]");
    } else if (filterselectedValue == 3) {
      // completed bookings
      var filter = [4];
      getMyBookings(viewContext, pageNo, "", filter, "", "", "",
          "&completed_booking=[1]");
    } else {
      // cancelled bookings
      var filter = [1, 3, 5, 7, 9];
      getMyBookings(viewContext, pageNo, "", filter, "", "", "",
          "&completed_booking=[0]");
    }
  }

  Future<void> pullRefresh() async {
    isFilter = false;
    debugPrint("_pullRefresh_pullRefresh");
    guideReceivedBookingList = [];
    if (itineraryRe == "yes") {
      getMyBookings(viewContext, 1, "", [], itineraryRe, "", "", "");
    } else if (itineraryRe == "bookingHistory") {
      getMyBookings(
          viewContext, 1, "", [1, 2, 3, 4, 5, 6, 7, 8, 9], "", "", "", "");
    } else {
      getMyBookings(viewContext, 1, "", [0], "", "", "", "");
    }
  }

  void getMyBookings(viewContext, int pageNo, searchVal, bookingStatus,
      itineraryRequired, startDate, endDate, String completedStatus) async {
    if (pageNo <= lastPage) {
      if (searchVal != "" || isFilter == true) {
        isSearchRunnig = true;
      }
      setBusy(true);
      notifyListeners();
      if (await GlobalUtility.isConnected()) {
        Response apiResponse =
            await _guideReceivedBookingRequest.guideReceivedBooking(
                pageNo: pageNo.toString(),
                number_of_rows: "10",
                searchTerm: searchVal.toString(),
                booking_status: bookingStatus,
                bookingItinerary: itineraryRequired,
                start_date: startDate,
                end_date: endDate,
                completedbooking: completedStatus);

        Map jsonData = jsonDecode(apiResponse.body);
        var statusCode = jsonData['statusCode'];
        var message = jsonData['message'];
        Map checkData = jsonData['data'];
        isSearchRunnig = false;
        isFilter = false;
        notifyListeners();
        if (statusCode == 200 && checkData.isEmpty == false) {
          setBusy(false);
          isEmtyViewForBooking = false;
          notifyListeners();
          guideReceivedBookingResponse =
              guideReceivedBookingResponseFromJson(apiResponse.body);

          if (pageNo == 1) {
            debugPrint(
                "getMyBookingsBookingsgetMyBookingsguiiiiide.body---- ${guideReceivedBookingResponse!.data!.rows!.length},,,,,,,$pageNo");
            lastPage =
                (guideReceivedBookingResponse!.data!.count! / 10).round();
            lastPage = lastPage + 1;
            guideReceivedBookingList = [];
            guideReceivedBookingList =
                guideReceivedBookingResponse!.data!.rows!;
            if (guideReceivedBookingList.isNotEmpty) {
              if (scrollController.positions.isNotEmpty) {
                scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: const Duration(seconds: 1),
                    curve: Curves.linear);
              }
            }
            notifyListeners();
          } else {
            guideReceivedBookingList = [
              ...guideReceivedBookingList,
              ...guideReceivedBookingResponse!.data!.rows!
            ];
            if (scrollController.positions.isNotEmpty) {
              scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.linear);
              notifyListeners();
            }
          }
        } else if (statusCode == 400) {
          setBusy(false);
          isEmtyViewForBooking = false;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (statusCode == 200 && checkData.isEmpty) {
          setBusy(false);
          isEmtyViewForBooking = true;
          guideReceivedBookingList = [];
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (statusCode == 401) {
          setBusy(false);
          isEmtyViewForBooking = false;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
          GlobalUtility().handleSessionExpire(viewContext);
        }
      } else {
        GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
      }
    }
  }

  void guideCancelTrip(viewContext, bookingId) async {
    setBusy(true);
    notifyListeners();
    counterNotifier1.value++;
    if (await GlobalUtility.isConnected()) {
      debugPrint("bookingIdbookingIdbookingId$bookingId");
      Response apiResponse = await _guideReceivedBookingRequest.guideCanceTrip(
        context: viewContext,
        booking_id: bookingId.toString(),
        description: cancelReasonController.text,
      );
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Map checkData = jsonData['data'];
      debugPrint("checkDatacheckDatacheckData.body---- ${checkData.isEmpty}");

      if (status == 200 && checkData.isEmpty == false) {
        setBusy(false);
        notifyListeners();
        counterNotifier1.value++;
        GlobalUtility.showToast(viewContext, message);
        //Navigator.pushReplacementNamed(viewContext, AppRoutes.touristGuideHome);
        Navigator.pushNamedAndRemoveUntil(
            viewContext, AppRoutes.touristGuideHome1, (route) => false);
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
      } else if (status == 200 && checkData.isEmpty) {
        setBusy(false);
        notifyListeners();
        counterNotifier1.value++;
        GlobalUtility.showToast(viewContext, message);
        Navigator.pushNamedAndRemoveUntil(
            viewContext, AppRoutes.touristGuideHome1, (route) => false);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void guideCreateItinerary(viewContext, bookingId) async {
    String? ckEidtorText = await htmlEditorController.getText();

    setBusy(true);
    notifyListeners();
    counterNotifier.value++;
    if (await GlobalUtility.isConnected()) {
      Response apiResponse =
          await _guideReceivedBookingRequest.guideCreateItinerary(
        context: viewContext,
        booking_id: bookingId.toString(),
        title: nameController.text,
        advance_price: advanceAmount.text,
        currency: "USD",
        finalPay: finalPayment.text,
        //itinerary_text: createItinerary.text,
        itinerary_text: ckEidtorText,
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
        Navigator.pushNamedAndRemoveUntil(
            viewContext, AppRoutes.touristGuideHome1, (route) => false);
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
        Navigator.pushNamedAndRemoveUntil(
            viewContext, AppRoutes.touristGuideHome1, (route) => false);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  Future<void> acceptBookingAPI({required String bookingId}) async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      GlobalUtility().showLoaderDialog(context);
      if (await GlobalUtility.isConnected()) {
        Map map = {"booking_id": bookingId};

        final apiResponse = await ApiRequest()
            .putWithMap(map, Api.acceptBooking)
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
