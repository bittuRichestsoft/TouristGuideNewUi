import 'dart:convert';

import 'package:flutter/material.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../app_constants/app_strings.dart';
import '../../main.dart';
import '../../utility/globalUtility.dart';

class PostLikeModel {
  // To like the gallery
  Future<bool> likeGalleryAPI(String postId, String likedById) async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        GlobalUtility().showLoaderDialog(context);

        Map map = {"gallery_id": postId, "liked_by_user_id": likedById};

        final apiResponse = await ApiRequest()
            .postWithMap(map, Api.likeGallery)
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        GlobalUtility().closeLoaderDialog(context);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          return true;
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        } else {
          GlobalUtility.showToast(context, message);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    }
    return false;
  }

  // To un like the gallery
  Future<bool> unLikeGalleryAPI(String postId, String likedById) async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        GlobalUtility().showLoaderDialog(context);

        Map map = {"gallery_id": postId, "liked_by_user_id": likedById};

        final apiResponse = await ApiRequest()
            .postWithMap(map, Api.unLikeGallery)
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        GlobalUtility().closeLoaderDialog(context);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          return true;
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    }
    return false;
  }

  // To like the post
  Future<bool> likePostAPI(String postId, String likedById) async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        GlobalUtility().showLoaderDialog(context);

        Map map = {"post_id": postId, "liked_by_user_id": likedById};

        final apiResponse = await ApiRequest()
            .postWithMap(map, Api.likePost)
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        GlobalUtility().closeLoaderDialog(context);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          return true;
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    }
    return false;
  }

  // To un like the post
  Future<bool> unLikePostAPI(String postId, String likedById) async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        GlobalUtility().showLoaderDialog(context);

        Map map = {"post_id": postId, "liked_by_user_id": likedById};

        final apiResponse = await ApiRequest()
            .postWithMap(map, Api.unLikePost)
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        GlobalUtility().closeLoaderDialog(context);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          return true;
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    }
    return false;
  }
}
