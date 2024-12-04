import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_constants/app_images.dart';
import '../common_widgets/vertical_size_box.dart';

class CommonWidgets {
  Widget inPageLoader() {
    return Center(
      child: Container(
          color: Colors.transparent,
          child: CircularProgressIndicator(
            color: AppColor.appthemeColor,
          )),
    );
  }

  Widget inAppErrorWidget(String errorMsg, VoidCallback onTap,
      {required BuildContext context}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppImages().svgImages.ivNoGallery,
                height: screenHeight * 0.15,
              ),
              UiSpacer.verticalSpace(context: context, space: 0.02),
              TextView.headingText(
                  context: context,
                  text: errorMsg,
                  fontSize: screenHeight * 0.02
                  // style: AppTextStyles.anton_400w_26_0Blue,
                  ),
              SizedBox(height: 10),
              SizedBox(
                width: screenWidth * 0.3,
                height: screenHeight * 0.06,
                child: CommonButton.commonNormalButton(
                  context: context,
                  onPressed: onTap,
                  text: "Refresh",
                ),
              ),
            ],
          )),
    );
  }

  Widget emptyStateWidget(
      {String? title, String? description, required BuildContext context}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          AppImages().svgImages.ivNoGallery,
          height: screenHeight * 0.15,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),
        TextView.headingText(
            context: context,
            textAlign: TextAlign.center,
            text: title ?? "No Data Available"),
        UiSpacer.verticalSpace(context: context, space: 0.02),
        TextView.mediumText(
          context: context,
          text: description ?? "",
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
