import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/custom_widgets/custom_experience_tile.dart';
import 'package:Siesta/view_models/guide_models/guide_experience_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../../../app_constants/shared_preferences.dart';
import '../../../../custom_widgets/common_widgets.dart';
import '../../../../main.dart';
import '../../../../view_models/gallery_general_experience_models/post_like_model.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({Key? key}) : super(key: key);

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<GuideExperienceModel>.reactive(
        viewModelBuilder: () => GuideExperienceModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, "back");
              return true;
            },
            child: Scaffold(
                backgroundColor: AppColor.whiteColor,
                appBar: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: AppColor.appthemeColor),
                  centerTitle: true,
                  backgroundColor: AppColor.appthemeColor,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
                    onPressed: () {
                      Navigator.pop(context, "back");
                    },
                  ),
                  title: TextView.headingWhiteText(
                      text: "Special Experience", context: context),
                ),
                body: model.status == Status.loading
                    ? CommonWidgets().inPageLoader()
                    : model.status == Status.error
                        ? CommonWidgets().inAppErrorWidget(
                            context: context, model.errorMsg, () {
                            model.pageNo = 1;
                            model.getExperiencePosts();
                          })
                        : RefreshIndicator(
                            color: AppColor.appthemeColor,
                            onRefresh: () async {
                              model.initialise();
                            },
                            child: model.experiencePostList.isEmpty
                                ? noPhotosView()
                                : ListView.separated(
                                    // shrinkWrap: true,
                                    controller: model.scrollController,
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    itemCount: model.experiencePostList.length,
                                    itemBuilder: (context, index) {
                                      return CustomExperienceTile(
                                        tileData:
                                            model.experiencePostList[index],
                                        onClickLike: () async {
                                          String postId = (model
                                                      .experiencePostList[index]
                                                      .id ??
                                                  0)
                                              .toString();
                                          String likedById = (prefs.getString(
                                                      SharedPreferenceValues
                                                          .id) ??
                                                  "0")
                                              .toString();

                                          if (model.experiencePostList[index]
                                                  .likedPost ==
                                              0) {
                                            bool val = await PostLikeModel()
                                                .likePostAPI(postId, likedById);
                                            if (val == true) {
                                              model.experiencePostList[index]
                                                  .likedPost = 1;
                                              model.experiencePostList[index]
                                                  .likesCount = (model
                                                          .experiencePostList[
                                                              index]
                                                          .likesCount ??
                                                      0) +
                                                  1;
                                              model.notifyListeners();
                                            }
                                          } else {
                                            bool val = await PostLikeModel()
                                                .unLikePostAPI(
                                                    postId, likedById);
                                            if (val == true) {
                                              model.experiencePostList[index]
                                                  .likedPost = 0;
                                              model.experiencePostList[index]
                                                  .likesCount = (model
                                                          .experiencePostList[
                                                              index]
                                                          .likesCount ??
                                                      0) -
                                                  1;
                                              model.notifyListeners();
                                            }
                                          }
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        UiSpacer.verticalSpace(
                                            context: context, space: 0.02),
                                  ),
                          )),
          );
        });
  }

  Widget noPhotosView() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * AppSizes().widgetSize.horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(AppImages().svgImages.ivNoGallery),
          ),
          UiSpacer.verticalSpace(
              space: AppSizes().widgetSize.smallPadding, context: context),
          Center(
            child: TextView.normalText(
                textColor: AppColor.appthemeColor,
                textSize: AppSizes().fontSize.headingTextSize,
                fontFamily: AppFonts.nunitoSemiBold,
                text: "No Experience Available",
                context: context),
          ),
        ],
      ),
    );
  }
}
