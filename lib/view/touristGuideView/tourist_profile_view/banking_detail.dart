import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/view_models/guide_models/guideUpdateProfileModel.dart';
import 'package:flutter/services.dart';

class TouristBankingDetails extends StatefulWidget {
  const TouristBankingDetails({Key? key}) : super(key: key);

  @override
  State<TouristBankingDetails> createState() => _TouristBankingDetailsState();
}

class _TouristBankingDetailsState extends State<TouristBankingDetails> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isContactFilled = false;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<GuideUpdateProfileModel>.reactive(
        viewModelBuilder: () => GuideUpdateProfileModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              backgroundColor: AppColor.appthemeColor,
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              leading: IconButton(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                color: AppColor.whiteColor,
              ),
              title: TextView.headingWhiteText(
                  text: AppStrings().bankingDetails, context: context),
            ),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal:
                      screenWidth * AppSizes().widgetSize.horizontalPadding,
                  vertical:
                      screenHeight * AppSizes().widgetSize.verticalPadding),
              children: [
                /*UiSpacer.verticalSpace(space: 0.03, context: context),
                bankUserNameField(model),*/

                Row(
                  children: [
                    Text(
                      "Note:-  ",
                      style: TextStyle(
                          color: AppColor.blackColor,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: screenHeight *
                              AppSizes().fontSize.simpleFontSize),
                    ),
                    Text(
                      AppStrings.bankNote,
                      style: TextStyle(
                          color: AppColor.hintTextColor,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: screenHeight *
                              AppSizes().fontSize.simpleFontSize),
                    ),
                  ],
                ),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                bankNameField(model),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                accountNumberField(model),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                ifscCodeField(model),
              ],
            ),
            bottomNavigationBar: submitButton(model),
          );
        });
  }

  Widget bankNameField(GuideUpdateProfileModel model) {
    return TextFormField(
      controller: model.branchNameController,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onTextFieldChange(model),
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(context,
          AppStrings().enterBankName, AppImages().svgImages.icEmail, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget bankUserNameField(GuideUpdateProfileModel model) {
    return TextFormField(
      controller: model.customerNameController,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      onChanged: onTextFieldChange(model),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(context,
          AppStrings().enterCustomerName, AppImages().svgImages.icEmail, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
    );
  }

  Widget accountNumberField(GuideUpdateProfileModel model) {
    return TextFormField(
      controller: model.accountNumberController,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onTextFieldChange(model),
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(context,
          AppStrings().enterCardNumber, AppImages().svgImages.icEmail, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget ifscCodeField(GuideUpdateProfileModel model) {
    return TextFormField(
      controller: model.ifscController,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onTextFieldChange(model),
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(context,
          AppStrings().enterIfscCode, AppImages().svgImages.icEmail, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget submitButton(GuideUpdateProfileModel model) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.05,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: MediaQuery.of(context).size.height * 0.05),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: model.isBankButtonEnable
                    ? AppColor.appthemeColor
                    : AppColor.buttonDisableColor),
            onPressed: () {
              if (model.isBankButtonEnable) {
                model.guideUpdateAccount(context);
              }
            },
            child: Text("Submit",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppFonts.nunitoBold,
                ))));
  }
}

onTextFieldChange(GuideUpdateProfileModel model) {
  if (model.branchNameController.text != "" &&
      model.accountNumberController.text != "" &&
      model.ifscController.text != "") {
    model.isBankButtonEnable = true;
    model.notifyListeners();
  } else {
    model.isBankButtonEnable = false;
    model.notifyListeners();
  }
}

onPasswordFieldChange(model) {
  if (model.currentPasswordController != "" &&
      model.newPasswordController != "" &&
      model.newPasswordAgainController != "") {
    if (model.newPasswordAgainController.text != "" &&
        model.newPasswordController.text != "" &&
        model.newPasswordController.text ==
            model.newPasswordAgainController.text) {
      model.updatePasswordButtonEnable = true;
      model.counterNotifier1.value++;
    } else {
      model.updatePasswordButtonEnable = false;
      model.counterNotifier1.value++;
    }
  } else {
    model.updatePasswordButtonEnable = false;
    model.counterNotifier1.value++;
  }
  model.notifyListeners();
}
