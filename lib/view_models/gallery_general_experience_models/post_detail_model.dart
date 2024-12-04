import 'dart:convert';

import 'package:Siesta/response_pojo/custom_pojos/media_type_pojo.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../app_constants/app_strings.dart';
import '../../main.dart';
import '../../response_pojo/get_post_detail_response.dart';
import '../../utility/globalUtility.dart';

enum Status { error, loading, initialised }

class PostDetailModel extends BaseViewModel implements Initialisable {
  PostDetails? postDetail;
  final String postid;
  PostDetailModel({required this.postid});

  Status _status = Status.loading;
  Status get status => _status;

  String errorMsg = "Some error occurred";

  List<MediaTypePojo> mediaList = [];

  @override
  void initialise() {
    debugPrint("Initialised");
    getPostDetailAPI(postid);
  }

  Future<void> getPostDetailAPI(String postId) async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        _status = Status.loading;
        notifyListeners();

        final apiResponse = await ApiRequest()
            .getWithHeader("${Api.getPostDetail}/$postId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          _status = Status.initialised;
          GetPostDetailResponse getPostDetailResponse =
              getPostDetailRespFromJson(apiResponse.body);

          postDetail = getPostDetailResponse.data!.postDetails;

          mediaList = [MediaTypePojo(mediaUrl: postDetail!.heroImage ?? "")];
          mediaList.addAll(postDetail!.postImages!.map((e) => MediaTypePojo(
              mediaUrl: e.url ?? "",
              mediaType: e.mediaType ?? "image",
              id: e.id!)));
        } else if (status == 400) {
          _status = Status.error;
          errorMsg = "Some error occurred";

          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          _status = Status.error;
          errorMsg = "Un authentication";

          GlobalUtility().handleSessionExpire(context);
        } else {
          _status = Status.error;
          errorMsg = "Some error occurred";

          GlobalUtility.showToast(context, message);
        }
      } else {
        _status = Status.error;
        errorMsg = AppStrings().INTERNET;

        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
    }
  }
}
