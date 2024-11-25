// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view_models/login.view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool passwordSuffixVisibility = true;
  BuildContext? viewContext;

  var emailErrorText = "";
  bool checkBoxVal = true;

  @override
  Widget build(BuildContext context) {
    viewContext = context;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: AppColor.whiteColor,
              bottomNavigationBar: Container(
                height: screenHeight * 0.07,
                alignment: Alignment.topCenter,
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    Map map = {"from": "login"};
                    Navigator.pushNamed(context, AppRoutes.commonWebViewPage,
                        arguments: map);
                  },
                  child: Text(
                    AppStrings().aboutUs,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            AppSizes().fontSize.normalFontSize,
                        fontFamily: AppFonts.nunitoSemiBold,
                        decoration: TextDecoration.underline,
                        color: AppColor.forgotTextColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              body: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(
                    screenWidth * AppSizes().widgetSize.horizontalPadding),
                children: [
                  UiSpacer.verticalSpace(space: 0.05, context: context),
                  signInImage(),
                  UiSpacer.verticalSpace(space: 0.03, context: context),
                  TextView.headingText(
                      text: AppStrings().welcomeBack, context: context),
                  UiSpacer.verticalSpace(space: 0.01, context: context),
                  TextView.subHeadingText(
                      text: AppStrings().loginToContinue, context: context),
                  UiSpacer.verticalSpace(space: 0.04, context: context),
                  emailField(model),
                  UiSpacer.verticalSpace(space: 0.02, context: context),
                  passwordField(model),
                  UiSpacer.verticalSpace(space: 0.015, context: context),
                  GestureDetector(
                    onTap: () {
                      openForgotPage();
                    },
                    child: Text(
                      AppStrings().forgotPassword,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.normalFontSize,
                          fontFamily: AppFonts.nunitoSemiBold,
                          color: AppColor.forgotTextColor),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  UiSpacer.verticalSpace(space: 0.025, context: context),
                  logInButton(model, context),
                  UiSpacer.verticalSpace(space: 0.015, context: context),
                  donotHaveAccount(),
                ],
              ));
        });
  }

  Widget signInImage() {
    return CommonImageView.largeSvgImageView(
        imagePath: AppImages().svgImages.signInImage);
  }

  Widget emailField(LoginViewModel model) {
    return TextFormField(
      controller: model.emailController,
      enabled: model.isBusy ? false : true,
      autovalidateMode: AutovalidateMode.disabled,
      validator: (value) {
        if (value == "" || value == null) {
          model.isLoginButtonEnable = false;
          model.notifyListeners();
          return AppStrings().enterEmail;
        } else if (GlobalUtility().validateEmail(value.toString()) == false) {
          model.isLoginButtonEnable = false;
          model.notifyListeners();
          return AppStrings().emailErrorString;
        }
        return null;
      },
      onChanged: onTextFieldChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(
          context,
          AppStrings().enterEmail,
          AppImages().svgImages.icEmail,
          emailErrorText),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget passwordField(LoginViewModel model) {
    return TextFormField(
      enabled: model.isBusy ? false : true,
      controller: model.passwordController,
      obscureText: passwordSuffixVisibility,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      obscuringCharacter: "✯",
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

            // model.notifyListeners();
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
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
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
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
      ),
      autovalidateMode: AutovalidateMode.disabled,
      validator: (value) {
        if (value == "" || value == null) {
          model.isLoginButtonEnable = false;
          model.notifyListeners();
          return AppStrings().enterPassword;
        } else if (value.toString().length < 8) {
          model.isLoginButtonEnable = false;
          model.notifyListeners();
          return AppStrings().passwordErrorString;
        }
        return null;
      },
      onChanged: onTextFieldChanged(model),
    );
  }

  bool selectedValue = false;

  Widget logInButton(LoginViewModel model, context) {
    return model.isBusy == false
        ? CommonButton.commonBoldTextButton(
            context: context,
            text: AppStrings().logIn,
            onPressed: () {
              if (validate(model)) {
                if (model.isLoginButtonEnable) {
                  model.processLogin(context);
                }
              }
            },
            isButtonEnable: model.isLoginButtonEnable)
        : SizedBox(
            width: screenWidth * 0.1,
            child: Center(
              child: CircularProgressIndicator(color: AppColor.appthemeColor),
            ),
          );
  }

  Widget donotHaveAccount() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
            text: AppStrings().dontHaveAccount,
            style: TextStyle(
                fontFamily: AppFonts.nunitoRegular,
                color: AppColor.dontHaveTextColor,
                fontSize: screenHeight * AppSizes().fontSize.normalFontSize)),
        TextSpan(
            text: AppStrings().signUp,
            style: TextStyle(
                fontFamily: AppFonts.nunitoSemiBold,
                color: AppColor.appthemeColor,
                fontSize: screenHeight * AppSizes().fontSize.normalFontSize),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                openSignUpPage();
              }),
      ]),
    );
  }

  openSignUpPage() {
    Navigator.pushNamed(context, AppRoutes.signUpPage);
  }

  openForgotPage() {
    Navigator.pushNamed(context, AppRoutes.forgotPassword);
  }

  onTextFieldChanged(LoginViewModel model) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (model.emailController.text.toString().isNotEmpty &&
          model.passwordController.text.toString().isNotEmpty) {
        model.isLoginButtonEnable = true;
      } else {
        model.isLoginButtonEnable = false;
      }
      model.notifyListeners();
    });
  }

  bool validate(LoginViewModel model) {
    String email = model.emailController.text;
    String password = model.passwordController.text;

    if (email == "") {
      GlobalUtility.showToast(context, AppStrings().enterEmail);
      return false;
    }
    if (password == "") {
      GlobalUtility.showToast(context, AppStrings().enterPassword);
      return false;
    }

    return true;
  }
}
