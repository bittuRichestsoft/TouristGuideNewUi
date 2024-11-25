import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view_models/register.view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

/// NOT IN USE
class WithdrawGuideRequestPage extends StatefulWidget {
  const WithdrawGuideRequestPage({Key? key}) : super(key: key);

  @override
  State<WithdrawGuideRequestPage> createState() => _WithdrawRequestPageState();
}

class _WithdrawRequestPageState extends State<WithdrawGuideRequestPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isSigunUpButtonEnable = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<RegisterViewModel>.reactive(
        viewModelBuilder: () => RegisterViewModel(context),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              elevation: 0,
              title: TextView.headingWhiteText(
                  context: context, text: "Withdraw Request"),
              leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColor.whiteColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal:
                      screenWidth * AppSizes().widgetSize.horizontalPadding,
                  vertical:
                      screenHeight * AppSizes().widgetSize.verticalPadding),
              children: [
                UiSpacer.verticalSpace(space: 0.007, context: context),
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    textColor: AppColor.lightBlack,
                    text: AppStrings().name),
                UiSpacer.verticalSpace(space: 0.009, context: context),
                firstNameField(model),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    textColor: AppColor.lightBlack,
                    text: AppStrings().emailId),
                UiSpacer.verticalSpace(space: 0.009, context: context),
                emailField(model),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    textColor: AppColor.lightBlack,
                    text: AppStrings().dateOfBooking),
                UiSpacer.verticalSpace(space: 0.009, context: context),
                dateFields(),
                UiSpacer.verticalSpace(space: 0.009, context: context),
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    textColor: AppColor.lightBlack,
                    text: AppStrings().paymentDate),
                UiSpacer.verticalSpace(space: 0.009, context: context),
                paymentDate(),
                UiSpacer.verticalSpace(space: 0.009, context: context),
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    textColor: AppColor.lightBlack,
                    text: AppStrings().amount),
                UiSpacer.verticalSpace(space: 0.009, context: context),
                amount(model),
                UiSpacer.verticalSpace(space: 0.04, context: context),
                signUpButton(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
              ],
            ),
          );
        });
  }

  Widget emailField(RegisterViewModel model) {
    return TextFormField(
      //controller: model.emailController,
      onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(
          context,
          AppStrings().enterEmailWithdrawPage,
          AppImages().svgImages.icEmail,
          ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (GlobalUtility().validateEmail(value.toString()) == false) {
          isSigunUpButtonEnable = false;
          return AppStrings().emailErrorString;
        } else if (value == "" || value == null) {
          isSigunUpButtonEnable = false;
          return null;
        }
        return null;
      },
    );
  }

  Widget firstNameField(RegisterViewModel model) {
    return TextFormField(
      //controller: model.firstNameController,
      onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(context,
          AppStrings().enterNameWithrawPage, AppImages().svgImages.icName, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null) {
          isSigunUpButtonEnable = false;
          return 'Please enter your first name';
        }
        return null;
      },
    );
  }

  Widget amount(RegisterViewModel model) {
    return TextFormField(
      //controller: model.firstNameController,
      onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(
          context, AppStrings().amount, AppImages().svgImages.icDollar, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null) {
          isSigunUpButtonEnable = false;
          return 'Please enter your first name';
        }
        return null;
      },
    );
  }

  Widget dateFields() {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      width: screenWidth,
      child: TextFormField(
        onChanged: (value) {},
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.textFieldDecoration(context,
            AppStrings().dateOfBooking, AppImages().svgImages.icCalendar, ""),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget paymentDate() {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      width: screenWidth,
      child: TextFormField(
        onChanged: (value) {},
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.textFieldDecoration(context,
            AppStrings().paymentDate, AppImages().svgImages.icCalendar, ""),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget signUpButton(RegisterViewModel model) {
    return CommonButton.commonBoldTextButton(
        context: context,
        text: AppStrings().submit,
        onPressed: () {
          if (isSigunUpButtonEnable) {}
        },
        isButtonEnable: isSigunUpButtonEnable);
  }

  onTextFieldValueChanged(RegisterViewModel model) {
    if (model.emailController.text.isNotEmpty &&
        model.passwordController.text.isNotEmpty &&
        model.firstNameController.text.isNotEmpty &&
        model.lastNameController.text.isNotEmpty &&
        model.confirmPasswordController.text.isNotEmpty) {
      isSigunUpButtonEnable = true;
    } else {
      isSigunUpButtonEnable = false;
    }
    model.notifyListeners();
  }
}
