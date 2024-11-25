import 'dart:convert';
import 'dart:io';
import 'package:Siesta/api_requests/api.dart' show Api;
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../app_services/http.service.dart';
import 'package:http_parser/http_parser.dart';


class TravellerUpdateProfileRequest extends HttpService {

  Future<http.StreamedResponse> updateTravellerProfile({
     File? profile_picture,
    required String name,
    required String last_name,
    required String phone,
    required String country_code,
    required String country_code_iso,
    required String country,
    required String state,
    required String city,

  }) async {
    var request = http.MultipartRequest(
        'PUT', Uri.parse(Api.baseUrl + Api.updateTravellerProfile));

    debugPrint("BaseUrl--$request");
    request.headers.addAll(<String, String>{
      'Content-type': 'application/multipart',
      "access_token":await PreferenceUtil().getToken()
    });
    if(profile_picture!=null){
    request.files.add(http.MultipartFile.fromBytes(
        'profile_picture', profile_picture.readAsBytesSync(),
        filename: profile_picture.path
            .split("/")
            .last,contentType: MediaType('image','*')));
    }
    request.fields['name'] = name;
    request.fields['last_name'] = last_name;
    request.fields['phone'] = phone;
    request.fields['country'] = country;
    request.fields['state'] = state;
    request.fields['city'] = city;
    request.fields['country_code'] = country_code;
    request.fields['country_code_iso'] = country_code_iso;
    request.fields['pincode'] = "1234567";
    var updateRequest = await request.send();
    debugPrint("fields -- ${request.fields.toString()}");
    debugPrint("fields -- ${request.files.length}");
    return updateRequest;
  }


//   //create traveller user profile
  Future<Response> updatePasswordTraveller(
      {required BuildContext context,
        required String  old_password,
        required String new_password,
        }) async {
    Map map = {
      "old_password": old_password,
      "new_password":new_password,
    };
    debugPrint("old_password---- ${old_password}");
    debugPrint("old_password---- ${new_password}");
     debugPrint("old_password---- ${Api.updatePassword}");
    final apiResult = await http.put(
      Uri.parse(Api.baseUrl + Api.updatePassword),
      body: jsonEncode(map),
      headers: {"Content-Type": "application/json",
      "access_token":await PreferenceUtil().getToken()},
    );

    debugPrint("apiResult---- Traveller update password ${apiResult.body}");
    return apiResult;
  }
   Future<Response> setNotification(
      {required BuildContext context,
        required String notification,
        }) async {
    Map map = {
      "notification": notification,
    };
    debugPrint("old_password---- ${notification}");
    final apiResult = await http.put(
      Uri.parse(Api.baseUrl + Api.travellerUpdateNotification),
      body: jsonEncode(map),
      headers: {"Content-Type": "application/json",
      "access_token":await PreferenceUtil().getToken()},
    );

    debugPrint("apiResult---- traveller set notification${apiResult.body}");
    return apiResult;
  }
   Future<Response> getProfile() async {
    debugPrint("token---- ${await PreferenceUtil().getToken()}");
    final apiResult = await get(
      Uri.parse(Api.baseUrl +
          Api.travellerGetProfile ),
      headers: {"Content-Type": "application/json", "access_token":await PreferenceUtil().getToken()},
      
    );
    return apiResult;
  }
 }
