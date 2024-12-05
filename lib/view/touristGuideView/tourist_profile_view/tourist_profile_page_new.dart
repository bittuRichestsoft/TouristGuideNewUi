import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/custom_widgets/custom_experience_tile.dart';
import 'package:Siesta/custom_widgets/custom_gallery_tile.dart';
import 'package:Siesta/view_models/gallery_general_experience_models/post_like_model.dart';
import 'package:Siesta/view_models/guide_profile_model/tourist_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stacked/stacked.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_images.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../common_widgets/common_button.dart';
import '../../../common_widgets/common_imageview.dart';
import '../../../common_widgets/common_textview.dart';
import '../../../common_widgets/vertical_size_box.dart';
import '../../../custom_widgets/custom_general_tile.dart';
import '../../../main.dart';

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

    return ViewModelBuilder.reactive(
        viewModelBuilder: () => TouristProfileModel(),
        builder: (context, model, child) {
          return Scaffold(
            body: RefreshIndicator(
              color: AppColor.appthemeColor,
              onRefresh: () async {
                model.initialise();
              },
              child: ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  // Cover and profile photo
                  profileImageView(model),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),

                  // Profile description
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile desc
                        profileDescription(model),
                        UiSpacer.verticalSpace(context: context, space: 0.03),

                        // Buttons view
                        buttonsView(model),
                        UiSpacer.verticalSpace(context: context, space: 0.05),

                        // Gallery view
                        if (model.galleryPostList.isNotEmpty)
                          galleryView(model),
                        if (model.galleryPostList.isNotEmpty)
                          UiSpacer.verticalSpace(context: context, space: 0.05),

                        // general planner
                        if (model.generalPostList.isNotEmpty)
                          generalPlannerView(model),
                        if (model.generalPostList.isNotEmpty)
                          UiSpacer.verticalSpace(context: context, space: 0.05),

                        // special experience
                        if (model.experiencePostList.isNotEmpty)
                          specialExperienceView(model),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget profileImageView(TouristProfileModel model) {
    return Container(
      height: screenHeight * 0.44,
      child: Stack(
        children: [
          Container(
            height: screenHeight * 0.4,
            width: screenWidth,
            child: CommonImageView.rectangleNetworkImage(
                imgUrl: model.coverImageUrl ?? ""),
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
                      image: model.profileImageUrl != null
                          ? DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(model.profileImageUrl ?? ""))
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

  Widget profileDescription(TouristProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        TextView.headingText(
          context: context,
          text: model.nameText ?? "",
          color: AppColor.blackColor,
          fontSize: screenHeight * 0.03,
        ),

        // host since
        TextView.mediumText(
          context: context,
          text:
              "Hosted since ${model.calculateYear(y: model.hostSinceYear ?? "0", m: model.hostSinceMonth ?? "0")}",
          textColor: AppColor.hintTextColor,
          textSize: 0.015,
          fontWeight: FontWeight.w400,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.005),

        // Rating
        RatingBar.builder(
          wrapAlignment: WrapAlignment.start,
          initialRating: double.parse(model.avgRating ?? "0"),
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
          text: model.bioText ?? "",
          textColor: AppColor.hintTextColor,
          textSize: 0.015,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget buttonsView(TouristProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create Experience
        CommonButton.commonOutlineButtonWithIconText(
          context: context,
          text: "Create Experience",
          iconPath: AppImages().svgImages.icAdd,
          onPressed: () async {
            var backData = await Navigator.pushNamed(
                context, AppRoutes.createPostPage,
                arguments: {"type": "experience"});
            if (backData != null) {
              model.getExperiencePosts();
            }
          },
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),

        // Create general
        if (model.showCreateGeneral == true)
          CommonButton.commonOutlineButtonWithIconText(
            context: context,
            text: "Create General",
            iconPath: AppImages().svgImages.icAdd,
            onPressed: () async {
              var backData = await Navigator.pushNamed(
                  context, AppRoutes.createPostPage,
                  arguments: {"type": "general"});
              if (backData != null) {
                model.getGeneralPosts();
              }
            },
          ),
        if (model.showCreateGeneral == true)
          UiSpacer.verticalSpace(context: context, space: 0.01),

        // Create gallery
        CommonButton.commonOutlineButtonWithIconText(
          context: context,
          text: "Create Gallery",
          iconPath: AppImages().svgImages.icAdd,
          onPressed: () async {
            var backData = await Navigator.pushNamed(
                context, AppRoutes.createPostPage,
                arguments: {"type": "gallery"});
            if (backData != null) {
              model.getGalleryPosts();
            }
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
          onPressed: () async {
            var val = await Navigator.pushNamed(
                context, AppRoutes.editGuideProfilePage);
            if (val != null) {
              model.getProfileAPI();
            }
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

  Widget galleryView(TouristProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextView.headingText(
              context: context,
              text: "Gallery",
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
                onPressed: () async {
                  var val = await Navigator.pushNamed(
                      context, AppRoutes.galleryListingPage);

                  if (val != null) {
                    model.getGalleryPosts();
                  }
                },
              ),
            )
          ],
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: model.galleryPostList.length,
          itemBuilder: (context, index) {
            return CustomGalleryTile(
              tileData: model.galleryPostList[index],
              onClickLike: () async {
                String postId =
                    (model.galleryPostList[index].id ?? 0).toString();
                String likedById =
                    (prefs.getString(SharedPreferenceValues.id) ?? "0")
                        .toString();
                if (model.galleryPostList[index].likedPost == 0) {
                  bool val =
                      await PostLikeModel().likeGalleryAPI(postId, likedById);
                  if (val == true) {
                    model.galleryPostList[index].likedPost = 1;
                    model.galleryPostList[index].likesCount =
                        (model.galleryPostList[index].likesCount ?? 0) + 1;
                    model.notifyListeners();
                  }
                } else {
                  bool val =
                      await PostLikeModel().unLikeGalleryAPI(postId, likedById);
                  if (val == true) {
                    model.galleryPostList[index].likedPost = 0;
                    model.galleryPostList[index].likesCount =
                        (model.galleryPostList[index].likesCount ?? 0) - 1;
                    model.notifyListeners();
                  }
                }
              },
            );
          },
          separatorBuilder: (context, index) =>
              UiSpacer.verticalSpace(context: context, space: 0.02),
        )
      ],
    );
  }

  Widget generalPlannerView(TouristProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        TextView.headingText(
          context: context,
          text: "General Planner",
          color: AppColor.blackColor,
          fontSize: screenHeight * 0.026,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: model.generalPostList.length,
          itemBuilder: (context, index) {
            return CustomGeneralTile(
              showDescription: false,
              tileData: model.generalPostList[index],
              onClickLike: () async {
                String postId =
                    (model.generalPostList[index].id ?? 0).toString();
                String likedById =
                    (prefs.getString(SharedPreferenceValues.id) ?? "0")
                        .toString();
                if (model.generalPostList[index].likedPost == 0) {
                  bool val =
                      await PostLikeModel().likePostAPI(postId, likedById);
                  if (val == true) {
                    model.generalPostList[index].likedPost = 1;
                    model.generalPostList[index].likesCount =
                        (model.generalPostList[index].likesCount ?? 0) + 1;
                    model.notifyListeners();
                  }
                } else {
                  bool val =
                      await PostLikeModel().unLikePostAPI(postId, likedById);
                  if (val == true) {
                    model.generalPostList[index].likedPost = 0;
                    model.generalPostList[index].likesCount =
                        (model.generalPostList[index].likesCount ?? 0) - 1;
                    model.notifyListeners();
                  }
                }
              },
            );
          },
          separatorBuilder: (context, index) =>
              UiSpacer.verticalSpace(context: context, space: 0.02),
        )
      ],
    );
  }

  Widget specialExperienceView(TouristProfileModel model) {
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
                onPressed: () async {
                  var val = await Navigator.pushNamed(
                      context, AppRoutes.experienceListingPage);
                  if (val != null) {
                    model.getExperiencePosts();
                  }
                },
              ),
            )
          ],
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: model.experiencePostList.length,
          itemBuilder: (context, index) {
            return CustomExperienceTile(
              tileData: model.experiencePostList[index],
              onClickLike: () async {
                String postId =
                    (model.experiencePostList[index].id ?? 0).toString();
                String likedById =
                    (prefs.getString(SharedPreferenceValues.id) ?? "0")
                        .toString();

                if (model.experiencePostList[index].likedPost == 0) {
                  bool val =
                      await PostLikeModel().likePostAPI(postId, likedById);
                  if (val == true) {
                    model.experiencePostList[index].likedPost = 1;
                    model.experiencePostList[index].likesCount =
                        (model.experiencePostList[index].likesCount ?? 0) + 1;
                    model.notifyListeners();
                  }
                } else {
                  bool val =
                      await PostLikeModel().unLikePostAPI(postId, likedById);
                  if (val == true) {
                    model.experiencePostList[index].likedPost = 0;
                    model.experiencePostList[index].likesCount =
                        (model.experiencePostList[index].likesCount ?? 0) - 1;
                    model.notifyListeners();
                  }
                }
              },
            );
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
