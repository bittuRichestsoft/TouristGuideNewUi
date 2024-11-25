import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_success_dialog.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view_models/forgot_password.view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({Key? key}) : super(key: key);

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  bool passwordSuffixVisibility = true;
  bool rePasswordSuffixVisibility = true;
  bool isCreatePasswordEnable = false;
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
        viewModelBuilder: () => ForgotPasswordViewModel(context),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColor.whiteColor,
              leading: IconButton(
                  onPressed: () {Navigator.pop(context);},
                  icon: Icon(Icons.arrow_back, color: AppColor.blackColor)),
            ),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.horizontalPadding),
              children: [
                UiSpacer.verticalSpace(space: 0.02, context: context),
                CommonImageView.largeSvgImageView(
                    imagePath: AppImages().svgImages.icCreatePassword),
                UiSpacer.verticalSpace(space: 0.03, context: context),
                TextView.headingText(
                    text: AppStrings().createNewPass, context: context),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                newPasswordField(),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                rePasswordField(),
                UiSpacer.verticalSpace(space: 0.025, context: context),
                continueButton(model)
              ],
            ),
          );
        });
  }

  Widget newPasswordField() {
    return TextFormField(
      controller: newPassController,
      obscureText: passwordSuffixVisibility,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      obscuringCharacter: "✯",
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              passwordSuffixVisibility = !passwordSuffixVisibility;
            });
          },
          icon: passwordSuffixVisibility
              ? Icon(Icons.visibility_off_outlined,
                  color: AppColor.disableColor,
                  size: AppSizes().widgetSize.iconWidth)
              : Icon(
                  Icons.visibility_outlined,
                  color: AppColor.lightBlack,
                  size: AppSizes().widgetSize.iconWidth,
                ),
        ),
        hintText: AppStrings().enterPassword,
        contentPadding: const EdgeInsets.only(
          top: 8,
          bottom: 0,
        ),
        hintStyle: TextStyle(
            color: AppColor.hintTextColor,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: MediaQuery.of(context).size.height *
                AppSizes().fontSize.simpleFontSize),
        prefixIcon: IconButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: () {},
          icon: SvgPicture.asset(AppImages().svgImages.icPassword),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldEnableColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
      ),
      validator: (value) {
        if (value.toString().length < 8) {
          isCreatePasswordEnable = false;
          return AppStrings().passwordErrorString;
        } else if (value == "" || value == null) {
          isCreatePasswordEnable = false;
          return null;
        }else{
           isCreatePasswordEnable = false;
        }
        return null;
      },
      onChanged: onTextFieldChanged(),
    );
  }

  Widget rePasswordField() {
    return TextFormField(
      controller: confirmPassController,
      obscureText: rePasswordSuffixVisibility,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      obscuringCharacter: "✯",
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              rePasswordSuffixVisibility = !rePasswordSuffixVisibility;
            });
          },
          icon: rePasswordSuffixVisibility
              ? Icon(Icons.visibility_off_outlined,
                  color: AppColor.disableColor,
                  size: AppSizes().widgetSize.iconWidth)
              : Icon(
                  Icons.visibility_outlined,
                  color: AppColor.lightBlack,
                  size: AppSizes().widgetSize.iconWidth,
                ),
        ),
        hintText: AppStrings().reEnterPasword,
        contentPadding: const EdgeInsets.only(
          top: 8,
          bottom: 0,
        ),
        hintStyle: TextStyle(
            color: AppColor.hintTextColor,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: MediaQuery.of(context).size.height *
                AppSizes().fontSize.simpleFontSize),
        prefixIcon: IconButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: null,
          icon: SvgPicture.asset(AppImages().svgImages.icPassword),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldEnableColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
      ),
      validator: (value) {
        if (value.toString().length < 8) {
          isCreatePasswordEnable = false;
          return AppStrings().passwordErrorString;
        } else if (value == "" || value == null) {
          isCreatePasswordEnable = false;
          return null;
        }else {
          isCreatePasswordEnable = true;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onTextFieldChanged(),
    );
  }

  Widget continueButton(ForgotPasswordViewModel model) {
    return CommonButton.commonBoldTextButton(
        context: context,
        text: AppStrings().resetPassword,
        onPressed: () {
          model.finishChangeAccountPassword(
            context,
          );
          // if (isCreatePasswordEnable) {
            GlobalUtility.showDialogFunction(
                context,
                CommonSuccessDialog(
                  imagepath: AppImages().svgImages.ivSuccess,
                  titletext: AppStrings().congratulations,
                  dialogSubText: AppStrings().updatedPassword,
                  isPng: false,
                  buttonheading: AppStrings().letsGo,
                  fromWhere: '',
                ));
          // }
        },
        isButtonEnable: isCreatePasswordEnable);
  }

  onTextFieldChanged() {
    // setState(() {
    //   if (newPassController.text.toString().replaceAll(" ", "") != "" &&
    //       confirmPassController.text.replaceAll(" ", "") != "") {
    //     isCreatePasswordEnable = true;
    //   } else {
    //     isCreatePasswordEnable = false;
    //   }
    // });
  }
}
