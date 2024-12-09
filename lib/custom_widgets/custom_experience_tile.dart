import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/response_pojo/get_experience_post_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_constants/app_color.dart';
import '../app_constants/app_images.dart';
import '../common_widgets/common_imageview.dart';
import '../common_widgets/common_textview.dart';
import '../response_pojo/custom_pojos/media_type_pojo.dart';

class CustomExperienceTile extends StatefulWidget {
  const CustomExperienceTile(
      {super.key,
      required this.tileData,
      required this.onClickLike,
      this.otherPersonProfile = true});
  final Rows tileData;
  final VoidCallback onClickLike;
  final bool otherPersonProfile;

  @override
  State<CustomExperienceTile> createState() => _CustomExperienceTileState();
}

class _CustomExperienceTileState extends State<CustomExperienceTile> {
  double screenWidth = 0.0, screenHeight = 0.0;
  int curIndex = 0;
  List<MediaTypePojo> imgList = [];

  @override
  void initState() {
    imgList = [
      MediaTypePojo(
        mediaUrl: widget.tileData.heroImage ?? "",
      )
    ];
    imgList.addAll(widget.tileData.postImages!.map((e) =>
        MediaTypePojo(mediaUrl: e.url!, mediaType: e.mediaType ?? "image")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1st Image
        ListView.separated(
          shrinkWrap: true,
          itemCount: imgList.length > 3 ? 3 : imgList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SizedBox(
              height: getContainerHeight(index),
              width: screenWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CommonImageView.rectangleNetworkImage(
                  imgUrl: imgList[index].mediaUrl,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              UiSpacer.verticalSpace(context: context, space: 0.02),
        ),

        InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.postDetailPage, arguments: {
              "type": "experience",
              "postId": (widget.tileData.id ?? 0).toString()
            });
          },
          child: Container(
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
                        text: widget.tileData.location ?? "",
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
                      onPressed: widget.onClickLike,
                      splashRadius: screenHeight * 0.025,
                      icon: widget.tileData.likedPost == 1
                          ? Icon(
                              CupertinoIcons.heart_fill,
                              color: Colors.red,
                            )
                          : Icon(
                              CupertinoIcons.heart,
                              color: AppColor.greyColor500,
                            ),
                    ),
                    TextView.mediumText(
                      context: context,
                      text: (widget.tileData.likesCount ?? 0).toString(),
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
                          text: "0 (0)",
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
                          text: widget.tileData.duration ?? "",
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
                  text: widget.tileData.title ?? "",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                  textColor: AppColor.greyColor,
                  maxLines: 2,
                ),
                UiSpacer.verticalSpace(context: context, space: 0.01),

                // description
                TextView.mediumText(
                  context: context,
                  text: widget.tileData.description ?? "",
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
          ),
        )
      ],
    );
  }

  double getContainerHeight(int index) {
    switch (index) {
      case 0:
        {
          return screenHeight * 0.36;
        }
      case 1:
        {
          return screenHeight * 0.25;
        }
      case 2:
        {
          return screenHeight * 0.15;
        }
      default:
        {
          return screenHeight * 0.15;
        }
    }
  }
}
