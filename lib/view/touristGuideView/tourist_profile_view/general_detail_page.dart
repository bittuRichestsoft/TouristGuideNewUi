import 'dart:io';

import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_images.dart';
import '../../../app_constants/app_strings.dart';
import '../../../common_widgets/common_imageview.dart';
import '../../../common_widgets/common_textview.dart';

class GeneralDetailPage extends StatefulWidget {
  const GeneralDetailPage({super.key});

  @override
  State<GeneralDetailPage> createState() => _GeneralDetailPageState();
}

class _GeneralDetailPageState extends State<GeneralDetailPage> {
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
      // appbar
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
            text: AppStrings.generalPlannerDetails, context: context),
      ),

      // body
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(screenWidth * 0.04),
        children: [
          TextView.headingText(
            context: context,
            text: "General Planner",
            color: AppColor.blackColor,
            fontSize: screenHeight * 0.026,
          ),
          UiSpacer.verticalSpace(context: context, space: 0.01),
          TextView.mediumText(
            context: context,
            text: "Check out the detail of place and experience",
            textColor: AppColor.blackColor,
            textSize: 0.018,
            fontWeight: FontWeight.w400,
          ),
          Divider(),
          UiSpacer.verticalSpace(context: context, space: 0.01),

          // details
          detailsView(),
          UiSpacer.verticalSpace(context: context, space: 0.02),

          // Image view
          imageView(),
          UiSpacer.verticalSpace(context: context, space: 0.02),

          // description view
          TextView.mediumText(
            context: context,
            text: AppStrings().dummyText,
            textColor: AppColor.greyColor500,
            textSize: 0.018,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget detailsView() {
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
          child: CommonImageView.rectangleNetworkImage(
            imgUrl: mediaList[index],
            height: screenHeight * getHeight(index),
            width: screenWidth * getWidth(index),
          ),
        );
      }).toList(),
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
          return 0.43;
        }
      case 3:
        {
          return 0.43;
        }
      case 4:
        {
          return double.infinity;
        }
    }

    return double.infinity;
  }

  Future<Widget> thumbnailVideo() async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video:
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );

    return fileName == null ? SizedBox() : Image.file(File(fileName));
  }
}