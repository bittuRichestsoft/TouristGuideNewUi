// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/response_pojo/guideGalleryResponse.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import '../../api_requests/guideGalleryRequest.dart';
import '../../app_constants/app_strings.dart';
import '../../view/all_dialogs/api_success_dialog.dart';
import 'package:Siesta/response_pojo/add_image_response.dart';

class GuideGalleryModel extends BaseViewModel implements Initialisable {
  GuideGalleryModel();
  final GuideGalleryRequest _guideGalleryRequest = GuideGalleryRequest();
  BuildContext? viewContext;
  GuideGalleryResponse? guideGalleryResponse;
  var guideReceivedBookingList = [];
  List<ImageSelectionPojo> imageSelectionList = [];
  List<Datum> galleryImageList = [];
  @override
  void initialise() async {
    getMyGallery(viewContext);
  }

  void getMyGallery(viewContext) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse =
          await _guideGalleryRequest.guideGalleryImages(viewContext);
      debugPrint("guideGalleryImagesguideGalleryImages${apiResponse.body}");
      Map jsonData = jsonDecode(apiResponse.body);
      var statusCode = jsonData['statusCode'];
      var message = jsonData['message'];

      if (statusCode == 200) {
        setBusy(false);
        notifyListeners();
        guideGalleryResponse = guideGalleryResponseFromJson(apiResponse.body);
        galleryImageList = guideGalleryResponse!.data;
        notifyListeners();
        debugPrint("galleryImageListgalleryImageList${galleryImageList}");
        Navigator.pushReplacementNamed(viewContext, AppRoutes.galleryPage);
      } else if (statusCode == 400) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      }
      // else if (statusCode == 200 && checkData.isEmpty) {
      //   setBusy(false);
      //   //guideReceivedBookingList = [];
      //   notifyListeners();
      //   GlobalUtility.showToast(viewContext, message);
      // }
      else if (statusCode == 401) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
    // }
  }

  // void guideCancelTrip(viewContext, bookingId) async {
  //   setBusy(true);

  //   if (await GlobalUtility.isConnected()) {
  //     debugPrint("bookingIdbookingIdbookingId$bookingId");
  //     Response apiResponse = await _guideReceivedBookingRequest.guideCanceTrip(
  //       context: viewContext,
  //       booking_id: bookingId.toString(),
  //       description:
  //           "i am rejecting this booking due to unavailability of myself guide",
  //     );
  //     Map jsonData = jsonDecode(apiResponse.body);
  //     var status = jsonData['statusCode'];
  //     var message = jsonData['message'];
  //     Map checkData = jsonData['data'];
  //     debugPrint("checkDatacheckDatacheckData.body---- ${checkData.isEmpty}");

  //     if (status == 200 && checkData.isEmpty == false) {
  //       setBusy(false);
  //       GlobalUtility.showToast(viewContext, message);
  //       //Navigator.pushReplacementNamed(viewContext, AppRoutes.touristGuideHome);
  //       Navigator.pushNamedAndRemoveUntil(
  //           viewContext, AppRoutes.touristGuideHome1, (route) => false);
  //     } else if (status == 400) {
  //       setBusy(false);
  //       GlobalUtility.showToast(viewContext, message);
  //     } else if (status == 401) {
  //       setBusy(false);
  //       notifyListeners();
  //       GlobalUtility.showToast(viewContext, message);
  //     } else if (status == 200 && checkData.isEmpty) {
  //       setBusy(false);
  //       notifyListeners();
  //       GlobalUtility.showToast(viewContext, message);
  //       Navigator.pushNamedAndRemoveUntil(
  //           viewContext, AppRoutes.touristGuideHome1, (route) => false);
  //     }
  //   } else {
  //     GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
  //   }
  // }

  void uploadGuidePhoto(BuildContext context, imageSelectionLists) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      StreamedResponse apiResponse =
          await _guideGalleryRequest.uploadGuideImages(
        guideImages: imageSelectionLists,
      );
      debugPrint("uploadGuideImagesuploadGuideImages${apiResponse}");
      apiResponse.stream.transform(utf8.decoder).listen((value) {
        var jsonData = json.decode(value);
        String message = jsonData['message'];
        int status = jsonData['statusCode'];
        setBusy(false);
        notifyListeners();
        if (status == 200) {
          GlobalUtility.showToast(context, message);
          // Navigator.pop(context, imageSelectionList);
          getMyGallery(context);
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (apiResponse.statusCode == 403 || status == 403) {
          GlobalUtility.showToast(context, "session Empty");
        } else if (status == 401) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(context, message);
          GlobalUtility().handleSessionExpire(context);
        }
      });
    } else {
      GlobalUtility.showToast(context, AppStrings().INTERNET);
    }
  }

  void updateGuidePhoto(BuildContext context, imageSelectionLists, title_id,
      title, imageToDelete) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      StreamedResponse apiResponse =
          await _guideGalleryRequest.updateGuideImages(
              guideImages: imageSelectionLists,
              title_id: title_id,
              title: title,
              delete_images_id: imageToDelete);
      debugPrint("uploadGuideImagesuploadGuideImages${apiResponse}");
      apiResponse.stream.transform(utf8.decoder).listen((value) {
        var jsonData = json.decode(value);
        String message = jsonData['message'];
        int status = jsonData['statusCode'];
        setBusy(false);
        notifyListeners();
        if (status == 200) {
          GlobalUtility.showToast(context, message);
          // Navigator.pop(context, imageSelectionList);
          getMyGallery(context);
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (apiResponse.statusCode == 403 || status == 403) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(context, message);
          GlobalUtility().handleSessionExpire(context);
        }
      });
    } else {
      GlobalUtility.showToast(context, AppStrings().INTERNET);
    }
  }

  successDialog(String from, BuildContext context, String message) {
    GlobalUtility.showDialogFunction(
        context,
        ApiSuccessDialog(
            imagepath: AppImages().pngImages.ivRegisterVerified,
            titletext: message,
            buttonheading: AppStrings().Okay,
            isPng: true,
            fromWhere: from));
  }
}
