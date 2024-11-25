import 'dart:convert';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/response_pojo/notificationsResponse.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import '../api_requests/notificationRequest.dart';
import '../app_constants/app_strings.dart';
import '../view/all_dialogs/api_success_dialog.dart';

class NotificationModel extends BaseViewModel implements Initialisable {
  final NotificationRequest _notificationRequest = NotificationRequest();
  BuildContext? viewContext;
  TextEditingController searchController = TextEditingController();
  NotificationsResponse? notificationsResponse;
  var notificatiosList = [];
  var listToMarkedRead = [];
  int pageNo = 1;
  int lastPage = 1;
  String notificationType = "All";
  int selectedTabIndex = 0;
  @override
  void initialise() async {
    getNotifications(viewContext, pageNo, notificationType);
  }

  void getNotifications(viewContext, int pageNo, notificationType) async {
    if (pageNo <= lastPage) {
      // GlobalUtility().showLoaderDialog(viewContext);
      setBusy(true);
      notifyListeners();
      if (await GlobalUtility.isConnected()) {
        // GlobalUtility.showToast(viewContext, notificationType);
        var bookingNotifications;
        var paymentNotifications;
        if (notificationType == "All") {
          bookingNotifications = "yes";
          paymentNotifications = "yes";
        } else if (notificationType == "booking") {
          bookingNotifications = "yes";
          paymentNotifications = "no";
        } else {
          bookingNotifications = "no";
          paymentNotifications = "yes";
        }
        Response apiResponse = await _notificationRequest.getNotifications(
            pageNo: pageNo.toString(),
            number_of_rows: "20",
            booking_notifications: bookingNotifications,
            payment_notifications: paymentNotifications);

        debugPrint(
            "getNotificationsgetNotifications.body---- ${apiResponse.body}");

        Map jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];

        if (status == 200) {
          setBusy(false);
          notifyListeners();
          notificationsResponse =
              notificationsResponseFromJson(apiResponse.body);
          if (pageNo == 1) {
            lastPage = (notificationsResponse!.data.count / 20).round();
            lastPage = lastPage + 1;
            notificatiosList = [];
            notificatiosList = notificationsResponse!.data.rows;
          } else {
            // travellerGuideList!
            //     .addAll(travellerFindGuideResponse!.data.details);
            notificatiosList = [
              ...notificatiosList,
              ...notificationsResponse!.data.rows
            ];
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
  }

  void readNotification(viewContext, notification_ids, type) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _notificationRequest.readtNotifications(
        context: viewContext,
        notification_ids: notification_ids,
      );
      debugPrint('readNotification${apiResponse.body}');
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        notificatiosList = [];
        getNotifications(viewContext, pageNo, type);
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
