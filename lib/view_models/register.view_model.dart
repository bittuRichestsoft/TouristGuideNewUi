// ignore_for_file: use_build_context_synchronously, duplicate_ignore, prefer_final_fields

import 'dart:convert';
import 'dart:math';

import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/signUp/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

import '../api_requests/auth.request.dart';
import '../app_constants/app_images.dart';
import '../app_constants/app_strings.dart';
import '../view/all_dialogs/api_success_dialog.dart';

class RegisterViewModel extends BaseViewModel {
  Sky? selectedSegment = Sky.traveller;

  AuthRequest _authRequest = AuthRequest();
  BuildContext? viewContext;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool checkBoxVal = false;
  bool checkPhoneSms = false;
  bool isSigunUpButtonEnable = false;
  bool isPwValShow = false;

  final counterNotifier = ValueNotifier<int>(0);
  TextEditingController userPhoneController = TextEditingController();
  String countryCode = "+1";
  String countryCodeIso = "US";
  bool isVerified = false;
  int? firstNumber;
  int? secNumber;

  TextEditingController captchaController = TextEditingController();

  generateRandomNumber() {
    var rng = Random();
    // for (var i = 0; i < 1; i++) {
    firstNumber = rng.nextInt(19) + 1;
    debugPrint("firstNumber --- $firstNumber");
    // }
    // for (var i = 1; i < 2; i++) {
    secNumber = rng.nextInt(19) + 1;
    debugPrint("secNumber --- $secNumber");
    // }
    notifyListeners();
  }

  RegisterViewModel(BuildContext context) {
    viewContext = context;
  }

  processSignUp(
      BuildContext context, String roleName, RegisterViewModel model) async {
    if (isVerified == true) {
      GlobalUtility().showLoader(context);
      Response? signupResponse =
          await finishAccountRegistration(context, roleName, model);
      if (signupResponse != null) {
        var jsonData = jsonDecode(signupResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        Navigator.pop(context);
        if (jsonData != null) {
          if (status == 200) {
            model.setBusy(false);
            GlobalUtility.showDialogFunction(
                context,
                WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: ApiSuccessDialog(
                        imagepath: AppImages().pngImages.ivRegisterVerified,
                        titletext: AppStrings().registerSuccessIns,
                        buttonheading: AppStrings().Okay,
                        isPng: true,
                        fromWhere: 'signUp')));
          } else if (status == 400) {
            model.setBusy(false);
            GlobalUtility.showToast(context, message);
          } else if (status == 500) {
            model.setBusy(false);
            GlobalUtility.showToast(context, message);
          }
          notifyListeners();
        }
      } else {
        GlobalUtility.showToast(context, "Not Verified.");
      }
    }
  }

  Future<Response> finishAccountRegistration(
      BuildContext context, String roleName, RegisterViewModel model) async {
    Response? apiResponse;
    if (await GlobalUtility.isConnected()) {
      apiResponse = await _authRequest.registerApi(
          firstName: firstNameController.text,
          last_name: lastNameController.text,
          email: emailController.text,
          role_name: roleName,
          password: passwordController.text,
          context: context,
          countryCode: countryCode == "" ? "+1" : countryCode,
          countryCodeIso: countryCodeIso == "" ? "In" : countryCodeIso,
          phone: userPhoneController.text);
    } else {
      GlobalUtility.showToast(context, AppStrings().INTERNET);
    }
    return apiResponse!;
  }
}
