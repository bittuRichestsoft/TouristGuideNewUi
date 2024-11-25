import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:flutter/material.dart';
import '../app_constants/app_color.dart';
import 'vertical_size_box.dart';

class CommonSuccessDialog extends StatefulWidget {
  CommonSuccessDialog(
      {Key? key,
      required String imagepath,
      required String titletext,
      required String dialogSubText,
      required String buttonheading,
      required bool isPng,
      required String fromWhere})
      : super(key: key) {
    imagePath = imagepath;
    titleText = titletext;
    dialogSubtitle = dialogSubText;
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
  State<CommonSuccessDialog> createState() => _CommonSuccessDialogState();
}

class _CommonSuccessDialogState extends State<CommonSuccessDialog> {
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
          widget.isPngImage == true
              ? CommonImageView.largeAssestImageView(
                  imagePath: widget.imagePath, ctx: context)
              : CommonImageView.largeSvgImageView(imagePath: widget.imagePath),
          UiSpacer.verticalSpace(space: 0.03, context: context),
          widget.titleText != ""
              ? TextView.headingText(text: widget.titleText, context: context)
              : UiSpacer.emptySpace(),
          UiSpacer.verticalSpace(space: 0.01, context: context),
          TextView.subHeadingText(
              text: widget.dialogSubtitle, context: context),
          UiSpacer.verticalSpace(space: 0.022, context: context),
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
            Navigator.pushNamed(context, AppRoutes.createTravelerProfile);
          } else if (widget.from == "signUp-guide") {
            Navigator.pushNamed(context, AppRoutes.createTouristProfile);
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
