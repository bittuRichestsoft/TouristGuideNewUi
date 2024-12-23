import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/custom_widgets/custom_experience_tile.dart';
import 'package:Siesta/custom_widgets/custom_gallery_tile.dart';
import 'package:Siesta/view_models/gallery_general_experience_models/post_like_model.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
import '../../custom_widgets/common_widgets.dart';
import '../../utility/globalUtility.dart';
import '../../view_models/preview_profile_model/preview_profile_model.dart';

class PreviewProfilePage extends StatefulWidget {
  const PreviewProfilePage({super.key, required this.argData});
  final Map<String, dynamic> argData;

  @override
  State<PreviewProfilePage> createState() => _PreviewProfilePageState();
}

class _PreviewProfilePageState extends State<PreviewProfilePage> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<PreviewProfileModel>.reactive(
        viewModelBuilder: () => PreviewProfileModel(argData: widget.argData),
        builder: (context, model, child) {
          return Scaffold(
            // app bar
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
                  text: model.isMe == true
                      ? "Preview Profile"
                      : "Localite Profile",
                  context: context),
            ),

            // body
            body: model.status == Status.loading
                ? CommonWidgets().inPageLoader()
                : model.status == Status.error
                    ? CommonWidgets()
                        .inAppErrorWidget(context: context, model.errorMsg, () {
                        model.initialise();
                      })
                    : RefreshIndicator(
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
                                  UiSpacer.verticalSpace(
                                      context: context, space: 0.03),

                                  // Buttons view
                                  buttonsView(model),
                                  UiSpacer.verticalSpace(
                                      context: context, space: 0.05),

                                  // Gallery view
                                  if (model.galleryPostList.isNotEmpty)
                                    galleryView(model),
                                  if (model.galleryPostList.isNotEmpty)
                                    UiSpacer.verticalSpace(
                                        context: context, space: 0.05),

                                  // general planner
                                  if (model.generalPostList.isNotEmpty)
                                    generalPlannerView(model),
                                  if (model.generalPostList.isNotEmpty)
                                    UiSpacer.verticalSpace(
                                        context: context, space: 0.05),

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

  Widget profileImageView(PreviewProfileModel model) {
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

  Widget profileDescription(PreviewProfileModel model) {
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

  Widget buttonsView(PreviewProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preview Profile
        CommonButton.commonOutlineButtonWithIconText(
          context: context,
          text: model.isFollowed == true ? "Followed" : "Follow",
          iconPath: AppImages().svgImages.icEditProfile,
          onPressed: () {
            if (model.isMe == false) {
              if (model.isFollowed == false) {
                model.followGuideAPI();
              } else {
                model.unFollowGuideAPI();
              }
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
            showShareProfileWidget(model);
          },
        ),
      ],
    );
  }

  Widget galleryView(PreviewProfileModel model) {
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
                  if (model.isMe == false) {
                    var val = await Navigator.pushNamed(
                        context, AppRoutes.galleryListingPage);

                    if (val != null) {
                      model.getGalleryPosts();
                    }
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
              onClickLike: model.isMe == true
                  ? () {}
                  : () async {
                      String postId =
                          (model.galleryPostList[index].id ?? 0).toString();
                      String likedById =
                          (prefs.getString(SharedPreferenceValues.id) ?? "0")
                              .toString();
                      if (model.galleryPostList[index].likedPost == 0) {
                        bool val = await PostLikeModel()
                            .likeGalleryAPI(postId, likedById);
                        if (val == true) {
                          model.galleryPostList[index].likedPost = 1;
                          model.galleryPostList[index].likesCount =
                              (model.galleryPostList[index].likesCount ?? 0) +
                                  1;
                          model.notifyListeners();
                        }
                      } else {
                        bool val = await PostLikeModel()
                            .unLikeGalleryAPI(postId, likedById);
                        if (val == true) {
                          model.galleryPostList[index].likedPost = 0;
                          model.galleryPostList[index].likesCount =
                              (model.galleryPostList[index].likesCount ?? 0) -
                                  1;
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

  Widget generalPlannerView(PreviewProfileModel model) {
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
              onClickLike: model.isMe == true
                  ? () {}
                  : () async {
                      String postId =
                          (model.generalPostList[index].id ?? 0).toString();
                      String likedById =
                          (prefs.getString(SharedPreferenceValues.id) ?? "0")
                              .toString();
                      if (model.generalPostList[index].likedPost == 0) {
                        bool val = await PostLikeModel()
                            .likePostAPI(postId, likedById);
                        if (val == true) {
                          model.generalPostList[index].likedPost = 1;
                          model.generalPostList[index].likesCount =
                              (model.generalPostList[index].likesCount ?? 0) +
                                  1;
                          model.notifyListeners();
                        }
                      } else {
                        bool val = await PostLikeModel()
                            .unLikePostAPI(postId, likedById);
                        if (val == true) {
                          model.generalPostList[index].likedPost = 0;
                          model.generalPostList[index].likesCount =
                              (model.generalPostList[index].likesCount ?? 0) -
                                  1;
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

  Widget specialExperienceView(PreviewProfileModel model) {
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
                  if (model.isMe == false) {
                    var val = await Navigator.pushNamed(
                        context, AppRoutes.experienceListingPage);
                    if (val != null) {
                      model.getExperiencePosts();
                    }
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
              onClickLike: model.isMe == true
                  ? () {}
                  : () async {
                      String postId =
                          (model.experiencePostList[index].id ?? 0).toString();
                      String likedById =
                          (prefs.getString(SharedPreferenceValues.id) ?? "0")
                              .toString();

                      if (model.experiencePostList[index].likedPost == 0) {
                        bool val = await PostLikeModel()
                            .likePostAPI(postId, likedById);
                        if (val == true) {
                          model.experiencePostList[index].likedPost = 1;
                          model.experiencePostList[index].likesCount =
                              (model.experiencePostList[index].likesCount ??
                                      0) +
                                  1;
                          model.notifyListeners();
                        }
                      } else {
                        bool val = await PostLikeModel()
                            .unLikePostAPI(postId, likedById);
                        if (val == true) {
                          model.experiencePostList[index].likedPost = 0;
                          model.experiencePostList[index].likesCount =
                              (model.experiencePostList[index].likesCount ??
                                      0) -
                                  1;
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

  void showShareProfileWidget(PreviewProfileModel model) {
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
                              imgUrl: model.profileImageUrl ?? "",
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
                                    text: model.nameText ?? "",
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
                                    text: model
                                        .calculateYear(
                                            y: model.hostSinceYear ?? "0",
                                            m: model.hostSinceMonth ?? "0")
                                        .toString(),
                                    textColor: AppColor.hintTextColor,
                                    textSize: 0.015,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  UiSpacer.verticalSpace(
                                      context: context, space: 0.005),

                                  // Rating
                                  RatingBar.builder(
                                    wrapAlignment: WrapAlignment.start,
                                    initialRating:
                                        double.parse(model.avgRating ?? "0"),
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
                          text: model.bioText ?? "",
                          maxLines: 3,
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
                  child: SizedBox(
                    height: screenHeight * 0.12,
                    width: screenHeight * 0.12,
                    child: QrImageView(
                      data: model.profileUrl ?? "",
                      version: QrVersions.auto,
                      size: screenHeight * 0.12,
                      gapless: false,
                    ),
                  )
                  /*CommonImageView.rectangleNetworkImage(
                    imgUrl: AppImages().dummyImage,
                    height: screenHeight * 0.12,
                    width: screenHeight * 0.12,
                  )*/
                  ,
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
                      Expanded(
                        child: TextView.mediumText(
                          context: context,
                          text: model.profileUrl ?? "",
                          textSize: 0.018,
                          maxLines: 1,
                          textColor: AppColor.greyColor500,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          FlutterClipboard.copy(model.profileUrl ?? "")
                              .then((value) {
                            GlobalUtility.showToast(context, "Link copied!");
                          });
                        },
                        child: Icon(
                          Icons.copy,
                          color: AppColor.greyColor500,
                        ),
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
