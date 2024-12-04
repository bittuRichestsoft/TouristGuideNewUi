import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/custom_widgets/custom_video_thumbnail.dart';
import 'package:Siesta/response_pojo/custom_pojos/media_type_pojo.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_constants/app_color.dart';
import '../app_constants/app_images.dart';
import '../common_widgets/common_imageview.dart';
import '../common_widgets/common_textview.dart';
import '../response_pojo/get_experience_post_response.dart';

class CustomGeneralTile extends StatefulWidget {
  const CustomGeneralTile(
      {super.key,
      this.showDescription = true,
      required this.tileData,
      required this.onClickLike});
  final bool showDescription;
  final Rows tileData;
  final VoidCallback onClickLike;

  @override
  State<CustomGeneralTile> createState() => _CustomGeneralTileState();
}

class _CustomGeneralTileState extends State<CustomGeneralTile> {
  double screenWidth = 0.0, screenHeight = 0.0;
  int curIndex = 0;

  List<MediaTypePojo> imgList = [];

  @override
  void initState() {
    imgList = [MediaTypePojo(mediaUrl: widget.tileData.heroImage!)];
    imgList.addAll(widget.tileData.postImages!.map((e) =>
        MediaTypePojo(mediaUrl: e.url!, mediaType: e.mediaType ?? "image")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.postDetailPage, arguments: {
          "type": "general",
          "postId": (widget.tileData.id ?? 0).toString()
        });
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
                        itemCount: imgList.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            imgList[itemIndex].mediaType == "image"
                                ? SizedBox(
                                    width: screenWidth,
                                    child:
                                        CommonImageView.rectangleNetworkImage(
                                      imgUrl: imgList[itemIndex].mediaUrl,
                                    ),
                                  )
                                : CustomVideoThumbnail(
                                    videoUrl: imgList[itemIndex].mediaUrl),
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
                    if (imgList.length > 1)
                      Positioned(
                          top: 10,
                          right: 10,
                          child: TextView.mediumText(
                            context: context,
                            text: "${curIndex + 1}/${imgList.length}",
                            fontWeight: FontWeight.w400,
                            textColor: AppColor.blackColor,
                            maxLines: 3,
                          )),

                    // Dots
                    if (imgList.length > 1)
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 20,
                          child: DotsIndicator(
                            dotsCount: imgList.length,
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
                          text: widget.tileData.title ?? "",
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
                          text: widget.tileData.location ?? "",
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
                      text: widget.tileData.description ?? "",
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
