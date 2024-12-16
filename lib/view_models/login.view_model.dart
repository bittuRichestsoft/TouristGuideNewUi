// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/main.dart';
import 'package:Siesta/response_pojo/guid_login_response.dart';
import 'package:Siesta/response_pojo/login_response.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../api_requests/auth.request.dart';
import '../app_constants/app_strings.dart';
import '../view/wait_list_screen.dart';

class LoginViewModel extends BaseViewModel {
  TextEditingController emailController =
      TextEditingController(text: "test4@yopmail.com");
  TextEditingController passwordController =
      TextEditingController(text: "Test@123");
  TextEditingController captchaController = TextEditingController();
  final AuthRequest _authRequest = AuthRequest();
  BuildContext? viewContext;
  bool isLoginButtonEnable = false;
  bool isVerified = true;
  int? firstNumber;
  int? secNumber;

  generateRandomNumber() {
    var rng = Random();
    for (var i = 0; i < 1; i++) {
      firstNumber = rng.nextInt(19) + 1;
    }
    for (var i = 1; i < 2; i++) {
      secNumber = rng.nextInt(19) + 1;
    }
    notifyListeners();
  }

  //LOGIN
  void processLogin(viewContext) async {
    setBusy(true);
    generateRandomNumber();
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      captchaDialog(viewContext);
      // loginApi(viewContext);
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  loginApi(viewContext) async {
    try{
      if (isVerified == true) {
        setBusy(true);
        captchaController.clear();
        // GlobalUtility().showLoader(viewContext);
        Response apiResponse = await _authRequest.loginApi(
          email: emailController.text,
          password: passwordController.text,
          context: viewContext,
        );
        debugPrint("Login Response:- ${apiResponse.body}");
        Map jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        String dataMap = jsonEncode(jsonData['data']);
        var datamapValue = jsonDecode(dataMap);
        // Navigator.pop(viewContext);
        if (status == 200) {
          captchaController.clear();
          setBusy(false);
          notifyListeners();
          var roleName = jsonData['data']['role_name'];
          var document = apiResponse.body.toString();
          if (datamapValue.containsKey('access_token')) {
            if (roleName == Api.guideRoleName) {
              GuideLoginResponse loginResponse =
              guideLoginResponseFromJson(apiResponse.body.toString());
              PreferenceUtil().setToken(loginResponse.data!.accessToken!);
              PreferenceUtil().setGuideNotificationSetting(
                  loginResponse.data!.notificationStatus.toString());
              PreferenceUtil()
                  .setCountryCode(loginResponse.data!.countryCode.toString());
              PreferenceUtil().setIdProof(document);
              debugPrint("My Phone : ${loginResponse.data!.phone}");
              prefs.setString(SharedPreferenceValues.phone,
                  loginResponse.data!.phone.toString());
              PreferenceUtil().setUserData(
                  loginResponse.data!.name.toString(),
                  loginResponse.data!.lastName.toString(),
                  loginResponse.data!.id ?? 0,
                  loginResponse.data!.email.toString(),
                  loginResponse.data!.roleName.toString(),
                  loginResponse.data!.phone.toString(),
                  loginResponse.data!.profilePicture.toString(),
                  loginResponse.data!.pincode.toString(),
                  loginResponse.data!.availability.toString(),
                  false,
                  "");
              PreferenceUtil().setWaitingStatus(
                  loginResponse.data!.waitingList != null
                      ? loginResponse.data!.waitingList!
                      : false);

              PreferenceUtil().setGuideLocationDetails(
                  loginResponse.data!.country.toString(),
                  loginResponse.data!.state.toString(),
                  loginResponse.data!.city.toString());

              PreferenceUtil().setGuideBio(
                loginResponse.data!.bio.toString(),
              );
              successDialog("home-guide", viewContext, message,
                  loginResponse.data!.waitingList!);
            } else {
              var accessToken = jsonData['data']['access_token'];
              var profile_picture = jsonData['data']['profile_picture'];
              var notificationStatus = jsonData['data']['notification_status'];
              var pincode = jsonData['data']['pincode'];

              LoginResponse loginResponse =
              loginResponseFromJson(apiResponse.body.toString());
              PreferenceUtil().setToken(accessToken);
              PreferenceUtil().setWaitingStatus(
                  loginResponse.data!.waitingList != null
                      ? loginResponse.data!.waitingList!
                      : false);

              PreferenceUtil()
                  .setGuideNotificationSetting(notificationStatus.toString());
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
                false,
                loginResponse.data!.email.toString(),
              );
              PreferenceUtil().setTravelerLocationDetails(
                  loginResponse.data!.country.toString(),
                  loginResponse.data!.state.toString(),
                  loginResponse.data!.city.toString());
              successDialog("home-traveller", viewContext, message,
                  loginResponse.data!.waitingList!);
            }
          } else {
            LoginResponse loginResponse =
            loginResponseFromJson(apiResponse.body.toString());
            PreferenceUtil().setUserData(
              loginResponse.data!.name.toString(),
              loginResponse.data!.lastName.toString(),
              loginResponse.data!.id!,
              loginResponse.data!.email.toString(),
              loginResponse.data!.roleName.toString(),
              loginResponse.data!.phone.toString(),
              "",
              "",
              "",
              false,
              loginResponse.data!.email.toString(),
            );

            PreferenceUtil().setWaitingStatus(
                loginResponse.data!.waitingList != null
                    ? loginResponse.data!.waitingList!
                    : false);
            successDialog(
                loginResponse.data!.roleName == Api.travellerRoleName
                    ? "login-traveller"
                    : "login-guide",
                viewContext,
                message,
                loginResponse.data!.waitingList != null
                    ? loginResponse.data!.waitingList!
                    : false);
          }
        } else if (status == 400) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 500) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 503) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else {
          setBusy(false);
          GlobalUtility.showToast(viewContext, message);
        }
      } else {
        GlobalUtility.showToast(viewContext, "Not Verified.");
      }
    }catch(e){}finally{
      setBusy(false);
    }
  }

  successDialog(
      String from, BuildContext context, String message, bool isWait) {
    GlobalUtility.showDialogFunction(
        context,
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            alignment: Alignment.center,
            backgroundColor: AppColor.whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.mediumBorderRadius))),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.horizontalPadding,
                  vertical: MediaQuery.of(context).size.height *
                      AppSizes().widgetSize.verticalPadding),
              children: [
                CommonImageView.largeAssestImageView(
                    imagePath: AppImages().pngImages.ivRegisterVerified,
                    ctx: context),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  child:
                      TextView.subHeadingText(text: message, context: context),
                ),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      AppSizes().widgetSize.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (from == "login-traveller") {
                        if (isWait == false) {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.createTravelerProfile,
                              (route) => false);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const WaitListScreen()));
                        }
                      } else if (from == "login-guide") {
                        if (isWait == false) {
                          Navigator.pushNamedAndRemoveUntil(context,
                              AppRoutes.createTouristProfile, (route) => false);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.createTouristProfile);
                        }
                      } else if (from == "home-traveller") {
                        if (isWait == false) {
                          Navigator.pushNamedAndRemoveUntil(context,
                              AppRoutes.travellerHomePage, (route) => false);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const WaitListScreen()));
                        }
                      } else if (from == "home-guide") {
                        if (isWait == false) {
                          Navigator.pushNamedAndRemoveUntil(context,
                              AppRoutes.touristGuideHome, (route) => false);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const WaitListScreen()));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColor.appthemeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width *
                                    AppSizes().widgetSize.smallBorderRadius))),
                    child: Text(
                      "OKAY",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.normalFontSize,
                          color: AppColor.whiteColor,
                          fontFamily: AppFonts.nunitoSemiBold),
                    ),
                  ),
                ),
                UiSpacer.verticalSpace(space: 0.02, context: context),
              ],
            ),
          ),
        ));
  }

  captchaDialog(BuildContext context) {
    setBusy(false);

    GlobalUtility.showDialogFunction(
        context,
        WillPopScope(
            onWillPop: () async {
              captchaController.clear();
              return true;
            },
            child: Dialog(
              alignment: Alignment.center,
              backgroundColor: AppColor.whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.mediumBorderRadius))),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.horizontalPadding,
                    vertical: MediaQuery.of(context).size.height *
                        AppSizes().widgetSize.verticalPadding),
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.clear),
                    ),
                  ),
                  UiSpacer.verticalSpace(space: 0.015, context: context),
                  TextView.headingText(
                      text: "   $firstNumber   +   $secNumber =   ",
                      context: context,
                      color: AppColor.blackColor),
                  UiSpacer.verticalSpace(space: 0.015, context: context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height *
                              AppSizes().widgetSize.buttonHeight,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            controller: captchaController,
                            maxLength: 5,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textAlign: TextAlign.start,
                            autovalidateMode: AutovalidateMode.disabled,
                            style: TextStyle(
                                color: AppColor.blackColor,
                                fontFamily: AppFonts.nunitoBold,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppSizes().fontSize.normalFontSize),
                            decoration: InputDecoration(
                              hintText: "---",
                              hintStyle: TextStyle(
                                  color: AppColor.hintTextColor,
                                  fontFamily: AppFonts.nunitoRegular,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppSizes().fontSize.simpleFontSize),
                              contentPadding: const EdgeInsets.only(
                                  top: 10, bottom: 0, left: 10),
                              counterText: "",
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.blackColor),
                              ),
                            ),
                            enableInteractiveSelection: true,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                          )),
                      const SizedBox(width: 15),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            AppSizes().widgetSize.buttonHeight,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (captchaController.text.replaceAll(" ", "") !=
                                "") {
                              int captchaResult = firstNumber! + secNumber!;
                              if (captchaResult.toString() ==
                                  captchaController.text) {
                                isVerified = true;
                                notifyListeners();
                                Navigator.pop(context);
                                loginApi(context);
                              } else {
                                GlobalUtility.showToast(
                                    context, "Not valid! verify again.");
                              }
                            } else {
                              GlobalUtility.showToast(
                                  context, "Please verify captcha.");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColor.appthemeColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          AppSizes()
                                              .widgetSize
                                              .smallBorderRadius))),
                          child: Text(
                            "Verify",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    AppSizes().fontSize.normalFontSize,
                                color: AppColor.whiteColor,
                                fontFamily: AppFonts.nunitoSemiBold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  UiSpacer.verticalSpace(space: 0.02, context: context),
                ],
              ),
            )));
  }
}
