// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/api_requests/api_request.dart';
import 'package:Siesta/api_requests/profile_requests.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/main.dart';
import 'package:Siesta/response_pojo/get_activities_pojo.dart';
import 'package:Siesta/response_pojo/login_response.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../api_requests/guide_trancaction_list_request.dart';
import '../response_pojo/county_pojo.dart';
import '../response_pojo/get_social_links_pojo.dart';
import '../view/wait_list_screen.dart';

class CreateProfileViewModel extends BaseViewModel implements Initialisable {
  //the text editing controllers
  TextEditingController phoneNumController = TextEditingController(
      text: prefs.getString(SharedPreferenceValues.phone) ?? "");
  TextEditingController emailController = TextEditingController(
      text: prefs.getString(SharedPreferenceValues.email) ?? "");
  TextEditingController countryNameController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  // TextEditingController priceController = TextEditingController();
  List<File> idProofFile = [];

  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userCountryController = TextEditingController();
  TextEditingController userStateController = TextEditingController();
  TextEditingController userCityController = TextEditingController();

  final ProfileRequest _profileRequest = ProfileRequest();
  File? profilePicture;
  bool isCreateButtonEnable = false;
  bool isSubmitProfileButtonEnable = false;
  String countryCode = "";
  final GuideTransactionListRequest _userSocialLinks =
      GuideTransactionListRequest();
  bool checkBoxVal = false;
  List<SocialLinksData> socialLinksData = [];
  String adminCommission = "";

  ValueNotifier<bool> destinationNotifier = ValueNotifier(false);

  List<String> countryList = ["Select Country"];
  List<String> stateList = ["Select State"];
  List<String> cityList = ["Select City"];

  List<ActivitiesModel> activitiesList = [];
  List<String> pronounsList = ["He/Him", "She/Her"];

  int yearValue = 0;
  int monthValue = 0;
  String? selectedPronounValue;

  @override
  void initialise() async {
    debugPrint("Model Initialized");
    // fetchSocialLinksApi(context);
    setBusy(true);
    getActivitiesAPI(navigatorKey.currentContext!);
  }

  void increaseHostValue(String type) {
    if (type == "year") {
      yearValue++;
    } else {
      if (monthValue < 11) {
        monthValue++;
      }
    }
    notifyListeners();
  }

  void decreaseHostValue(String type) {
    if (type == "year" && yearValue > 0) {
      yearValue--;
    } else if (type == "month" && monthValue > 0) {
      monthValue--;
    }
    notifyListeners();
  }

  Future<bool> getLocationApi(
      {BuildContext? viewContext, String? countryId, String? stateId}) async {
    try {
      GlobalUtility().showLoaderDialog(viewContext!);
      if (await GlobalUtility.isConnected()) {
        Map map = {
          "countryName": countryId ?? "",
          "stateName": stateId ?? "",
        };
        Response apiResponse = await _profileRequest.getLocation(map);
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

          setBusy(false);
          notifyListeners();
          return true;
        } else if (status == 400) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 401) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
          GlobalUtility().handleSessionExpire(viewContext);
        }
      } else {
        GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
      }
    } catch (e) {
      GlobalUtility.showToast(viewContext!, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(viewContext!);
    }
    return false;
  }

  // TO create Profile - Guide/localite
  createGuideProfile(BuildContext context) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();

      List<int> selectedActivitiesId =
          activitiesList.where((e) => e.isSelect).map((e) => e.id).toList();

      StreamedResponse apiResponse = await _profileRequest.createGuideProfile(
        idProof: idProofFile,
        phone: phoneNumController.text,
        country: countryNameController.text,
        state: stateNameController.text,
        city: cityNameController.text,
        pincode: pincodeController.text,
        bio: bioController.text,
        hostSinceYear: yearValue.toString(),
        hostSinceMonth: monthValue.toString(),
        pronounValue: selectedPronounValue,
        activitiesId: selectedActivitiesId,
      );

      apiResponse.stream.transform(utf8.decoder).listen((value) {
        var jsonData = json.decode(value);
        String message = jsonData['message'];
        int status = jsonData['statusCode'];
        setBusy(false);
        debugPrint("API RES:-- ${value.toString()}");

        notifyListeners();
        if (status == 200) {
          GlobalUtility.showToast(context, message);
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.loginPage, (route) => false);
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

  // TO create Profile - Traveller
  void createTravellerProfile(BuildContext context) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      Response apiResponse = await _profileRequest.createTravellerApi(
          phone: userPhoneController.text,
          country: userCountryController.text,
          state: userStateController.text,
          city: userCityController.text,
          countryCode: countryCode == "" ? "+1" : countryCode,
          countryCodeIso: 'In',
          context: context);
      debugPrint("apiResponse:---${apiResponse.body}");
      var jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (jsonData != null) {
        setBusy(false);
        notifyListeners();
        if (status == 200) {
          var accessToken = jsonData['data']['access_token'];
          var profile_picture = jsonData['data']['profile_picture'];
          var pincode = jsonData['data']['pincode'];
          LoginResponse loginResponse =
              loginResponseFromJson(apiResponse.body.toString());
          PreferenceUtil().setToken(accessToken);
          PreferenceUtil().setUserData(
            loginResponse.data!.name.toString(),
            loginResponse.data!.lastName.toString(),
            loginResponse.data!.id!,
            loginResponse.data!.email.toString(),
            loginResponse.data!.roleName.toString(),
            loginResponse.data!.phone.toString(),
            profile_picture ?? "",
            pincode.toString(),
            "",
            true,
            loginResponse.data!.email.toString(),
          );
          PreferenceUtil().setWaitingStatus(
              loginResponse.data!.waitingList != null
                  ? loginResponse.data!.waitingList!
                  : false);
          if (loginResponse.data!.waitingList == false ||
              loginResponse.data!.waitingList == null) {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.travellerHomePage, (route) => false);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WaitListScreen()));
          }

          GlobalUtility.showToast(context, message);
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        }
      }
    } else {
      GlobalUtility.showToast(context, AppStrings().INTERNET);
    }
  }

  updateProfileImage(BuildContext context) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      StreamedResponse apiResponse = await _profileRequest.updateProfileImage(
        profilePicture: profilePicture!,
      );

      apiResponse.stream.transform(utf8.decoder).listen((value) {
        debugPrint("apiResponse:-- ${value}");
        var jsonData = json.decode(value);
        String message = jsonData['message'];
        int status = jsonData['statusCode'];
        setBusy(false);
        notifyListeners();
        if (status == 200) {
          //GlobalUtility.showToast(context, message);
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (apiResponse.statusCode == 403) {
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

  // API to get the commission value from admin
  void fetchSocialLinksApi(BuildContext context) async {
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _userSocialLinks.userSocialLinksApi();
      debugPrint("USER SOCIAL LINKS API ==>> ${apiResponse.body}");
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (status == 200) {
        setBusy(false);
        GetSocialLinksPojo socialLink =
            getSocialLinksPojoFromJson(apiResponse.body);
        socialLinksData = socialLink.data!;
        for (int i = 0; i < socialLinksData.length; i++) {
          if (socialLinksData[i].key!.toUpperCase() == "COMMISSION") {
            adminCommission = socialLinksData[i].value.toString();
          }
        }
        notifyListeners();
      } else if (status == 400) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(context, message);
      } else if (status == 401) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(context, message);
        GlobalUtility().handleSessionExpire(context);
      }
    } else {
      GlobalUtility.showToast(context, AppStrings().INTERNET);
    }
  }

  Future<void> getActivitiesAPI(BuildContext context) async {
    try {
      if (await GlobalUtility.isConnected()) {
        GlobalUtility().showLoaderDialog(context);
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
      debugPrint("Get Activities error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      setBusy(false);
      GlobalUtility().closeLoaderDialog(context);
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
