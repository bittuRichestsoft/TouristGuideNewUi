// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/web_view_pages/web_view_terms_conditions.dart';
import 'package:Siesta/view_models/register.view_model.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../app_constants/app_images.dart';
import '../../app_constants/app_routes.dart';
import '../../app_constants/textfield_decoration.dart';
import '../../common_widgets/common_imageview.dart';
import '../../common_widgets/vertical_size_box.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

enum Sky {
  traveller,
  guide,
}

Map<Sky, Color> selectedThumbColor = <Sky, Color>{
  Sky.traveller: AppColor.appthemeColor,
  Sky.guide: AppColor.appthemeColor,
};
Map<Sky, Color> selectedTextColor = <Sky, Color>{
  Sky.traveller: AppColor.whiteColor,
  Sky.guide: AppColor.blackColor,
};
Map<Sky, Color> unSelectedTextColor = <Sky, Color>{
  Sky.traveller: AppColor.blackColor,
  Sky.guide: AppColor.whiteColor,
};

class _SignUpPageState extends State<SignUpPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool passwordSuffixVisibility = true;
  bool rePasswordSuffixVisibility = true;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<RegisterViewModel>.reactive(
        viewModelBuilder: () => RegisterViewModel(context),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal:
                      screenWidth * AppSizes().widgetSize.horizontalPadding,
                  vertical: screenHeight * 0.025),
              children: [
                UiSpacer.verticalSpace(space: 0.025, context: context),
                CommonImageView.largeSvgImageView(
                    imagePath: AppImages().svgImages.ivSignUp),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                TextView.headingText(
                  text: AppStrings().signUp,
                  context: context,
                ),
                UiSpacer.verticalSpace(space: 0.01, context: context),
                TextView.subHeadingText(
                    text: AppStrings().signUpToContinue, context: context),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                slidingSegment(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                firstNameField(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                lastNameField(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                emailField(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                contactField(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                phoneSMSCheckBox(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                passwordField(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                rePasswordField(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                agreeTermsCheckBox(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                signUpButton(model),
                UiSpacer.verticalSpace(space: 0.015, context: context),
                alreadyHaveAccount()
              ],
            ),
          );
        });
  }

  Widget slidingSegment(RegisterViewModel model) {
    return SizedBox(
      width: screenWidth,
      child: CupertinoSlidingSegmentedControl<Sky>(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        backgroundColor: AppColor.buttonDisableColor,
        thumbColor: selectedThumbColor[model.selectedSegment]!,
        groupValue: model.selectedSegment,
        onValueChanged: (Sky? value) {
          if (model.isBusy == false) {
            setState(() {
              model.selectedSegment = value;
            });
          }
        },
        children: <Sky, Widget>{
          Sky.traveller: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 9,
              ),
              child: TextView.semiBoldText(
                  textColor: selectedTextColor[model.selectedSegment]!,
                  text: AppStrings().traveller,
                  context: context)),
          Sky.guide: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 9,
              ),
              child: TextView.semiBoldText(
                  textColor: unSelectedTextColor[model.selectedSegment]!,
                  text: AppStrings().localite,
                  context: context))
        },
      ),
    );
  }

  Widget emailField(RegisterViewModel model) {
    return TextFormField(
      controller: model.emailController,
      enabled: model.isBusy ? false : true,
      onTap: () {
        model.isPwValShow = false;
        model.notifyListeners();
      },
      // onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.disabled,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(
          context, AppStrings().enterEmail, AppImages().svgImages.icEmail, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == "" || value == null) {
          model.isSigunUpButtonEnable = false;
          model.notifyListeners();
          return AppStrings().enterEmail;
        } else if (GlobalUtility().validateEmail(value.toString()) == false) {
          model.isSigunUpButtonEnable = false;
          model.notifyListeners();
          return AppStrings().emailErrorString;
        }
        return null;
      },
    );
  }

  Widget firstNameField(RegisterViewModel model) {
    return TextFormField(
      controller: model.firstNameController,
      onTap: () {
        model.isPwValShow = false;
        model.notifyListeners();
      },
      enabled: model.isBusy ? false : true,
      textCapitalization: TextCapitalization.words,
      // onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      maxLength: 50,
      autovalidateMode: AutovalidateMode.disabled,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(
          context, AppStrings().enterName, AppImages().svgImages.icName, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == "" || value == null) {
          model.isSigunUpButtonEnable = false;
          model.notifyListeners();
          return AppStrings().enterFirstString;
        } else if (value.trim().isEmpty) {
          model.isSigunUpButtonEnable = false;
          model.notifyListeners();
          return AppStrings().blankSpace;
        } else if (value.toString().length < 2) {
          model.isSigunUpButtonEnable = false;
          model.notifyListeners();
          return AppStrings().nameErrorString;
        }
        return null;
      },
    );
  }

  Widget lastNameField(RegisterViewModel model) {
    return TextFormField(
      controller: model.lastNameController,
      enabled: model.isBusy ? false : true,
      onTap: () {
        model.isPwValShow = false;
        model.notifyListeners();
      },
      maxLength: 50,
      // onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.disabled,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(context,
          AppStrings().enterLastName, AppImages().svgImages.icName, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null) {
          model.isSigunUpButtonEnable = false;
          model.notifyListeners();
          return 'Please enter your last name';
        }
        return null;
      },
    );
  }

  Widget passwordField(RegisterViewModel model) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        model.isPwValShow == true
            ? Container(
                height: screenHeight * 0.23,
                padding: const EdgeInsets.only(top: 10, left: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FlutterPwValidator(
                    controller: model.passwordController,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    defaultColor: Colors.red.shade700,
                    lowercaseCharCount: 1,
                    numericCharCount: 1,
                    successColor: Colors.green.shade700,
                    failureColor: Colors.red.shade700,
                    specialCharCount: 1,
                    width: 350,
                    height: 140,
                    onSuccess: () {
                      model.isPwValShow = false;
                      debugPrint("MATCHED");
                    },
                    onFail: () {
                      model.isPwValShow = true;
                      debugPrint("Not MATCHED");
                    }),
              )
            : const SizedBox(),
        Container(
          color: Colors.white,
          child: TextFormField(
            controller: model.passwordController,
            onTap: () {
              model.isPwValShow = true;
              model.notifyListeners();
            },
            enabled: model.isBusy ? false : true,
            obscureText: passwordSuffixVisibility,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            obscuringCharacter: "✯",
            autovalidateMode: AutovalidateMode.disabled,
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
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
                top: 10,
                bottom: 0,
              ),
              hintStyle: TextStyle(
                  color: AppColor.hintTextColor,
                  fontFamily: AppFonts.nunitoRegular,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
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
              return GlobalUtility().validatePassword(value!);
            },
            // onChanged: onTextFieldValueChanged(model),
          ),
        ),
      ],
    );
  }

  Widget rePasswordField(RegisterViewModel model) {
    return TextFormField(
      controller: model.confirmPasswordController,
      obscureText: rePasswordSuffixVisibility,
      enabled: model.isBusy ? false : true,
      onTap: () {
        model.isPwValShow = false;
        model.notifyListeners();
      },
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      obscuringCharacter: "✯",
      autovalidateMode: AutovalidateMode.disabled,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      // onChanged: onTextFieldValueChanged(model),
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
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
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
        return GlobalUtility().validatePassword(value!);
      },
    );
  }

  Widget agreeTermsCheckBox(RegisterViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: Checkbox(
            value: model.checkBoxVal,
            onChanged: (v) {
              if (model.isBusy == false) {
                setState(() {
                  model.checkBoxVal = v!;
                  model.notifyListeners();
                });

                model.isPwValShow = false;
                model.notifyListeners();
              }
            },
            side: BorderSide(color: AppColor.hintTextColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 5),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: AppStrings().agreeTerms,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoRegular,
                    color: AppColor.textBlack,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize)),
            TextSpan(
                text: AppStrings().termsCondition,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoSemiBold,
                    color: AppColor.appthemeColor,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsConditions()));
                  }),
          ]),
        )
      ],
    );
  }

  Widget phoneSMSCheckBox(RegisterViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: Checkbox(
            value: model.checkPhoneSms,
            onChanged: (v) {
              if (model.isBusy == false) {
                setState(() {
                  model.checkPhoneSms = v!;
                  model.notifyListeners();
                });
              }
            },
            side: BorderSide(color: AppColor.hintTextColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text("I consent to receiving SMS text messages from Imerzn.",
              maxLines: 2,
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.textBlack,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize)),
        ),
      ],
    );
  }

  Widget signUpButton(RegisterViewModel model) {
    return model.isBusy == false
            ? CommonButton.commonBoldTextButton(
                context: context,
                text: AppStrings().continueText,
                onPressed: () async {
                  if (validate(model)) {
                    model.generateRandomNumber();
                    if (model.checkBoxVal) {
                      captchaDialog(model);
                    } else {
                      GlobalUtility.showToast(context,
                          "By continuing, you agree to our terms of service and privacy policy");
                    }
                  }
                },
                isButtonEnable: true,
              )
            : CommonButton.commonLoadingButton(
                context: context,
              ) /*SizedBox(
            width: screenWidth * 0.1,
            child: Center(
              child: CircularProgressIndicator(color: AppColor.appthemeColor),
            ),
          )*/
        ;
  }

  captchaDialog(RegisterViewModel model) {
    GlobalUtility.showDialogFunction(
        context,
        Dialog(
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
              TextView.headingText(
                  text: "   ${model.firstNumber}   +   ${model.secNumber} =   ",
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
                        controller: model.captchaController,
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
                            borderSide: BorderSide(color: AppColor.blackColor),
                          ),
                        ),
                        enableInteractiveSelection: true,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                      )),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        AppSizes().widgetSize.buttonHeight,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (model.captchaController.text.replaceAll(" ", "") !=
                            "") {
                          int captchaResult =
                              model.firstNumber! + model.secNumber!;

                          if (captchaResult.toString() ==
                              model.captchaController.text) {
                            model.isVerified = true;
                            model.notifyListeners();
                            model.captchaController.clear();
                            if (model.isSigunUpButtonEnable) {
                              String roleName;
                              if (model.selectedSegment == Sky.traveller) {
                                roleName = Api.travellerRoleName;
                              } else {
                                roleName = Api.guideRoleName;
                              }

                              setState(() {
                                model.setBusy(true);
                              });

                              Navigator.pop(context);
                              GlobalUtility.showDialogFunction(
                                  context,
                                  confirmationDialog(roleName, () {
                                    Navigator.pop(context);
                                    model.processSignUp(
                                        context, roleName, model);
                                  }, model));
                            }
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
        ));
  }

  Widget alreadyHaveAccount() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
            text: AppStrings().alreadyHaveAccount,
            style: TextStyle(
                fontFamily: AppFonts.nunitoRegular,
                color: AppColor.dontHaveTextColor,
                fontSize: screenHeight * AppSizes().fontSize.normalFontSize)),
        TextSpan(
            text: AppStrings().signIn,
            style: TextStyle(
                fontFamily: AppFonts.nunitoSemiBold,
                color: AppColor.appthemeColor,
                fontSize: screenHeight * AppSizes().fontSize.normalFontSize),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                openLoginPage();
              }),
      ]),
    );
  }

  openLoginPage() {
    Navigator.pushNamed(context, AppRoutes.loginPage);
  }

  /*onTextFieldValueChanged(RegisterViewModel model) {
    if (model.emailController.text.isNotEmpty &&
        model.passwordController.text.isNotEmpty &&
        model.firstNameController.text.isNotEmpty &&
        model.confirmPasswordController.text.isNotEmpty &&
        model.userPhoneController.text.replaceAll(" ", "") != "") {
      model.isSigunUpButtonEnable = true;
    } else {
      model.isSigunUpButtonEnable = false;
    }
    // model.notifyListeners();
  }*/

  bool validate(RegisterViewModel model) {
    String firstName = model.firstNameController.text;
    String lastName = model.lastNameController.text;
    String email = model.emailController.text;
    String password = model.passwordController.text;
    String rePassword = model.confirmPasswordController.text;
    String contact = model.userPhoneController.text;
    if (firstName == "") {
      GlobalUtility.showToast(context, AppStrings().enterName);
      return false;
    } else if (GlobalUtility().validationName(firstName) &&
        firstName.length < 2) {
      GlobalUtility.showToast(context,
          "Name should be of minimum 2 length, which contains only alphabets and white space");
      return false;
    } else if (lastName == "") {
      GlobalUtility.showToast(context, AppStrings().enterLastName);
      return false;
    } else if (GlobalUtility().validationName(lastName) &&
        lastName.length < 2) {
      GlobalUtility.showToast(context,
          "Name should be of minimum 2 length, which contains only alphabets and white space");
      return false;
    }
    if (email == "") {
      GlobalUtility.showToast(context, AppStrings().enterEmail);
      return false;
    } else if (!GlobalUtility().validatedEmail(email.toString())) {
      GlobalUtility.showToast(context, AppStrings().enterValidEmail);
      return false;
    } else if (contact == "") {
      GlobalUtility.showToast(context, AppStrings().enterPhoneNumber);
      return false;
    } else if (contact.length < 6) {
      GlobalUtility.showToast(context, AppStrings().enterValidPhoneNumber);
      return false;
    } else if (model.checkPhoneSms == false) {
      GlobalUtility.showToast(
          context, "Please agree for receiving sms text from Siesta.");
      return false;
    } else if (password == "") {
      GlobalUtility.showToast(context, AppStrings().enterPassword);
      return false;
    } else if (!GlobalUtility().validationPassword(password)) {
      GlobalUtility.showToast(context, AppStrings().passwordErrorString);
      return false;
    }
    if (rePassword == "") {
      GlobalUtility.showToast(context, AppStrings().enterRePassword);
      return false;
    } else if (rePassword != password) {
      GlobalUtility.showToast(context, AppStrings().reEnterPassword);
      return false;
    }
    return true;
  }

  confirmationDialog(String role, VoidCallback onTapYes, model) {
    if (role == "TRAVELLER") {
      role = "TRAVELER";
    } else if (role == "GUIDE") {
      role = "LOCALITE";
    }
    return Dialog(
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.03),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TextView.mediumText(
              textAlign: TextAlign.center,
              context: context,
              text:
                  "Please confirm you want to sign up as a $role with Siesta Travel.",
              textColor: AppColor.textColorBlack,
              textSize: AppSizes().fontSize.normalFontSize,
              fontFamily: AppFonts.nunitoBold),
          UiSpacer.verticalSpace(context: context, space: 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  model.setBusy(false);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.textbuttonColors,
                    border: Border.all(color: AppColor.textbuttonColor),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextView.mediumText(
                      textAlign: TextAlign.center,
                      context: context,
                      text: "Cancel",
                      textColor: AppColor.textbuttonColor,
                      textSize: AppSizes().fontSize.normalFontSize,
                      fontFamily: AppFonts.nunitoSemiBold),
                ),
              ),
              InkWell(
                onTap: onTapYes,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.appthemeColor,
                    border: Border.all(color: AppColor.appthemeColor),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextView.mediumText(
                      textAlign: TextAlign.center,
                      context: context,
                      text: "Yes",
                      textColor: AppColor.whiteColor,
                      textSize: AppSizes().fontSize.normalFontSize,
                      fontFamily: AppFonts.nunitoSemiBold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget contactField(RegisterViewModel model) {
    return TextFormField(
      controller: model.userPhoneController,
      enabled: model.isBusy ? false : true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == "" || value == null) {
          model.isSigunUpButtonEnable = false;
          model.notifyListeners();
          return AppStrings().enterPhoneNumber;
        } else if (value.trim().isEmpty) {
          model.isSigunUpButtonEnable = false;
          model.notifyListeners();
          return AppStrings().blankSpace;
        } else if (value.length < 6) {
          model.isSigunUpButtonEnable = false;
          model.notifyListeners();
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          if (value.replaceAll(" ", "") == "") {
            model.isSigunUpButtonEnable = false;
          } else {
            model.isSigunUpButtonEnable = true;
          }
          // onTextFieldValueChanged(model);
        });
        model.notifyListeners();
      },
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      maxLength: 16,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: InputDecoration(
        hintText: AppStrings().contactNumber,
        prefixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  if (model.isBusy == false) {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      countryListTheme: CountryListThemeData(
                        flagSize: 25,
                        backgroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 16, color: Colors.blueGrey),
                        bottomSheetHeight: 500,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        inputDecoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Start typing to search',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8C98A8).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      onSelect: (Country country) {
                        model.countryCode = '+${country.phoneCode}';

                        model.countryCodeIso = country.countryCode;

                        model.notifyListeners();
                        debugPrint(
                            "country.phoneCode --- ${country.phoneCode}-- ${country.countryCode}");
                      },
                    );
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 8),
                      child: Text(
                          model.countryCode == "" ? "+1" : model.countryCode),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                            AppImages().svgImages.chevronDown)),
                  ],
                ),
              ),
            ]),
        counterText: "",
        hintStyle: TextStyle(
            color: AppColor.hintTextColor,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: MediaQuery.of(context).size.height *
                AppSizes().fontSize.simpleFontSize),
        contentPadding: const EdgeInsets.only(top: 20, bottom: 2),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldEnableColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
        ),
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
    );
  }
}
