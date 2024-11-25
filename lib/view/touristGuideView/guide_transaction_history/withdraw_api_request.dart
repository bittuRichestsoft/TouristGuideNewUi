import 'dart:convert';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class WithdrawPaymentRequest extends HttpService {
  /// ADVANCE PAYMENT WITHDRAW
  Future<Response> withDrawAdvancePay({
    required String bookingId,
  }) async {
    Map map = {
      "booking_id": bookingId,
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.withdrawAdvancePayment),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint(
        "ADVANCE PAY API ----${Api.baseUrl + Api.withdrawAdvancePayment} \n Response ==>> ${apiResult.body}");
    return apiResult;
  }


  /// TOTAL PAYMENT WITHDRAW
  Future<Response> withDrawTotalPay({
    required String bookingId,
  }) async {
    Map map = {
      "booking_id": bookingId,
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.withdrawTotalPayment),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint(
        "TOTAL PAY API ----${Api.baseUrl + Api.withdrawTotalPayment} \n Response ==>> ${apiResult.body}");
    return apiResult;
  }



}
