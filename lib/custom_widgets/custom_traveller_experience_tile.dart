import 'package:Siesta/app_constants/app_routes.dart';
import 'package:flutter/material.dart';

import '../app_constants/app_color.dart';
import '../common_widgets/common_imageview.dart';
import '../common_widgets/common_textview.dart';
import '../common_widgets/vertical_size_box.dart';

class CustomTravellerExperienceTile extends StatefulWidget {
  const CustomTravellerExperienceTile(
      {super.key,
      required this.id,
      required this.heroImage,
      required this.title,
      required this.price,
      required this.avgRating,
      required this.duration});

  final String id;
  final String heroImage;
  final String title;
  final String price;
  final String avgRating;
  final String duration;

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

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.postDetailPage, arguments: {
          "postId": widget.id,
          "type": "experience",
          "otherPersonProfile": true
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          SizedBox(
            height: screenHeight * 0.35,
            width: screenWidth,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CommonImageView.rectangleNetworkImage(
                imgUrl: widget.heroImage,
                height: screenHeight * 0.35,
                width: screenWidth,
              ),
            ),
          ),
          UiSpacer.verticalSpace(context: context, space: 0.01),

          // title
          TextView.mediumText(
            context: context,
            text: widget.title,
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
                text: "  \$${widget.price}",
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
                    text: double.parse(widget.avgRating).toStringAsFixed(1),
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
                text: widget.duration,
                fontWeight: FontWeight.w400,
                textColor: AppColor.greyColor500,
                textSize: 0.016,
              )
            ],
          ),
        ],
      ),
    );
  }
}
