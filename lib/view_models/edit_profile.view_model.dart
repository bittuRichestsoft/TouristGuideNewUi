// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:Siesta/api_requests/profile_requests.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/main.dart';
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

class EditProfileViewModel extends BaseViewModel {
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
  TextEditingController priceController = TextEditingController();
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

  List<ActivitiesModel> activitiesList = [
    ActivitiesModel(id: 1, title: "Bar"),
    ActivitiesModel(id: 2, title: "Restaurant"),
    ActivitiesModel(id: 3, title: "Cycling"),
    ActivitiesModel(id: 4, title: "Travelling"),
    ActivitiesModel(id: 5, title: "Sightseeing"),
  ];

  initialise(BuildContext context) {
    fetchSocialLinksApi(context);
  }

  Future<void> getLocationApi(
      {BuildContext? viewContext, String? countryId, String? stateId}) async {
    setBusy(true);
    notifyListeners();
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
      Navigator.pop(viewContext);
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
  }

  createGuideProfile(BuildContext context) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      StreamedResponse apiResponse = await _profileRequest.createGuideProfile(
          idProof: idProofFile,
          phone: phoneNumController.text,
          country: countryNameController.text,
          state: stateNameController.text,
          city: cityNameController.text,
          countryCode: countryCode == "" ? "+1" : countryCode,
          countryCodeIso: "In",
          pincode: pincodeController.text,
          bio: bioController.text,
          price: priceController.text);

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
}

class ActivitiesModel {
  String title;
  int id;
  bool isSelect;
  ActivitiesModel(
      {required this.id, required this.title, this.isSelect = false});
}
