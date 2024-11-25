// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/all_dialogs/email_verified_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../api_requests/auth.request.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  //the textediting controllers
  TextEditingController forgotEmailController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();

  final AuthRequest _authRequest = AuthRequest();
  BuildContext? viewContext;

  ForgotPasswordViewModel(BuildContext context) {
    viewContext = context;
  }

  processForgotPassword(BuildContext context) async {
    setBusy(true);
    notifyListeners();
    final apiResponse = await _authRequest.forgotPassword(
      email: forgotEmailController.text,
    );
    var jsonData = jsonDecode(apiResponse.body);
    var status = jsonData['statusCode'];
    var message = jsonData['message'];
    setBusy(false);
    if (jsonData != null) {
      if (status == 200) {
        GlobalUtility.showDialogFunction(context, const EmailVerifiedDialog());
      } else if (status == 400) {
        GlobalUtility.showToast(context, message);
      }
    }
  }

  finishChangeAccountPassword(BuildContext context) async {
    setBusy(true);
    notifyListeners();
    final apiResponse = await _authRequest.resetPasswordApi(
        password: resetPasswordController.text,
        //change as soon as possible
        token: SharedPreferenceValues.token,
        context: context);
    setBusy(false);
    notifyListeners();
    GlobalUtility.showToast(context, "reset password");
  }
}
