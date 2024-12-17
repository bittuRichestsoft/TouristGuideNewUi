// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:Siesta/api_requests/travellerUpdateProfileRequest.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/response_pojo/getTravellerProfileResponse.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../api_requests/traveller_find_guide.dart';
import '../response_pojo/county_pojo.dart';

class UpdateTravellerProfileViewModel extends BaseViewModel
    implements Initialisable {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordAgainController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  GetTravellerProfileResponse? getTravellerProfileResponse;
  String email = "";
  String username = "";
  String profileImage = "";
  String countryCode = "";
  bool isProfileButtonEnable = true;
  bool updatePasswordButtonEnable = false;
  bool isEnableNotification = false;
  final counterNotifier = ValueNotifier<int>(0);
  final counterNotifier1 = ValueNotifier<int>(0);
  BuildContext? viewContext;

  List<String> countryList = ["Select Country"];
  List<String> stateList = ["Select State"];
  List<String> cityList = ["Select City"];
  ValueNotifier<bool> destinationNotifier = ValueNotifier(false);

  @override
  void initialise() {
    _asyncMethod();
    getProfile(viewContext);
  }

  _asyncMethod() async {
    String val1 = await PreferenceUtil().getEmail();
    String val2 = await PreferenceUtil().getFirstName();
    String val3 = await PreferenceUtil().getProgileImage();
    String val4 = await PreferenceUtil().getLastName();
    String val5 = await PreferenceUtil().getphone();
    String val9 = await PreferenceUtil().getGuideNotigicationSetting();
    if (await PreferenceUtil().getTravellerCountrySetting() != null) {
      countryNameController.text =
          await PreferenceUtil().getTravellerCountrySetting();
    }

    if (await PreferenceUtil().getTravellerStateSetting() != null) {
      stateNameController.text =
          await PreferenceUtil().getTravellerStateSetting();
    }
    if (await PreferenceUtil().getTravellerCitySetting() != null) {
      cityNameController.text =
          await PreferenceUtil().getTravellerCitySetting();
    }

    email = val1;
    username = val2;
    profileImage = val3;
    emailController.text = val1;
    firstNameController.text = val2;
    lastNameController.text = val4;
    contactController.text = val5;
    isEnableNotification = val9 == '1' ? true : false;

    if (firstNameController.text != "" &&
        emailController.text != "" &&
        lastNameController.text != "" &&
        stateNameController.text != "" &&
        cityNameController.text != "" &&
        countryNameController.text != "" &&
        contactController.text != "") {
      isProfileButtonEnable = true;
    }
    notifyListeners();
  }

  void getProfile(viewContext) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _travellerUpdateProfileRequest.getProfile();
      debugPrint(
          "getTouristGuide getTouristGuide.body---- ${apiResponse.body}");

      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        isBusy == false;
        notifyListeners();
        getTravellerProfileResponse =
            getTravellerProfileResponseFromJson(apiResponse.body);
        var notificationStatus = jsonData['data']['notification_status'];
        PreferenceUtil()
            .setGuideNotificationSetting(notificationStatus.toString());
        PreferenceUtil().updateUserData(
          getTravellerProfileResponse!.data!.travellerDetails!.name.toString(),
          getTravellerProfileResponse!.data!.travellerDetails!.lastName
              .toString(),
          getTravellerProfileResponse!.data!.travellerDetails!.phone.toString(),
          getTravellerProfileResponse!.data!.travellerDetails!.userDetail !=
                      null &&
                  getTravellerProfileResponse!
                          .data!.travellerDetails!.userDetail!.profilePicture !=
                      null
              ? getTravellerProfileResponse!
                  .data!.travellerDetails!.userDetail!.profilePicture!
              : "",
          getTravellerProfileResponse!.data!.travellerDetails!.country
              .toString(),
          getTravellerProfileResponse!.data!.travellerDetails!.state.toString(),
          getTravellerProfileResponse!.data!.travellerDetails!.city.toString(),
          getTravellerProfileResponse!.data!.travellerDetails!.email.toString(),
        );

        countryCode =
            getTravellerProfileResponse!.data!.travellerDetails!.countryCode!;
        PreferenceUtil().setCountryCode(countryCode);

        username = getTravellerProfileResponse!.data!.travellerDetails!.name!;

        if (getTravellerProfileResponse!.data!.travellerDetails!.userDetail !=
            null) {
          profileImage = getTravellerProfileResponse!
                      .data!.travellerDetails!.userDetail!.profilePicture !=
                  null
              ? getTravellerProfileResponse!
                  .data!.travellerDetails!.userDetail!.profilePicture!
              : "";
        }
        firstNameController.text = getTravellerProfileResponse!
            .data!.travellerDetails!.name
            .toString();
        lastNameController.text = getTravellerProfileResponse!
            .data!.travellerDetails!.lastName
            .toString();
        countryNameController.text = getTravellerProfileResponse!
            .data!.travellerDetails!.country
            .toString();
        stateNameController.text = getTravellerProfileResponse!
            .data!.travellerDetails!.state
            .toString();
        cityNameController.text = getTravellerProfileResponse!
            .data!.travellerDetails!.city
            .toString();
        contactController.text = getTravellerProfileResponse!
            .data!.travellerDetails!.phone
            .toString();
        isEnableNotification = notificationStatus == 1 ? true : false;
        notifyListeners();
      } else if (status == 400) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  final TravellerUpdateProfileRequest _travellerUpdateProfileRequest =
      TravellerUpdateProfileRequest();
  File? profilePicture;

  updateTravellerProfile(BuildContext context) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      counterNotifier.value++;
      StreamedResponse apiResponse =
          await _travellerUpdateProfileRequest.updateTravellerProfile(
        profile_picture: profilePicture,
        name: firstNameController.text,
        last_name: lastNameController.text,
        phone: contactController.text,
        country: countryNameController.text,
        state: stateNameController.text,
        city: cityNameController.text,
        country_code: countryCode == "" ? "+1" : countryCode,
        country_code_iso: "US",
      );

      apiResponse.stream.transform(utf8.decoder).listen((value) {
        var jsonData = json.decode(value);
        debugPrint('api updateTravellerProfile ---- $value');
        String message = jsonData['message'];
        int status = jsonData['statusCode'];
        String dataMap = jsonEncode(jsonData['data']);
        var dataMapValue = jsonDecode(dataMap);

        setBusy(false);
        notifyListeners();
        counterNotifier.value++;
        if (status == 200) {
          getProfile(viewContext);
          if (dataMapValue.containsKey('image_url')) {
            username = firstNameController.text;
            notifyListeners();
          } else {
            username = firstNameController.text;
            notifyListeners();
            PreferenceUtil().updateUserData(
              firstNameController.text,
              lastNameController.text,
              contactController.text,
              profileImage,
              countryNameController.text,
              stateNameController.text,
              cityNameController.text,
              emailController.text,
            );
          }
          GlobalUtility.showToast(context, message);
          notifyListeners();
          Navigator.pop(context);
        } else if (status == 400) {
          setBusy(false);
          notifyListeners();
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

  void updatePassword(BuildContext context) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      counterNotifier1.value++;
      Response apiResponse =
          await _travellerUpdateProfileRequest.updatePasswordTraveller(
        context: context,
        old_password: currentPasswordController.text,
        new_password: newPasswordController.text,
      );
      debugPrint("apiResponse:---$apiResponse");
      var jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (jsonData != null) {
        setBusy(false);
        notifyListeners();
        counterNotifier1.value++;
        if (status == 200) {
          Navigator.pop(context);
          currentPasswordController.text = "";
          newPasswordController.text = "";
          newPasswordAgainController.text = "";
          notifyListeners();
          GlobalUtility.showToast(context, message);
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(context, message);
          GlobalUtility().handleSessionExpire(context);
        }
      }
    } else {
      GlobalUtility.showToast(context, AppStrings().INTERNET);
    }
  }

  void travellerNotificationOnOff(BuildContext context, notiVal) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      Response apiResponse =
          await _travellerUpdateProfileRequest.setNotification(
        context: context,
        notification: notiVal == true ? "1" : "0",
      );
      debugPrint("apiResponse:---$apiResponse");
      var jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (jsonData != null) {
        setBusy(false);
        notifyListeners();
        if (status == 200) {
          isEnableNotification = isEnableNotification == true ? false : true;
          await PreferenceUtil()
              .setGuideNotificationSetting(notiVal == true ? "1" : "0");
          notifyListeners();
          GlobalUtility.showToast(context, message);
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
      }
    } else {
      GlobalUtility.showToast(context, AppStrings().INTERNET);
    }
  }

  Future<void> getLocationApi(
      {BuildContext? context, String? countryId, String? stateId}) async {
    setBusy(true);
    notifyListeners();
    GlobalUtility().showLoaderDialog(context!);
    if (await GlobalUtility.isConnected()) {
      Map map = {
        "countryName": countryId ?? "",
        "stateName": stateId ?? "",
      };
      Response apiResponse = await FindGuideRequest().getLocation(map);
      Map jsonData = jsonDecode(apiResponse.body);
      debugPrint("MAP --- $map ----- \n$jsonData");
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Navigator.pop(context);
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
        destinationNotifier.value = true;
        destinationNotifier.notifyListeners();
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
