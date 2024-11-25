// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:http_parser/http_parser.dart';

class TravellerMessageRequest extends HttpService {
  Future<Response> eligibleMessageUser({
    required String pageNo,
    required String number_of_rows,
  }) async {
    var role = await PreferenceUtil().getRoleName();
    String endPoint;
    if (role == Api.guideRoleName) {
      endPoint = Api.guideEligibleMessageUser;
    } else {
      endPoint = Api.eligibleMessageUser;
    }
    debugPrint(
        "Message user--- ${Api.guideEligibleMessageUser}---- ${Api.eligibleMessageUser}");
    final apiResult = await get(
      Uri.parse(
          "${Api.baseUrl + endPoint}?page_no=$pageNo&number_of_rows=$number_of_rows"),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    return apiResult;
  }

  Future<Response> messageThread({
    required String pageNo,
    required String number_of_rows,
    required String threadId,
  }) async {
    var role = await PreferenceUtil().getRoleName();
    String endPoint;
    if (role == Api.guideRoleName) {
      endPoint = Api.guideGetMessagesThread;
    } else {
      endPoint = Api.getMessagesThread;
    }

    debugPrint(
        "${Api.baseUrl + endPoint}?page_no=$pageNo&number_of_rows=$number_of_rows&thread_id=$threadId");
    final apiResult = await get(
      Uri.parse(
          "${Api.baseUrl + endPoint}?page_no=$pageNo&number_of_rows=$number_of_rows&thread_id=$threadId"),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    return apiResult;
  }

  Future<Response> inboxUser(
      {required String pageNo,
      required String number_of_rows,
      required String? inboxType,
      String? search_text}) async {
    var role = await PreferenceUtil().getRoleName();
    String endPoint;
    String uri;
    if (role == Api.guideRoleName) {
      if (inboxType == "1") {
        endPoint = Api.guideInboxUsers;
        uri =
            "${Api.baseUrl + endPoint}?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$search_text";
      } else {
        endPoint = Api.guideSentinboxUsers;
        uri =
            "${Api.baseUrl + endPoint}?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$search_text";
      }
    } else {
      if (inboxType == "1") {
        endPoint = Api.inboxUsers;
        uri =
            "${Api.baseUrl + endPoint}?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$search_text";
      } else {
        endPoint = Api.sentinboxUsers;
        uri =
            "${Api.baseUrl + endPoint}?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$search_text";
      }
    }
    debugPrint(uri);

    final apiResult = await get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    return apiResult;
  }

/*  Future<Response> sendComposedMessage({
    required BuildContext context,
    required String receiver_user_id,
    required String subject,
    required String message_text,
  }) async {
    var role = await PreferenceUtil().getRoleName();
    var endPoint;
    if (role == Api.guideRoleName) {
      endPoint = Api.guideSendComposeMessage;
    } else {
      endPoint = Api.sendComposeMessage;
    }

    Map map = {
      "receiver_user_id": int.parse(receiver_user_id),
      "subject": subject,
      "message_text": message_text,
    };

    debugPrint("Send Compose msg Map --- $map");
    final apiResult = await post(
      Uri.parse(Api.baseUrl + endPoint),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- Send Composed message${apiResult.body}");
    return apiResult;
  }*/

  Future<StreamedResponse> sendComposedMessage({
    required BuildContext context,
    required String receiver_user_id,
    required String subject,
    required String message_text,
    required File? audioFile,
  }) async {
    var role = await PreferenceUtil().getRoleName();
    String endPoint;
    if (role == Api.guideRoleName) {
      endPoint = Api.guideSendComposeMessage;
    } else {
      endPoint = Api.sendComposeMessage;
    }

    Map<String, String> map = {
      "receiver_user_id": int.parse(receiver_user_id).toString(),
      "subject": subject,
      "message_text": message_text,
    };

    debugPrint("Send Compose msg Map --- $map");

    var request = MultipartRequest('POST', Uri.parse(Api.baseUrl + endPoint));
    if (audioFile != null) {
      File file = File(audioFile.path);
      request.files.add(MultipartFile.fromBytes(
          "voice_record", file.readAsBytesSync(),
          filename: file.path.split("/").last,
          contentType: MediaType('audio', 'wav')));
    }
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "access_token": await PreferenceUtil().getToken()
    };

    request.headers.addAll(headers);
    request.fields.addAll(map);
    var apiResponse = await request.send();
    return apiResponse;
  }

  Future<Response> sendReply({
    required BuildContext context,
    required String thread_id,
    required String message_text,
  }) async {
    var role = await PreferenceUtil().getRoleName();
    String endPoint;
    if (role == Api.guideRoleName) {
      endPoint = Api.guideSendreplyMessage;
    } else {
      endPoint = Api.sendreplyMessage;
    }
    Map map = {
      "thread_id": int.parse(thread_id),
      "message_text": message_text,
    };
    final apiResult = await post(
      Uri.parse(Api.baseUrl + endPoint),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- Send reply${apiResult.body}");
    return apiResult;
  }

  Future<StreamedResponse> sendVoiceReply({
    required BuildContext context,
    required String thread_id,
    required File? audioFile,
  }) async {
    var role = await PreferenceUtil().getRoleName();
    String endPoint;
    if (role == Api.guideRoleName) {
      endPoint = Api.guideSendVoiceMsgApi;
    } else {
      endPoint = Api.travellerSendVoiceMsgApi;
    }
    Map<String, String> map = {
      "thread_id": int.parse(thread_id).toString(),
    };

    var request = MultipartRequest('POST', Uri.parse(Api.baseUrl + endPoint));

    if (audioFile != null) {
      debugPrint("inside file  send path-- ${audioFile.path}");

      request.files.add(MultipartFile.fromBytes(
          "voice_record", audioFile.readAsBytesSync(),
          filename: audioFile.path.split("/").last,
          contentType: MediaType('audio', 'wav')));
    }
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "access_token": await PreferenceUtil().getToken()
    };

    request.headers.addAll(headers);
    request.fields.addAll(map);
    var apiResponse = await request.send();
    return apiResponse;
  }

  Future<Response> deleteMessage({
    required BuildContext context,
    required List<dynamic>? thread_ids,
  }) async {
    var role = await PreferenceUtil().getRoleName();
    String endPoint;
    if (role == Api.guideRoleName) {
      endPoint = Api.guideDeleteMessage;
    } else {
      endPoint = Api.deleteMessage;
    }
    Map map = {
      "thread_ids": thread_ids,
    };
    final apiResult = await put(
      Uri.parse(Api.baseUrl + endPoint),
      body: jsonEncode(map),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("apiResult---- delete massage${apiResult.body}");
    return apiResult;
  }
}
