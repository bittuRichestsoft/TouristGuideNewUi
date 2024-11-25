import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_constants/app_color.dart';
import '../app_constants/app_images.dart';
import '../app_constants/app_strings.dart';
import '../common_widgets/common_imageview.dart';
import '../common_widgets/common_textview.dart';

class CustomGeneralTile extends StatefulWidget {
  const CustomGeneralTile(
      {super.key, this.showDescription = true, required this.tileType});
  final bool showDescription;
  final String tileType;

  @override
  State<CustomGeneralTile> createState() => _CustomGeneralTileState();
}

class _CustomGeneralTileState extends State<CustomGeneralTile> {
  double screenWidth = 0.0, screenHeight = 0.0;
  int curIndex = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.generalDetailPage);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.greyColor500),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight * 0.2,
                minWidth: screenWidth,
                maxHeight: screenHeight * 0.5,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: CarouselSlider.builder(
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            CommonImageView.rectangleNetworkImage(
                          imgUrl: AppImages().dummyImage,
                        ),
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 9 / 16,
                          onPageChanged: (index, reason) {
                            curIndex = index;
                            setState(() {});
                          },
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                        ),
                      ),
                    ),

                    // count Text
                    Positioned(
                        top: 10,
                        right: 10,
                        child: TextView.mediumText(
                          context: context,
                          text: "${curIndex + 1}/4",
                          fontWeight: FontWeight.w400,
                          textColor: AppColor.blackColor,
                          maxLines: 3,
                        )),

                    // Dots
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 20,
                        child: DotsIndicator(
                          dotsCount: 4,
                          position: curIndex,
                          decorator: DotsDecorator(
                            color: AppColor.greyColor500, // Inactive color
                            activeColor: AppColor.blackColor,
                            spacing: EdgeInsets.symmetric(horizontal: 5),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // title, share, like and count
                  Row(
                    children: [
                      // title
                      Expanded(
                        child: TextView.mediumText(
                          context: context,
                          text:
                              "sdfn sfjdghfldsbfjkbd sd fadsf adsf dsf dsfd fds dsf dsf ds fds dsa",
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

                  // location
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
                      )
                    ],
                  ),
                  if (widget.showDescription == true)
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  // description
                  if (widget.showDescription == true)
                    TextView.mediumText(
                      context: context,
                      text: AppStrings().dummyText,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w400,
                      textColor: AppColor.greyColor500,
                      maxLines: 3,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
