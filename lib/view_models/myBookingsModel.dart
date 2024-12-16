import 'dart:convert';

import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/response_pojo/traveller_myBooking_responde.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../api_requests/myBookingsRequest.dart';
import '../app_constants/app_color.dart';
import '../app_constants/app_fonts.dart';
import '../app_constants/app_sizes.dart';
import '../app_constants/app_strings.dart';
import '../common_widgets/common_textview.dart';
import '../common_widgets/vertical_size_box.dart';
import '../view/all_dialogs/api_success_dialog.dart';

class TravellerMyBookingsModel extends BaseViewModel {
  String? itineraryReq;

  TravellerMyBookingsModel(
      viewContext, itineraryRequired, int index, double rate) {
    itineraryReq = itineraryRequired;
    selectRating = rate.toInt();
    if (itineraryRequired == "yes") {
      getMyBookings(viewContext, 1, "", [], itineraryRequired, "", "", "");
    } else if (itineraryRequired == "noNeedToCallApi") {
    } else {
      getMyBookings(
          viewContext, 1, "", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "", "", "", "");
      getUserDetails(index);
    }
  }

  final MyBookingsRequest _myBookingsRequest = MyBookingsRequest();
  BuildContext? viewContextM;
  TextEditingController searchController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController cancelReasonController = TextEditingController();
  TravellerMyBookingsResponse? travellerMyBookingsResponse;
  List<Rows> travellerMybookingList = [];
  // int pageNo = 1;
  int lastPage = 1;
  int filterselectedValue = 1;
  int selectRating = 0;
  ScrollController scrollController = ScrollController();
  bool isEmtyViewForBooking = false;
  bool isSearchRunnig = false;
  final counterNotifier1 = ValueNotifier<int>(0);
  bool isCancelButtonEnable = true;

  String? name;
  String? email;

  getUserDetails(int index) async {
    name = travellerMyBookingsResponse!.data!.rows![index].firstName;
    email = travellerMybookingList[index].user?.email;
  }

  void getMyBookingsFilter(val, int pageNo) {
    if (filterselectedValue == 1) {
      // all bookings
      var filter = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
      getMyBookings(viewContextM, pageNo, "", filter, "", "", "", "");
    } else if (filterselectedValue == 2) {
      // upcomming bookings
      var filter = [0, 2, 6, 8];
      getMyBookings(viewContextM, pageNo, "", filter, "", "", "", "");
    } else if (filterselectedValue == 3) {
      // completed bookings
      var filter = [4];
      getMyBookings(viewContextM, pageNo, "", filter, "", "", "",
          "completed_booking=[1]");
    } else {
      // cancelled bookings
      var filter = [1, 3, 5, 7, 9];
      getMyBookings(viewContextM, pageNo, "", filter, "", "", "", "");
    }
  }

  Future<void> pullRefresh() async {
    debugPrint("_pullRefresh_pullRefresh");
    travellerMybookingList = [];
    getMyBookings(viewContextM, 1, "", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        itineraryReq, "", "", "");
  }

  void getMyBookings(viewContext, int pageNo, searchVal, bookingStatus,
      itineraryRequired, startDate, endDate, String completedStatus) async {
    if (pageNo <= lastPage) {
      setBusy(true);
      if (searchVal != "") {
        isSearchRunnig = true;
      }
      notifyListeners();
      if (await GlobalUtility.isConnected()) {
        setBusy(true);
        Response apiResponse = await _myBookingsRequest.myBooking(
            pageNo: pageNo.toString(),
            number_of_rows: "10",
            searchTerm: searchVal.toString(),
            booking_status: bookingStatus,
            bookingItinerary: itineraryRequired,
            start_date: startDate,
            end_date: endDate,
            completedStatus: completedStatus);

        debugPrint("getMyBookings RESPONSE :- ${apiResponse.body}");

        Map jsonData = jsonDecode(apiResponse.body);
        var statusCode = jsonData['statusCode'];
        var message = jsonData['message'];
        Map checkData = jsonData['data'];
        isSearchRunnig = false;
        if (statusCode == 200 && checkData.isEmpty == false) {
          setBusy(false);
          isEmtyViewForBooking = false;
          notifyListeners();
          travellerMyBookingsResponse =
              travellerMyBookingsResponseFromJson(apiResponse.body);

          if (pageNo == 1) {
            debugPrint("indeise page");
            lastPage = (travellerMyBookingsResponse!.data!.count! / 10).round();
            lastPage = lastPage + 1;
            travellerMybookingList = [];
            travellerMybookingList = travellerMyBookingsResponse!.data!.rows!;

            notifyListeners();
          } else {
            travellerMybookingList = [
              ...travellerMybookingList,
              ...travellerMyBookingsResponse!.data!.rows!
            ];
            notifyListeners();
          }
        } else if (statusCode == 400) {
          setBusy(false);
          isEmtyViewForBooking = false;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (statusCode == 200 && checkData.isEmpty) {
          setBusy(false);
          isEmtyViewForBooking = true;
          travellerMybookingList = [];
          notifyListeners();
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

  void travellerCancelTrip(viewContext, bookingId) async {
    setBusy(true);
    counterNotifier1.value++;
    try {
      if (await GlobalUtility.isConnected()) {
        debugPrint("bookingIdbookingIdbookingId$bookingId");
        Response apiResponse = await _myBookingsRequest.travellerCancelTrip(
          context: viewContext,
          booking_id: bookingId,
          description: cancelReasonController.text,
        );
        Map jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];

        if (status == 200) {
          setBusy(false);
          cancelReasonController.text = "";
          notifyListeners();
          counterNotifier1.value++;
          Navigator.pushNamedAndRemoveUntil(
              viewContext, AppRoutes.travellerHomePageTab2, (route) => false);
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 400) {
          setBusy(false);
          Navigator.pop(viewContext);
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
    } catch (e) {
    } finally {
      setBusy(false);
    }
  }

  void logout(viewContext, fromWhere) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _myBookingsRequest.logoutCommon(fromWhere);
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (status == 200) {
        setBusy(false);
        notifyListeners();
        PreferenceUtil().logout();
        Navigator.pushNamedAndRemoveUntil(
            viewContext, AppRoutes.loginPage, (route) => false);
      } else if (status == 400) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        notifyListeners();
        PreferenceUtil().logout();
        Navigator.pushNamedAndRemoveUntil(
            viewContext, AppRoutes.loginPage, (route) => false);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void deleteAccApi(viewContext, fromWhere, reasontext) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse =
          await _myBookingsRequest.deleteCommon(fromWhere, reasontext);
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (status == 200) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showDialogFunction(
            viewContext,
            WillPopScope(
                onWillPop: () async {
                  PreferenceUtil().logout();
                  Navigator.pushNamedAndRemoveUntil(
                      viewContext, AppRoutes.loginPage, (route) => false);
                  return false;
                },
                child: Dialog(
                  alignment: Alignment.center,
                  backgroundColor: AppColor.whiteColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(
                          MediaQuery.of(viewContext).size.width *
                              AppSizes().widgetSize.mediumBorderRadius))),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(viewContext).size.width *
                            AppSizes().widgetSize.horizontalPadding,
                        vertical: MediaQuery.of(viewContext).size.height *
                            AppSizes().widgetSize.verticalPadding),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(viewContext).size.width * 0.03),
                        child: TextView.headingText(
                            text: "Your account is deleted successfully.",
                            context: viewContext),
                      ),
                      UiSpacer.verticalSpace(space: 0.02, context: viewContext),
                      SizedBox(
                        height: MediaQuery.of(viewContext).size.height *
                            AppSizes().widgetSize.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            PreferenceUtil().logout();
                            Navigator.pushNamedAndRemoveUntil(viewContext,
                                AppRoutes.loginPage, (route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColor.appthemeColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(viewContext).size.width *
                                          AppSizes()
                                              .widgetSize
                                              .smallBorderRadius))),
                          child: Text(
                            "Okay",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(viewContext).size.height *
                                        AppSizes().fontSize.normalFontSize,
                                color: AppColor.whiteColor,
                                fontFamily: AppFonts.nunitoSemiBold),
                          ),
                        ),
                      ),
                      UiSpacer.verticalSpace(space: 0.01, context: viewContext),
                    ],
                  ),
                )));
      } else if (status == 400) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void writeAReviewToGuide(viewContext, ratedToUserId) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _myBookingsRequest.writeReview(
        context: viewContext,
        booking_id: ratedToUserId.toString(),
        user_name: name.toString(),
        user_email: email.toString(),
        ratings: selectRating.toString(),
        review_message: commentController.text,
      );
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        notifyListeners();
        Navigator.pushReplacementNamed(
            viewContext, AppRoutes.travellerHomePageTab2);
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
