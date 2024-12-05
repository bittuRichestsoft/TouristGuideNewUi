import 'package:Siesta/view_models/gallery_general_experience_models/post_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../../../app_constants/app_color.dart';
import '../../../../app_constants/app_images.dart';
import '../../../../app_constants/app_routes.dart';
import '../../../../app_constants/app_strings.dart';
import '../../../../app_constants/common_date_time_formats.dart';
import '../../../../common_widgets/common_imageview.dart';
import '../../../../common_widgets/common_textview.dart';
import '../../../../common_widgets/vertical_size_box.dart';
import '../../../../custom_widgets/common_widgets.dart';
import '../../../../custom_widgets/custom_video_thumbnail.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.argData});
  final Map<String, dynamic> argData;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  late String postId;
  late String type;

  @override
  void initState() {
    postId = widget.argData["postId"] ?? "0";
    type = widget.argData["type"] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<PostDetailModel>.reactive(
        viewModelBuilder: () => PostDetailModel(postid: postId),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: AppColor.appthemeColor),
                centerTitle: true,
                backgroundColor: AppColor.appthemeColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: TextView.headingWhiteText(
                    text: type == "general"
                        ? AppStrings.generalPlannerDetails
                        : AppStrings.specialExperience,
                    context: context),
                actions: [
                  IconButton(
                      onPressed: () {
                        if (model.postDetail != null) {
                          Navigator.pushNamed(context, AppRoutes.createPostPage,
                              arguments: {
                                "type": type == "general"
                                    ? "general"
                                    : "experience",
                                "screenType": "edit",
                                "postDetails": model.postDetail,
                              });
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
                      ? CommonWidgets().inAppErrorWidget(
                          context: context, model.errorMsg, () {
                          model.getPostDetailAPI(postId);
                        })
                      : ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          children: [
                            // general heading
                            if (type == "general") generalHeadingView(),

                            // title, location
                            titleLocationView(model),
                            UiSpacer.verticalSpace(
                                context: context, space: 0.04),

                            // Image view
                            imageView(model),
                            UiSpacer.verticalSpace(
                                context: context, space: 0.06),

                            // details view
                            if (type == "experience") detailsView(model),
                            if (type == "experience")
                              UiSpacer.verticalSpace(
                                  context: context, space: 0.06),

                            // description view
                            descriptionView(model),
                          ],
                        ));
        });
  }

  Widget titleLocationView(PostDetailModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.headingText(
          context: context,
          text: model.postDetail?.title ?? "",
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
                text: model.postDetail?.location ?? "",
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

  Widget imageView(PostDetailModel model) {
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
                  child: CustomVideoThumbnail(
                    videoUrl: model.mediaList[index].mediaUrl,
                  ),
                )
              : CommonImageView.rectangleNetworkImage(
                  imgUrl: model.mediaList[index].mediaUrl,
                  height: screenHeight * getHeight(index),
                  width: screenWidth * getWidth(index),
                ),
        );
      }).toList(),
    );
  }

  Widget detailsView(PostDetailModel model) {
    return Container(
      // padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.greyColor500),
      ),
      child: Column(
        children: [
          UiSpacer.verticalSpace(context: context, space: 0.01),
          detailTile("\$${model.postDetail?.price ?? 0}/person", null,
              titleSize: 0.024),
          detailTile("People",
              "${model.postDetail?.minPeople ?? 0}-${model.postDetail?.maxPeople ?? 0}"),
          detailTile("Transport", model.postDetail?.transportType ?? ""),
          detailTile("Accessibility",
              model.postDetail?.accessibility == true ? "Yes" : "No"),
          detailTile("Duration", model.postDetail?.duration ?? ""),
          detailTile(
              "Time",
              CommonDateTimeFormats.timeFormatLocal(
                  model.postDetail?.startingTime ?? DateTime.now().toString())),
          detailTile("Pick-up", model.postDetail?.meetingPoint ?? ""),
          detailTile("Drop-off", model.postDetail?.dropOffPoint ?? "",
              showDivider: false),
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

  Widget generalHeadingView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextView.headingText(
          context: context,
          text: widget.argData["tileType"] == "gallery"
              ? "Gallery"
              : "General Planner",
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
      ],
    );
  }

  Widget descriptionView(PostDetailModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (type == "experience")
          TextView.headingText(
            context: context,
            text: "What you’ll do",
            color: AppColor.greyColor,
          ),
        if (type == "experience")
          UiSpacer.verticalSpace(context: context, space: 0.01),
        TextView.mediumText(
          context: context,
          text: model.postDetail?.description ?? "",
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
