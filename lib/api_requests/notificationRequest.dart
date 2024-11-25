import 'dart:convert';
import 'dart:io';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:Siesta/models/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';

class NotificationRequest extends HttpService {
  Future<Response> getNotifications({
    required String pageNo,
    required String number_of_rows,
    required String booking_notifications,
    required String payment_notifications,
  }) async {
    var role = await PreferenceUtil().getRoleName();
    var endPoint;
    if (role == Api.guideRoleName) {
      endPoint = Api.guideNotification;
    } else {
      endPoint = Api.travellerNotification;
    }
    debugPrint(endPoint +
        "?page_no=${pageNo}" +
        "&number_of_rows=${number_of_rows}" +
        "&booking_notifications=${booking_notifications}" +
        "&payment_notifications=${payment_notifications}");
    final apiResult = await get(
      Uri.parse(Api.baseUrl +
          endPoint +
          "?page_no=${pageNo}" +
          "&number_of_rows=${number_of_rows}" +
          "&booking_notifications=${booking_notifications}" +
          "&payment_notifications=${payment_notifications}"),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("NOTIFICATION PAYMNEt  ${Api.baseUrl +
        endPoint +
        "?page_no=${pageNo}" +
        "&number_of_rows=${number_of_rows}" +
        "&booking_notifications=${booking_notifications}" +
        "&payment_notifications=${payment_notifications}"}");
    return apiResult;
  }

  Future<Response> readtNotifications({
    required BuildContext context,
    required List<dynamic>? notification_ids,
  }) async {
    var role = await PreferenceUtil().getRoleName();
    var endPoint;
    if (role == Api.guideRoleName) {
      endPoint = Api.guideReadNotification;
    } else {
      endPoint = Api.readNotification;
    }
    Map map = {
      "notification_ids": notification_ids,
    };

    final apiResult = await put(
      Uri.parse(Api.baseUrl + endPoint),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- Read notification ${apiResult.body}");
    return apiResult;
  }
}
