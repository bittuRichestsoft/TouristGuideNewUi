import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/custom_widgets/custom_video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../../../app_constants/app_color.dart';
import '../../../../app_constants/app_images.dart';
import '../../../../app_constants/app_routes.dart';
import '../../../../app_constants/app_strings.dart';
import '../../../../common_widgets/common_imageview.dart';
import '../../../../common_widgets/common_textview.dart';
import '../../../../custom_widgets/common_widgets.dart';
import '../../../../view_models/gallery_general_experience_models/gallery_detail_model.dart';

class GalleryDetailPage extends StatefulWidget {
  const GalleryDetailPage({super.key, required this.argData});
  final Map<String, dynamic> argData;

  @override
  State<GalleryDetailPage> createState() => _GalleryDetailPageState();
}

class _GalleryDetailPageState extends State<GalleryDetailPage> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<GalleryDetailModel>.reactive(
        viewModelBuilder: () =>
            GalleryDetailModel(galleryId: widget.argData["galleryId"]),
        builder: (context, model, child) {
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
                  text: AppStrings.galleryDetails, context: context),
              actions: [
                if (widget.argData["otherPersonProfile"] == false)
                  IconButton(
                      onPressed: () async {
                        var varData = await Navigator.pushNamed(
                            context, AppRoutes.createPostPage, arguments: {
                          "type": "gallery",
                          "screenType": "edit",
                          "galleryDetails": model.galleryDetails
                        });
                        if (varData != null) {
                          model
                              .getGalleryDetailAPI(widget.argData["galleryId"]);
                        }
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                      ))
              ],
            ),

            // body
            body: model.status == Status.loading
                ? CommonWidgets().inPageLoader()
                : model.status == Status.error
                    ? CommonWidgets()
                        .inAppErrorWidget(context: context, model.errorMsg, () {
                        model.getGalleryDetailAPI(widget.argData["galleryId"]);
                      })
                    : ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        children: [
                          TextView.headingText(
                            context: context,
                            text: "Gallery",
                            color: AppColor.blackColor,
                            fontSize: screenHeight * 0.026,
                          ),
                          UiSpacer.verticalSpace(context: context, space: 0.01),
                          TextView.mediumText(
                            context: context,
                            text:
                                "Check out the detail of place and experience",
                            textColor: AppColor.blackColor,
                            textSize: 0.018,
                            fontWeight: FontWeight.w400,
                          ),
                          Divider(),
                          UiSpacer.verticalSpace(context: context, space: 0.01),

                          // details
                          detailsView(model),
                          UiSpacer.verticalSpace(context: context, space: 0.02),

                          // Image view
                          imageView(model),
                          UiSpacer.verticalSpace(context: context, space: 0.02),

                          // description view
                          TextView.mediumText(
                            context: context,
                            text: model.galleryDetails?.description ?? "",
                            textColor: AppColor.greyColor500,
                            textSize: 0.018,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
          );
        });
  }

  Widget detailsView(GalleryDetailModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.headingText(
          context: context,
          text: model.galleryDetails?.title ?? "",
          color: AppColor.blackColor,
          fontSize: screenHeight * 0.035,
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
                text: model.galleryDetails?.location ?? "",
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

  Widget imageView(GalleryDetailModel model) {
    return Wrap(
      spacing: screenWidth * 0.04,
      runSpacing: screenHeight * 0.02,
      alignment: WrapAlignment.spaceBetween,
      children: model.mediaList.asMap().entries.map((entry) {
        int index = entry.key;

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: entry.value.mediaType == "video"
              ? SizedBox(
                  height: screenHeight * getHeight(index),
                  width: screenWidth * getWidth(index),
                  child: CustomVideoThumbnail(videoUrl: entry.value.mediaUrl),
                )
              : CommonImageView.rectangleNetworkImage(
                  imgUrl: entry.value.mediaUrl,
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
