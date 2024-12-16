// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:Siesta/view/all_bottomsheet/range_selector_datesheet.dart';
import 'package:Siesta/view_models/guide_models/guideReceivedBookingModel.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:stacked/stacked.dart';

class GuideBookingsPage extends StatefulWidget {
  const GuideBookingsPage({Key? key}) : super(key: key);

  @override
  State<GuideBookingsPage> createState() => _GuideBookingsPageState();
}

class _GuideBookingsPageState extends State<GuideBookingsPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  List<String> ratingList = ["1", "2", "3", "4", "5"];
  int pageCount = 1;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<GuideReceivedBookingModel>.reactive(
        viewModelBuilder: () => GuideReceivedBookingModel(context, "no"),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          model.scrollController.addListener(() {
            if (model.scrollController.position.maxScrollExtent ==
                model.scrollController.position.pixels) {
              pageCount = pageCount + 1;
              model.getMyBookings(context, pageCount, "", [0], "", "", "", "");
            } else {}
          });

          return Scaffold(
              backgroundColor: AppColor.whiteColor,
              body: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal:
                        screenWidth * AppSizes().widgetSize.horizontalPadding),
                children: [
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),
                  searchField(model),
                  model.isSearchRunnig == true
                      ? Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.3),
                          child: Text(
                            AppStrings().pleaseWait,
                            style: TextStyle(
                                height: 3,
                                fontFamily: AppFonts.nunitoSemiBold,
                                color: AppColor.fieldEnableColor),
                          ),
                        )
                      : const SizedBox(),
                  model.guideReceivedBookingList.isNotEmpty
                      ? Container(
                          height: screenHeight * 0.73,
                          color: Colors.transparent,
                          child: RefreshIndicator(
                            onRefresh: model.pullRefresh,
                            child: ListView.builder(
                                controller: model.scrollController,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    model.guideReceivedBookingList.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return bookingItemView(index, model);
                                }),
                          ))
                      : emptyItemView(),
                ],
              ));
        });
  }

  Widget emptyItemView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.3),
        Container(
          height: screenHeight * 0.2,
          width: screenWidth,
          alignment: Alignment.center,
          child: Image.asset(AppImages().pngImages.ivEmptySearch),
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.normalPadding, context: context),
        Text(
          "No pending bookings",
          style: TextStyle(
              fontSize: screenHeight * AppSizes().fontSize.largeTextSize,
              fontFamily: AppFonts.nunitoSemiBold,
              color: AppColor.lightBlack),
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.largePadding, context: context),
      ],
    );
  }

  Widget searchField(model) {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        onChanged: (value) {
          if (value != "") {
            model.getMyBookings(context, 1, value, [0], "", "", "", "");
          } else {
            model.getMyBookings(context, 1, "", [0], "", "", "", "");
          }
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.searchFieldDecoWithSuffixWithLeftBorder(
            context, AppStrings().fingGuideSearch, () {
          GlobalUtility.showBottomSheet(
              context,
              RangeDateSelector(
                  travellerMyBookingsModel: null, guideMyBookingsModel: model));
        }),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget bookingItemView(int index, GuideReceivedBookingModel model) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 300),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * AppSizes().widgetSize.xsmallPadding),
            child: Card(
                elevation: 0.5,
                color: AppColor.whiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(screenWidth *
                        AppSizes().widgetSize.mediumBorderRadius))),
                child: Container(
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
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.start,
                      children: [
                        ListTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.01),
                          leading: profileImage(model
                                  .guideReceivedBookingList[index]
                                  .user!
                                  .userDetail!
                                  .profilePicture ??
                              ""),
                          title: TextView.normalText(
                              textColor: AppColor.appthemeColor,
                              textSize: AppSizes().fontSize.simpleFontSize,
                              fontFamily: AppFonts.nunitoBold,
                              text: model.guideReceivedBookingList.length > 0
                                  ? GlobalUtility().firstLetterCapital(
                                      "${model.guideReceivedBookingList[index].firstName} ${model.guideReceivedBookingList[index].lastName != "null" ? model.guideReceivedBookingList[index].lastName : ""}")
                                  : "",
                              context: context),
                          isThreeLine: false,
                          trailing: TextButton.icon(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.topCenter),
                            onPressed: null,
                            icon: Container(
                              height: screenHeight * 0.04,
                              width: screenHeight * 0.04,
                              decoration: BoxDecoration(
                                  color: AppColor.shadowLocation,
                                  shape: BoxShape.circle),
                              child: Icon(Icons.location_on_outlined,
                                  color: AppColor.appthemeColor, size: 16),
                            ),
                            label: Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              width: screenWidth * 0.35,
                              child: TextView.normalText(
                                  text: model.guideReceivedBookingList[index]
                                          .location ??
                                      "",
                                  context: context,
                                  fontFamily: AppFonts.nunitoSemiBold,
                                  textSize: AppSizes().fontSize.xsimpleFontSize,
                                  textColor: AppColor.textfieldColor),
                            ),
                          ),
                        ),
                        Divider(
                          color: AppColor.textfieldborderColor,
                          height: 2,
                        ),
                        UiSpacer.verticalSpace(
                            space: AppSizes().widgetSize.smallPadding,
                            context: context),
                        ListTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03),
                          horizontalTitleGap: 0,
                          leading: Image.asset(
                            AppImages().pngImages.icCalendar,
                            width: AppSizes().widgetSize.iconWidth,
                            height: AppSizes().widgetSize.iconHeight,
                            color: AppColor.appthemeColor,
                          ),
                          title: TextView.normalText(
                              textColor: AppColor.textColorBlack,
                              textSize: AppSizes().fontSize.simpleFontSize,
                              fontFamily: AppFonts.nunitoMedium,
                              text:
                                  "${model.guideReceivedBookingList.length > 0 ? "From: ${model.guideReceivedBookingList[index].startDate}" : ""}   ${model.guideReceivedBookingList.length > 0 ? "To: ${model.guideReceivedBookingList[index].endDate}" : ""}",
                              context: context),
                          isThreeLine: false,
                        ),
                        DottedLine(
                          direction: Axis.horizontal,
                          lineLength: double.infinity,
                          lineThickness: 1.0,
                          dashLength: 6.0,
                          dashColor: AppColor.textfieldborderColor,
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                        UiSpacer.verticalSpace(
                            space: AppSizes().widgetSize.verticalPadding,
                            context: context),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 12),
                          child: buttonRow(
                              model,
                              model.guideReceivedBookingList.length > 0
                                  ? model.guideReceivedBookingList[index].id
                                  : "",
                              index),
                        ),
                      ],
                    ))),
          ),
        ),
      ),
    );
  }

  //image view
  Widget profileImage(String img) {
    return Container(
      height: screenHeight * 0.06,
      width: screenHeight * 0.06,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          shape: BoxShape.circle,
          image: img != null && img != ""
              ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(img))
              : DecorationImage(
                  image:
                      AssetImage(AppImages().pngImages.icProfilePlaceholder))),
    );
  }

  Widget buttonRow(GuideReceivedBookingModel model, bookingId, ind) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.25,
          child: CommonButton.commonButtonRoundedsmallBorderRadius(
            context: context,
            textColor: AppColor.whiteColor,
            text: "Chat",
            onPressed: () async {
              await PreferenceUtil().setGuideSendMessageUserId(
                  model.guideReceivedBookingList[ind].travellerId.toString());
              await PreferenceUtil().setGuideSendMessageUserName(
                  model.guideReceivedBookingList[ind].firstName!);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.touristGuideMessageHomePage,
                (route) => false,
              );
            },
            backColor: AppColor.appthemeColor,
          ),
        ),
        SizedBox(
          width: screenWidth * 0.32,
          child: CommonButton.commonButtonRoundedsmallBorderRadius(
            context: context,
            textColor: AppColor.whiteColor,
            text: "Review",
            onPressed: () {
              reviewSheet(model, ind);
              /*GlobalUtility.showItineraryBottomSheet(
                  context,
                  CreateItineraryPage(
                      guideReceievedBookingModel: model,
                      selIndex: ind,
                      guideBookinghistoryModel: null));*/
            },
            backColor: AppColor.progressbarColor,
          ),
        ),
        SizedBox(
          width: screenWidth * 0.25,
          child: CommonButton.commonButtonRoundedsmallBorderRadius(
            context: context,
            textColor: AppColor.textbuttonColor,
            text: AppStrings().rejectText,
            onPressed: () {
              cancelTripSheet(model, bookingId, ind);
            },
            backColor: AppColor.marginBorderColor,
          ),
        ),
      ],
    );
  }

  void reviewSheet(GuideReceivedBookingModel model, int index) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextView.normalText(
                    context: context,
                    text: "Review Booking",
                    textColor: AppColor.appthemeColor,
                    textSize: AppSizes().fontSize.headingTextSize,
                    fontFamily: AppFonts.nunitoSemiBold),
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: AppColor.appthemeColor,
                    ))
              ],
            ),
            subtitle: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                TextView.normalText(
                    context: context,
                    text: "Name",
                    textColor: AppColor.blackColor,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    fontFamily: AppFonts.nunitoBold),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.01),
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.disableColor.withOpacity(0.2)),
                  child: TextView.normalText(
                      context: context,
                      text:
                          "${model.guideReceivedBookingList[index].firstName ?? ""} ${model.guideReceivedBookingList[index].lastName ?? ""}",
                      textColor: AppColor.blackColor,
                      textSize: AppSizes().fontSize.simpleFontSize,
                      fontFamily: AppFonts.nunitoSemiBold),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView.normalText(
                        context: context,
                        text: "Location",
                        textColor: AppColor.blackColor,
                        textSize: AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoBold),
                    Container(
                        width: screenWidth,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.01),
                        margin:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.disableColor.withOpacity(0.2)),
                        child: Text(
                          model.guideReceivedBookingList[index].location ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: screenHeight *
                                  AppSizes().fontSize.simpleFontSize,
                              fontFamily: AppFonts.nunitoSemiBold,
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView.normalText(
                            context: context,
                            text: "No. of People",
                            textColor: AppColor.blackColor,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            fontFamily: AppFonts.nunitoBold),
                        Container(
                          width: screenWidth * 0.32,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.01),
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.disableColor.withOpacity(0.2)),
                          child: TextView.normalText(
                              context: context,
                              text: model.guideReceivedBookingList[index]
                                      .noOfPeople ??
                                  "",
                              textColor: AppColor.blackColor,
                              textSize: AppSizes().fontSize.simpleFontSize,
                              fontFamily: AppFonts.nunitoSemiBold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView.normalText(
                            context: context,
                            text: "No of days",
                            textColor: AppColor.blackColor,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            fontFamily: AppFonts.nunitoBold),
                        Container(
                          width: screenWidth * 0.32,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.01),
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.disableColor.withOpacity(0.2)),
                          child: TextView.normalText(
                              context: context,
                              text: model.guideReceivedBookingList[index].post
                                      ?.duration ??
                                  "",
                              textColor: AppColor.blackColor,
                              textSize: AppSizes().fontSize.simpleFontSize,
                              fontFamily: AppFonts.nunitoSemiBold),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView.normalText(
                            context: context,
                            text: "Start date",
                            textColor: AppColor.blackColor,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            fontFamily: AppFonts.nunitoBold),
                        Container(
                          width: screenWidth * 0.32,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.01),
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.disableColor.withOpacity(0.2)),
                          child: TextView.normalText(
                              context: context,
                              text: model.guideReceivedBookingList[index]
                                      .startDate ??
                                  "",
                              textColor: AppColor.blackColor,
                              textSize: AppSizes().fontSize.simpleFontSize,
                              fontFamily: AppFonts.nunitoSemiBold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView.normalText(
                            context: context,
                            text: "End date",
                            textColor: AppColor.blackColor,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            fontFamily: AppFonts.nunitoBold),
                        Container(
                          width: screenWidth * 0.32,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.01),
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.disableColor.withOpacity(0.2)),
                          child: TextView.normalText(
                              context: context,
                              text: model.guideReceivedBookingList[index]
                                      .endDate ??
                                  "",
                              textColor: AppColor.blackColor,
                              textSize: AppSizes().fontSize.simpleFontSize,
                              fontFamily: AppFonts.nunitoSemiBold),
                        ),
                      ],
                    ),
                  ],
                ),
                TextView.normalText(
                    context: context,
                    text: "Notes",
                    textColor: AppColor.blackColor,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    fontFamily: AppFonts.nunitoBold),
                Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.01),
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColor.disableColor.withOpacity(0.2)),
                    child: Text(
                      model.guideReceivedBookingList[index].notes ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      softWrap: true,
                      style: TextStyle(
                          fontSize:
                              screenHeight * AppSizes().fontSize.simpleFontSize,
                          fontFamily: AppFonts.nunitoSemiBold,
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.w500),
                    )),
                UiSpacer.verticalSpace(context: context, space: 0.02),

                // accept booking button
                CommonButton.commonNormalButton(
                  context: context,
                  text: "Accept",
                  backColor: AppColor.appthemeColor,
                  onPressed: () {
                    model.acceptBookingAPI(
                      bookingId: (model.guideReceivedBookingList[index].id ?? 0)
                          .toString(),
                    );
                  },
                ),

                SizedBox(
                  height: screenHeight * 0.03,
                )
              ],
            ),
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 800),
    );
  }

  cancelTripSheet(GuideReceivedBookingModel model, bookingId, ind) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        )),
        builder: (context) => ValueListenableBuilder(
            valueListenable: model.counterNotifier1,
            builder: (context, current, child) {
              return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(
                        screenWidth * AppSizes().widgetSize.horizontalPadding),
                    children: [
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      Center(
                        child: Container(
                          height: 4,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding,
                          context: context),
                      Center(
                          child: TextView.normalText(
                              context: context,
                              fontFamily: AppFonts.nunitoSemiBold,
                              textSize: AppSizes().fontSize.headingTextSize,
                              textColor: AppColor.lightBlack,
                              text: AppStrings().cancelBooking)),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding,
                          context: context),
                      Container(
                        height: 1.8,
                        width: screenWidth,
                        color: Colors.black12,
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      TextView.normalText(
                          text: AppStrings().cancelReasonsheet,
                          textColor: AppColor.dontHaveTextColor,
                          textSize: AppSizes().fontSize.mediumFontSize,
                          fontFamily: AppFonts.nunitoRegular,
                          context: context),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                      reasonForCancel(model),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                      cancelButton(model, bookingId, ind),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                    ],
                  ));
            }));
  }

  Widget reasonForCancel(GuideReceivedBookingModel model) {
    return SizedBox(
      child: TextFormField(
        controller: model.cancelReasonController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onReasonFieldChange(model),
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          hintText: "Please write your reason here...",
          contentPadding: const EdgeInsets.only(
            top: 8,
            bottom: 0,
            left: 10,
          ),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldEnableColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
        ),
      ),
    );
  }

  Widget cancelButton(GuideReceivedBookingModel model, bookingId, ind) {
    return model.isBusy == false
        ? CommonButton.commonBoldTextButton(
            text: AppStrings().cancelBooking,
            context: context,
            onPressed: () {
              model.counterNotifier1.value++;
              if (validate(model)) {
                if (model.isCancelButtonEnable) {
                  if (model.cancelReasonController.text != "" &&
                      model.cancelReasonController.text.trim().isNotEmpty) {
                    if (model.guideReceivedBookingList[ind].status == 1 ||
                        model.guideReceivedBookingList[ind].status == 3 ||
                        model.guideReceivedBookingList[ind].status == 5 ||
                        model.guideReceivedBookingList[ind].status == 7 ||
                        model.guideReceivedBookingList[ind].status == 9) {
                      GlobalUtility.showToast(
                          context, "This Booking is rejected!! 😔 ");
                    } else {
                      model.guideCancelTrip(context, bookingId);
                    }
                  } else {
                    GlobalUtility.showToast(
                        context, "Please write reason for cancel trip!!");
                  }
                }
              }
            },
            isButtonEnable: model.isCancelButtonEnable)
        : SizedBox(
            width: screenWidth * 0.1,
            child: Center(
              child: CircularProgressIndicator(color: AppColor.appthemeColor),
            ),
          );
  }

  onReasonFieldChange(GuideReceivedBookingModel model) {
    if (model.cancelReasonController.text != "") {
      model.isCancelButtonEnable = true;
      model.notifyListeners();
      model.counterNotifier1.value++;
    } else {
      model.isCancelButtonEnable = false;
      model.notifyListeners();
      model.counterNotifier1.value++;
    }
  }

  bool validate(GuideReceivedBookingModel model) {
    String cancelReason = model.cancelReasonController.text;
    if (cancelReason == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterCancelReason);
      return false;
    }
    return true;
  }
}
