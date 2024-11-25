// ignore_for_file: must_be_immutable

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/response_pojo/traveller_findeguide_detail_response.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:Siesta/view_models/traveller_findGuide_Detail_model.dart';
import 'package:stacked/stacked.dart';

class FindGuideDetail extends StatefulWidget {
  FindGuideDetail({Key? key, Object? idMap}) : super(key: key) {
    Map map = idMap as Map;
    guideId = map["guideId"];
  }

  String? guideId;
  @override
  State<FindGuideDetail> createState() => _FindGuideDetailState();
}

class _FindGuideDetailState extends State<FindGuideDetail> {
  double screenWidth = 0.0, screenHeight = 0.0;

  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<TravellerFindGuideDetailModel>.reactive(
        viewModelBuilder: () =>
            TravellerFindGuideDetailModel(context, widget.guideId),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              backgroundColor: AppColor.appthemeColor,
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              leading: IconButton(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.travellerHomePage);
                },
                icon: const Icon(Icons.arrow_back),
                color: AppColor.whiteColor,
              ),
              title: TextView.headingWhiteText(
                  text: model.travellerFindGuideDetailResponse != null
                      ? model.travellerFindGuideDetailResponse!.data
                          .guideDetails!.name
                      : "",
                  context: context),
            ),
            body: model.isBusy == true
                ? Center(
                    child: SizedBox(
                      height: screenHeight,
                      width: screenWidth * 0.1,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppColor.appthemeColor),
                      ),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(
                        screenWidth * AppSizes().widgetSize.horizontalPadding),
                    shrinkWrap: true,
                    children: [
                      profileImageView(
                          model.travellerFindGuideDetailResponse != null
                              ? model.travellerFindGuideDetailResponse!.data
                                  .guideDetails!.userDetail!.profilePicture
                              : ""),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding,
                          context: context),
                      model.ratingAndReviewList!.isNotEmpty
                          ? ratingBar('center', model)
                          : const SizedBox(),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      locationCityBar(model),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      Divider(
                        color: AppColor.textfieldborderColor,
                        height: 2,
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.verticalPadding,
                          context: context),
                      titleText(AppStrings().description),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      Container(
                          width: screenWidth * 0.8,
                          color: Colors.transparent,
                          child: Text(
                            model.travellerFindGuideDetailResponse != null
                                ? model.travellerFindGuideDetailResponse!.data
                                    .guideDetails!.userDetail!.bio
                                    .toString()
                                : "",
                            style: TextStyle(
                              color: AppColor.textColorLightBlack,
                              fontFamily: AppFonts.nunitoRegular,
                              fontSize: screenHeight *
                                  AppSizes().fontSize.normalFontSize,
                            ),
                          )),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      model.travellerFindGuideDetailResponse != null &&
                              model.travellerFindGuideDetailResponse!.data
                                  .mediaFiles!.isNotEmpty
                          ? (Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                  color: AppColor.textfieldborderColor,
                                  height: 2,
                                ),
                                titleText(AppStrings().findMorePlace),
                                UiSpacer.verticalSpace(
                                    space: AppSizes().widgetSize.smallPadding,
                                    context: context),
                                imagesView(
                                    model.travellerFindGuideDetailResponse !=
                                            null
                                        ? model
                                            .travellerFindGuideDetailResponse!
                                            .data
                                            .mediaFiles
                                        : ""),
                              ],
                            ))
                          : const SizedBox(),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      Divider(
                        color: AppColor.textfieldborderColor,
                        height: 2,
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                      titleText(AppStrings().ratingReviews),
                      ListTile(
                        isThreeLine: false,
                        minVerticalPadding: 0.0,
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(vertical: -4, horizontal: -4),
                        leading: SizedBox(
                          width: screenWidth * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                // ignore: unrelated_type_equality_checks
                                model.travellerFindGuideDetailResponse != null
                                    ? model.travellerFindGuideDetailResponse!
                                        .data.avgRatings!
                                    : "",
                                style: TextStyle(
                                  fontSize: screenHeight *
                                      AppSizes().fontSize.extralargeTextSize,
                                  color: AppColor.lightBlack,
                                  fontFamily: AppFonts.nunitoBlack,
                                ),
                              ),
                              ratingBars(AppColor.lightBlack, 1, 1)
                            ],
                          ),
                        ),
                        trailing: Text(
                          "${model.travellerFindGuideDetailResponse != null ? model.travellerFindGuideDetailResponse!.data.ratings : "1"} ratings & ${model.travellerFindGuideDetailResponse != null ? model.travellerFindGuideDetailResponse!.data.reviews : "1"} Reviews",
                          style: TextStyle(
                            fontSize: screenHeight *
                                AppSizes().fontSize.simpleFontSize,
                            color: AppColor.lightBlack,
                            fontFamily: AppFonts.nunitoRegular,
                          ),
                        ),
                        subtitle: const SizedBox(),
                      ),
                      ratingProgressWidget(
                          AppStrings().fiveStar,
                          model.travellerFindGuideDetailResponse != null
                              ? (model.travellerFindGuideDetailResponse!.data
                                      .star5Ratings!) /
                                  100
                              : 0.1,
                          "${model.travellerFindGuideDetailResponse != null ? (model.travellerFindGuideDetailResponse!.data.percentage5Ratings).toString() : ""}%"),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      ratingProgressWidget(
                          AppStrings().fourStar,
                          model.travellerFindGuideDetailResponse != null
                              ? (model.travellerFindGuideDetailResponse!.data
                                      .star4Ratings!) /
                                  100
                              : 0.1,
                          "${model.travellerFindGuideDetailResponse != null ? (model.travellerFindGuideDetailResponse!.data.percentage4Ratings).toString() : ""}%"),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      ratingProgressWidget(
                          AppStrings().threeStar,
                          model.travellerFindGuideDetailResponse != null
                              ? (model.travellerFindGuideDetailResponse!.data
                                      .star3Ratings!) /
                                  100
                              : 0.1,
                          "${model.travellerFindGuideDetailResponse != null ? (model.travellerFindGuideDetailResponse!.data.percentage3Ratings).toString() : ""}%"),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      ratingProgressWidget(
                          AppStrings().twoStar,
                          model.travellerFindGuideDetailResponse != null
                              ? (model.travellerFindGuideDetailResponse!.data
                                      .star2Ratings!) /
                                  100
                              : 0.1,
                          "${model.travellerFindGuideDetailResponse != null ? (model.travellerFindGuideDetailResponse!.data.percentage2Ratings).toString() : ""}%"),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      ratingProgressWidget(
                          AppStrings().oneStar,
                          model.travellerFindGuideDetailResponse != null
                              ? (model.travellerFindGuideDetailResponse!.data
                                      .star1Ratings!) /
                                  100
                              : 0.1,
                          "${model.travellerFindGuideDetailResponse != null ? (model.travellerFindGuideDetailResponse!.data.percentage1Ratings).toString() : ""}%"),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      commentSection(model),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      model.ratingAndReviewList!.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpand = !isExpand;
                                });
                              },
                              child: TextView.normalText(
                                  text: isExpand == true
                                      ? ""
                                      : AppStrings().allReview,
                                  context: context,
                                  fontFamily: AppFonts.nunitoBold,
                                  textColor: AppColor.appthemeColor,
                                  textSize:
                                      AppSizes().fontSize.headingTextSize),
                            )
                          : const SizedBox(),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.largePadding,
                          context: context),
                    ],
                  ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.035,
                  vertical: screenWidth * 0.06),
              child: CommonButton.commonThemeColorButton(
                  context: context,
                  text: "AI Itinerary",
                  onPressed: () {
                    openBookTripPage(widget.guideId!,
                        model.travellerFindGuideDetailResponse!.data);
                  }),
            ),
          );
        });
  }

  openBookTripPage(String guideId, GuideDetailData guideData) {
    Navigator.pushNamed(context, AppRoutes.bookTripNow,
        arguments: {"guideId": guideId, "guideData": guideData});
  }

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is int) {
      return 0.0 + value;
    } else {
      return value;
    }
  }

  Widget imagesView(list) {
    return ListView.builder(
        itemCount: list!.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * AppSizes().widgetSize.normalPadding,
            horizontal: screenWidth * AppSizes().widgetSize.horizontalPadding),
        itemBuilder: (context, index) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            runSpacing: 20,
            children: [
              TextView.normalText(
                  textSize: AppSizes().fontSize.headingTextSize,
                  textColor: AppColor.lightBlack,
                  fontFamily: AppFonts.nunitoBold,
                  text: list[index].destinationTitle,
                  context: context),
              selectedImagesGrid(list[index].fileUrls)
            ],
          );
        });
  }

  Widget selectedImagesGrid(imagesList) {
    return GridView.count(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
        physics: const ClampingScrollPhysics(),
        childAspectRatio: 1.0,
        shrinkWrap: true,
        crossAxisCount: 4,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.01,
        mainAxisSpacing: MediaQuery.of(context).size.width * 0.01,
        children: List.generate(imagesList.length, (index) {
          return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius)),
              child: showNetworkImage(
                imagesList[index],
              )

              /*Image.network(
              imagesList[index],
              fit: BoxFit.cover,
            ),*/

              );
        }));
  }

  Widget showNetworkImage(
    String imageurl,
  ) {
    return FastCachedImage(
      alignment: Alignment.centerLeft,
      filterQuality: FilterQuality.high,
      fit: BoxFit.fill,
      url: imageurl,
      errorBuilder: (context, exception, stacktrace) {
        return Container(
          height: screenHeight * 0.2,
          width: screenWidth * 0.3,
          color: AppColor.appthemeColor,
        );
      },
      loadingBuilder: (context, progress) {
        return CircularProgressIndicator(
            color: AppColor.appthemeColor,
            value: progress.progressPercentage.value);
      },
    );
  }

  Widget commentSection(model) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: isExpand == false ? 1 : model.ratingAndReviewList!.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Card(
                  color: AppColor.whiteColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(
                          screenWidth *
                              AppSizes().widgetSize.smallBorderRadius)),
                      side: BorderSide(color: AppColor.disableColor)),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 10.0,
                    runSpacing: 5.0,
                    children: [
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: ratingBarAllRating('start', model, index)),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextView.normalText(
                            text: model.ratingAndReviewList!.length > 0
                                ? model
                                    .ratingAndReviewList![index]!.reviewMessage
                                : "",
                            context: context,
                            fontFamily: AppFonts.nunitoRegular,
                            textColor: AppColor.textColorLightBlack,
                            textSize: AppSizes().fontSize.simpleFontSize),
                      ),
                      Divider(
                        color: AppColor.disableColor,
                        height: 2,
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      TextView.headingText(
                        text: model.ratingAndReviewList!.length > 0
                            ? model.ratingAndReviewList![index]!.userName
                            : "",
                        context: context,
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.horizontalPadding,
                          context: context),
                    ],
                  )));
        });
  }

  Widget profileImageView(img) {
    return CircleAvatar(
      radius: screenWidth * 0.17,
      child: Container(
          width: screenWidth * 0.35,
          height: screenWidth * 0.35,
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              border: Border.all(color: AppColor.buttonDisableColor, width: 3),
              shape: BoxShape.circle,
              image: img != null && img != ""
                  ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(img))
                  : DecorationImage(
                      image: AssetImage(
                          AppImages().pngImages.icProfilePlaceholder)))),
    );
  }

  Widget ratingBar(setposition, model) {
    return Row(
      mainAxisAlignment: setposition == "center"
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RatingBar.builder(
          wrapAlignment: WrapAlignment.center,
          initialRating: model.travellerFindGuideDetailResponse != null
              ? checkDouble(
                  model.travellerFindGuideDetailResponse!.data.avgRatings)
              : 5,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,
          unratedColor: AppColor.disableColor,
          itemCount: 5,
          itemSize: 20.0,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: AppColor.ratingbarColor,
          ),
          onRatingUpdate: (double value) {},
        ),
        TextView.normalText(
            text: model.travellerFindGuideDetailResponse != null
                ? model.travellerFindGuideDetailResponse!.data.avgRatings
                : "",
            context: context,
            fontFamily: AppFonts.nunitoSemiBold,
            textColor: AppColor.lightBlack,
            textSize: AppSizes().fontSize.normalFontSize)
      ],
    );
  }

  Widget ratingBarAllRating(setposition, model, index) {
    return Row(
      mainAxisAlignment: setposition == "center"
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RatingBar.builder(
          wrapAlignment: WrapAlignment.center,
          initialRating: model.ratingAndReviewList!.length > 0
              ? checkDouble(model.ratingAndReviewList[index]!.ratings)
              : 1.0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,
          unratedColor: AppColor.disableColor,
          itemCount: 5,
          itemSize: 20.0,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: AppColor.ratingbarColor,
          ),
          onRatingUpdate: (double value) {},
        ),
        TextView.normalText(
            text: model.ratingAndReviewList!.length > 0
                ? (model.ratingAndReviewList[index]!.ratings).toString()
                : "1.0",
            context: context,
            fontFamily: AppFonts.nunitoSemiBold,
            textColor: AppColor.textColorBlack,
            textSize: AppSizes().fontSize.headingTextSize)
      ],
    );
  }

  Widget locationCityBar(model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
            onPressed: null,
            icon: Image.asset(
              AppImages().pngImages.icDollar,
              height: AppSizes().widgetSize.iconWidth,
              width: AppSizes().widgetSize.iconWidth,
            ),
            label: TextView.normalText(
                textSize: AppSizes().fontSize.headingTextSize,
                textColor: AppColor.textColorBlack,
                fontFamily: AppFonts.nunitoSemiBold,
                context: context,
                text:
                    "\$${model.travellerFindGuideDetailResponse != null ? model.travellerFindGuideDetailResponse!.data.guideDetails.userDetail.price : ""}/hr")),
        TextButton.icon(
            onPressed: null,
            icon: Image.asset(
              AppImages().pngImages.icLoc,
              height: AppSizes().widgetSize.iconWidth,
              width: AppSizes().widgetSize.iconWidth,
            ),
            label: TextView.normalText(
                textSize: AppSizes().fontSize.headingTextSize,
                textColor: AppColor.textColorBlack,
                fontFamily: AppFonts.nunitoSemiBold,
                context: context,
                text: model.travellerFindGuideDetailResponse != null
                    ? model.travellerFindGuideDetailResponse!.data.guideDetails
                        .country
                    : "")),
      ],
    );
  }

  Widget titleText(String text) {
    return TextView.normalText(
        text: text,
        context: context,
        fontFamily: AppFonts.nunitoSemiBold,
        textColor: AppColor.textColorBlack,
        textSize: AppSizes().fontSize.headingTextSize);
  }

  Widget findPlacesGrid() {
    return GridView.count(
        padding: EdgeInsets.all(screenWidth * 0.01),
        physics: const ScrollPhysics(),
        childAspectRatio: 1.1,
        shrinkWrap: true,
        crossAxisCount: 4,
        crossAxisSpacing: screenWidth * 0.015,
        mainAxisSpacing: screenWidth * 0.015,
        children: List.generate(4, (index) {
          return Image.asset(
            AppImages().pngImages.ivImageView,
            fit: BoxFit.fill,
          );
        }));
  }

  Widget ratingBars(Color starColor, double count, int totalItemCount) {
    return RatingBar.builder(
      wrapAlignment: WrapAlignment.start,
      initialRating: count,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: true,
      unratedColor: AppColor.disableColor,
      itemCount: totalItemCount,
      itemSize: 15.0,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: starColor,
      ),
      onRatingUpdate: (double value) {},
    );
  }

  Widget progressIndicator(double value) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: LinearProgressIndicator(
        minHeight: 10,
        backgroundColor: AppColor.disableColor,
        value: value,
        color: AppColor.progressbarColor,
      ),
    );
  }

  Widget ratingProgressWidget(
      String startext, double progressVal, String percentText) {
    return ListTile(
      minVerticalPadding: 0.0,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: 1, vertical: -4),
      leading: TextView.normalText(
          textSize: AppSizes().fontSize.simpleFontSize,
          textColor: AppColor.dontHaveTextColor,
          fontFamily: AppFonts.nunitoMedium,
          context: context,
          text: startext),
      title: progressIndicator(progressVal),
      trailing: TextView.normalText(
          textSize: AppSizes().fontSize.simpleFontSize,
          textColor: AppColor.dontHaveTextColor,
          fontFamily: AppFonts.nunitoMedium,
          context: context,
          text: percentText),
    );
  }
}
