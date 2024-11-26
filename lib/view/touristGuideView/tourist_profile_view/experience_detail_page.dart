import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_images.dart';
import '../../../app_constants/app_routes.dart';
import '../../../app_constants/app_strings.dart';
import '../../../common_widgets/common_textview.dart';
import '../../../common_widgets/vertical_size_box.dart';
import '../../../custom_widgets/custom_video_thumbnail.dart';

class ExperienceDetailPage extends StatefulWidget {
  const ExperienceDetailPage({super.key});

  @override
  State<ExperienceDetailPage> createState() => _ExperienceDetailPageState();
}

class _ExperienceDetailPageState extends State<ExperienceDetailPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  List<String> mediaList = [
    AppImages().dummyImage,
    AppImages().dummyImage,
    AppImages().dummyImage,
    AppImages().dummyImage,
    AppImages().dummyImage,
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
          centerTitle: true,
          backgroundColor: AppColor.appthemeColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: TextView.headingWhiteText(
              text: AppStrings.specialExperience, context: context),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.createGeneralPage,
                      arguments: {"type": "experience", "screenType": "edit"});
                },
                icon: Icon(
                  Icons.edit,
                  size: 20,
                ))
          ],
        ),

        // body
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(screenWidth * 0.04),
          children: [
            // title, location
            titleLocationView(),
            UiSpacer.verticalSpace(context: context, space: 0.04),

            // Image view
            imageView(),
            UiSpacer.verticalSpace(context: context, space: 0.06),

            // details view
            detailsView(),
            UiSpacer.verticalSpace(context: context, space: 0.06),

            // description view
            descriptionView(),
          ],
        ));
  }

  Widget titleLocationView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.headingText(
          context: context,
          text: "Title Text Title Text Title Text Title Text Title Text",
          color: AppColor.blackColor,
          fontSize: screenHeight * 0.026,
          textAlign: TextAlign.start,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),
        Row(
          children: [
            SvgPicture.asset(
              AppImages().svgImages.icLocation,
              color: AppColor.greyColor600,
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
                textColor: AppColor.greyColor600,
                maxLines: 2,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget imageView() {
    return Wrap(
      spacing: screenWidth * 0.04,
      runSpacing: screenHeight * 0.02,
      alignment: WrapAlignment.spaceBetween,
      children: mediaList.asMap().entries.map((entry) {
        int index = entry.key;

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: screenHeight * getHeight(index),
            width: screenWidth * getWidth(index),
            child: CustomVideoThumbnail(),
          )
          /*CommonImageView.rectangleNetworkImage(
            imgUrl: mediaList[index],
            height: screenHeight * getHeight(index),
            width: screenWidth * getWidth(index),
          )*/
          ,
        );
      }).toList(),
    );
  }

  Widget detailsView() {
    return Container(
      // padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.greyColor500),
      ),
      child: Column(
        children: [
          UiSpacer.verticalSpace(context: context, space: 0.01),
          detailTile("\$30/person", null, titleSize: 0.024),
          detailTile("People", "3-6"),
          detailTile("Transport", "Car, Bike"),
          detailTile("Accessibility", "No"),
          detailTile("Duration", "5 days"),
          detailTile("Time", "11:45 PM"),
          detailTile("Pick-up", "Huston, USA"),
          detailTile("Drop-off", "Arizona, USA", showDivider: false),
          UiSpacer.verticalSpace(context: context, space: 0.01),
        ],
      ),
    );
  }

  Widget detailTile(String title, String? msg,
      {bool? showDivider = true, double? titleSize}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(top: screenHeight * 0.01),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextView.mediumText(
                context: context,
                text: title,
                textColor: AppColor.greyColor,
                textSize: titleSize ?? 0.018,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
              ),
              if (msg != null)
                TextView.mediumText(
                  context: context,
                  text: msg,
                  textColor: AppColor.greyColor500,
                  textSize: 0.018,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start,
                ),
            ],
          ),
        ),
        if (showDivider == true)
          Divider(
            color: AppColor.greyColor500,
            thickness: 1,
            height: screenHeight * 0.035,
          ),
      ],
    );
  }

  Widget descriptionView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.headingText(
          context: context,
          text: "What you’ll do",
          color: AppColor.greyColor,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),
        TextView.mediumText(
          context: context,
          text: AppStrings().dummyText,
          textColor: AppColor.greyColor500,
          textSize: 0.018,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  double getHeight(int index) {
    switch (index) {
      case 0:
        {
          return 0.4;
        }
      case 1:
        {
          return 0.1;
        }
      case 2:
        {
          return 0.1;
        }
      case 3:
        {
          return 0.1;
        }
      case 4:
        {
          return 0.25;
        }
    }

    return 0.1;
  }

  double getWidth(int index) {
    switch (index) {
      case 0:
        {
          return double.infinity;
        }
      case 1:
        {
          return double.infinity;
        }
      case 2:
        {
          return 0.435;
        }
      case 3:
        {
          return 0.435;
        }
      case 4:
        {
          return double.infinity;
        }
    }

    return double.infinity;
  }
}
