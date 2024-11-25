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
import 'package:Siesta/view_models/forgot_password.view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isForgotButtonEnable = false;


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
   return  ViewModelBuilder<ForgotPasswordViewModel>.reactive(
        viewModelBuilder: () => ForgotPasswordViewModel(context),
       onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColor.whiteColor,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.loginPage);
                  },
                  icon: Icon(Icons.arrow_back, color: AppColor.blackColor)
              ),
            ),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(
                  screenWidth * AppSizes().widgetSize.horizontalPadding),
              children: [
                UiSpacer.verticalSpace(space: 0.02, context: context),
                CommonImageView.largeSvgImageView(
                    imagePath: AppImages().svgImages.ivForgotPasswod),
                UiSpacer.verticalSpace(space: 0.03, context: context),
                TextView.headingText(
                  text: AppStrings().forgotPassword,
                  context: context,
                ),
                UiSpacer.verticalSpace(space: 0.01, context: context),
                TextView.subHeadingText(
                    text: AppStrings().forgotPasswordDetail, context: context),
                UiSpacer.verticalSpace(space: 0.03, context: context),
                forgotEmailField(model),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                forgotButton(model)
              ],
            ),
          );
        } );
  }

  Widget forgotEmailField(ForgotPasswordViewModel model) {
    return TextFormField(
      controller: model.forgotEmailController,
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
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (GlobalUtility().validateEmail(value.toString()) == false) {
          isForgotButtonEnable = false;
          return AppStrings().emailErrorString;
        } else if (value == "" || value == null) {
          isForgotButtonEnable = false;
          return null;
        }
        return null;
      },
      onChanged: (value,) {
        if (model.forgotEmailController.text.replaceAll(" ", "") != "") {
            isForgotButtonEnable = true;
            model.notifyListeners();
        }
      },
    );
  }

  Widget forgotButton(ForgotPasswordViewModel model) {
    return 
    model.isBusy == false ? 
    CommonButton.commonBoldTextButton(
        context: context,
        text: AppStrings().submit,
        onPressed: () {
         
          if (validate(model)) {
            if (isForgotButtonEnable) {
            model.processForgotPassword(context);
          }
          }
          debugPrint("forgot password button is enabled");
        },
        isButtonEnable: isForgotButtonEnable)
         : SizedBox(
            width: screenWidth * 0.1,
            child: Center(
              child: CircularProgressIndicator(color: AppColor.appthemeColor),
            ),
          );
  }


  bool validate(ForgotPasswordViewModel model) {
  String email = model.forgotEmailController.text;
  if (email.replaceAll(" ", "") == "") {
    GlobalUtility.showToast(context, AppStrings().enterEmail);
    return false;
  } else if (!GlobalUtility().validatedEmail(email.toString())) {
    GlobalUtility.showToast(context, AppStrings().enterValidEmail);
    return false;
  }

  return true;
}

}
