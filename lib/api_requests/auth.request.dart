import 'dart:convert';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:Siesta/models/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/globalUtility.dart';

import '../utility/preference_util.dart';

class AuthRequest extends HttpService {
  //login api
  loginApi(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String firebaseToken = await GlobalUtility().getFcmToken();
    debugPrint("FIREBASE TOKEN :--- $firebaseToken");
    Map map = {
      'email': email,
      'password': password,
      "application_type": 2,
      "device_token": firebaseToken
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.login),
      body: jsonEncode(map),
      headers: {"Content-Type": "application/json"},
    );
    debugPrint("Login Response:- ${Api.baseUrl + Api.login}");
    return apiResult;
  }

  //register_api
  Future<Response> registerApi(
      {required String firstName,
      required String last_name,
      required String email,
      required String role_name,
      required String password,
      required String countryCode,
      required String countryCodeIso,
      required String phone,
      required BuildContext context}) async {
    Map map = {
      "name": firstName,
      "last_name": last_name,
      "email": email,
      "role_name": role_name,
      "password": password,
      "country_code": countryCode,
      "country_code_iso": countryCodeIso,
      "phone": phone,
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.register),
      body: jsonEncode(map),
      headers: {"Content-Type": "application/json"},
    );
    debugPrint("REGISTER ---- MAP===  $map");
    debugPrint("apiResult---- Register api ${apiResult.body}");
    return apiResult;
  }

  ///forgot password
  Future<Response> forgotPassword({
    required String email,
  }) async {
    Map map = {
      'email': email,
    };
    print("Forgot password email---${map}");
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.forgotPassword),
      body: jsonEncode(map),
      headers: {"Content-Type": "application/json"},
    );
    debugPrint("apiResult=== Forget  $apiResult");
    return apiResult;
  }

  Future<ApiResponse> resetPasswordApi({
    required String password,
    required String token,
    required BuildContext context,
  }) async {
    Map map = {
      'password': password,
      'token': token,
    };
    final apiResult = await post(Uri.parse(Api.baseUrl + Api.resetPassword),
        body: jsonEncode(map));

    debugPrint("api response of login $apiResult");
    return ApiResponse.fromResponse(apiResult);
  }

  Future<Response> userWaitingStatusApi(Map map) async {
    String url = Api.baseUrl + Api.checkWaitingUser;
    final apiResult = await post(
      Uri.parse(url),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("WAITING USER STATUS --- $url");
    return apiResult;
  }

  Future<Response> waitingListContentApi() async {
    final apiResult = await get(
      Uri.parse(
          "${Api.baseUrl}${Api.waitingListContent}?key=WAITING_LIST&section=WAIT_LIST"),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken() ?? ""
      },
    );
    debugPrint(
        "WaitingList Content --  ${"${Api.baseUrl}${Api.waitingListContent}?key=WAITING_LIST&section=WAIT_LIST"} $apiResult");
    return apiResult;
  }
}
