import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jiffy/jiffy.dart';
import '../../../app_constants/app_fonts.dart';
import '../../../app_constants/app_sizes.dart';
import 'package:readmore/readmore.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import '../../../view_models/guide_review_rating_profile.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  List<String> titleStringList = [
    "Rory kanny",
    "Daniel Scott",
    "Adrew Milos",
    "William"
  ];
  getDate(date) {
    return DateFormat("yyyy-MM-dd hh:mm").format(date);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<GuideProfileReviewRating>.reactive(
        viewModelBuilder: () => GuideProfileReviewRating(context, 1),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: AppColor.whiteColor,
              appBar: AppBar(
                backgroundColor: AppColor.appthemeColor,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: AppColor.appthemeColor),
                centerTitle: true,
                leading: IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: AppColor.whiteColor,
                ),
                title: TextView.headingWhiteText(
                    text: AppStrings().reviewText, context: context),
              ),
              body: model.isBusy == false
                  ? model.ratingReviewList.isNotEmpty
                      ? ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: model.pageSC,
                          itemCount: model.ratingReviewList.length,
                          padding: EdgeInsets.only(
                              left: screenWidth *
                                  AppSizes().widgetSize.horizontalPaddings,
                              right: screenWidth *
                                  AppSizes().widgetSize.horizontalPaddings,
                              bottom: kBottomNavigationBarHeight,
                              top: 13),
                          itemBuilder: (context, index) {
                            return itemView(index, model);
                          })
                      : const Center(
                          child: Text("No Reviews!"),
                        )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppColor.appthemeColor),
                      ),
                    ));
        });
  }

  Widget itemView(int index, GuideProfileReviewRating model) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 1000),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
            child: GestureDetector(
          onTap: () {},
          child: SizedBox(
            width: screenWidth,
            height: screenHeight * 0.23,
            child: Card(
              margin: EdgeInsets.symmetric(
                  vertical: screenHeight * AppSizes().widgetSize.smallPadding),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: AppColor.textfieldborderColor, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(
                      screenWidth * AppSizes().widgetSize.mediumBorderRadius))),
              child: ListView(
                padding: EdgeInsets.only(
                  left: screenHeight * AppSizes().widgetSize.normalPadding,
                  right: screenHeight * AppSizes().widgetSize.normalPadding,
                  top: screenHeight * AppSizes().widgetSize.normalPadding,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      guideImage(model.ratingReviewList[index]
                                  .ratingGivenUserDetails !=
                              null
                          ? model.ratingReviewList[index]
                                      .ratingGivenUserDetails!.userDetail !=
                                  null
                              ? model
                                  .ratingReviewList[index]
                                  .ratingGivenUserDetails!
                                  .userDetail!
                                  .profilePicture
                              : ""
                          : ""),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView.normalText(
                              text: model.ratingReviewList.length > 0
                                  ? model.ratingReviewList[index].userName
                                  : "",
                              context: context,
                              fontFamily: AppFonts.nunitoBold,
                              textSize: AppSizes().fontSize.normalFontSize,
                              textColor: AppColor.appthemeColor),
                          TextView.normalText(
                              text: model.ratingReviewList[index]
                                          .ratingGivenUserDetails !=
                                      null
                                  ? Jiffy.parse(model
                                          .ratingReviewList[index].ratingGivenAt
                                          .toString())
                                      .yMMMd
                                  : "",
                              context: context,
                              fontFamily: AppFonts.nunitoSemiBold,
                              textSize: AppSizes().fontSize.xsimpleFontSize,
                              textColor: AppColor.lightBlack),
                        ],
                      )
                    ],
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.smallPadding,
                      context: context),
                  ReadMoreText(
                    model.ratingReviewList.length > 0
                        ? model.ratingReviewList[index].reviewMessage.toString()
                        : "",
                    trimMode: TrimMode.Line,
                    trimLines: 4,
                    textAlign: TextAlign.justify,
                    trimCollapsedText: 'read more',
                    trimExpandedText: 'read less',
                    moreStyle: TextStyle(
                        fontSize:
                            screenHeight * AppSizes().fontSize.mediumFontSize,
                        fontFamily: AppFonts.nunitoRegular,
                        color: AppColor.lightBlack),
                    style: TextStyle(
                        fontSize:
                            screenHeight * AppSizes().fontSize.mediumFontSize,
                        fontFamily: AppFonts.nunitoRegular,
                        color: AppColor.lightBlack),
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.smallPadding,
                      context: context),
                  Row(
                    children: [
                      RatingBar.builder(
                        wrapAlignment: WrapAlignment.start,
                        initialRating: 5,
                        minRating: 5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        unratedColor: AppColor.disableColor,
                        itemCount: model.ratingReviewList.length > 0
                            ? model.ratingReviewList[index].ratings!
                            : 5,
                        itemSize: 20.0,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: AppColor.ratingbarColor,
                        ),
                        onRatingUpdate: (double value) {},
                      ),
                      TextView.semiBoldText(
                        textColor: AppColor.appthemeColor,
                        context: context,
                        text: model.ratingReviewList.length > 0
                            ? (model.ratingReviewList[index].ratings).toString()
                            : "",
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget guideImage(img) {
    return Container(
      width: screenWidth * 0.1,
      height: screenWidth * 0.1,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(color: AppColor.appthemeColor, width: 2),
          shape: BoxShape.circle,
          image: img != null && img != ""
              ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(img))
              : DecorationImage(
                  image:
                      AssetImage(AppImages().pngImages.icProfilePlaceholder))),
    );
  }
}
