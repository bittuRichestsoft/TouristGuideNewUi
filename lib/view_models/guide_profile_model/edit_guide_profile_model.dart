import 'dart:convert';
import 'dart:io';

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/api_requests/api_request.dart';
import 'package:Siesta/main.dart';
import 'package:Siesta/response_pojo/get_guide_profile_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:stacked/stacked.dart';

import '../../app_constants/app_strings.dart';
import '../../response_pojo/county_pojo.dart';
import '../../response_pojo/get_activities_pojo.dart';
import '../../utility/globalUtility.dart';
import '../../utility/preference_util.dart';

class EditGuideProfileModel extends BaseViewModel implements Initialisable {
  int yearValue = 0;
  int monthValue = 0;
  String? selectedPronounValue;

  String countryCode = "";
  String countryCodeIso = "";

  String? profileImgLocal;
  String? profileImgUrl;

  String? coverImgLocal;
  String? coverImgUrl;

  TextEditingController firstNameTEC = TextEditingController();
  TextEditingController lastNameTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController hostSinceYearTEC = TextEditingController();
  TextEditingController hostSinceMonthTEC = TextEditingController();
  TextEditingController bioTEC = TextEditingController();
  TextEditingController zipcodeTEC = TextEditingController();

  TextEditingController countryNameTEC = TextEditingController();
  TextEditingController stateNameTEC = TextEditingController();
  TextEditingController cityNameTEC = TextEditingController();

  ValueNotifier<bool> destinationNotifier = ValueNotifier(false);

  List<ActivitiesModel> activitiesList = [];
  List<DocumentsModel> documentsList = [];

  List<String> countryList = ["Select Country"];
  List<String> stateList = ["Select State"];
  List<String> cityList = ["Select City"];

  List<String> pronounsList = ["He/Him", "She/Her"];

  @override
  void initialise() {
    // get Activities
    getActivitiesAPI().then((value) {
      getProfileAPI();
    });
  }

  void increaseHostValue(String type) {
    if (type == "year") {
      yearValue++;
    } else {
      if (monthValue < 11) {
        monthValue++;
      }
    }
    hostSinceYearTEC.text = yearValue.toString();
    hostSinceMonthTEC.text = monthValue.toString();
    notifyListeners();
  }

  void decreaseHostValue(String type) {
    if (type == "year" && yearValue > 0) {
      yearValue--;
    } else if (type == "month" && monthValue > 0) {
      monthValue--;
    }
    hostSinceYearTEC.text = yearValue.toString();
    hostSinceMonthTEC.text = monthValue.toString();
    notifyListeners();
  }

  bool validate() {
    BuildContext context = navigatorKey.currentContext!;
    List<ActivitiesModel> activityList =
        activitiesList.where((element) => element.isSelect == true).toList();
    if (firstNameTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter first name");
      return false;
    } else if (lastNameTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter last name");
      return false;
    } else if (phoneTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter phone number");
      return false;
    } else if (phoneTEC.text.trim().length < 6) {
      GlobalUtility.showToast(context, "Please enter valid phone number");
      return false;
    } else if (bioTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter your bio");
      return false;
    } else if (activityList.isEmpty) {
      GlobalUtility.showToast(context, "Please choose the activity");
      return false;
    } else if (countryNameTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please select the county");
      return false;
    } else if (stateNameTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please select the state");
      return false;
    } else if (cityNameTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please select the city");
      return false;
    } else if (zipcodeTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter your zipcode");
      return false;
    }
    return true;
  }

  Future<bool> getLocationApi(
      {BuildContext? viewContext, String? countryId, String? stateId}) async {
    GlobalUtility().showLoaderDialog(viewContext!);
    try {
      if (await GlobalUtility.isConnected()) {
        Map map = {
          "countryName": countryId ?? "",
          "stateName": stateId ?? "",
        };
        final apiResponse =
            await ApiRequest().postWithMap(map, Api.getLocation);
        Map jsonData = jsonDecode(apiResponse.body);

        debugPrint("MAP --- $map ----- \n$jsonData");
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        // Navigator.pop(viewContext);
        if (status == 200) {
          CountryResponse countryResponse =
              countryResponseFromJson(apiResponse.body);
          if (countryId!.isEmpty && stateId!.isEmpty) {
            countryList.clear();
            for (int i = 0; i < countryResponse.data!.length; i++) {
              countryList.add(countryResponse.data![i].name!);
            }
          } else if (countryId.isNotEmpty && stateId!.isEmpty) {
            stateList.clear();
            for (int i = 0; i < countryResponse.data!.length; i++) {
              stateList.add(countryResponse.data![i].name!);
            }
            debugPrint("state list : ${stateList.toString()}");
          } else if (countryId.isNotEmpty && stateId!.isNotEmpty) {
            cityList.clear();
            for (int i = 0; i < countryResponse.data!.length; i++) {
              cityList.add(countryResponse.data![i].name!);
            }
          }

          return true;
        } else if (status == 400) {
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 401) {
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
          GlobalUtility().handleSessionExpire(viewContext);
        }
      } else {
        GlobalUtility.showToast(viewContext!, AppStrings().INTERNET);
      }
    } catch (e) {
      GlobalUtility.showToast(viewContext!, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(viewContext);
    }
    return false;
  }

  Future<void> getActivitiesAPI() async {
    BuildContext context = navigatorKey.currentContext!;

    try {
      // GlobalUtility().showLoaderDialog(context);
      if (await GlobalUtility.isConnected()) {
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getActivities)
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          GetActivitiesPojo getActivitiesPojo =
              getActivitiesPojoFromJson(apiResponse.body);
          activitiesList.clear();

          activitiesList = getActivitiesPojo.data!.rows!.map((e) {
            return ActivitiesModel(id: e.id!, title: e.name ?? "");
          }).toList();
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
    } finally {
      // GlobalUtility().closeLoaderDialog(context);
    }
  }

  Future<void> deleteDocumentAPI(
      {required int documentId, required int index}) async {
    BuildContext context = navigatorKey.currentContext!;
    GlobalUtility().showLoaderDialog(context);
    try {
      if (await GlobalUtility.isConnected()) {
        final apiResponse = await ApiRequest()
            .deleteWithHeader(Api.deleteDocuments + "?document_id=$documentId")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          documentsList.removeAt(index);
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
    } finally {
      GlobalUtility().closeLoaderDialog(context);
      notifyListeners();
    }
  }

  Future<void> getProfileAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    GlobalUtility().showLoaderDialog(context);
    try {
      if (await GlobalUtility.isConnected()) {
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.guideGetProfile)
            .timeout(const Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          GetGuideProfileResponse getGuideProfileResponse =
              getGuideProfileResponseFromJson(apiResponse.body);

          // Saving User data
          PreferenceUtil().updateUserDataGuide(
              getGuideProfileResponse.data!.guideDetails!.name!,
              getGuideProfileResponse.data!.guideDetails!.lastName!,
              getGuideProfileResponse.data!.guideDetails!.phone.toString(),
              getGuideProfileResponse
                  .data!.guideDetails!.userDetail!.profilePicture!,
              getGuideProfileResponse.data!.guideDetails!.pincode.toString(),
              getGuideProfileResponse.data!.guideDetails!.userDetail!.price
                  .toString(),
              getGuideProfileResponse.data!.guideDetails!.country.toString(),
              getGuideProfileResponse.data!.guideDetails!.state.toString(),
              getGuideProfileResponse.data!.guideDetails!.city.toString(),
              getGuideProfileResponse.data!.guideDetails!.userDetail!.bio
                  .toString());

          profileImgUrl = getGuideProfileResponse
              .data!.guideDetails!.userDetail!.profilePicture;
          coverImgUrl = getGuideProfileResponse
              .data!.guideDetails!.userDetail!.coverPicture;
          firstNameTEC.text =
              getGuideProfileResponse.data!.guideDetails!.name ?? "";
          lastNameTEC.text =
              getGuideProfileResponse.data!.guideDetails!.lastName ?? "";
          countryCode =
              (getGuideProfileResponse.data!.guideDetails!.countryCode)
                      ?.replaceAll(" ", "") ??
                  "+1";
          debugPrint("Country code : $countryCode");
          countryCodeIso =
              getGuideProfileResponse.data!.guideDetails!.countryCodeIso ??
                  "Us";
          phoneTEC.text =
              (getGuideProfileResponse.data!.guideDetails!.phone ?? "")
                  .toString();

          hostSinceYearTEC.text = getGuideProfileResponse
                  .data!.guideDetails!.userDetail!.hostSinceYears ??
              "0";
          yearValue = int.parse(hostSinceYearTEC.text);

          hostSinceMonthTEC.text = getGuideProfileResponse
                  .data!.guideDetails!.userDetail!.hostSinceMonths ??
              "0";
          monthValue = int.parse(hostSinceMonthTEC.text);

          selectedPronounValue =
              getGuideProfileResponse.data!.guideDetails!.userDetail!.pronouns;

          bioTEC.text =
              getGuideProfileResponse.data!.guideDetails!.userDetail!.bio ?? "";

          if (getGuideProfileResponse.data!.guideDetails!.guideActivities !=
              null) {
            List<int> selectedIds = getGuideProfileResponse
                .data!.guideDetails!.guideActivities!
                .map((item) => item.activity!.id!)
                .toList();

            // Update isSelect for activities in activityList
            for (var activity in activitiesList) {
              activity.isSelect = selectedIds.contains(activity.id);
            }
            debugPrint(
                "Activity selected IDs : ${getGuideProfileResponse.data!.guideDetails!.guideActivities!.length}");
          }

          countryNameTEC.text =
              getGuideProfileResponse.data!.guideDetails!.country ?? "";
          stateNameTEC.text =
              getGuideProfileResponse.data!.guideDetails!.state ?? "";
          cityNameTEC.text =
              getGuideProfileResponse.data!.guideDetails!.city ?? "";

          zipcodeTEC.text =
              getGuideProfileResponse.data!.guideDetails!.pincode ?? "";

          documentsList.clear();

          for (int i = 0;
              i <
                  getGuideProfileResponse
                      .data!.guideDetails!.userDocumentUrl!.length;
              i++) {
            documentsList.add(DocumentsModel(
                id: getGuideProfileResponse
                        .data!.guideDetails!.userDocumentUrl![i].id ??
                    0,
                documentPath: getGuideProfileResponse
                        .data!.guideDetails!.userDocumentUrl![i].documentUrl ??
                    "",
                isLocal: false));
          }

          // set guide notification setting
          await PreferenceUtil().setGuideNotificationSetting(
            getGuideProfileResponse.data!.guideDetails!.notificationStatus
                .toString(),
          );
          // await  PreferenceUtil().setIdProof(document);

          await PreferenceUtil().setGuideAvailability(
            getGuideProfileResponse.data!.guideDetails!.availability == 1
                ? "1"
                : "0",
          );
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        } else {}
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(context);
      notifyListeners();
    }
  }

  Future<void> updateGuideProfileAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    GlobalUtility().showLoaderDialog(context);
    try {
      if (await GlobalUtility.isConnected()) {
        List<int> selectedActivitiesId =
            activitiesList.where((e) => e.isSelect).map((e) => e.id).toList();
        Map<String, String> map = {
          "name": firstNameTEC.text.trim(),
          "last_name": lastNameTEC.text.trim(),
          "phone": phoneTEC.text.trim(),
          "country_code": countryCode,
          "country_code_iso": countryCodeIso,
          "pincode": zipcodeTEC.text.trim(),
          "country": countryNameTEC.text,
          "state": stateNameTEC.text,
          "city": cityNameTEC.text,
          "bio": bioTEC.text.trim(),
          "hostYear": hostSinceYearTEC.text,
          "hostMonth": hostSinceMonthTEC.text,
          if (selectedPronounValue != null)
            "pronouns": selectedPronounValue ?? "",
        };

        for (int i = 0; i < selectedActivitiesId.length; i++) {
          map['activities[$i]'] = selectedActivitiesId[i].toString();
        }

        List<http.MultipartFile> field = [];

        if (profileImgLocal != null) {
          field.add(http.MultipartFile.fromBytes(
              'profile_picture', File(profileImgLocal!).readAsBytesSync(),
              filename: File(profileImgLocal!).path.split("/").last,
              contentType: MediaType('image', '*')));
        }
        if (documentsList.isNotEmpty) {
          for (int i = 0; i < documentsList.length; i++) {
            if (documentsList[i].isLocal == true) {
              field.add(http.MultipartFile.fromBytes('id_proof',
                  File(documentsList[i].documentPath).readAsBytesSync(),
                  filename: File(documentsList[i].documentPath)
                      .path
                      .split("/")
                      .last));
            }
          }
        }

        final response = await ApiRequest()
            .putMultipartRequest(map, Api.updateGuideProfile, field)
            .timeout(Duration(seconds: 20));

        var apiResponse = await response.stream.bytesToString();

        var jsonData = jsonDecode(apiResponse);
        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          getProfileAPI();
          GlobalUtility.showToast(context, message);
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
    } finally {
      GlobalUtility().closeLoaderDialog(context);
    }
  }

  Future<void> updateCoverImageAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    GlobalUtility().showLoaderDialog(context);
    try {
      if (await GlobalUtility.isConnected()) {
        List<http.MultipartFile> field = [];

        if (coverImgLocal != null) {
          field.add(http.MultipartFile.fromBytes(
              'cover_picture', File(coverImgLocal!).readAsBytesSync(),
              filename: File(coverImgLocal!).path.split("/").last,
              contentType: MediaType('image', '*')));
        }

        final response = await ApiRequest().putMultipartRequest(
            {}, Api.updateCoverImage, field).timeout(Duration(seconds: 20));

        var apiResponse = await response.stream.bytesToString();

        var jsonData = jsonDecode(apiResponse);
        debugPrint(apiResponse);
        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          // getProfileAPI();
          // GlobalUtility.showToast(context, message);
          coverImgLocal = null;
          coverImgUrl = jsonData["data"]["image_url"];
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
    } finally {
      GlobalUtility().closeLoaderDialog(context);
      notifyListeners();
    }
  }

  Future<void> removeCoverImageAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    GlobalUtility().showLoaderDialog(context);

    try {
      if (await GlobalUtility.isConnected()) {
        final apiResponse = await ApiRequest()
            .deleteWithHeader(
              Api.removeCoverImage,
            )
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);
        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          // getProfileAPI();
          // GlobalUtility.showToast(context, message);
          coverImgUrl = null;
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
    } finally {
      GlobalUtility().closeLoaderDialog(context);
      notifyListeners();
    }
  }
}

class ActivitiesModel {
  String title;
  int id;
  bool isSelect;
  ActivitiesModel(
      {required this.id, required this.title, this.isSelect = false});
}

class DocumentsModel {
  int id;
  String documentPath;
  bool isLocal;
  DocumentsModel(
      {this.id = 0, required this.documentPath, required this.isLocal});
}
