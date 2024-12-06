import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../main.dart';
import '../utility/globalUtility.dart';
import '../utility/preference_util.dart';
import 'api.dart';

class ApiRequest {
  /// Get Method
  Future<Response> getWithHeader(String url) async {
    Map<String, String> header = await PreferenceUtil().getAuthHeader();
    var getUrl = Api.baseUrl + url;
    Uri myUri = Uri.parse(getUrl);
    final apiResult = await get(
      myUri,
      headers: header,
    );

    debugPrint(Api.baseUrl + url);
    debugPrint("$url apiResult---- ${apiResult.body}");

    if (apiResult.statusCode == 401) {
      return Response(
        json.encode({
          "status": 401,
          "message": "Session Expired",
        }),
        401,
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }

    return apiResult;
  }

  /// Post Method With Header
  Future<Response> postWithMap(Map map, String url) async {
    Map<String, String> header = await PreferenceUtil().getAuthHeader();
    var postUrl = Api.baseUrl + url;
    Uri myUri = Uri.parse(postUrl);
    debugPrint("map data : ${jsonEncode(map)}");
    final apiResult = await post(myUri, headers: header, body: jsonEncode(map));

    debugPrint(Api.baseUrl + url);
    debugPrint("$url apiResult---- ${apiResult.body}");

    if (apiResult.statusCode == 401) {
      return Response(
        json.encode({
          "status": 401,
          "message": "Session Expired",
        }),
        401,
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }

    return apiResult;
  }

  /// Post Method Without header
  Future<Response> postWithMapWithoutHeader(Map map, String url) async {
    Map<String, String> header = await PreferenceUtil().getAuthHeader();
    var postUrl = Api.baseUrl + url;
    Uri myUri = Uri.parse(postUrl);
    debugPrint("map data : ${jsonEncode(map)}");
    final apiResult = await post(myUri, body: map);

    debugPrint(Api.baseUrl + url);
    debugPrint("$url apiResult---- ${apiResult.body}");

    return apiResult;
  }

  /// Multipart Request
  Future<StreamedResponse> postMultipartRequest(
      Map<String, String> fields, String url, List<MultipartFile> files) async {
    Map<String, String> header = await PreferenceUtil().getAuthHeader();
    var postUrl = Api.baseUrl + url;
    Uri myUri = Uri.parse(postUrl);

    debugPrint("Api : $url --> ${fields.toString()}  --> ${files.toString()}");

    var request = MultipartRequest('POST', myUri)
      ..headers.addAll(header)
      ..fields.addAll(fields);

    if (files.isNotEmpty) {
      for (var file in files) {
        request.files.add(file);
      }
    }

    // debugPrint("fields: $fields");
    // debugPrint("files: ${files.map((file) => file.filename)}");

    final streamedResponse = await request.send();

    streamedResponse.stream.transform(utf8.decoder).listen((value) {
      debugPrint("response: $value");
    });
    if (streamedResponse.statusCode == 401) {
      GlobalUtility().handleSessionExpire(navigatorKey.currentContext!);
    }

    return streamedResponse;
  }

  Future<StreamedResponse> putMultipartRequest(
      Map<String, String> fields, String url, List<MultipartFile> files) async {
    Map<String, String> header = await PreferenceUtil().getAuthHeader();
    var postUrl = Api.baseUrl + url;
    Uri myUri = Uri.parse(postUrl);

    var request = MultipartRequest('PUT', myUri)
      ..headers.addAll(header)
      ..fields.addAll(fields);

    if (files.isNotEmpty) {
      for (var file in files) {
        request.files.add(file);
      }
    }

    // debugPrint("fields: $fields");
    // debugPrint("files: ${files.map((file) => file.filename)}");

    final streamedResponse = await request.send();

    // streamedResponse.stream.transform(utf8.decoder).listen((value) {
    //   debugPrint("response: $value");
    // });
    if (streamedResponse.statusCode == 401) {
      GlobalUtility().handleSessionExpire(navigatorKey.currentContext!);
    }

    return streamedResponse;
  }

  /// DELETE request
  Future<Response> deleteWithHeader(String url) async {
    Map<String, String> header = await PreferenceUtil().getAuthHeader();
    var getUrl = Api.baseUrl + url;
    Uri myUri = Uri.parse(getUrl);
    final apiResult = await delete(
      myUri,
      headers: header,
    );

    debugPrint(Api.baseUrl + url);
    debugPrint("$url apiResult---- ${apiResult.body}");

    if (apiResult.statusCode == 401) {
      return Response(
        json.encode({
          "status": 401,
          "message": "Session Expired",
        }),
        401,
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }

    return apiResult;
  }
}
