import 'package:flutter/material.dart';

import '../app_constants/app_color.dart';
import '../app_constants/app_images.dart';
import '../app_constants/app_strings.dart';
import '../common_widgets/common_imageview.dart';
import '../common_widgets/common_textview.dart';
import '../common_widgets/vertical_size_box.dart';

class CustomTravellerExperienceTile extends StatefulWidget {
  const CustomTravellerExperienceTile({super.key});

  @override
  State<CustomTravellerExperienceTile> createState() =>
      _CustomTravellerExperienceTileState();
}

class _CustomTravellerExperienceTileState
    extends State<CustomTravellerExperienceTile> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CommonImageView.rectangleNetworkImage(
            imgUrl: AppImages().dummyImage,
            height: screenHeight * 0.35,
            width: screenWidth,
          ),
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),

        // title
        TextView.mediumText(
          context: context,
          text: AppStrings().dummyText,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w500,
          textColor: AppColor.greyColor,
          maxLines: 1,
          textSize: 0.018,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),

        // price per person
        Row(
          children: [
            TextView.mediumText(
              context: context,
              text: "Price / person",
              fontWeight: FontWeight.w400,
              textColor: AppColor.greyColor500,
              textSize: 0.016,
            ),
            TextView.mediumText(
              context: context,
              text: "  \$1000",
              fontWeight: FontWeight.w500,
              textColor: AppColor.greyColor,
              textSize: 0.018,
            ),
          ],
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),

        // star
        Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: AppColor.greyColor,
                  size: 20,
                ),
                UiSpacer.horizontalSpace(context: context, space: 0.02),
                TextView.mediumText(
                  context: context,
                  text: "4.9",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w400,
                  textColor: AppColor.greyColor500,
                  maxLines: 2,
                  textSize: 0.016,
                )
              ],
            ),
            UiSpacer.horizontalSpace(context: context, space: 0.04),
            Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.greyColor,
              ),
            ),
            UiSpacer.horizontalSpace(context: context, space: 0.04),
            TextView.mediumText(
              context: context,
              text: "5 days",
              fontWeight: FontWeight.w400,
              textColor: AppColor.greyColor500,
              textSize: 0.016,
            )
          ],
        ),
      ],
    );
  }
}
