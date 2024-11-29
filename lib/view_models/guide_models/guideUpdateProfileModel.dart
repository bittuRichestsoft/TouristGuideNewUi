// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/api_requests/guideUpdateProfileRequest.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/response_pojo/getTravellerProfileResponse.dart';
import 'package:Siesta/response_pojo/guid_login_response.dart';
import 'package:Siesta/response_pojo/guideAccountDeatilsPojo.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/traveller_find_guide.dart';
import '../../response_pojo/county_pojo.dart';

class GuideUpdateProfileModel extends BaseViewModel implements Initialisable {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordAgainController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  //banking controller
  TextEditingController customerNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController ifscController = TextEditingController();

  GetTravellerProfileResponse? getTravellerProfileResponse;
  BuildContext? viewContext;
  String email = "";
  String username = "";
  String profileImage = "";
  String countryCode = "";
  bool isProfileButtonEnable = true;
  bool isBankButtonEnable = true;
  bool updatePasswordButtonEnable = false;
  List<File> idProofFile = [];
  List<UserDocument> idProofUploaded = [];
  bool isEnableAvailbility = false;
  bool isEnableNotification = false;

  final counterNotifier = ValueNotifier<int>(0);
  final counterNotifier1 = ValueNotifier<int>(0);

  GuideGetAccountDetailsPojo? guideGetAccountDetailsPojo;

  List<String> countryList = ["Select Country"];
  List<String> stateList = ["Select State"];
  List<String> cityList = ["Select City"];
  ValueNotifier<bool> destinationNotifier = ValueNotifier(false);

  @override
  void initialise() {
    _asyncMethod();
    getProfile(viewContext);
    getGuideAccountDetails(viewContext);
  }

  _asyncMethod() async {
    String val1 = await PreferenceUtil().getEmail();
    String val2 = await PreferenceUtil().getFirstName();
    String val3 = await PreferenceUtil().getProgileImage();
    String val4 = await PreferenceUtil().getLastName();
    String val5 = await PreferenceUtil().getphone();
    String val6 = await PreferenceUtil().getPinCode();
    String val7 = await PreferenceUtil().getIdProof();
    String val8 = await PreferenceUtil().getGuideAvailability();
    String val9 = await PreferenceUtil().getGuideNotigicationSetting();
    String val10 = await PreferenceUtil().getGuideCountryDetails();
    String val11 = await PreferenceUtil().getGuideStateDetails();
    String val12 = await PreferenceUtil().getGuideCityDetails();
    String val13 = await PreferenceUtil().getGuideBio();

    email = val1;
    username = val2;
    profileImage = val3;
    emailController.text = val1;
    firstNameController.text = val2;
    lastNameController.text = val4;
    contactController.text = val5;
    pincodeController.text = val6;
    isEnableAvailbility = val8 == '1' ? true : false;
    isEnableNotification = val9 == '1' ? true : false;
    countryController.text = val10;
    stateController.text = val11;
    cityController.text = val12;
    bioController.text = val13;

    GuideLoginResponse loginResponse = guideLoginResponseFromJson(val7);
    idProofUploaded = loginResponse.data!.userDocuments!;
    notifyListeners();
    if (firstNameController.text != "" &&
        emailController.text != "" &&
        lastNameController.text != "" &&
        contactController.text != "" &&
        countryController.text != "" &&
        stateController.text != "" &&
        cityController.text != "" &&
        bioController.text != "") {
      isProfileButtonEnable = true;
    }
    notifyListeners();
  }

  final GuideUpdateProfileRequest _guideUpdateProfileRequest =
      GuideUpdateProfileRequest();
  File? profilePicture;

  void getProfile(viewContext) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _guideUpdateProfileRequest.getProfile();
      debugPrint("getProfile RESPONSE---- ${apiResponse.body}");
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        getTravellerProfileResponse =
            getTravellerProfileResponseFromJson(apiResponse.body);
        notifyListeners();

        PreferenceUtil().updateUserDataGuide(
            getTravellerProfileResponse!.data!.name!,
            getTravellerProfileResponse!.data!.lastName!,
            getTravellerProfileResponse!.data!.phone.toString(),
            getTravellerProfileResponse!.data!.userDetail!.profilePicture!,
            getTravellerProfileResponse!.data!.pincode.toString(),
            getTravellerProfileResponse!.data!.userDetail!.price.toString(),
            getTravellerProfileResponse!.data!.country.toString(),
            getTravellerProfileResponse!.data!.state.toString(),
            getTravellerProfileResponse!.data!.city.toString(),
            getTravellerProfileResponse!.data!.userDetail!.bio.toString());
        countryCode = getTravellerProfileResponse!.data!.countryCode!;
        notifyListeners();

        await PreferenceUtil().setGuideNotificationSetting(
            getTravellerProfileResponse!.data!.notificationStatus.toString());
        // await  PreferenceUtil().setIdProof(document);

        await PreferenceUtil().setGuideAvailability(
            getTravellerProfileResponse!.data!.availability == 1 ? "1" : "0");

        username = getTravellerProfileResponse!.data!.name!;
        profileImage =
            getTravellerProfileResponse!.data!.userDetail!.profilePicture!;
        firstNameController.text = getTravellerProfileResponse!.data!.name!;
        lastNameController.text = getTravellerProfileResponse!.data!.lastName!;
        contactController.text =
            getTravellerProfileResponse!.data!.phone.toString();
        pincodeController.text =
            getTravellerProfileResponse!.data!.pincode.toString();

        priceController.text =
            getTravellerProfileResponse!.data!.userDetail!.price.toString();
        bioController.text =
            getTravellerProfileResponse!.data!.userDetail!.bio.toString();

        isEnableAvailbility =
            getTravellerProfileResponse!.data!.availability == 1 ? true : false;
        isEnableNotification =
            getTravellerProfileResponse!.data!.notificationStatus == 1
                ? true
                : false;

        notifyListeners();
      } else if (status == 400) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        notifyListeners();

        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  guideUpdateProfile(BuildContext context) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      counterNotifier.value++;
      StreamedResponse apiResponse =
          await _guideUpdateProfileRequest.updateGuideProfile(
              profile_picture: profilePicture,
              name: firstNameController.text,
              last_name: lastNameController.text,
              phone: contactController.text,
              country_code: countryCode == "" ? "+1" : countryCode,
              country_code_iso: "US",
              pincode: pincodeController.text,
              id_proof: idProofFile,
              price: priceController.text.toString(),
              country: countryController.text.toString(),
              state: stateController.text.toString(),
              city: cityController.text.toString(),
              bio: bioController.text.toString());

      apiResponse.stream.transform(utf8.decoder).listen((value) {
        debugPrint("API GUIDE PROFILE RESPONSE: ----$value");
        var jsonData = json.decode(value);
        String message = jsonData['message'];
        int status = jsonData['statusCode'];
        String dataMap = jsonEncode(jsonData['data']);
        var datamapValue = jsonDecode(dataMap);

        setBusy(false);
        notifyListeners();
        counterNotifier.value++;
        if (status == 200) {
          getProfile(viewContext);
          idProofFile = [];
          if (datamapValue.containsKey('image_url')) {
            username = firstNameController.text;
            PreferenceUtil().updateUserDataGuide(
              firstNameController.text,
              lastNameController.text,
              contactController.text,
              datamapValue['image_url'],
              pincodeController.text,
              priceController.text,
              countryController.text,
              stateController.text,
              cityController.text,
              bioController.text,
            );
            profileImage = datamapValue['image_url'];
          } else {
            PreferenceUtil().updateUserDataGuide(
              firstNameController.text,
              lastNameController.text,
              contactController.text,
              profileImage,
              pincodeController.text,
              priceController.text,
              countryController.text,
              stateController.text,
              cityController.text,
              bioController.text,
            );
          }
          GlobalUtility.showToast(context, message);
          notifyListeners();
          Navigator.pop(context);
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

  void guideUpdatePassword(BuildContext context) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      counterNotifier1.value++;
      Response apiResponse =
          await _guideUpdateProfileRequest.updatePasswordGuide(
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

  void guideUpdateAccount(BuildContext context) async {
    if (validate(context)) {
      if (await GlobalUtility.isConnected()) {
        Map map = {
          "account_number": accountNumberController.text.toString(),
          "account_user_name": username,
          "bank_name": branchNameController.text.toString(),
          "bank_ifsc": ifscController.text.toString()
        };
        final apiResult = await put(
          Uri.parse(Api.baseUrl + Api.guideUpdateBankAccountApi),
          body: jsonEncode(map),
          headers: {
            "Content-Type": "application/json",
            "access_token": await PreferenceUtil().getToken()
          },
        );
        debugPrint("BANK DETAILS ;-- ${apiResult.body}");
        debugPrint("BANK DETAILS MAP;-- $map");
        var jsonData = jsonDecode(apiResult.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        if (jsonData != null) {
          setBusy(false);
          notifyListeners();
          counterNotifier1.value++;
          if (status == 200) {
            notifyListeners();
            Navigator.pop(context);
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
  }

  void getGuideAccountDetails(viewContext) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse =
          await _guideUpdateProfileRequest.getAccountDetails();
      debugPrint("GetAccountDetails RESPONSE---- ${apiResponse.body}");
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        guideGetAccountDetailsPojo =
            guideGetAccountDetailsPojoFromJson(apiResponse.body);
        if (guideGetAccountDetailsPojo!.data.value.isNotEmpty) {
          Map valuesMap = jsonDecode(guideGetAccountDetailsPojo!.data.value);
          customerNameController.text = valuesMap["account_user_name"] ?? "";
          accountNumberController.text = valuesMap["account_number"] ?? "";
          branchNameController.text = valuesMap["bank_name"] ?? "";
          ifscController.text = valuesMap["bank_ifsc"] ?? "";
          notifyListeners();
        }
      } else if (status == 400) {
        setBusy(false);
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void guideAvailability(BuildContext context, availability) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      Response apiResponse =
          await _guideUpdateProfileRequest.updateAvailabilityGuide(
        context: context,
        availability: availability == true ? "1" : "0",
      );
      debugPrint("apiResponse:---$apiResponse");
      var jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (jsonData != null) {
        setBusy(false);
        notifyListeners();
        if (status == 200) {
          isEnableAvailbility = isEnableAvailbility == true ? false : true;
          await PreferenceUtil()
              .setGuideAvailability(availability == true ? "1" : "0");
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

  void guideNotificationOnOff(BuildContext context, notiVal) async {
    if (await GlobalUtility.isConnected()) {
      setBusy(true);
      notifyListeners();
      Response apiResponse = await _guideUpdateProfileRequest.setNotification(
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
      {BuildContext? viewContext, String? countryId, String? stateId}) async {
    setBusy(true);
    notifyListeners();
    GlobalUtility().showLoaderDialog(viewContext!);
    if (await GlobalUtility.isConnected()) {
      debugPrint("countryName --- $countryId ----- \nstateName---- $stateId");

      Map map = {
        "countryName": countryId ?? "",
        "stateName": stateId ?? "",
      };
      Response apiResponse = await FindGuideRequest().getLocation(map);
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
        destinationNotifier.value = true;
        destinationNotifier.notifyListeners();
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

  bool validate(BuildContext context) {
    if (branchNameController.text.replaceAll(" ", "") == "") {
      GlobalUtility.showToast(context, "Please enter valid bank name");
      return false;
    } else if (accountNumberController.text.replaceAll(" ", "") == "") {
      GlobalUtility.showToast(context, "Please enter valid account number");
      return false;
    } else if (ifscController.text.replaceAll(" ", "") == "") {
      GlobalUtility.showToast(context, "Please enter valid routing number");
      return false;
    }
    return true;
  }
}
