import 'dart:convert';

import 'package:Siesta/response_pojo/custom_pojos/media_type_pojo.dart';
import 'package:Siesta/response_pojo/get_gallery_detail_response.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../app_constants/app_strings.dart';
import '../../main.dart';
import '../../utility/globalUtility.dart';

enum Status { error, loading, initialised }

class GalleryDetailModel extends BaseViewModel implements Initialisable {
  GalleryDetails? galleryDetails;
  final String galleryId;
  GalleryDetailModel({required this.galleryId});

  Status _status = Status.loading;
  Status get status => _status;

  String errorMsg = "Some error occurred";

  List<MediaTypePojo> mediaList = [];

  @override
  void initialise() {
    debugPrint("Initialised");
    getGalleryDetailAPI(galleryId);
  }

  Future<void> getGalleryDetailAPI(String galleryId) async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        _status = Status.loading;
        notifyListeners();

        final apiResponse = await ApiRequest()
            .getWithHeader("${Api.getGalleryDetail}/$galleryId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          _status = Status.initialised;
          GetGalleryDetailResponse getGalleryDetailResponse =
              getGalleryDetailRespFromJson(apiResponse.body);

          galleryDetails = getGalleryDetailResponse.data!.galleryDetails;

          mediaList = [
            MediaTypePojo(mediaUrl: galleryDetails!.heroImage ?? "")
          ];
          mediaList.addAll(galleryDetails!.galleryMedia!.map((e) =>
              MediaTypePojo(
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
