import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';

class TravellerTransactionViewRequest extends HttpService {
  Future<Response> getTransactionView({
    required String booking_id,
  }) async {
    debugPrint(
        "${Api.baseUrl}${Api.travellerTransactionView}?booking_id=$booking_id");
    var uri =
        "${Api.baseUrl}${Api.travellerTransactionView}?booking_id=$booking_id";

    final apiResult = await get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    return apiResult;
  }

  static Future<Response> getPaymentMethods() async {
    var uri = Api.baseUrl + Api.travellerGetPaymentMethodList;
    debugPrint("API URL PAYMENT --- $uri");

    final apiResult = await get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    return apiResult;
  }
}
