// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:Siesta/api_requests/api.dart' show Api;
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../app_services/http.service.dart';
import 'package:http_parser/http_parser.dart';

class GuideUpdateProfileRequest extends HttpService {
  Future<http.StreamedResponse> updateGuideProfile(
      {File? profile_picture,
      required String name,
      String? last_name,
      required String phone,
      required String country_code,
      required String country_code_iso,
      String? pincode,
      String? price,
      String? country,
      String? state,
      String? city,
      String? bio,
      List<File>? id_proof}) async {
    var request = http.MultipartRequest(
        'PUT', Uri.parse(Api.baseUrl + Api.updateGuideProfile));

    debugPrint("BaseUrl Update guide profile---- $request");
    request.headers.addAll(<String, String>{
      'Content-type': 'application/multipart',
      "access_token": await PreferenceUtil().getToken()
    });
    if (profile_picture != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'profile_picture', profile_picture.readAsBytesSync(),
          filename: profile_picture.path.split("/").last,
          contentType: MediaType('image', '*')));
    }
    if (id_proof!.isNotEmpty) {
      for (int i = 0; i < id_proof.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
            'id_proof', id_proof[i].readAsBytesSync(),
            filename: id_proof[i].path.split("/").last));
      }
    }
    request.fields['name'] = name;
    request.fields['last_name'] = last_name.toString();
    request.fields['phone'] = phone;
    request.fields['country_code'] = country_code;
    request.fields['country_code_iso'] = country_code_iso;
    request.fields['pincode'] = pincode.toString();
    request.fields['price'] = price.toString();
    request.fields['country'] = country.toString();
    request.fields['state'] = state.toString();
    request.fields['city'] = city.toString();
    request.fields['bio'] = bio.toString();
    request.fields['currency'] = "USD";
    var updateRequest = await request.send();
    debugPrint("fields -- ${request.fields.toString()}");
    debugPrint("token -- ${await PreferenceUtil().getToken()}");
    return updateRequest;
  }

  Future<Response> updatePasswordGuide({
    required BuildContext context,
    required String old_password,
    required String new_password,
  }) async {
    Map map = {
      "old_password": old_password,
      "new_password": new_password,
    };

    debugPrint("old_password---- ${Api.updatePassword}");
    final apiResult = await http.put(
      Uri.parse(Api.baseUrl + Api.updatePasswordGuide),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );

    debugPrint("apiResult---- Update password${apiResult.body}");
    return apiResult;
  }

  Future<Response> updateAvailabilityGuide({
    required BuildContext context,
    required String availability,
  }) async {
    Map map = {
      "availability": availability,
    };
    debugPrint("availability---- $availability");
    final apiResult = await http.put(
      Uri.parse(Api.baseUrl + Api.guideAvailability),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );

    debugPrint("apiResult---- Update Availablilty ${apiResult.body}");
    return apiResult;
  }

  Future<Response> setNotification({
    required BuildContext context,
    required String notification,
  }) async {
    Map map = {
      "notification": notification,
    };
    debugPrint("old_password---- $notification");
    final apiResult = await http.put(
      Uri.parse(Api.baseUrl + Api.guideUpdateNotification),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );

    debugPrint("apiResult---- set Notification${apiResult.body}");
    return apiResult;
  }

  Future<Response> getProfile() async {
    debugPrint("token---- ${await PreferenceUtil().getToken()}");
    final apiResult = await get(
      Uri.parse(Api.baseUrl + Api.guideGetProfile),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint(
        "UPDATE PROFILE API URL---- ${Api.baseUrl + Api.guideGetProfile}--- ${{
      "Content-Type": "application/json",
      "access_token": await PreferenceUtil().getToken()
    }}");
    return apiResult;
  }

  Future<Response> getAccountDetails() async {
    final apiResponse = await get(
      Uri.parse(Api.baseUrl + Api.guideGetBankAccountApi),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint(
        "GetAccountDetails url Api ---- ${Api.baseUrl + Api.guideGetBankAccountApi}");
    return apiResponse;
  }

  Future<Response> getRatingAndReviews({int? pageNo, int? numberOfRows}) async {
    final apiResponse = await get(
      Uri.parse(
          "${Api.baseUrl}${Api.guideRatingReviews}?page_no=$pageNo&number_of_rows=$numberOfRows"),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint(
        "getRatingAndReviews url Api ---- ${Api.baseUrl + Api.guideRatingReviews}");
    return apiResponse;
  }
}
