// ignore_for_file: must_be_immutable, prefer_is_empty, non_constant_identifier_names, use_build_context_synchronously

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/all_bottomsheet/edit_package_sheet.dart';
import 'package:Siesta/view/travellerView/itinerary/payment_screen.dart';
import 'package:Siesta/view_models/itineraryDetailModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../app_constants/app_routes.dart';
import '../../../utility/preference_util.dart';

class ItineraryDetailPage extends StatefulWidget {
  ItineraryDetailPage({Key? key, Object? bookingId}) : super(key: key) {
    Map obj = bookingId as Map;
    booking_id = obj["bookingId"];
  }
  int? booking_id;
  @override
  State<ItineraryDetailPage> createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
  double screenWidth = 0.0, screenHeight = 0.0;

  int? travellerStatus;
  int? travellerComplete;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<TravellerItineraryDetailModel>.reactive(
        viewModelBuilder: () =>
            TravellerItineraryDetailModel(context, widget.booking_id),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          if (model.travellerItineraryDetailResponse != null) {
            travellerStatus =
                model.travellerItineraryDetailResponse!.data!.status;
            travellerComplete =
                model.travellerItineraryDetailResponse!.data!.isCompleted;
            debugPrint(
                "STATUS :==>> $travellerStatus --------- IS COMPLETE :==>> $travellerComplete ");
          }

          return Scaffold(
            backgroundColor: Colors.white,
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
                  text: AppStrings().itineraryDetails, context: context),
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
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Container(
                        alignment: Alignment.center,
                        color: AppColor.whiteColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UiSpacer.verticalSpace(
                                context: context,
                                space: AppSizes().widgetSize.normalPadding),
                            profileImageView(
                                model.travellerItineraryDetailResponse != null
                                    ? model.travellerItineraryDetailResponse!
                                        .data!.user!.userDetail!.profilePicture
                                    : ""),
                            UiSpacer.verticalSpace(
                                space: AppSizes().widgetSize.normalPadding,
                                context: context),
                            TextView.headingText(
                                context: context,
                                text: model.travellerItineraryDetailResponse !=
                                        null
                                    ? GlobalUtility().firstLetterCapital(
                                        "${model.travellerItineraryDetailResponse!.data!.user!.name} ${model.travellerItineraryDetailResponse!.data!.user!.lastName}")
                                    : ""),
                            UiSpacer.verticalSpace(
                                space: AppSizes().widgetSize.smallPadding,
                                context: context),
                            /* TextView.subHeadingText(
                                context: context,
                                text: model.travellerItineraryDetailResponse !=
                                        null
                                    ? model.travellerItineraryDetailResponse
                                        ?.data!.user!.email
                                    : ""),*/
                            UiSpacer.verticalSpace(
                                space: AppSizes().widgetSize.smallPadding,
                                context: context),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: Divider(
                                  color: AppColor.disableColor,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: screenWidth * 0.45,
                                  color: Colors.transparent,
                                  child: textButtonWithIcon(
                                      AppImages().pngImages.icLoc,
                                      model.travellerItineraryDetailResponse !=
                                              null
                                          ? "${GlobalUtility().firstLetterCapital(model.travellerItineraryDetailResponse!.data!.country!.toString())}, ${GlobalUtility().firstLetterCapital(model.travellerItineraryDetailResponse!.data!.state!.toString())}, ${model.travellerItineraryDetailResponse!.data!.city!.length != 0 ? GlobalUtility().firstLetterCapital(model.travellerItineraryDetailResponse!.data!.city.toString()) : ""}"
                                          : ""),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  width: screenWidth * 0.45,
                                  color: Colors.transparent,
                                  child: textButtonWithIcon(
                                      AppImages().pngImages.icCalendar,
                                      model.travellerItineraryDetailResponse !=
                                              null
                                          ? "${model.travellerItineraryDetailResponse?.data!.dateDetails!.replaceAll("rd", "")}"
                                          : ""),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: AppColor.whiteColor,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                AppSizes().widgetSize.horizontalPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UiSpacer.verticalSpace(
                                context: context,
                                space: AppSizes().widgetSize.normalPadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextView.normalText(
                                    context: context,
                                    text: AppStrings().itinerary,
                                    textColor: AppColor.lightBlack,
                                    fontFamily: AppFonts.nunitoMedium,
                                    textSize:
                                        AppSizes().fontSize.headingTextSize),
                                model.travellerItineraryDetailResponse?.data!
                                                .status ==
                                            2 ||
                                        model
                                                .travellerItineraryDetailResponse
                                                ?.data!
                                                .status ==
                                            8
                                    ? CommonButton.commonButtonWithIconText(
                                        text: AppStrings().editQuote,
                                        context: context,
                                        color:
                                            (travellerStatus ==
                                                            8 ||
                                                        travellerStatus == 6) &&
                                                    travellerComplete != 0
                                                ? AppColor.buttonDisableColor
                                                : AppColor.appthemeColor,
                                        onPressed: () {
                                          debugPrint(
                                              "STATUS VALUES---- $travellerStatus ---- isComplete-- $travellerComplete");
                                          cancelTripSheet(model);
                                        },
                                        iconPath: AppImages().pngImages.icEdit)
                                    : CommonButton.commonButtonWithIconText(
                                        text: AppStrings().editQuote,
                                        context: context,
                                        color:
                                            (model.travellerItineraryDetailResponse?.data!
                                                            .status ==
                                                        1 ||
                                                    model.travellerItineraryDetailResponse
                                                            ?.data!.status ==
                                                        3 ||
                                                    model.travellerItineraryDetailResponse
                                                            ?.data!.status ==
                                                        4 ||
                                                    model.travellerItineraryDetailResponse
                                                            ?.data!.status ==
                                                        5 ||
                                                    model.travellerItineraryDetailResponse
                                                            ?.data!.status ==
                                                        7 ||
                                                    model.travellerItineraryDetailResponse
                                                            ?.data!.status ==
                                                        9)
                                                ? AppColor.buttonDisableColor
                                                : AppColor.appthemeColor,
                                        onPressed: () {
                                          if (model.travellerItineraryDetailResponse?.data!.status == 1 ||
                                              model.travellerItineraryDetailResponse
                                                      ?.data!.status ==
                                                  3 ||
                                              model.travellerItineraryDetailResponse
                                                      ?.data!.status ==
                                                  4 ||
                                              model.travellerItineraryDetailResponse
                                                      ?.data!.status ==
                                                  5 ||
                                              model.travellerItineraryDetailResponse
                                                      ?.data!.status ==
                                                  7 ||
                                              model.travellerItineraryDetailResponse
                                                      ?.data!.status ==
                                                  9) {
                                          } else {
                                            GlobalUtility.showToast(context,
                                                "You already requested");
                                          }

                                          debugPrint(
                                              "STATUS VALUES----2  ${(travellerStatus == 2 || travellerStatus == 8 || travellerStatus == 6) && travellerComplete != 0}");
                                        },
                                        iconPath: AppImages().pngImages.icEdit)
                              ],
                            ),
                            UiSpacer.verticalSpace(
                                context: context,
                                space: AppSizes().widgetSize.normalPadding),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.00),
                              title: TextView.normalText(
                                  textColor: AppColor.lightBlack,
                                  textSize: AppSizes().fontSize.normalFontSize,
                                  fontFamily: AppFonts.nunitoBold,
                                  text:
                                      "${AppStrings().advanceAmount}${model.travellerItineraryDetailResponse != null && model.travellerItineraryDetailResponse!.data!.itinerary != null ? model.travellerItineraryDetailResponse?.data!.itinerary!.price : ""}",
                                  context: context),
                              subtitle: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: AppStrings().note,
                                      style: TextStyle(
                                          fontFamily: AppFonts.nunitoRegular,
                                          color: AppColor.blackColor,
                                          fontSize: screenHeight *
                                              AppSizes()
                                                  .fontSize
                                                  .mediumFontSize)),
                                  TextSpan(
                                      text: AppStrings().notePrepayment,
                                      style: TextStyle(
                                          fontFamily: AppFonts.nunitoSemiBold,
                                          color: AppColor.hintTextColor,
                                          fontSize: screenHeight *
                                              AppSizes()
                                                  .fontSize
                                                  .mediumFontSize)),
                                ]),
                              ),
                              isThreeLine: false,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.00),
                              title: TextView.normalText(
                                  textColor: AppColor.lightBlack,
                                  textSize: AppSizes().fontSize.normalFontSize,
                                  fontFamily: AppFonts.nunitoBold,
                                  text:
                                      "Final Amount : \$${model.travellerItineraryDetailResponse != null && model.travellerItineraryDetailResponse!.data!.itinerary != null ? model.travellerItineraryDetailResponse?.data!.itinerary!.finalPrice : ""}",
                                  context: context),
                            ),
                            HtmlWidget(
                                textStyle: TextStyle(
                                    color: model.travellerItineraryDetailResponse !=
                                                null &&
                                            model.travellerItineraryDetailResponse!
                                                    .data!.itinerary !=
                                                null
                                        ? model
                                                    .travellerItineraryDetailResponse
                                                    ?.data!
                                                    .itinerary!
                                                    .descriptions !=
                                                null
                                            ? AppColor.blackColor
                                            : AppColor.textbuttonColor
                                        : AppColor.textbuttonColor),
                                model.travellerItineraryDetailResponse != null &&
                                        model.travellerItineraryDetailResponse!
                                                .data!.itinerary !=
                                            null
                                    ? model
                                                .travellerItineraryDetailResponse
                                                ?.data!
                                                .itinerary!
                                                .descriptions !=
                                            null
                                        ? (model.travellerItineraryDetailResponse
                                                ?.data!.itinerary!.descriptions)
                                            .toString()
                                        : travellerStatus == 5 &&
                                                travellerComplete == 0
                                            ? ""
                                            : "In order to view itinerary, please pay advance amount."
                                    : travellerStatus == 5 &&
                                            travellerComplete == 0
                                        ? ""
                                        : "In order to view itinerary, please pay advance amount."),
                            UiSpacer.verticalSpace(
                                context: context,
                                space: AppSizes().widgetSize.normalPadding),
                            ListView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: model.bookingTrackHistories!.length,
                                padding: const EdgeInsets.only(
                                    bottom: kBottomNavigationBarHeight),
                                itemBuilder: (context, index) {
                                  return itineraryDetailView(index, model);
                                }),
                            travellerComplete == 0 &&
                                    model.travellerItineraryDetailResponse
                                            ?.data!.status ==
                                        8
                                ? Text(
                                    "Itinerary updated by guide as per request.",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                                .size
                                                .height *
                                            AppSizes().fontSize.simpleFontSize,
                                        fontFamily: AppFonts.nunitoBold,
                                        color: AppColor.appthemeColor),
                                    textAlign: TextAlign.center,
                                  )
                                : const SizedBox(),
                            UiSpacer.verticalSpace(
                                context: context,
                                space: AppSizes().widgetSize.verticalPadding),
                            buttonView(model),
                            UiSpacer.verticalSpace(
                                context: context,
                                space: AppSizes()
                                    .widgetSize
                                    .roundBorderRadiuSmall),
                          ],
                        ),
                      )
                    ],
                  ),
          );
        });
  }

  Widget itineraryDetailView(int index, TravellerItineraryDetailModel model) {
    return Column(
      children: [
        Text(
          model.bookingTrackHistories!.length > 0
              ? model.bookingTrackHistories![index].key!.replaceAll("_", " ")
              : "",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.simpleFontSize,
              fontFamily: AppFonts.nunitoBold,
              color: AppColor.appthemeColor),
          textAlign: TextAlign.center,
        ),
        TextView.normalText(
            context: context,
            text: model.bookingTrackHistories!.length > 0
                ? model.bookingTrackHistories![index].value
                : "",
            textColor: AppColor.lightBlack,
            textSize: AppSizes().fontSize.xsimpleFontSize,
            fontFamily: AppFonts.nunitoSemiBold),
        UiSpacer.verticalSpace(
            context: context, space: AppSizes().widgetSize.smallPadding),
      ],
    );
  }

  Widget profileImageView(img) {
    return Container(
      width: screenWidth * 0.25,
      height: screenWidth * 0.25,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(color: AppColor.buttonDisableColor, width: 2),
          shape: BoxShape.circle,
          image: img != null && img != ""
              ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(img))
              : DecorationImage(
                  image:
                      AssetImage(AppImages().pngImages.icProfilePlaceholder))),
    );
  }

  Widget textButtonWithIcon(String iconPath, String titleText) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.topCenter),
      onPressed: null,
      icon: Image.asset(
        iconPath,
        width: 18,
        height: 18,
      ),
      label: Transform.translate(
        offset: const Offset(-6, 0),
        child: TextView.normalText(
            text: GlobalUtility().firstLetterCapital(titleText),
            context: context,
            fontFamily: AppFonts.nunitoMedium,
            textSize: AppSizes().fontSize.mediumFontSize,
            textColor: AppColor.textfieldColor),
      ),
    );
  }

  Widget textButtonWithIconForDate(String iconPath, String titleText) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.topCenter),
      onPressed: null,
      icon: Image.asset(
        iconPath,
        width: 18,
        height: 18,
      ),
      label: Transform.translate(
          offset: const Offset(-3, 0),
          child: Container(
            height: screenHeight * 0.038,
            width: screenWidth * 0.35,
            color: Colors.transparent,
            child: Text(
              GlobalUtility().firstLetterCapital(titleText),
              maxLines: 2,
              style: TextStyle(
                  fontFamily: AppFonts.nunitoMedium,
                  fontSize: screenHeight * AppSizes().fontSize.mediumFontSize,
                  color: AppColor.textfieldColor),
            ),
          )),
    );
  }

  Widget buttonView(TravellerItineraryDetailModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        chatWithGuideBtn(model),
        travellerStatus == 5 && travellerComplete == 0
            ? SizedBox(
                width: screenWidth * 0.35,
                child: CommonButton.commonButtonRounded(
                  context: context,
                  textColor: AppColor.textbuttonColor,
                  text: "Rejected",
                  onPressed: () {
                    GlobalUtility.showToast(
                        context, "This itinerary is rejected!!");
                  },
                  backColor: AppColor.textbuttonColors.withOpacity(0.2),
                ),
              )
            : /*(travellerStatus == 2 || travellerStatus == 8 || travellerStatus == 6)*/
            model.travellerItineraryDetailResponse!.data!.isEligibleToPay ==
                    true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.28,
                        child: CommonButton.commonButtonRounded(
                          context: context,
                          textColor: AppColor.whiteColor,
                          text: "Pay Advance",
                          onPressed: () {
                            GlobalUtility.showDialogFunction(
                                context, enterCardDetailsDialog());
                          },
                          backColor: AppColor.progressbarColor,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.015,
                      ),
                      SizedBox(
                        width: screenWidth * 0.28,
                        child: CommonButton.commonButtonRounded(
                          context: context,
                          textColor: AppColor.textbuttonColor,
                          text: AppStrings().rejectText,
                          onPressed: () {
                            if (model.travellerItineraryDetailResponse?.data!.status == 1 ||
                                model.travellerItineraryDetailResponse?.data!
                                        .status ==
                                    3 ||
                                model.travellerItineraryDetailResponse?.data!
                                        .status ==
                                    5 ||
                                model.travellerItineraryDetailResponse?.data!
                                        .status ==
                                    7 ||
                                model.travellerItineraryDetailResponse?.data!
                                        .status ==
                                    9) {
                              GlobalUtility.showToast(
                                  context, "This itinerary is rejected!!");
                            } else {
                              GlobalUtility.showBottomSheet(
                                  context,
                                  EditPackageSheet(
                                      travellerItineraryDetailModel: model));
                            }
                          },
                          backColor: AppColor.marginBorderColor,
                        ),
                      ),
                    ],
                  )
                : travellerStatus == 1 ||
                        travellerStatus == 3 ||
                        travellerStatus == 5 ||
                        travellerStatus == 7 ||
                        travellerStatus == 9
                    ? SizedBox(
                        width: screenWidth * 0.3,
                        child: CommonButton.commonButtonRounded(
                          context: context,
                          textColor: AppColor.appthemeColor,
                          text: "Cancelled",
                          onPressed: null,
                          backColor: AppColor.progressbarColor,
                        ),
                      )
                    : travellerStatus == 4 && travellerComplete == 0
                        ? SizedBox(
                            width: screenWidth * 0.35,
                            child: CommonButton.commonButtonRounded(
                              context: context,
                              textColor: AppColor.whiteColor,
                              text: "Trip On Going",
                              onPressed: () {},
                              backColor: AppColor.completedStatusColor,
                            ),
                          )
                        : travellerStatus == 4 && travellerComplete == 1
                            ? SizedBox(
                                width: screenWidth * 0.35,
                                child: CommonButton.commonButtonRounded(
                                  context: context,
                                  textColor: AppColor.completedStatusColor,
                                  text: "Booking Completed",
                                  onPressed: () {},
                                  backColor: AppColor.completedStatusColor
                                      .withOpacity(0.1),
                                ),
                              )
                            : travellerStatus == 1 && travellerComplete == 0
                                ? SizedBox(
                                    width: screenWidth * 0.35,
                                    child: CommonButton.commonButtonRounded(
                                      context: context,
                                      textColor: AppColor.textbuttonColor,
                                      text: "Rejected",
                                      onPressed: () {},
                                      backColor: AppColor.textbuttonColors
                                          .withOpacity(0.2),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.3,
                                        child: CommonButton.commonButtonRounded(
                                          context: context,
                                          textColor: AppColor.whiteColor,
                                          text: AppStrings().acceptText,
                                          onPressed: () {
                                            GlobalUtility.showDialogFunction(
                                                context,
                                                enterCardDetailsDialog());
                                          },
                                          backColor: AppColor.progressbarColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.02,
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.3,
                                        child: CommonButton.commonButtonRounded(
                                          context: context,
                                          textColor: AppColor.textbuttonColor,
                                          text: AppStrings().rejectText,
                                          onPressed: () {
                                            if (model.travellerItineraryDetailResponse?.data!.status == 1 ||
                                                model.travellerItineraryDetailResponse
                                                        ?.data!.status ==
                                                    3 ||
                                                model.travellerItineraryDetailResponse
                                                        ?.data!.status ==
                                                    5 ||
                                                model.travellerItineraryDetailResponse
                                                        ?.data!.status ==
                                                    7 ||
                                                model.travellerItineraryDetailResponse
                                                        ?.data!.status ==
                                                    9) {
                                              GlobalUtility.showToast(context,
                                                  "This itinerary is rejected!! 😔 ");
                                            } else {
                                              GlobalUtility.showBottomSheet(
                                                  context,
                                                  EditPackageSheet(
                                                      travellerItineraryDetailModel:
                                                          model));
                                            }
                                          },
                                          backColor: AppColor.marginBorderColor,
                                        ),
                                      ),
                                    ],
                                  ),
      ],
    );
  }

  Widget enterCardDetailsDialog() {
    return WillPopScope(
      child: StatefulBuilder(builder: (context, setState) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04, vertical: screenHeight * 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: StripePaymentScreen(
                bookingId: widget.booking_id!,
              )),
        );
      }),
      onWillPop: () async {
        return true;
      },
    );
  }

  cancelTripSheet(TravellerItineraryDetailModel model) {
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
                              text: AppStrings().editQuote)),
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
                          text: AppStrings().pleaseletUsKnow,
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
                      cancelButton(model),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                    ],
                  ));
            }));
  }

  Widget reasonForCancel(TravellerItineraryDetailModel model) {
    return SizedBox(
      child: TextFormField(
        controller: model.editQuoteController,
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
          hintText: "Enter your request",
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

  Widget cancelButton(TravellerItineraryDetailModel model) {
    return model.isBusy == false
        ? CommonButton.commonBoldTextButton(
            text: AppStrings().send,
            context: context,
            onPressed: () {
              model.counterNotifier1.value++;
              if (model.isCancelButtonEnable) {
                if (model.editQuoteController.text != "" &&
                    model.editQuoteController.text.trim().isNotEmpty) {
                  model.requestForItinerary(context);
                } else {
                  GlobalUtility.showToast(context, "Please write edit quote!!");
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

  chatWithGuideBtn(TravellerItineraryDetailModel model) {
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.02),
      width: screenWidth * 0.32,
      child: CommonButton.commonButtonRounded(
        context: context,
        textColor: AppColor.whiteColor,
        text: "Chat with Guide",
        onPressed: () async {
          await PreferenceUtil().setTravellerSendMessageUserId(model
              .travellerItineraryDetailResponse!.data!.touristGuideUserId
              .toString());
          await PreferenceUtil().setTravellerSendMessageUserName(model
              .travellerItineraryDetailResponse!.data!.user!.name
              .toString());
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.travellerHomeMessagePage,
            (route) => false,
          );
        },
        backColor: AppColor.appthemeColor,
      ),
    );
  }

  onReasonFieldChange(TravellerItineraryDetailModel model) {
    if (model.editQuoteController.text != "") {
      model.isCancelButtonEnable = true;
      model.notifyListeners();
      model.counterNotifier1.value++;
    } else {
      model.isCancelButtonEnable = false;
      model.notifyListeners();
      model.counterNotifier1.value++;
    }
  }
}
