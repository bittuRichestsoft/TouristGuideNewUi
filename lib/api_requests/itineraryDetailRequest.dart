import 'dart:convert';

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';

class MyItineraryDetailRequest extends HttpService {
  Future<Response> getItineraryDetail({
    required String booking_id,
  }) async {
    debugPrint("${Api.baseUrl}${Api.itineraryDetail}?booking_id=$booking_id");
    var uri = "${Api.baseUrl}${Api.itineraryDetail}?booking_id=$booking_id";

    final apiResult = await get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    return apiResult;
  }

  Future<Response> requestItinerary({
    required BuildContext context,
    required String booking_id,
    required String description,
  }) async {
    Map map = {
      "booking_id": booking_id,
      "description": description,
    };
    final apiResult = await put(
      Uri.parse(Api.baseUrl + Api.travellerRequestItinerary),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- Requested==== ${apiResult.body}");
    return apiResult;
  }

  Future<Response> rejectItinerary({
    required BuildContext context,
    required String booking_id,
    required String description,
  }) async {
    Map map = {
      "booking_id": booking_id,
      "description": description,
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.travellerRejectItinerary),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult----Rejected --- ${apiResult.body}");
    return apiResult;
  }

  Future<Response> acceptItinerary({
    required BuildContext context,
    required String booking_id,
  }) async {
    Map map = {
      "booking_id": booking_id,
    };
    debugPrint("booking_idbooking_id---- ${booking_id}");
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.travellerInitialPayment),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- Accepted === ${apiResult.body}");
    return apiResult;
  }
}
