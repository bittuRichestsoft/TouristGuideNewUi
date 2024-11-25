import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utility/preference_util.dart';
import 'api.dart';

class AIRequest {
  fetchAiDetails({
    BuildContext? context,
    String? guideId,
    String? firstName,
    String? country,
    String? state,
    String? city,
    String? bookingStart,
    String? bookingEnd,
    String? familyType,
    String? activities,
  }) async {
    final url =
        Uri.parse(Api.baseUrl + Api.travellerSampleGenerateItineraryApi);
    debugPrint("guideId--- $guideId-- $url");
    Map<String, String> map = {
      "guide_id": guideId.toString(),
      "first_name": firstName.toString(),
      "country": country.toString(),
      "state": state.toString(),
      "city": city.toString(),
      "booking_start": bookingStart.toString(),
      "booking_end": bookingEnd.toString(),
      "family_type": familyType.toString(),
      "activities": activities.toString()
    };

    debugPrint("MAP AI API ---- ${map.toString()}");
    final client = http.Client();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "access_token": await PreferenceUtil().getToken()
    };
    try {
      final request = http.Request('Post', url);
      request.bodyFields.addAll(map);
      request.headers.addAll(headers);
      final response = await client.send(request);
      await for (var chunk in response.stream.transform(utf8.decoder)) {
        debugPrint(chunk);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      client.close();
    }
  }

  Future<Response> sendAiRequest({
    BuildContext? context,
    String? guideId,
    String? firstName,
    String? country,
    String? state,
    String? city,
    String? bookingStart,
    String? bookingEnd,
    String? familyType,
    String? activities,
  }) async {
    Map map = {
      "guide_id": guideId,
      "first_name": firstName,
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

    return apiResult;
  }
}
