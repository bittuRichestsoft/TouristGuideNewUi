// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:http/http.dart' as http;
import 'package:Siesta/response_pojo/add_image_response.dart';
import 'package:http_parser/http_parser.dart';

class GuideGalleryRequest extends HttpService {
  Future<Response> guideGalleryImages(BuildContext? context) async {
    debugPrint(Api.baseUrl + Api.guideGalleryImages);
    var uri = Api.baseUrl + Api.guideGalleryImages;
    final apiResult = await get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    return apiResult;
  }

  Future<http.StreamedResponse> uploadGuideImages({
    required List<ImageSelectionPojo> guideImages,
  }) async {
    var request = http.MultipartRequest(
        'post', Uri.parse(Api.baseUrl + Api.guideUploadImages));

    debugPrint("BaseUrl--$request");
    request.headers.addAll(<String, String>{
      'Content-type': 'application/multipart',
      "access_token": await PreferenceUtil().getToken()
    });
    var images = guideImages[0].file;
    debugPrint("imagesimagesimagesimages--${images[0].path.split("/").last}");
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
            'gallery_img', File(images[i].path).readAsBytesSync(),
            filename: images[i].path.split("/").last,
            contentType: MediaType('image', '*')));
      }
    }

    request.fields['title'] = guideImages[0].title;
    debugPrint("fields -- ${request.files.length}");
    var returnResponse = await request.send();

    return returnResponse;
  }

  Future<http.StreamedResponse> updateGuideImages(
      {required List<ImageSelectionPojo> guideImages,
      title_id,
      title,
      List<dynamic>? delete_images_id}) async {
    var request = http.MultipartRequest(
        'put',
        Uri.parse(Api.baseUrl +
            Api.guideUpdateImages +
            "?title_id=${title_id}&title=${title}&delete_images_id=${delete_images_id}"));

    debugPrint("BaseUrl--$request");
    request.headers.addAll(<String, String>{
      'Content-type': 'application/multipart',
      "access_token": await PreferenceUtil().getToken()
    });

    var images = guideImages.length > 0 ? guideImages[0].file : [];
    // debugPrint("imagesimagesimagesimages--${images[0].path.split("/").last}");
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
            'gallery_img', File(images[i].path).readAsBytesSync(),
            filename: images[i].path.split("/").last,
            contentType: MediaType('image', '*')));
      }
    }

    //request.fields['title'] = guideImages[0].title;
    debugPrint("fields -- ${request.files.length}");
    var returnResponse = await request.send();

    return returnResponse;
  }
}
