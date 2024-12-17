import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/profile_requests.dart';
import '../../app_constants/app_routes.dart';
import '../../app_constants/app_strings.dart';
import '../../app_constants/shared_preferences.dart';
import '../../main.dart';
import '../../response_pojo/county_pojo.dart';
import '../../response_pojo/login_response.dart';
import '../../utility/globalUtility.dart';
import '../../utility/preference_util.dart';
import '../../view/wait_list_screen.dart';

class CreateTravellerViewModel extends BaseViewModel implements Initialisable {
  final ProfileRequest _profileRequest = ProfileRequest();
  String? profilePictureLocal;

  String? countryCode = "";

  TextEditingController firstNameTEC = TextEditingController();
  TextEditingController lastNameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();

  List<String> countryList = ["Select Country"];
  List<String> stateList = ["Select State"];
  List<String> cityList = ["Select City"];

  @override
  void initialise() {
    firstNameTEC.text = prefs.getString(SharedPreferenceValues.firstName) ?? "";
    lastNameTEC.text = prefs.getString(SharedPreferenceValues.lastName) ?? "";
    emailTEC.text = prefs.getString(SharedPreferenceValues.email) ?? "";
  }

  Future<bool> getLocationApi(
      {BuildContext? viewContext, String? countryId, String? stateId}) async {
    try {
      GlobalUtility().showLoader(navigatorKey.currentContext!);
      if (await GlobalUtility.isConnected()) {
        Map map = {
          "countryName": countryId ?? "",
          "stateName": stateId ?? "",
        };
        final apiResponse = await _profileRequest.getLocation(map);

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
          GlobalUtility.showToast(navigatorKey.currentContext!, message);
        } else if (status == 401) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(navigatorKey.currentContext!, message);
          GlobalUtility().handleSessionExpire(navigatorKey.currentContext!);
        }
      } else {
        GlobalUtility.showToast(viewContext!, AppStrings().INTERNET);
      }
    } catch (e) {
      GlobalUtility.showToast(viewContext!, AppStrings.someErrorOccurred);
    } finally {
      debugPrint("I got the locations");
      GlobalUtility().closeLoaderDialog(navigatorKey.currentContext!);
    }
    return false;
  }

  // TO create Profile - Traveller
  void createTravellerProfileAPI(BuildContext context) async {
    try {
      if (await GlobalUtility.isConnected()) {
        setBusy(true);

        final apiResponse = await _profileRequest.createTravellerApi(
            phone: userPhoneController.text,
            country: countryNameController.text,
            state: stateNameController.text,
            city: cityNameController.text,
            countryCode: countryCode == "" ? "+1" : countryCode!,
            countryCodeIso: 'In',
            context: context);

        debugPrint("apiResponse:---${apiResponse.body}");
        var jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        if (jsonData != null) {
          setBusy(false);
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
        setBusy(false);
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      setBusy(false);
    }
  }

  updateProfileImage(BuildContext context) async {
    try {
      GlobalUtility().showLoaderDialog(context);
      if (await GlobalUtility.isConnected()) {
        StreamedResponse apiResponse = await _profileRequest.updateProfileImage(
          profilePicture: File(profilePictureLocal!),
        );

        apiResponse.stream.transform(utf8.decoder).listen((value) {
          debugPrint("apiResponse:-- ${value}");
          var jsonData = json.decode(value);
          String message = jsonData['message'];
          int status = jsonData['statusCode'];

          if (status == 200) {
            GlobalUtility.showToast(context, message);
          } else if (status == 400) {
            GlobalUtility.showToast(context, message);
          } else if (apiResponse.statusCode == 403) {
            GlobalUtility.showToast(context, message);
          } else if (status == 401) {
            GlobalUtility().handleSessionExpire(context);
          } else {
            GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
          }
        });
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error:- $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
      GlobalUtility().closeLoaderDialog(context);
    }
  }
}
