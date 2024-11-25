import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';

class EmailVerifiedDialog extends StatefulWidget {
  const EmailVerifiedDialog({Key? key}) : super(key: key);

  @override
  State<EmailVerifiedDialog> createState() => _EmailVerifiedDialogState();
}

class _EmailVerifiedDialogState extends State<EmailVerifiedDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
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
          UiSpacer.verticalSpace(space: 0.02, context: context),
          CommonImageView.largeAssestImageView(
              imagePath: AppImages().pngImages.ivEmailVerified, ctx: context),
          UiSpacer.verticalSpace(space: 0.03, context: context),
          TextView.headingText(text: AppStrings().checkEmail, context: context),
          UiSpacer.verticalSpace(space: 0.01, context: context),
          TextView.subHeadingText(
              text: AppStrings().emailIns, context: context),
          UiSpacer.verticalSpace(space: 0.015, context: context),
          okayButton(),
          UiSpacer.verticalSpace(space: 0.02, context: context),
        ],
      ),
    );
  }

  Widget okayButton() {
    return CommonButton.commonThemeColorButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRoutes.loginPage);
          //Navigator.pushNamed(context, AppRoutes.createPassword);
        },
        text: AppStrings().Okay,
        context: context);
  }

  openCreatePage() {
    Navigator.pushNamed(context, AppRoutes.createPassword);
  }
}
