import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/custom_widgets/custom_textfield.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view_models/gallery_general_experience_models/post_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
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
import '../../../../custom_widgets/custom_traveller_experience_tile.dart';
import '../../../../custom_widgets/custom_video_thumbnail.dart';
import '../../../../main.dart';

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
                  if (widget.argData["otherPersonProfile"] != true)
                    IconButton(
                        onPressed: () async {
                          if (model.postDetail != null) {
                            var varData = await Navigator.pushNamed(
                                context, AppRoutes.createPostPage,
                                arguments: {
                                  "type": type == "general"
                                      ? "general"
                                      : "experience",
                                  "screenType": "edit",
                                  "postDetails": model.postDetail,
                                });
                            if (varData != null) {
                              model.getPostDetailAPI(postId);
                            }
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

                            // guide detail view
                            if (model.userType == "TRAVELLER")
                              guideDetailView(model),

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

                            // Meet your localite view
                            if (model.userType == "TRAVELLER")
                              meetLocaliteView(model),

                            // rating and review
                            if ((model.postDetail?.user?.ratingAndReviews
                                        ?.length ??
                                    0) >
                                0)
                              reviewAndRating(model),

                            // similar experience
                            if (model.userType == "TRAVELLER" &&
                                model.similarExperienceList.isNotEmpty)
                              similarExperienceView(model),
                          ],
                        ));
        });
  }

  Widget guideDetailView(PostDetailModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            CommonImageView.roundNetworkImage(
              imgUrl: model.postDetail?.user?.userDetail?.profilePicture ?? "",
              height: screenHeight * 0.13,
              width: screenHeight * 0.13,
            ),
            UiSpacer.horizontalSpace(context: context, space: 0.04),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextView.headingText(
                    context: context,
                    text:
                        "${model.postDetail?.user?.name} ${model.postDetail?.user?.lastName ?? ""}",
                    color: AppColor.greyColor600,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                  ),
                  UiSpacer.verticalSpace(context: context, space: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextView.mediumText(
                        context: context,
                        text:
                            "${double.parse(model.postDetail?.user?.avgRating ?? "0.0").toStringAsFixed(1)} (${model.postDetail?.user?.ratingAndReviews?.length})",
                        textColor: AppColor.greyColor600,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        fontWeight: FontWeight.w400,
                        textSize: 0.017,
                      ),
                      UiSpacer.horizontalSpace(context: context, space: 0.02),
                      RatingBar.builder(
                        initialRating: double.parse(
                            model.postDetail?.user?.avgRating ?? "0.0"),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: screenHeight * 0.023,
                        unratedColor: Colors.white,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 10,
                        ),
                        onRatingUpdate: (rating) {},
                      )
                    ],
                  ),
                  UiSpacer.verticalSpace(context: context, space: 0.01),
                  if ((model.postDetail?.user?.ratingAndReviews!.length ?? 0) >
                      0)
                    TextView.mediumText(
                      context: context,
                      text:
                          "Related ${double.parse(model.postDetail?.user?.avgRating ?? "0.0")} out of 5 from ${model.postDetail?.user?.ratingAndReviews!.length ?? "0"} reviews.",
                      textColor: AppColor.greyColor600,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      fontWeight: FontWeight.w400,
                      textSize: 0.017,
                    ),
                ],
              ),
            )
          ],
        ),
        UiSpacer.verticalSpace(context: context, space: 0.03),
      ],
    );
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
            color: AppColor.greyColor600,
            fontSize: screenHeight * 0.028,
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

  Widget reviewAndRating(PostDetailModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiSpacer.verticalSpace(context: context, space: 0.02),

        TextView.headingText(
          context: context,
          text: "Review & Ratings",
          color: AppColor.greyColor600,
          fontSize: screenHeight * 0.028,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // listing
        ListView.separated(
          shrinkWrap: true,
          itemCount: model.postDetail?.user?.ratingAndReviews?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ratingReviewWidget(
            profileImg: model.postDetail?.user?.ratingAndReviews?[index]
                    .profilePicture ??
                "",
            avgRating: double.parse(
                (model.postDetail?.user?.ratingAndReviews?[index].ratings ?? 0)
                    .toString()),
            fullName:
                model.postDetail?.user?.ratingAndReviews?[index].userName ?? "",
            hostSince:
                "2025" /*model.calculateYear(
                y: model.postDetail?.user?.userDetail?.hostSinceYears ?? "0",
                m: model.postDetail?.user?.userDetail?.hostSinceMonths ?? "0")*/
            ,
            reviewText: model
                    .postDetail?.user?.ratingAndReviews?[index].reviewMessage ??
                "",
          ),
          separatorBuilder: (context, index) =>
              UiSpacer.verticalSpace(context: context, space: 0.02),
        )
      ],
    );
  }

  Widget ratingReviewWidget(
      {required String profileImg,
      required String fullName,
      required String hostSince,
      required double avgRating,
      required String reviewText}) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor.greyColor500,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonImageView.roundNetworkImage(
            imgUrl: profileImg,
            height: screenHeight * 0.08,
            width: screenHeight * 0.08,
          ),
          UiSpacer.horizontalSpace(context: context, space: 0.04),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView.headingText(
                  context: context,
                  text: fullName,
                  color: AppColor.greyColor600,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  fontSize: screenHeight * 0.026,
                ),
                UiSpacer.verticalSpace(context: context, space: 0.006),
                TextView.mediumText(
                  context: context,
                  text: hostSince,
                  textColor: AppColor.greyColor500,
                  textSize: 0.016,
                ),
                UiSpacer.verticalSpace(context: context, space: 0.006),
                RatingBar.builder(
                  initialRating: avgRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: screenHeight * 0.023,
                  unratedColor: Colors.white,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 10,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                UiSpacer.verticalSpace(context: context, space: 0.006),
                TextView.mediumText(
                  context: context,
                  text: reviewText,
                  textColor: AppColor.greyColor500,
                  fontWeight: FontWeight.w400,
                  maxLines: 6,
                  textSize: 0.018,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget meetLocaliteView(PostDetailModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiSpacer.verticalSpace(context: context, space: 0.02),

        Divider(
          color: AppColor.greyColor500,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // content
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // image
            CommonImageView.roundNetworkImage(
              imgUrl: model.postDetail?.user?.userDetail?.profilePicture ?? "",
              height: screenHeight * 0.1,
              width: screenHeight * 0.1,
            ),
            UiSpacer.horizontalSpace(context: context, space: 0.04),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextView.headingText(
                    context: context,
                    text:
                        "Meet your localite, ${model.postDetail?.user?.name} ${model.postDetail?.user?.lastName}",
                    color: AppColor.greyColor600,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                  UiSpacer.verticalSpace(context: context, space: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextView.mediumText(
                        context: context,
                        text:
                            "Host since ${model.calculateYear(y: model.postDetail?.user?.userDetail?.hostSinceYears ?? "0", m: model.postDetail?.user?.userDetail?.hostSinceMonths ?? "0")}",
                        textColor: AppColor.greyColor500,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        fontWeight: FontWeight.w400,
                        textSize: 0.017,
                      ),
                      UiSpacer.horizontalSpace(context: context, space: 0.02),
                      Icon(
                        Icons.star_rounded,
                        color: AppColor.greyColor500,
                        size: 17,
                      ),
                      TextView.mediumText(
                        context: context,
                        text:
                            " ${double.parse(model.postDetail?.user?.avgRating ?? "0.0").toStringAsFixed(1)}",
                        textColor: AppColor.greyColor500,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        fontWeight: FontWeight.w400,
                        textSize: 0.017,
                      ),
                      /* UiSpacer.horizontalSpace(context: context, space: 0.02),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.greyColor500,
                        ),
                      ),
                      UiSpacer.horizontalSpace(context: context, space: 0.02),
                      Expanded(
                        child: TextView.mediumText(
                          context: context,
                          text: " ${model.postDetail?.user?.userDetail?.}",
                          textColor: AppColor.greyColor500,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          fontWeight: FontWeight.w500,
                          textSize: 0.017,
                        ),
                      ),*/
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // bio
        TextView.mediumText(
          context: context,
          text: model.postDetail?.user?.userDetail?.bio ?? "",
          textColor: AppColor.greyColor500,
          textAlign: TextAlign.left,
          fontWeight: FontWeight.w400,
          textSize: 0.018,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // join the experience
        SizedBox(
          width: screenWidth,
          height: screenHeight * 0.06,
          child: CommonButton.commonNormalButton(
            context: context,
            onPressed: () {
              showRequestInfoSheet(model);
            },
            text: "Join the Experience",
            borderRadius: 50,
            backColor: AppColor.appthemeColor,
          ),
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),
        Divider(
          color: AppColor.greyColor500,
        )
      ],
    );
  }

  Widget similarExperienceView(PostDetailModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiSpacer.verticalSpace(context: context, space: 0.04),

        // Similar experience title
        TextView.headingText(
          context: context,
          text: "Similar experience",
          color: AppColor.greyColor600,
          fontSize: screenHeight * 0.028,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),

        // listing
        ListView.separated(
          shrinkWrap: true,

          // only show max 4 similar experience
          itemCount: model.similarExperienceList.length > 4
              ? 4
              : model.similarExperienceList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => CustomTravellerExperienceTile(
            id: (model.similarExperienceList[index].id ?? 0).toString(),
            heroImage: model.similarExperienceList[index].heroImage ?? "",
            title: model.similarExperienceList[index].title ?? "",
            avgRating:
                model.similarExperienceList[index].user?.avgRating ?? "0",
            price: (model.similarExperienceList[index].price ?? "0").toString(),
            duration: model.similarExperienceList[index].duration ?? "",
          ),
          // itemBuilder: (context, index) => Container(),
          separatorBuilder: (context, index) =>
              UiSpacer.verticalSpace(context: context, space: 0.02),
        )
      ],
    );
  }

  void showRequestInfoSheet(PostDetailModel model) {
    var firstNameTEC = TextEditingController(
        text: prefs.getString(SharedPreferenceValues.firstName) ?? "");
    var lastNameTEC = TextEditingController(
        text: prefs.getString(SharedPreferenceValues.lastName) ?? "");
    var locationTEC =
        TextEditingController(text: model.postDetail?.location ?? "");
    var startDateTEC = TextEditingController();
    var endDateTEC = TextEditingController();
    var startTimeTEC = TextEditingController(
        text: CommonDateTimeFormats.timeFormatLocal(
            model.postDetail?.startingTime ?? ""));
    var notesTEC = TextEditingController();
    var noOfPeopleTEC = TextEditingController();
    String startDateVal = "";
    String endDateVal = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.9,
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModelState) {
            return Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                top: screenWidth * 0.04,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // request info text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // request info
                        TextView.headingText(
                          context: context,
                          text: "Request Info",
                          color: AppColor.greyColor600,
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: AppColor.greyColor600,
                          ),
                        )
                      ],
                    ),
                    UiSpacer.verticalSpace(context: context, space: 0.01),

                    // request info desc
                    TextView.mediumText(
                      context: context,
                      text:
                          "Your Dream Destination Awaits: Join Your Adventure Today!",
                      textColor: AppColor.greyColor500,
                      textAlign: TextAlign.start,
                      textSize: 0.016,
                    ),
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                    Row(
                      children: [
                        // first and last name
                        Expanded(
                          child: CustomTextField(
                            textEditingController: firstNameTEC,
                            headingText: "First Name",
                            readOnly: true,
                            isFilled: true,
                            fillColor: AppColor.fieldBorderColor,
                            hintText: "Enter first name",
                          ),
                        ),
                        UiSpacer.horizontalSpace(context: context, space: 0.04),
                        Expanded(
                          child: CustomTextField(
                            textEditingController: lastNameTEC,
                            headingText: "Last Name",
                            readOnly: true,
                            isFilled: true,
                            fillColor: AppColor.fieldBorderColor,
                            hintText: "Enter last name",
                          ),
                        )
                      ],
                    ),
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                    // location
                    CustomTextField(
                      textEditingController: locationTEC,
                      headingText: "Location",
                      hintText: "Enter location",
                      readOnly: true,
                      isFilled: true,
                      fillColor: AppColor.fieldBorderColor,
                    ),
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                    // date and time
                    Row(
                      children: [
                        // first and last name
                        Expanded(
                          child: CustomTextField(
                            readOnly: true,
                            textEditingController: startDateTEC,
                            headingText: "Start Date",
                            hintText: "Pick date",
                            suffixIconPath: AppImages().svgImages.icCalendar,
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                initialDatePickerMode: DatePickerMode.day,
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 0)),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(picked);

                                String formattedEndDate =
                                    DateFormat('dd-MM-yyyy').format(picked.add(
                                        Duration(
                                            days: int.parse(model
                                                    .postDetail?.duration
                                                    ?.split(" ")[0] ??
                                                "0"))));

                                startDateVal = picked.toString();
                                endDateVal = picked
                                    .add(Duration(
                                        days: int.parse(model
                                                .postDetail?.duration
                                                ?.split(" ")[0] ??
                                            "0")))
                                    .toString();

                                startDateTEC.text = formattedDate;
                                endDateTEC.text = formattedEndDate;

                                setModelState(() {});
                              }
                            },
                          ),
                        ),
                        UiSpacer.horizontalSpace(context: context, space: 0.04),
                        Expanded(
                          child: CustomTextField(
                            readOnly: true,
                            isFilled: true,
                            fillColor: AppColor.fieldBorderColor,
                            textEditingController: endDateTEC,
                            headingText: "End Date",
                            hintText: "End date",
                            suffixIconPath: AppImages().svgImages.icCalendar,
                          ),
                        )
                      ],
                    ),
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                    // start time & no. of people
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            textEditingController: startTimeTEC,
                            headingText: "Start Time",
                            hintText: "Pick time",
                            suffixIconPath: AppImages().svgImages.icClock,
                            readOnly: true,
                            isFilled: true,
                            fillColor: AppColor.fieldBorderColor,
                          ),
                        ),
                        UiSpacer.horizontalSpace(context: context, space: 0.04),
                        Expanded(
                          child: CustomTextField(
                            keyboardType: TextInputType.number,
                            textEditingController: noOfPeopleTEC,
                            headingText: "No. of People",
                            hintText: "Enter no. of people",
                            maxLength: 5,
                            showCounterText: false,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        )
                      ],
                    ),
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                    // no. of people

                    // notes
                    CustomTextField(
                      textEditingController: notesTEC,
                      headingText: "Notes",
                      hintText: "Give description (100 to 180 words)",
                      minLines: 5,
                      maxLines: 5,
                    ),
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                    // save button
                    SizedBox(
                      width: screenWidth,
                      child: CommonButton.commonNormalButton(
                        context: context,
                        borderRadius: 50,
                        text: "Save",
                        onPressed: () {
                          if (startDateTEC.text.isEmpty) {
                            GlobalUtility.showToast(
                                context, "Please select start date");
                          } else if (noOfPeopleTEC.text.trim().isEmpty) {
                            GlobalUtility.showToast(
                                context, "Please enter no. of people");
                          } else if (int.parse(noOfPeopleTEC.text) <
                              (model.postDetail?.minPeople ?? 0)) {
                            GlobalUtility.showToast(context,
                                "The minimum no. of people is ${model.postDetail?.minPeople ?? 0}");
                          } else if (int.parse(noOfPeopleTEC.text) >
                              (model.postDetail?.maxPeople ?? 0)) {
                            GlobalUtility.showToast(context,
                                "The maximum no. of people is ${model.postDetail?.maxPeople ?? 0}");
                          } else if (notesTEC.text.trim().isEmpty) {
                            GlobalUtility.showToast(
                                context, "Please enter the notes");
                          } else {
                            // call the API
                            model.bookExperienceAPI(
                              localiteId:
                                  (model.postDetail?.user?.id ?? 0).toString(),
                              firstName: firstNameTEC.text,
                              lastName: lastNameTEC.text,
                              location: locationTEC.text,
                              startDate: startDateVal,
                              endDate: endDateVal,
                              startTime: startTimeTEC.text,
                              notes: notesTEC.text.trim(),
                              noOfPeople: noOfPeopleTEC.text,
                            );
                          }
                        },
                        backColor: AppColor.appthemeColor,
                      ),
                    ),
                    UiSpacer.verticalSpace(context: context, space: 0.02),
                  ],
                ),
              ),
            );
          },
        );
      },
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
