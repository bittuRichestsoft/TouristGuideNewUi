import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/view_models/myBookingsModel.dart';
import 'package:Siesta/utility/globalUtility.dart';

class ReviewScreen extends StatefulWidget {
  ReviewScreen(
      {Key? key,
      String? touristGuideUserId,
      int? selectedIndex,
      double? rating})
      : super(key: key) {
    //  touristGuideUserId is booking id
    guide_user_id = touristGuideUserId.toString();
    itemSelIndex = selectedIndex;
    rate = rating;
    debugPrint("RATE ---$rate");
  }
  String? guide_user_id;
  int? itemSelIndex;
  double? rate;
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  @override
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<TravellerMyBookingsModel>.reactive(
        viewModelBuilder: () => TravellerMyBookingsModel(
            context, "no", widget.itemSelIndex!, widget.rate!),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          model.getUserDetails(widget.itemSelIndex!);
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              elevation: 0,
              title: TextView.headingWhiteText(
                  context: context, text: AppStrings().writeAReview),
              leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColor.whiteColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: messageView(model),
          );
        });
  }

  Widget messageView(TravellerMyBookingsModel model) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          decoration: BoxDecoration(color: AppColor.backgroundDefaultColor),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      screenWidth * AppSizes().widgetSize.horizontalPadding,
                  vertical:
                      screenWidth * AppSizes().widgetSize.horizontalPadding),
              child: Column(children: [
                profileImage(model.travellerMybookingList.length > 0
                    ? model.travellerMybookingList[widget.itemSelIndex!].user!
                        .userDetail!.profilePicture
                    : ""),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextView.normalText(
                      textColor: AppColor.appthemeColor,
                      textSize: AppSizes().fontSize.headingTextSize,
                      fontFamily: AppFonts.nunitoBold,
                      text: model.travellerMybookingList.length > 0
                          ? model.travellerMybookingList[widget.itemSelIndex!]
                              .firstName
                          : "",
                      context: context),
                ),
              ])),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        screenWidth * AppSizes().widgetSize.horizontalPadding,
                    vertical:
                        screenWidth * AppSizes().widgetSize.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView.normalText(
                        textColor: AppColor.lightBlack,
                        textSize: AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoSemiBold,
                        text: AppStrings().yourRatings,
                        context: context),
                    const SizedBox(
                      height: 10,
                    ),
                    ratingStars(model),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding,
                        context: context),
                    TextView.normalText(
                        textColor: AppColor.lightBlack,
                        textSize: AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoSemiBold,
                        text: AppStrings().writeYourReview,
                        context: context),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      height: screenHeight * 0.25,
                      width: screenWidth,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.disableColor,
                              blurRadius: 3.0, // soften the shadow
                              spreadRadius: 1.0, //extend the shadow
                            )
                          ],
                          color: AppColor.whiteColor),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        controller: model.commentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        expands: true,
                        style: TextStyle(
                          color: AppColor.textfieldColor,
                          fontSize:
                              screenHeight * AppSizes().fontSize.normalFontSize,
                          fontFamily: AppFonts.nunitoSemiBold,
                        ),
                        decoration: InputDecoration(
                            hintText: "Add comment here",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: AppColor.hintTextColor,
                              fontSize: screenHeight *
                                  AppSizes().fontSize.normalFontSize,
                              fontFamily: AppFonts.nunitoSemiBold,
                            )),
                      ),
                    ),
                  ],
                ))),
        SizedBox(
          height: screenHeight * 0.15,
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          width: screenWidth,
          child: CommonButton.commonThemeColorButton(
              onPressed: () {
                if (model.selectRating != 0) {
                  model.writeAReviewToGuide(context, widget.guide_user_id);
                } else {
                  GlobalUtility.showToast(context, "Please give star rating");
                }
              },
              text: AppStrings().submit,
              context: context),
        ),
      ],
    );
  }

  //image view
  Widget profileImage(img) {
    return Container(
      width: screenWidth * 0.25,
      height: screenWidth * 0.25,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(color: AppColor.buttonDisableColor, width: 3),
          shape: BoxShape.circle,
          // image: DecorationImage(
          //     image: AssetImage(AppImages().pngImages.icProfilePlaceholder))),
          image: img != null && img != ""
              ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(img))
              : DecorationImage(
                  image:
                      AssetImage(AppImages().pngImages.icProfilePlaceholder))),
    );
  }

  // Rating Widget

  Widget ratingStars(TravellerMyBookingsModel model) {
    return RatingBar.builder(
      initialRating: widget.rate!,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      glow: false,
      itemSize: screenHeight * 0.04,
      unratedColor: AppColor.disableColor,
      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: AppColor.ratingbarColor,
      ),
      onRatingUpdate: (rating) {
        //   model.selectRating = widget.rate;
        model.selectRating = rating.toInt();
        model.notifyListeners();
      },
    );
  }
}
