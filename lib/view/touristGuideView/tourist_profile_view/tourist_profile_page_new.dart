import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/custom_widgets/custom_experience_tile.dart';
import 'package:Siesta/custom_widgets/custom_gallery_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_images.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../common_widgets/common_button.dart';
import '../../../common_widgets/common_imageview.dart';
import '../../../common_widgets/common_textview.dart';
import '../../../common_widgets/vertical_size_box.dart';

class TouristProfilePageNew extends StatefulWidget {
  const TouristProfilePageNew({super.key});

  @override
  State<TouristProfilePageNew> createState() => _TouristProfilePageNewState();
}

class _TouristProfilePageNewState extends State<TouristProfilePageNew> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Cover and profile photo
          profileImageView(AppImages().dummyImage),
          UiSpacer.verticalSpace(
              space: AppSizes().widgetSize.normalPadding, context: context),

          // Profile description
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile desc
                profileDescription(),
                UiSpacer.verticalSpace(context: context, space: 0.03),

                // Buttons view
                buttonsView(),
                UiSpacer.verticalSpace(context: context, space: 0.05),

                // Gallery view
                galleryView(),
                UiSpacer.verticalSpace(context: context, space: 0.05),

                // general planner
                generalPlannerView(),
                UiSpacer.verticalSpace(context: context, space: 0.05),

                // special experience
                specialExperienceView(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget profileImageView(img) {
    return Container(
      height: screenHeight * 0.44,
      child: Stack(
        children: [
          Container(
            height: screenHeight * 0.4,
            width: screenWidth,
            child: CommonImageView.rectangleNetworkImage(imgUrl: img),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CircleAvatar(
              radius: screenWidth * 0.17,
              child: Container(
                  width: screenWidth * 0.35,
                  height: screenWidth * 0.35,
                  decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      border: Border.all(
                          color: AppColor.buttonDisableColor, width: 3),
                      shape: BoxShape.circle,
                      image: img != null && img != ""
                          ? DecorationImage(
                              fit: BoxFit.fill, image: NetworkImage(img))
                          : DecorationImage(
                              image: AssetImage(AppImages()
                                  .pngImages
                                  .icProfilePlaceholder)))),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileDescription() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        TextView.headingText(
          context: context,
          text: "Robert Luis",
          color: AppColor.blackColor,
          fontSize: screenHeight * 0.03,
        ),

        // host since
        TextView.mediumText(
          context: context,
          text: "Hosted since 2002",
          textColor: AppColor.hintTextColor,
          textSize: 0.015,
          fontWeight: FontWeight.w400,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.005),

        // Rating
        RatingBar.builder(
          wrapAlignment: WrapAlignment.start,
          initialRating: 4.5,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,
          unratedColor: AppColor.disableColor,
          itemCount: 5,
          itemSize: 20.0,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: AppColor.ratingbarColor,
          ),
          onRatingUpdate: (double value) {},
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // Bio
        TextView.mediumText(
          context: context,
          text: AppStrings().dummyText,
          textColor: AppColor.hintTextColor,
          textSize: 0.015,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget buttonsView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create Experience
        CommonButton.commonOutlineButtonWithIconText(
          context: context,
          text: "Create Experience",
          iconPath: AppImages().svgImages.icAdd,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.createGeneralPage,
                arguments: {"type": "experience"});
          },
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),

        // Create general
        CommonButton.commonOutlineButtonWithIconText(
          context: context,
          text: "Create General",
          iconPath: AppImages().svgImages.icAdd,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.createGeneralPage,
                arguments: {"type": "general"});
          },
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),

        // Create gallery
        CommonButton.commonOutlineButtonWithIconText(
          context: context,
          text: "Create Gallery",
          iconPath: AppImages().svgImages.icAdd,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.createGeneralPage,
                arguments: {"type": "gallery"});
          },
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),

        // Preview Profile
        CommonButton.commonOutlineButtonWithIconText(
          context: context,
          text: "Preview Profile",
          iconPath: AppImages().svgImages.icPreviewProfile,
          onPressed: () {},
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),

        // Edit profile
        CommonButton.commonOutlineButtonWithIconText(
          context: context,
          text: "Edit Profile",
          iconPath: AppImages().svgImages.icEditProfile,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.editGuideProfilePage);
          },
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),

        // Share profile
        CommonButton.commonOutlineButtonWithIconText(
          context: context,
          text: "Share profile",
          iconPath: AppImages().svgImages.icShare,
          onPressed: () {
            showShareProfileWidget();
          },
        ),
      ],
    );
  }

  Widget galleryView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        TextView.headingText(
          context: context,
          text: "Gallery",
          color: AppColor.blackColor,
          fontSize: screenHeight * 0.026,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return CustomGeneralTile(
              tileType: "gallery",
            );
          },
          separatorBuilder: (context, index) =>
              UiSpacer.verticalSpace(context: context, space: 0.02),
        )
      ],
    );
  }

  Widget generalPlannerView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // General planner heading
            TextView.headingText(
              context: context,
              text: "General Planner",
              color: AppColor.blackColor,
              fontSize: screenHeight * 0.026,
            ),

            // show more button
            SizedBox(
              height: screenHeight * 0.05,
              child: CommonButton.commonOutlineButtonWithTextIcon(
                context: context,
                text: "Show more",
                iconPath: AppImages().svgImages.arrowRight,
                borderRadius: 50,
                onPressed: () {},
              ),
            )
          ],
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return CustomGeneralTile(
              showDescription: false,
              tileType: "general",
            );
          },
          separatorBuilder: (context, index) =>
              UiSpacer.verticalSpace(context: context, space: 0.02),
        )
      ],
    );
  }

  Widget specialExperienceView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // General planner heading
            TextView.headingText(
              context: context,
              text: "Special Experience",
              color: AppColor.blackColor,
              fontSize: screenHeight * 0.026,
            ),

            // show more button
            SizedBox(
              height: screenHeight * 0.05,
              child: CommonButton.commonOutlineButtonWithTextIcon(
                context: context,
                text: "Show more",
                iconPath: AppImages().svgImages.arrowRight,
                borderRadius: 50,
                onPressed: () {},
              ),
            )
          ],
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return CustomExperienceTile();
          },
          separatorBuilder: (context, index) =>
              UiSpacer.verticalSpace(context: context, space: 0.02),
        )
      ],
    );
  }

  void showShareProfileWidget() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView.headingText(
                      context: context,
                      text: "Profile Sharing",
                      color: AppColor.blackColor,
                      fontSize: screenHeight * 0.022,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close))
                  ],
                ),
                Divider(),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // profile img, name, rating etc
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonImageView.roundNetworkImage(
                              imgUrl: AppImages().dummyImage,
                              width: screenWidth * 0.22,
                              height: screenWidth * 0.22,
                            ),
                            UiSpacer.horizontalSpace(
                                context: context, space: 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // name
                                  TextView.headingText(
                                    context: context,
                                    text: "Robert Luis",
                                    color: AppColor.blackColor,
                                    fontSize: screenHeight * 0.022,
                                    maxLines: 1,
                                  ),
                                  TextView.mediumText(
                                    context: context,
                                    text: "Hosted since",
                                    textColor: AppColor.hintTextColor,
                                    textSize: 0.015,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  TextView.mediumText(
                                    context: context,
                                    text: "2002",
                                    textColor: AppColor.hintTextColor,
                                    textSize: 0.015,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  UiSpacer.verticalSpace(
                                      context: context, space: 0.005),

                                  // Rating
                                  RatingBar.builder(
                                    wrapAlignment: WrapAlignment.start,
                                    initialRating: 4.5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    ignoreGestures: true,
                                    unratedColor: AppColor.disableColor,
                                    itemCount: 5,
                                    itemSize: 18.0,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: AppColor.ratingbarColor,
                                    ),
                                    onRatingUpdate: (double value) {},
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.01),
                        Divider(),
                        UiSpacer.verticalSpace(context: context, space: 0.01),
                        TextView.headingText(
                          context: context,
                          text: "Bio",
                          color: AppColor.blackColor,
                          fontSize: screenHeight * 0.022,
                          maxLines: 1,
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.01),
                        TextView.mediumText(
                          context: context,
                          text: "This is dummy description",
                          textSize: 0.016,
                          textColor: AppColor.greyColor500,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                UiSpacer.verticalSpace(context: context, space: 0.02),
                Center(
                  child: CommonImageView.rectangleNetworkImage(
                    imgUrl: AppImages().dummyImage,
                    height: screenHeight * 0.12,
                    width: screenHeight * 0.12,
                  ),
                ),
                UiSpacer.verticalSpace(context: context, space: 0.02),
                Center(
                  child: TextView.mediumText(
                    context: context,
                    text: "Scan the QR code to get in touch with me.",
                    textColor: AppColor.greyColor,
                    textSize: 0.016,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(),

                // Social Link
                TextView.headingText(
                  context: context,
                  text: "Social Links",
                  color: AppColor.blackColor,
                  fontSize: screenHeight * 0.022,
                ),
                UiSpacer.verticalSpace(context: context, space: 0.02),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.greyColor500),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextView.mediumText(
                        context: context,
                        text: "ABCDEF",
                        textSize: 0.018,
                        textColor: AppColor.greyColor500,
                      ),
                      Icon(
                        Icons.copy,
                        color: AppColor.greyColor500,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
