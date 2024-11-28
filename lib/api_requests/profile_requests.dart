import 'dart:convert';
import 'dart:io';

import 'package:Siesta/api_requests/api.dart' show Api;
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../app_services/http.service.dart';

class ProfileRequest extends HttpService {
  Future<http.StreamedResponse> createGuideProfile({
    required List<File> idProof,
    required String phone,
    required String pincode,
    required String bio,
    required country,
    required state,
    required city,
    required String hostSinceYear,
    required String hostSinceMonth,
    String? pronounValue,
    required List<int> activitiesId,
  }) async {
    var request = http.MultipartRequest(
        'PUT', Uri.parse(Api.baseUrl + Api.guideCreateProfile));

    debugPrint("BaseUrl--$request");
    request.headers.addAll(<String, String>{
      'Content-type': 'application/multipart',
    });

    /*if (idProof.isNotEmpty) {
      for (int i = 0; i < idProof.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
            'id_proof', idProof[i].readAsBytesSync(),
            filename: idProof[i].path.split("/").last));
      }
    }*/

    /*(phone.replaceAll(" ", "") != "") ? request.fields['phone'] = phone : "";*/

    (bio.replaceAll(" ", "") != "") ? request.fields['bio'] = bio : "";

    (pincode.replaceAll(" ", "") != "")
        ? request.fields['pincode'] = pincode
        : "";

    /*(countryCode.replaceAll(" ", "") != "")
        ? request.fields['country_code'] = countryCode
        : "";

    (countryCodeIso.replaceAll(" ", "") != "")
        ? request.fields['country_code_iso'] = countryCodeIso
        : "";*/
    (country.replaceAll("", "") != "")
        ? request.fields['country'] = country
        : "";
    (state.replaceAll("", "") != "") ? request.fields['state'] = state : "";

    (city.replaceAll("", "") != "") ? request.fields['city'] = city : "";

    request.fields['id'] = await PreferenceUtil().getId();
    request.fields['email'] = await PreferenceUtil().getEmail();
    request.fields['currency'] = 'USD';
    request.fields['host_since_years'] = hostSinceYear;
    request.fields['host_since_months'] = hostSinceMonth;
    if (pronounValue != null) {
      request.fields['pronouns'] = pronounValue;
    }
    for (int i = 0; i < activitiesId.length; i++) {
      request.fields['activities[$i]'] = activitiesId[i].toString();
    }

    var updateRequest = await request.send();
    debugPrint("fields -- ${request.fields.toString()}");
    return updateRequest;
  }

  Future<http.StreamedResponse> updateProfileImage({
    required File profilePicture,
  }) async {
    var request = http.MultipartRequest(
        'PUT', Uri.parse(Api.baseUrl + Api.updateProfileImage));
    debugPrint("BaseUrl--$request");
    request.headers.addAll(<String, String>{
      'Content-type': 'multipart/form-data',
    });
    request.files.add(http.MultipartFile.fromBytes(
        'profile_picture', profilePicture.readAsBytesSync(),
        filename: profilePicture.path.split("/").last,
        contentType: MediaType('image', '*')));
    request.fields['id'] = await PreferenceUtil().getId();
    request.fields['email'] = await PreferenceUtil().getEmail();
    var request_response = await request.send();
    debugPrint("field -- ${request.fields.toString()}");
    return request_response;
  }

  Future<Response> getLocation(Map map) async {
    final apiResult = await post(
      Uri.parse(Api.baseUrl + Api.getLocation),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        //"access_token": await PreferenceUtil().getToken()
      },
    ).timeout(Duration(seconds: 20));

    debugPrint("Get Location api${Api.baseUrl}${Api.getLocation}");

    return apiResult;
  }

  //create traveller user profile
  Future<Response> createTravellerApi(
      {required String phone,
      required String country,
      required String state,
      required String city,
      required String countryCode,
      required String countryCodeIso,
      required BuildContext context}) async {
    String firebaseToken = await GlobalUtility().getFcmToken();
    Map map = {
      "id": await PreferenceUtil().getId(),
      "email": await PreferenceUtil().getEmail(),
      // "phone": phone,
      "country": country,
      "state": state,
      "city": city,
      // "country_code": countryCode,
      // "country_code_iso": countryCodeIso,
      "application_type": 2,
      "device_token": firebaseToken
    };
    final apiResult = await http.put(
      Uri.parse(Api.baseUrl + Api.travellerCreateProfile),
      body: jsonEncode(map),
      headers: {"Content-Type": "application/json"},
    );

    debugPrint(
        "travellerCreateProfile --${Api.baseUrl + Api.travellerCreateProfile} \n apiResult---- Create traveller${apiResult.body}");
    return apiResult;
  }
}
