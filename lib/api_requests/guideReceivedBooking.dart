import 'dart:convert';

import 'dart:io';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:Siesta/models/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';

class GuideReceivedBookingRequest extends HttpService {
  Future<Response> guideReceivedBooking(
      {required String pageNo,
      required String number_of_rows,
      String? searchTerm,
      List<dynamic>? booking_status,
      String? bookingItinerary,
      String? start_date,
      String? end_date,
      String? completedbooking}) async {
    var uri = "";
    debugPrint('getTokengetTokengetToken ${await PreferenceUtil().getToken()}');
    if (bookingItinerary == "yes") {
      debugPrint(Api.baseUrl +
          Api.guideRecievedBooking +
          "?page_no=$pageNo" +
          "&number_of_rows=$number_of_rows" +
          "&search_text=$searchTerm" +
          "&start_date=$start_date" +
          "&end_date=$end_date" +
          "&bookingItinerary=$bookingItinerary");
      uri = Api.baseUrl +
          Api.guideRecievedBooking +
          "?page_no=$pageNo" +
          "&number_of_rows=$number_of_rows" +
          "&search_text=$searchTerm" +
          "&start_date=$start_date" +
          "&end_date=$end_date" +
          "&bookingItinerary=$bookingItinerary";
    } else {
      debugPrint(Api.baseUrl +
          Api.guideRecievedBooking +
          "?page_no=$pageNo" +
          "&number_of_rows=$number_of_rows" +
          "&search_text=$searchTerm" +
          "&booking_status=$booking_status" +
          "&start_date=$start_date" +
          "&end_date=$end_date");
      if (completedbooking != "") {
        uri = Api.baseUrl +
            Api.guideRecievedBooking +
            "?page_no=$pageNo" +
            "&number_of_rows=$number_of_rows" +
            "&search_text=$searchTerm" +
            "&booking_status=$booking_status" +
            "&start_date=$start_date" +
            "&end_date=$end_date" +
            completedbooking.toString();
      } else {
        uri = Api.baseUrl +
            Api.guideRecievedBooking +
            "?page_no=$pageNo" +
            "&number_of_rows=$number_of_rows" +
            "&search_text=$searchTerm" +
            "&booking_status=$booking_status" +
            "&start_date=$start_date" +
            "&end_date=$end_date";
      }
    }

    final apiResult = await get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    return apiResult;
  }

  Future<Response> guideCanceTrip({
    required BuildContext context,
    required String booking_id,
    required String description,
  }) async {
    Map map = {
      "booking_id": booking_id,
      "description": description,
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.guideCancelTrip),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult----Cancel Guide  ${apiResult.body}");
    return apiResult;
  }

  Future<Response> guideCreateItinerary({
    required BuildContext context,
    required String booking_id,
    required String title,
    required String advance_price,
    required String currency,
    required String itinerary_text,
    required String finalPay,
  }) async {
    Map map = {
      "booking_id": booking_id,
      "title": title,
      "advance_price": advance_price,
      "currency": currency,
      "itinerary_text": itinerary_text,
      "final_price": finalPay,
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.guideCreateItinerary),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- Create Itinerary guide ${apiResult.body}");
    debugPrint("MAP ---- Create Itinerary GUIDE $map");
    return apiResult;
  }
}
