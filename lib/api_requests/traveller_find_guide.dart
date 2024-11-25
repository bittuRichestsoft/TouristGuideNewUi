// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';

class FindGuideRequest extends HttpService {
  Future<Response> guideSortByRating({
    required String pageNo,
    required String number_of_rows,
  }) async {
    final apiResult = await get(
      Uri.parse(
          "${Api.baseUrl}${Api.guide_sort_by_rating}?page_no=$pageNo&number_of_rows=$number_of_rows"),
      headers: {"Content-Type": "application/json"},
    );
    debugPrint(
        "Api ==>> ${Api.baseUrl + Api.guide_sort_by_rating}?page_no=$pageNo&number_of_rows=$number_of_rows ");
    return apiResult;
  }

  Future<Response> guideDetail({
    required String id,
  }) async {
    final apiResult = await get(
      Uri.parse("${Api.baseUrl}${Api.guide_detail}$id"),
      headers: {"Content-Type": "application/json"},
    );
    debugPrint(
        "guide DetailguideDetailressssssss${"${Api.baseUrl}${Api.guide_detail}$id"} $apiResult");
    return apiResult;
  }

  Future<Response> searchGuide({
    required String destination,
  }) async {
    print("searchGuidesearchGuidesearchGuide");
    final apiResult = await get(
      Uri.parse(
          "${Api.baseUrl}${Api.search_guide}?destination=$destination&page_no=${1}"),
      headers: {"Content-Type": "application/json"},
    );
    debugPrint(
        "searchGuidesearchGuide${"${Api.baseUrl}${Api.search_guide}?destination=$destination"}");
    return apiResult;
  }

  Future<Response> getLocation(Map map) async {
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.getLocation),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );

    debugPrint("Get Location api${Api.baseUrl}${Api.getLocation}");

    return apiResult;
  }

  Future<Response> bookYourTrip({
    required BuildContext context,
    required String guide_id,
    required String first_name,
    String? last_name,
    required String email,
    required String country,
    required String state,
    required String city,
    String? country_code,
    String? country_code_iso,
    String? phone,
    String? booking_start,
    String? booking_end,
    String? booking_slot_start,
    String? booking_slot_end,
    String? familyType,
    String? activities,
    String? itineraryText,
  }) async {
    Map map = {
      "guide_id": guide_id,
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "country": country,
      "state": state,
      "city": city,
      "country_code": country_code,
      "country_code_iso": country_code_iso,
      "phone": phone,
      "booking_start": booking_start,
      "booking_end": booking_end,
      "booking_slot_start": booking_slot_start,
      "booking_slot_end": booking_slot_end,
      "family_type": familyType,
      "activities": activities,
      "itinerary_text": itineraryText,
    };
    debugPrint("mapmapmapmapmapmap---- ${map.toString()}");
    debugPrint("token---- ${await PreferenceUtil().getToken()}");
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.bookYourTrip),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint(
        "apiResult---- Book trip API URL ${Api.baseUrl + Api.bookYourTrip}");
    debugPrint("apiResult---- Book trip guide${apiResult.body}");
    return apiResult;
  }

  Future<Response> sendEnquiry({
    required BuildContext context,
    required String first_name,
    String? last_name,
    required String email,
    required String destination,
    required String country_code,
    required String country_code_iso,
    required String phone,
    required String booking_start,
    required String booking_end,
  }) async {
    Map map = {
      "first_name": first_name,
      "last_name": last_name,
      "user_email": email,
      "destination": destination,
      "country_code": country_code,
      "country_code_iso": country_code_iso,
      "contact_no": phone,
      "booking_start": booking_start,
      "booking_end": booking_end,
    };
    debugPrint("mapmapmapmapmapmap---- ${map.toString()}");
    debugPrint("tolen---- ${await PreferenceUtil().getToken()}");
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.sendEnquiry),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- send enquary ${apiResult.body}");
    return apiResult;
  }

  Future<Response> sendAiRequest({
    BuildContext? context,
    String? guide_id,
    String? first_name,
    String? country,
    String? state,
    String? city,
    String? bookingStart,
    String? bookingEnd,
    String? familyType,
    String? activities,
  }) async {
    Map map = {
      "guide_id": guide_id,
      "first_name": first_name,
      "country": country,
      "state": state,
      "city": city,
      "booking_start": bookingStart,
      "booking_end": bookingEnd,
      "family_type": familyType,
      "activities": activities
    };
    debugPrint("MAP AI API ---- ${map.toString()}");
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.travellerSampleGenerateItineraryApi),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint(
        "AI  API URL----  ${Api.baseUrl + Api.travellerSampleGenerateItineraryApi}");
    debugPrint("AI Api Response--- ${apiResult.body}");
    return apiResult;
  }
}
