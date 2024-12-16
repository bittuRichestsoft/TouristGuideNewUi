import 'dart:convert';

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class MyBookingsRequest extends HttpService {
  Future<Response> myBooking({
    required String pageNo,
    required String number_of_rows,
    String? searchTerm,
    List<dynamic>? booking_status,
    String? bookingItinerary,
    String? start_date,
    String? end_date,
    String? completedStatus,
  }) async {
    var uri = "";
    if (bookingItinerary == "yes") {
      debugPrint(
          "on yess -- ${Api.baseUrl}${Api.myBooking}?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$searchTerm&start_date=$start_date&end_date=$end_date&bookingItinerary=$bookingItinerary");
      uri =
          "${Api.baseUrl}${Api.myBooking}?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$searchTerm&start_date=$start_date&end_date=$end_date&bookingItinerary=$bookingItinerary";
    } else {
      if (completedStatus != "") {
        debugPrint(
            "on elsee-- ${Api.baseUrl}${Api.myBooking}?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$searchTerm&booking_status=$booking_status&$completedStatus");

        uri = "${Api.baseUrl}${Api.myBooking}?page_no=$pageNo&number_of_rows="
            "$number_of_rows&search_text=$searchTerm&booking_status=$booking_status&$completedStatus";
      } else {
        debugPrint(
            "on elsee-- ${Api.baseUrl}${Api.myBooking}?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$searchTerm&booking_status=$booking_status");
        uri = "${Api.baseUrl}${Api.myBooking}?page_no=$pageNo&number_of_rows="
            "$number_of_rows&search_text=$searchTerm&booking_status=$booking_status";
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

  Future<Response> travellerCancelTrip({
    required BuildContext context,
    required String booking_id,
    required String description,
  }) async {
    Map map = {
      "booking_id": booking_id,
      "cancel_notes": description,
    };
    final apiResult = await put(
      Uri.parse(Api.baseUrl + Api.cancelTrip),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- traveller cancel tip  ${apiResult.body}");
    return apiResult;
  }

  Future<Response> logoutCommon(fromWhere) async {
    var url = "";
    if (fromWhere == 'guide_logout') {
      url = Api.baseUrl + Api.logoutguide;
    } else {
      url = Api.baseUrl + Api.logoutTraveller;
    }
    debugPrint(url);
    await PreferenceUtil().getToken();

    final apiResult = await post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken() ?? ""
      },
    );
    debugPrint("apiResult---- logout ${apiResult.body}");
    return apiResult;
  }

  Future<Response> deleteCommon(fromWhere, reasonText) async {
    var url = "";
    if (fromWhere == 'guide_delete') {
      url = Api.baseUrl + Api.deleteGuide;
    } else {
      url = Api.baseUrl + Api.deleteTraveller;
    }
    debugPrint(url);
    Map map = {"reason": reasonText.toString()};
    final apiResult = await post(
      Uri.parse(url),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- delete  ${apiResult.body}");
    return apiResult;
  }

  Future<Response> writeReview({
    required BuildContext context,
    required String booking_id,
    required String user_name,
    required String user_email,
    required String ratings,
    required String review_message,
  }) async {
    Map map = {
      "booking_id": booking_id,
      "user_name": user_name,
      "user_email": user_email,
      "ratings": ratings,
      "review_message": review_message,
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.addRatings),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- write review ${apiResult.body}");
    return apiResult;
  }
}
