import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ApiSuccessDialog extends StatefulWidget {
  ApiSuccessDialog(
      {Key? key,
      required String imagepath,
      required String titletext,
      required String buttonheading,
      required bool isPng,
      required String fromWhere})
      : super(key: key) {
    imagePath = imagepath;
    titleText = titletext;
    buttonText = buttonheading;
    isPngImage = isPng;
    from = fromWhere;
  }
  String? imagePath;
  String? titleText;
  String? dialogSubtitle;
  String? buttonText;
  bool? isPngImage;
  String? from;
  @override
  State<ApiSuccessDialog> createState() => _ApiSuccessDialogState();
}

class _ApiSuccessDialogState extends State<ApiSuccessDialog> {
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
          widget.isPngImage == true
              ? CommonImageView.largeAssestImageView(
                  imagePath: widget.imagePath, ctx: context)
              : CommonImageView.largeSvgImageView(imagePath: widget.imagePath),
          UiSpacer.verticalSpace(space: 0.02, context: context),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            child: TextView.subHeadingText(
                text: widget.titleText, context: context),
          ),
          UiSpacer.verticalSpace(space: 0.015, context: context),
          okayButton(),
          UiSpacer.verticalSpace(space: 0.02, context: context),
        ],
      ),
    );
  }

  Widget okayButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          AppSizes().widgetSize.buttonHeight,
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
          if (widget.from == "signUp") {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.loginPage, (route) => false);
          } else if (widget.from == "login-traveller") {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.createTravelerProfile, (route) => false);
          } else if (widget.from == "login-guide") {
            Navigator.pushReplacementNamed(
                context, AppRoutes.createTouristProfile);
          } else if (widget.from == "home-traveller") {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.travellerHomePage, (route) => false);
          } else if (widget.from == "home-guide") {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.touristGuideHome, (route) => false);
          }
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColor.appthemeColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.smallBorderRadius))),
        child: Text(
          widget.buttonText.toString(),
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.normalFontSize,
              color: AppColor.whiteColor,
              fontFamily: AppFonts.nunitoSemiBold),
        ),
      ),
    );
  }
}
