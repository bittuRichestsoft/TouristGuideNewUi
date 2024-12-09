// ignore_for_file: use_build_context_synchronously

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/common_widgets/common_loader_dialog.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalUtility {
  static isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static showDialogFunction(BuildContext context, Widget dialogWidget) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return dialogWidget;
      },
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 800),
    );
  }

  static showBottomSheet(BuildContext context, Widget sheetView) {
    showModalBottomSheet<void>(
      useSafeArea: false,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return sheetView;
      },
    );
  }

  static showItineraryBottomSheet(BuildContext context, Widget sheetView) {
    showModalBottomSheet<void>(
      useSafeArea: false,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return sheetView;
      },
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validateAllowCharactor(String value) {
    Pattern pattern = '[a-zA-Z]';
    RegExp regex = RegExp(pattern.toString());
    return (regex.hasMatch(value)) ? false : true;
  }

  bool validateContact(String value) {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = RegExp(pattern.toString());
    debugPrint("${regex.hasMatch(value)}");
    return (regex.hasMatch(value)) ? false : true;
  }

  bool validatePinCode(String value) {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{5,8}$)';
    RegExp regex = RegExp(pattern.toString());
    debugPrint("${regex.hasMatch(value)}");
    return (regex.hasMatch(value)) ? false : true;
  }

  bool validatePinPrice(String value) {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{1,5}$)';
    RegExp regex = RegExp(pattern.toString());
    debugPrint("${regex.hasMatch(value)}");
    return (regex.hasMatch(value)) ? false : true;
  }

  String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  static showToast(
    BuildContext context,
    String title,
  ) {
    return Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.appthemeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showToastShort(
    BuildContext context,
    String title,
  ) {
    return Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.appthemeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showToastBottom(
    BuildContext context,
    String title,
  ) {
    return Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM_LEFT,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.appthemeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void setSessionEmpty(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.loginPage, (route) => false);
  }

  void showLoaderDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        barrierDismissible: false,
        useSafeArea: false,
        context: context,
        builder: (BuildContext context) {
          return const CommonLoaderDialog();
        },
      );
    });
  }

  void closeLoaderDialog(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent != true) {
      debugPrint("Dialog closed");
      Navigator.of(context).pop();
    }
  }

  showLoader(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      useSafeArea: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColor.appthemeColor,
            backgroundColor: Colors.grey.withOpacity(0.2),
          ),
        );
      },
    );
  }

  closeLoader(BuildContext context) {
    Navigator.pop(context);
  }

  String firstLetterCapital(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  Future<String> getFcmToken() async {
    String firebaseToken = "";
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    firebaseToken = token!;
    return firebaseToken;
  }

  handleSessionExpire(BuildContext context) {
    GlobalUtility.showToast(context, "Session Expired");
    PreferenceUtil().logout();
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.loginPage, (route) => false);
  }

  bool validatedEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validationPassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validationName(String value) {
    Pattern pattern = r'^[a-z A-Z]+$';
    RegExp regex = RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool containsPhoneNumberOrEmail(String input) {
    RegExp phoneRegExp = RegExp(r'\b\d{3}[-.\s]?\d{3}[-.\s]?\d{4}\b');

    RegExp emailRegExp = RegExp(
        r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b|\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\.[A-Z|a-z]{2,}\b');

    return (phoneRegExp.hasMatch(input) || emailRegExp.hasMatch(input))
        ? true
        : false;
  }
}
