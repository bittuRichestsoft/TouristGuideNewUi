// ignore_for_file: file_names

import 'dart:convert';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';

class GuideItineraryDetailRequest extends HttpService {
  Future<Response> getGuideItineraryDetail({
    required String bookingId,
  }) async {
    debugPrint(
        "${Api.baseUrl}${Api.guideItineraryDetail}?booking_id=$bookingId");
    var uri = "${Api.baseUrl}${Api.guideItineraryDetail}?booking_id=$bookingId";

    final apiResult = await get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    return apiResult;
  }

  Future<Response> rejectItinerary({
    required BuildContext context,
    required String bookingId,
    required String description,
  }) async {
    Map map = {
      "booking_id": bookingId,
      "description": description,
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.guideCancelBooking),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- REjected Guide ${apiResult.body}");
    return apiResult;
  }

  Future<Response> guideEditItinerary({
    required BuildContext context,
    required String bookingId,
    required String title,
    required String advancePrice,
    required String finalPrice,
    required String currency,
    required String itineraryText,
  }) async {
    Map map = {
      "booking_id": bookingId,
      "title": title,
      "advance_price": advancePrice,
      "final_price": finalPrice,
      "currency": currency,
      "itinerary_text": itineraryText,
    };
    final apiResult = await put(
      Uri.parse(Api.baseUrl + Api.guideEditItinerary),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint(
        "Edit Itinerary Guide == Api Url ${Api.baseUrl + Api.guideEditItinerary}");
    debugPrint("Edit Itinerary Guide Response===== ${apiResult.body}");
    return apiResult;
  }

  Future<Response> guideCompleteBooking({
    required String bookingId,
  }) async {
    Map map = {
      "booking_id": bookingId,
    };
    String url = Api.baseUrl + Api.completeGuideApi;
    final apiResponse = await post(
      Uri.parse(url),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("API URL ==> $url RESPONSE-==>> ${apiResponse.body}");
    return apiResponse;
  }

  Future<Response> guidePaymentProceed({
    required String bookingId,
  }) async {
    Map map = {
      "booking_id": bookingId,
    };
    String url = Api.baseUrl + Api.paymentProceedGuideApi;
    final apiResponse = await post(
      Uri.parse(url),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("API URL ==> $url RESPONSE-==>> ${apiResponse.body}");
    return apiResponse;
  }
}
