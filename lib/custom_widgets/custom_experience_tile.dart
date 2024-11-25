import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_constants/app_color.dart';
import '../app_constants/app_images.dart';
import '../app_constants/app_strings.dart';
import '../common_widgets/common_imageview.dart';
import '../common_widgets/common_textview.dart';

class CustomExperienceTile extends StatefulWidget {
  const CustomExperienceTile({super.key});

  @override
  State<CustomExperienceTile> createState() => _CustomExperienceTileState();
}

class _CustomExperienceTileState extends State<CustomExperienceTile> {
  double screenWidth = 0.0, screenHeight = 0.0;
  int curIndex = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1st Image
        SizedBox(
          height: screenHeight * 0.36,
          width: screenWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CommonImageView.rectangleNetworkImage(
              imgUrl: AppImages().dummyImage,
            ),
          ),
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // 2nd Image
        SizedBox(
          height: screenHeight * 0.25,
          width: screenWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CommonImageView.rectangleNetworkImage(
              imgUrl: AppImages().dummyImage,
            ),
          ),
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // 3rd image
        SizedBox(
          height: screenHeight * 0.15,
          width: screenWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CommonImageView.rectangleNetworkImage(
              imgUrl: AppImages().dummyImage,
            ),
          ),
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.greyColor500),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // location, share, like and count
              Row(
                children: [
                  SvgPicture.asset(
                    AppImages().svgImages.icLocation,
                    color: AppColor.greyColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextView.mediumText(
                      context: context,
                      text: "Belgium, Europe",
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w400,
                      textColor: AppColor.greyColor,
                      maxLines: 2,
                    ),
                  ),
                  // Share button
                  IconButton(
                    onPressed: () {},
                    splashRadius: screenHeight * 0.025,
                    icon: SvgPicture.asset(
                      AppImages().svgImages.icShare,
                      color: AppColor.greyColor500,
                    ),
                  ),

                  // Like button
                  IconButton(
                    onPressed: () {},
                    splashRadius: screenHeight * 0.025,
                    icon: Icon(
                      CupertinoIcons.heart,
                      color: AppColor.greyColor500,
                    ),
                  ),
                  TextView.mediumText(
                    context: context,
                    text: "50.1k",
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w400,
                    textColor: AppColor.greyColor500,
                    maxLines: 2,
                  ),
                ],
              ),

              // star and time
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppColor.greyColor,
                        size: 22,
                      ),
                      UiSpacer.horizontalSpace(context: context, space: 0.02),
                      TextView.mediumText(
                        context: context,
                        text: "4.0 (40)",
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w400,
                        textColor: AppColor.greyColor,
                        maxLines: 2,
                      )
                    ],
                  ),
                  UiSpacer.horizontalSpace(context: context, space: 0.06),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColor.greyColor,
                        size: 20,
                      ),
                      UiSpacer.horizontalSpace(context: context, space: 0.02),
                      TextView.mediumText(
                        context: context,
                        text: "4:45 hrs",
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w400,
                        textColor: AppColor.greyColor,
                        maxLines: 2,
                      )
                    ],
                  )
                ],
              ),
              UiSpacer.verticalSpace(context: context, space: 0.02),

              // title
              TextView.mediumText(
                context: context,
                text:
                    "sdfn sfjdghfldsbfjkbd sd fadsf adsf dsf dsfd fds dsf dsf ds fds dsa",
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w500,
                textColor: AppColor.greyColor,
                maxLines: 2,
              ),
              UiSpacer.verticalSpace(context: context, space: 0.01),

              // description
              TextView.mediumText(
                context: context,
                text: AppStrings().dummyText,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w400,
                textColor: AppColor.greyColor500,
                maxLines: 3,
              ),
              UiSpacer.verticalSpace(context: context, space: 0.02),

              // see more
              Text(
                "See more",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  color: AppColor.greyColor,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
