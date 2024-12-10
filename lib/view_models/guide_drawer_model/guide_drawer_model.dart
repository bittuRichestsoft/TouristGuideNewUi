import 'dart:convert';

import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/custom_widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../api_requests/guideUpdateProfileRequest.dart';
import '../../app_constants/app_color.dart';
import '../../app_constants/app_fonts.dart';
import '../../app_constants/app_images.dart';
import '../../app_constants/app_routes.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/app_strings.dart';
import '../../common_widgets/common_textview.dart';
import '../../common_widgets/vertical_size_box.dart';
import '../../main.dart';
import '../../utility/globalUtility.dart';
import '../../utility/preference_util.dart';
import '../../view/all_dialogs/dialog_with_twoButton.dart';

class GuideDrawerModel extends BaseViewModel implements Initialisable {
  final GuideUpdateProfileRequest _guideUpdateProfileRequest =
      GuideUpdateProfileRequest();

  String? profileImageUrl;
  String? guideName;

  bool isEnableAvailability = false;
  bool isEnableNotification = false;

  TextEditingController currentPasswordTEC = TextEditingController();
  TextEditingController newPasswordTEC = TextEditingController();
  TextEditingController confirmPasswordTEC = TextEditingController();

  List<String> titleString = [
    AppStrings().receivedBookings,
    AppStrings().bookingsHistory,
    AppStrings().messages,
    AppStrings().transactions,
    AppStrings().bankingDetails,
    AppStrings().changePassword,
    AppStrings().notification,
    AppStrings().availability,
    AppStrings().aboutUs,
    //AppStrings().wallet,
    AppStrings().logout,
    //  AppStrings().deleteAcc
  ];

  List<String> iconPath = [
    AppImages().pngImages.icCalendar,
    AppImages().pngImages.icitinary,
    AppImages().pngImages.icMessage,
    AppImages().pngImages.icTransaction,
    AppImages().pngImages.icTransaction,
    AppImages().pngImages.icTransaction,
    AppImages().pngImages.icNotification,
    AppImages().pngImages.icAvailbility,
    // AppImages().pngImages.icWallet,
    AppImages().pngImages.icAbout,
    AppImages().pngImages.icLogout,
    //  AppImages().pngImages.icDelete,
  ];

  @override
  void initialise() {
    profileImageUrl =
        prefs.getString(SharedPreferenceValues.profileImgUrl) ?? "";
    guideName =
        "${prefs.getString(SharedPreferenceValues.firstName) ?? ""} ${prefs.getString(SharedPreferenceValues.lastName) ?? ""}";
    isEnableAvailability =
        prefs.getString(SharedPreferenceValues.availability) == "1"
            ? true
            : false;
    isEnableNotification =
        prefs.getString(SharedPreferenceValues.notification) == "1"
            ? true
            : false;
  }

  onTapListTile(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.touristGuideHome);
        break;

      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.touristGuideHome1);
        break;

      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.touristGuideHome2);
        break;

      case 3:
        Navigator.pushReplacementNamed(
            context, AppRoutes.transactionHistoryGuide);
        break;

      case 4:
        Navigator.pushNamed(context, AppRoutes.guideBankingDetails);
        break;

      case 5:
        // Navigator.pushNamed(context, AppRoutes.guideBankingDetails);
        onClickChangePassword();
        break;

      case 8:
        Map map = {"from": "drawer", "role": "GUIDE"};
        Navigator.pushNamed(context, AppRoutes.commonWebViewPage,
            arguments: map);
        break;

      case 9:
        GlobalUtility.showDialogFunction(
            context,
            DialogWithTwoButton(
                from: "guide_logout",
                cancelText: AppStrings().logoutNo,
                headingText: AppStrings().logout,
                okayText: AppStrings().logoutYes,
                subContent: AppStrings().logoutHeading));
        break;

      /*  case 9:
        GlobalUtility.showDialogFunction(
            context,
            DialogDeleteAccount(
                from: "guide_delete",
                cancelText: AppStrings().logoutNo,
                headingText: AppStrings().deleteAcc,
                okayText: AppStrings().logoutYes,
                subContent: AppStrings().deleteHeading));
        break;*/
    }
  }

  void guideAvailability(BuildContext context, availability) async {
    try {
      GlobalUtility().showLoaderDialog(context);
      if (await GlobalUtility.isConnected()) {
        Map map = {
          "availability": availability == true ? "1" : "0",
        };

        final apiResponse = await ApiRequest()
            .putWithMap(map, Api.guideAvailability)
            .timeout(const Duration(seconds: 20));

        debugPrint("apiResponse:--- ${apiResponse.body}");
        var jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'] ?? 404;
        var message = jsonData['message'] ?? "";

        if (jsonData != null) {
          if (status == 200) {
            isEnableAvailability = isEnableAvailability == true ? false : true;
            await PreferenceUtil()
                .setGuideAvailability(availability == true ? "1" : "0");

            GlobalUtility.showToast(context, message);
          } else if (status == 400) {
            GlobalUtility.showToast(context, message);
          } else if (status == 401) {
            GlobalUtility().handleSessionExpire(context);
          }
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
      GlobalUtility().closeLoaderDialog(context);
    }
  }

  void guideNotificationOnOff(BuildContext context, notiVal) async {
    try {
      GlobalUtility().showLoaderDialog(context);
      if (await GlobalUtility.isConnected()) {
        Map map = {
          "notification": notiVal == true ? "1" : "0",
        };

        final apiResponse = await ApiRequest()
            .putWithMap(map, Api.guideUpdateNotification)
            .timeout(const Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'] ?? 404;
        var message = jsonData['message'] ?? "";

        if (jsonData != null) {
          if (status == 200) {
            isEnableNotification = isEnableNotification == true ? false : true;
            await PreferenceUtil()
                .setGuideNotificationSetting(notiVal == true ? "1" : "0");

            GlobalUtility.showToast(context, message);
          } else if (status == 400) {
            GlobalUtility.showToast(context, message);
          } else if (status == 401) {
            GlobalUtility().handleSessionExpire(context);
          }
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
      GlobalUtility().closeLoaderDialog(context);
    }
  }

  void onClickChangePassword() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: navigatorKey.currentContext!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return editPasswordBottomSheet();
      },
    );
  }

  Widget editPasswordBottomSheet() {
    BuildContext context = navigatorKey.currentContext!;
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.smallPadding, context: context),
            Center(
              child: Container(
                height: 4,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.normalPadding, context: context),
            Center(
                child: TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.headingTextSize,
                    textColor: AppColor.lightBlack,
                    text: AppStrings().changePassword)),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.normalPadding, context: context),
            Container(
              height: 1.8,
              width: MediaQuery.of(context).size.width,
              color: Colors.black12,
            ),
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.horizontalPadding),
              shrinkWrap: true,
              children: [
                TextView.normalText(
                    text: AppStrings().changePassContent,
                    textColor: AppColor.dontHaveTextColor,
                    textSize: AppSizes().fontSize.mediumFontSize,
                    fontFamily: AppFonts.nunitoRegular,
                    context: context),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),

                // current password
                CustomTextField(
                  textEditingController: currentPasswordTEC,
                  hintText: AppStrings().enterCurrentPassword,
                  obscureText: true,
                ),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding022,
                    context: context),

                // new password
                CustomTextField(
                  textEditingController: newPasswordTEC,
                  hintText: AppStrings().enterNewPassword,
                  obscureText: true,
                ),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding022,
                    context: context),

                // confirm password
                CustomTextField(
                  textEditingController: confirmPasswordTEC,
                  hintText: AppStrings().enterConfirmPassword,
                  obscureText: true,
                ),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding022,
                    context: context),

                CommonButton.commonNormalButton(
                    context: context,
                    onPressed: () {
                      if (validate(context)) {
                        // update password API hit
                        guideUpdatePasswordAPI(context);
                      }
                    },
                    text: AppStrings().updatePassword)
              ],
            )
          ],
        ));
  }

  bool validate(BuildContext context) {
    String newPassword = newPasswordTEC.text;
    String confirmPassword = confirmPasswordTEC.text;

    if (currentPasswordTEC.text.trim().isEmpty) {
      GlobalUtility.showToastBottom(context, AppStrings().enterCurrentPassword);
      return false;
    } else if (newPasswordTEC.text.trim().isEmpty) {
      GlobalUtility.showToastBottom(context, AppStrings().enterNewPassword);
      return false;
    }

    if (newPassword != confirmPassword) {
      GlobalUtility.showToastBottom(
          context, AppStrings().newPasswordAndConfirmMustBeSame);
      return false;
    }
    return true;
  }

  void guideUpdatePasswordAPI(BuildContext context) async {
    try {
      GlobalUtility().showLoaderDialog(context);
      if (await GlobalUtility.isConnected()) {
        Map map = {
          "old_password": currentPasswordTEC.text,
          "new_password": newPasswordTEC.text,
        };

        final apiResponse = await ApiRequest()
            .putWithMap(map, Api.updatePasswordGuide)
            .timeout(const Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'] ?? 404;
        var message = jsonData['message'] ?? "";

        debugPrint("Status ${jsonData}");

        if (status == 200) {
          currentPasswordTEC.clear();
          newPasswordTEC.clear();
          confirmPasswordTEC.clear();

          Navigator.pop(context);
          GlobalUtility.showToast(context, message);
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          debugPrint("401 401");
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
}
