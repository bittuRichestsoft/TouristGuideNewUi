// ignore_for_file: prefer_is_empty, non_constant_identifier_names, must_be_immutable, unnecessary_null_comparison

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/all_bottomsheet/create_itinerary_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/view_models/guide_models/guideItineraryModel.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class BookingHistoryDetail extends StatefulWidget {
  BookingHistoryDetail({Key? key, Object? bookingId}) : super(key: key) {
    Map obj = bookingId as Map;
    booking_id = obj["bookingId"];
  }
  int? booking_id;

  @override
  State<BookingHistoryDetail> createState() => _BookingHistoryDetailState();
}

class _BookingHistoryDetailState extends State<BookingHistoryDetail> {
  double screenWidth = 0.0, screenHeight = 0.0;
  List<int> bookingStatus = [1, 2, 3, 5, 6, 7, 8, 9];
  List<String> buttonList = [
    'Ongoing',
    "Cancelled",
    "Payment Processed",
    "Completed"
  ];

  bool isCompleted = false;
  bool isPayProceed = false;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<GuideItineraryDetailModel>.reactive(
        viewModelBuilder: () =>
            GuideItineraryDetailModel(context, widget.booking_id),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: AppColor.whiteColor,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: AppColor.appthemeColor),
                centerTitle: true,
                backgroundColor: AppColor.appthemeColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.touristGuideHome1, (route) => false);
                  },
                ),
                title: TextView.headingWhiteText(
                    text: AppStrings().bookingDetails, context: context),
              ),
              body: model.isBusy == false
                  ? ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(screenWidth *
                          AppSizes().widgetSize.horizontalPadding),
                      children: [
                        (model.guideItineraryDetailResponse!.data.isComplete ==
                                        0 &&
                                    model.guideItineraryDetailResponse!.data
                                            .initialPaid !=
                                        0 &&
                                    model.guideItineraryDetailResponse!.data
                                            .finalPaid ==
                                        0) &&
                                isPayProceed == false
                            ? TextView.mediumText(
                                textAlign: TextAlign.left,
                                textColor: AppColor.appthemeColor,
                                textSize: AppSizes().fontSize.simpleFontSize,
                                fontFamily: AppFonts.nunitoBold,
                                text:
                                    "Note: When you click or select Process Final Payment the final amount will be charged. Final payment must be processed before ${model.noteDate}.",
                                context: context)
                            : const SizedBox(),
                        SizedBox(height: screenHeight * 0.015),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.02,
                              horizontal: screenWidth * 0.01),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  screenWidth *
                                      AppSizes().widgetSize.smallBorderRadius)),
                              color:
                                  AppColor.marginBorderColor.withOpacity(0.3)),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      profileImage(
                                          model.guideItineraryDetailResponse !=
                                                      null &&
                                                  model
                                                          .guideItineraryDetailResponse!
                                                          .data
                                                          .travellerDetails
                                                          .userDetail !=
                                                      null
                                              ? model
                                                  .guideItineraryDetailResponse!
                                                  .data
                                                  .travellerDetails
                                                  .userDetail!
                                                  .profilePicture
                                              : ""),
                                      SizedBox(width: screenWidth * 0.015),
                                      TextView.normalText(
                                          textColor: AppColor.appthemeColor,
                                          textSize: AppSizes()
                                              .fontSize
                                              .simpleFontSize,
                                          fontFamily: AppFonts.nunitoBold,
                                          text: model.guideItineraryDetailResponse !=
                                                  null
                                              ? GlobalUtility().firstLetterCapital(
                                                  "${model.guideItineraryDetailResponse!.data.firstName} ${model.guideItineraryDetailResponse!.data.lastName != "null" ? model.guideItineraryDetailResponse!.data.lastName : ""}")
                                              : "",
                                          context: context),
                                    ],
                                  ),
                                  model.guideItineraryDetailResponse != null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                                height: screenWidth * 0.015),
                                            model.guideItineraryDetailResponse!
                                                        .data.status !=
                                                    6
                                                ? model.guideItineraryDetailResponse!
                                                            .data.status !=
                                                        8
                                                    ? model.guideItineraryDetailResponse!
                                                                .data.status !=
                                                            2
                                                        ? isCompleted == false
                                                            ? model.guideItineraryDetailResponse!.data
                                                                        .isComplete ==
                                                                    0
                                                                ? model.guideItineraryDetailResponse!.data
                                                                            .isCancelled ==
                                                                        0
                                                                    ? model.guideItineraryDetailResponse!.data.isComplete ==
                                                                            0
                                                                        ? buttonSecContainer(
                                                                            AppColor.appthemeColor,
                                                                            (model.guideItineraryDetailResponse!.data.isComplete == 0 && model.guideItineraryDetailResponse!.data.initialPaid != 0 && model.guideItineraryDetailResponse!.data.finalPaid == 0) && isPayProceed == false
                                                                                ? "Process Final Payment"
                                                                                : "Complete Booking",
                                                                            AppColor.whiteColor,
                                                                            () {
                                                                              if (model.guideItineraryDetailResponse!.data.isComplete == 0 && model.guideItineraryDetailResponse!.data.finalPaid == 0 && model.guideItineraryDetailResponse!.data.initialPaid != 0) {
                                                                                if (!bookingStatus.contains(model.guideItineraryDetailResponse!.data.status)) {
                                                                                  isPayProceed = true;
                                                                                  model.paymentProceedApi(context, widget.booking_id!);
                                                                                }
                                                                              } else if (model.guideItineraryDetailResponse!.data.isComplete == 0 && model.guideItineraryDetailResponse!.data.finalPaid != 0) {
                                                                                if (!bookingStatus.contains(model.guideItineraryDetailResponse!.data.status)) {
                                                                                  isCompleted = true;
                                                                                  model.completeBookingApi(context, widget.booking_id!);
                                                                                }
                                                                              }

                                                                              model.notifyListeners();
                                                                            },
                                                                          )
                                                                        : const SizedBox()
                                                                    : const SizedBox()
                                                                : const SizedBox()
                                                            : const SizedBox()
                                                        : const SizedBox()
                                                    : const SizedBox()
                                                : const SizedBox(),
                                            SizedBox(
                                                height: screenWidth * 0.015),
                                            buttonContainer(
                                                AppColor.buttonDisableColor,
                                                "Ongoing",
                                                AppColor.appthemeColor,
                                                () {},
                                                model),
                                            SizedBox(
                                                height: screenWidth * 0.015),
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ),
                              Divider(
                                color: AppColor.textfieldborderColor,
                                height: 2,
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02),
                                horizontalTitleGap: 0,
                                leading: Container(
                                  height: screenHeight * 0.035,
                                  width: screenHeight * 0.035,
                                  decoration: BoxDecoration(
                                      color: AppColor.shadowLocation,
                                      shape: BoxShape.circle),
                                  child: Icon(Icons.location_on_outlined,
                                      color: AppColor.appthemeColor, size: 18),
                                ),
                                title: Transform.translate(
                                    offset: const Offset(-8, 0),
                                    child: TextView.normalText(
                                        textColor: AppColor.textfieldColor,
                                        textSize:
                                            AppSizes().fontSize.mediumFontSize,
                                        fontFamily: AppFonts.nunitoMedium,
                                        text: (model.guideItineraryDetailResponse !=
                                                    null &&
                                                model.guideItineraryDetailResponse!
                                                        .data.country !=
                                                    null)
                                            ? " ${GlobalUtility().firstLetterCapital(model.guideItineraryDetailResponse!.data.country.toString())} ${GlobalUtility().firstLetterCapital(model.guideItineraryDetailResponse!.data.state.toString())} "
                                                "${model.guideItineraryDetailResponse!.data.city.length != 0 ? GlobalUtility().firstLetterCapital(model.guideItineraryDetailResponse!.data.city.toString()) : ""}"
                                            : "",
                                        context: context)),
                                isThreeLine: false,
                                trailing: TextView.normalText(
                                    textColor: AppColor.textfieldColor,
                                    textSize:
                                        AppSizes().fontSize.mediumFontSize,
                                    fontFamily: AppFonts.nunitoMedium,
                                    text: model.guideItineraryDetailResponse !=
                                            null
                                        ? model.guideItineraryDetailResponse!
                                            .data.dateDetails
                                        : "",
                                    context: context),
                              ),
                              UiSpacer.verticalSpace(
                                  space: AppSizes().widgetSize.smallPadding,
                                  context: context),
                            ],
                          ),
                        ),
                        UiSpacer.verticalSpace(
                            space: AppSizes().widgetSize.smallPadding,
                            context: context),
                        ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.00),
                            title: TextView.normalText(
                                textColor: AppColor.textfieldColor,
                                textSize: AppSizes().fontSize.normalFontSize,
                                fontFamily: AppFonts.nunitoBold,
                                text: AppStrings().itinerary,
                                context: context),
                            isThreeLine: false,
                            trailing: model.guideItineraryDetailResponse != null
                                ? model.dropDownValue == "Ongoing" &&
                                        model.guideItineraryDetailResponse!.data
                                                .status ==
                                            6
                                    ? SizedBox(
                                        height: screenHeight * 0.05,
                                        child: CommonButton
                                            .commonButtonWithIconText(
                                                text: AppStrings()
                                                    .edititineraryText,
                                                color: (model.dropDownValue ==
                                                            "Ongoing" &&
                                                        model.guideItineraryDetailResponse!
                                                                .data.status ==
                                                            2)
                                                    ? AppColor.appthemeColor
                                                    : (model.dropDownValue ==
                                                                "Ongoing" &&
                                                            model.guideItineraryDetailResponse!
                                                                    .data.status ==
                                                                6)
                                                        ? AppColor.appthemeColor
                                                        : (model.dropDownValue ==
                                                                    "Ongoing" &&
                                                                model
                                                                        .guideItineraryDetailResponse!
                                                                        .data
                                                                        .status ==
                                                                    8)
                                                            ? AppColor
                                                                .appthemeColor
                                                            : AppColor
                                                                .buttonDisableColor,
                                                context: context,
                                                onPressed: () {
                                                  if (model.dropDownValue ==
                                                      "Ongoing") {
                                                    int status = model
                                                        .guideItineraryDetailResponse!
                                                        .data
                                                        .status;
                                                    debugPrint(
                                                        "STSTS=== $status");
                                                    if (status == 0 ||
                                                        status == 1 ||
                                                        status == 3 ||
                                                        status == 4 ||
                                                        status == 5 ||
                                                        status == 7 ||
                                                        status == 9) {
                                                      GlobalUtility.showToast(
                                                          context,
                                                          "Itinerary can not be edit now");
                                                    } else {
                                                      GlobalUtility.showItineraryBottomSheet(
                                                          context,
                                                          CreateItineraryPage(
                                                              guideReceievedBookingModel:
                                                                  null,
                                                              selIndex: -1,
                                                              guideBookinghistoryModel:
                                                                  model));
                                                    }

                                                    /*  if (model.guideItineraryDetailResponse!.data.status != 2 ||
                                                        model.guideItineraryDetailResponse!
                                                                .data.status !=
                                                            6 ||
                                                        model.guideItineraryDetailResponse!
                                                                .data.status !=
                                                            8) {
                                                      debugPrint("STSTS=== IF");

                                                      GlobalUtility.showToast(
                                                          context, "Itinerary can not be edit now");
                                                    } else {
                                                      debugPrint(
                                                          "STSTS=== ELSE");
                                                      GlobalUtility.showItineraryBottomSheet(
                                                          context,
                                                          CreateItineraryPage(
                                                              guideReceievedBookingModel:
                                                                  null,
                                                              selIndex: -1,
                                                              guideBookinghistoryModel:
                                                                  model));
                                                    }*/
                                                  }
                                                },
                                                iconPath:
                                                    AppImages().pngImages.icEdit),
                                      )
                                    : const SizedBox()
                                : const SizedBox()),
                        UiSpacer.verticalSpace(
                            context: context,
                            space: AppSizes().widgetSize.mediumPadding),
                        ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.00),
                            title: TextView.normalText(
                                textColor: AppColor.textfieldColor,
                                textSize: AppSizes().fontSize.normalFontSize,
                                fontFamily: AppFonts.nunitoBold,
                                text: "${AppStrings().advanceAmount}"
                                    "${(model.guideItineraryDetailResponse != null && model.guideItineraryDetailResponse!.data.itinerary != null) ? model.guideItineraryDetailResponse!.data.itinerary!.price : "0"}",
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
                            trailing: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: AppStrings().price,
                                    style: TextStyle(
                                        fontFamily: AppFonts.nunitoSemiBold,
                                        color: AppColor.blackColor,
                                        fontSize: screenHeight *
                                            AppSizes()
                                                .fontSize
                                                .mediumFontSize)),
                                TextSpan(
                                    text:
                                        " \$${model.guideItineraryDetailResponse != null ? model.guideItineraryDetailResponse!.data.price : "0"}/per hour",
                                    style: TextStyle(
                                        fontFamily: AppFonts.nunitoSemiBold,
                                        color: AppColor.appthemeColor,
                                        fontSize: screenHeight *
                                            AppSizes()
                                                .fontSize
                                                .mediumFontSize)),
                              ]),
                            )),
                        TextView.normalText(
                            textColor: AppColor.textfieldColor,
                            textSize: AppSizes().fontSize.normalFontSize,
                            fontFamily: AppFonts.nunitoBold,
                            text: "${AppStrings().finalPayment} \$"
                                "${(model.guideItineraryDetailResponse != null && model.guideItineraryDetailResponse!.data.itinerary != null) ? model.guideItineraryDetailResponse!.data.itinerary!.finalPrice : "0"}",
                            context: context),
                        UiSpacer.verticalSpace(
                            context: context,
                            space: AppSizes().widgetSize.normalPadding),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColor.buttonDisableColor)),
                          child: HtmlWidget(
                              model.guideItineraryDetailResponse != null &&
                                      model.guideItineraryDetailResponse!.data
                                              .itinerary !=
                                          null
                                  ? (model.guideItineraryDetailResponse?.data
                                          .itinerary!.descriptions)
                                      .toString()
                                  : "",
                              textStyle: TextStyle(
                                  height: 1.5,
                                  fontFamily: AppFonts.nunitoSemiBold,
                                  color: AppColor.blackColor,
                                  fontSize: screenHeight *
                                      AppSizes().fontSize.mediumFontSize)),
                        ),
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
                              return itineraryDetailViews(index, model);
                            }),
                      ],
                    )
                  : Container(
                      height: screenHeight * 0.7,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                          color: AppColor.appthemeColor),
                    ));
        });
  }

  Widget itineraryDetailViews(int index, GuideItineraryDetailModel model) {
    return Column(
      children: [
        Text(
          model.bookingTrackHistories!.length > 0
              ? model.bookingTrackHistories![index].key
                  .replaceAll("\n\n", "<br></br>")
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
            fontFamily: AppFonts.nunitoRegular),
        UiSpacer.verticalSpace(
            context: context, space: AppSizes().widgetSize.smallPadding),
      ],
    );
  }

  Widget profileImage(img) {
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

  Widget buttonContainer(Color bgColor, String text, Color textColor,
      VoidCallback onPressed, GuideItineraryDetailModel model) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          height: screenHeight * 0.04,
          width: screenWidth * 0.38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: model.dropDownValue == 'Ongoing'
                  ? AppColor.completedStatusBGColor
                  : model.dropDownValue == 'Cancelled'
                      ? AppColor.shadowButton
                      : AppColor.completedStatusBGColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              model.dropDownValue == 'Cancelled'
                  ? Text(
                      "Cancelled",
                      style: TextStyle(
                          color: AppColor.errorBorderColor,
                          fontFamily: AppFonts.nunitoMedium,
                          fontSize:
                              screenHeight * AppSizes().fontSize.simpleFontSize,
                          fontWeight: FontWeight.w500),
                    )
                  : model.dropDownValue == 'Completed'
                      ? Text(
                          "Completed",
                          style: TextStyle(
                              color: AppColor.completedStatusColor,
                              fontFamily: AppFonts.nunitoMedium,
                              fontSize: screenHeight *
                                  AppSizes().fontSize.simpleFontSize,
                              fontWeight: FontWeight.w500),
                        )
                      : model.guideItineraryDetailResponse!.data.isComplete ==
                                  0 &&
                              model.guideItineraryDetailResponse!.data
                                      .finalPaid !=
                                  0
                          ? Text(
                              "Payment Processed",
                              style: TextStyle(
                                  color: AppColor.completedStatusColor,
                                  fontFamily: AppFonts.nunitoMedium,
                                  fontSize: screenHeight *
                                      AppSizes().fontSize.xsimpleFontSize,
                                  fontWeight: FontWeight.w500),
                            )
                          : DropdownButton<String>(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              isDense: true,
                              value: model.dropDownValue, //selected
                              icon: CommonImageView.largeSvgImageView(
                                  imagePath: AppImages().svgImages.arrowDown),
                              iconSize: 20,
                              elevation: 16,
                              style: TextStyle(
                                  color: model.dropDownValue == 'Ongoing' ||
                                          model.dropDownValue ==
                                              "Payment Processed"
                                      ? AppColor.completedStatusColor
                                      : model.dropDownValue == 'Cancelled'
                                          ? AppColor.errorBorderColor
                                          : AppColor.completedStatusColor),
                              underline: Container(
                                height: 2,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? newValue) {
                                if (newValue == 'Ongoing') {
                                  model.dropDownValue = newValue;
                                }
                                if (newValue == 'Cancelled') {
                                  if (model.guideItineraryDetailResponse!.data
                                              .isComplete ==
                                          0 &&
                                      model.guideItineraryDetailResponse!.data
                                              .initialPaid ==
                                          0) {
                                    cancelTripSheet(model);
                                  }
                                }
                                if (newValue == 'Payment Processed') {
                                  if (model.guideItineraryDetailResponse!.data
                                              .isComplete ==
                                          0 &&
                                      model.guideItineraryDetailResponse!.data
                                              .finalPaid ==
                                          0 &&
                                      model.guideItineraryDetailResponse!.data
                                              .initialPaid !=
                                          0) {
                                    if (!bookingStatus.contains(model
                                        .guideItineraryDetailResponse!
                                        .data
                                        .status)) {
                                      model.paymentProceedApi(
                                          context, widget.booking_id!);
                                    }
                                  }
                                }
                                if (newValue == 'Completed') {
                                  if (model.guideItineraryDetailResponse!.data
                                              .isComplete ==
                                          0 &&
                                      model.guideItineraryDetailResponse!.data
                                              .finalPaid !=
                                          0) {
                                    if (!bookingStatus.contains(model
                                        .guideItineraryDetailResponse!
                                        .data
                                        .status)) {
                                      model.completeBookingApi(
                                          context, widget.booking_id!);
                                    }
                                  }
                                }
                                model.notifyListeners();
                              },
                              items: buttonList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: bookingStatus.contains(model.guideItineraryDetailResponse!.data.status) == true &&
                                            ((model.guideItineraryDetailResponse!.data.isComplete == 0 && model.guideItineraryDetailResponse!.data.finalPaid == 0 && model.guideItineraryDetailResponse!.data.initialPaid == 0) &&
                                                (value == "Ongoing" ||
                                                    value == "Cancelled"))
                                        ? TextView.normalText(
                                            context: context,
                                            text: value.toString(),
                                            textSize: AppSizes()
                                                .fontSize
                                                .xsimpleFontSize,
                                            fontFamily: AppFonts.nunitoSemiBold,
                                            textColor: AppColor.blackColor)
                                        : ((model.guideItineraryDetailResponse!.data.isComplete == 0 && model.guideItineraryDetailResponse!.data.finalPaid == 0 && model.guideItineraryDetailResponse!.data.initialPaid != 0) &&
                                                value == "Payment Processed")
                                            ? TextView.normalText(
                                                context: context,
                                                text: value.toString(),
                                                textSize: AppSizes()
                                                    .fontSize
                                                    .xsimpleFontSize,
                                                fontFamily:
                                                    AppFonts.nunitoSemiBold,
                                                textColor: AppColor.blackColor)
                                            : TextView.normalText(
                                                context: context,
                                                text: value.toString(),
                                                textSize: AppSizes().fontSize.xsimpleFontSize,
                                                fontFamily: AppFonts.nunitoSemiBold,
                                                textColor: model.guideItineraryDetailResponse!.data.isComplete == 0 && model.guideItineraryDetailResponse!.data.finalPaid == 0 ? AppColor.hintTextColor : AppColor.blackColor));
                              }).toList(),
                            ),
              UiSpacer.horizontalSpace(
                  context: context, space: AppSizes().widgetSize.smallPadding),
            ],
          )),
    );
  }

  cancelTripSheet(GuideItineraryDetailModel model) {
    model.cancelReasonController.clear();
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
                      cancelButton(model),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                    ],
                  ));
            }));
  }

  Widget reasonForCancel(GuideItineraryDetailModel model) {
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

  Widget cancelButton(GuideItineraryDetailModel model) {
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
                    model.guideRejectItinerary(context);
                  } else {
                    GlobalUtility.showToast(
                        context, "Please write reason for cancel trip!");
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

  Widget buttonSecContainer(
      Color bgColor, String text, Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.04,
        width: screenWidth * 0.36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: bgColor),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor,
              fontFamily: AppFonts.nunitoMedium,
              fontSize: screenHeight * AppSizes().fontSize.mediumFontSize,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  onReasonFieldChange(GuideItineraryDetailModel model) {
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

  bool validate(GuideItineraryDetailModel model) {
    String cancelReason = model.cancelReasonController.text;
    if (cancelReason == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterReason);
      return false;
    }
    return true;
  }
}
/*  Widget buttonContainer(Color bgColor, String text, Color textColor,
      VoidCallback onPressed, GuideItineraryDetailModel model) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          height: screenHeight * 0.04,
          width: screenWidth * 0.33,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: model.dropDownValue == 'Ongoing'
                  ? AppColor.completedStatusBGColor
                  : model.dropDownValue == 'Cancelled'
                      ? AppColor.shadowButton
                      : AppColor.completedStatusBGColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              model.dropDownValue == 'Cancelled'
                  ? Text(
                      "Cancelled",
                      style: TextStyle(
                          color: AppColor.errorBorderColor,
                          fontFamily: AppFonts.nunitoMedium,
                          fontSize:
                              screenHeight * AppSizes().fontSize.simpleFontSize,
                          fontWeight: FontWeight.w500),
                    )
                  : model.dropDownValue == 'Completed'
                      ? Text(
                          "Completed",
                          style: TextStyle(
                              color: AppColor.completedStatusColor,
                              fontFamily: AppFonts.nunitoMedium,
                              fontSize: screenHeight *
                                  AppSizes().fontSize.simpleFontSize,
                              fontWeight: FontWeight.w500),
                        )
                      : DropdownButton<String>(
                          value: model.dropDownValue, //selected
                          icon: CommonImageView.largeSvgImageView(
                              imagePath: AppImages().svgImages.arrowDown),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              color: model.dropDownValue == 'Ongoing'
                                  ? AppColor.completedStatusColor
                                  : model.dropDownValue == 'Cancelled'
                                      ? AppColor.errorBorderColor
                                      : AppColor.completedStatusColor),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue == 'Ongoing') {
                              model.dropDownValue = newValue;
                            }
                            if (newValue == 'Cancelled') {
                              cancelTripSheet(model);
                            } else if (newValue == 'Payment Processed') {
                              if (!bookingStatus.contains(model
                                  .guideItineraryDetailResponse!.data.status)) {
                                model.paymentProceedApi(
                                    context, widget.booking_id!);
                              }
                            } else if (newValue == 'Completed') {
                              if (!bookingStatus.contains(model
                                  .guideItineraryDetailResponse!.data.status)) {
                                model.completeBookingApi(
                                    context, widget.booking_id!);
                              }
                            }
                            model.notifyListeners();
                          },
                          items: buttonList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Transform.translate(
                                offset: const Offset(5, 0),
                                child: model.guideItineraryDetailResponse != null &&
                                        model.guideItineraryDetailResponse!.data !=
                                            null
                                    ? bookingStatus.contains(model.guideItineraryDetailResponse!.data.status) ==
                                                true &&
                                            (value == "Completed" ||
                                                value == "Payment Processed")
                                        ? TextView.normalText(
                                            context: context,
                                            text: value.toString(),
                                            textSize: AppSizes()
                                                .fontSize
                                                .xsimpleFontSize,
                                            fontFamily: AppFonts.nunitoSemiBold,
                                            textColor: AppColor.hintTextColor)
                                        : TextView.normalText(
                                            context: context,
                                            text: value.toString(),
                                            textSize: AppSizes()
                                                .fontSize
                                                .xsimpleFontSize,
                                            fontFamily: AppFonts.nunitoSemiBold,
                                            textColor: (model
                                                            .guideItineraryDetailResponse!
                                                            .data
                                                            .isComplete ==
                                                        0 &&
                                                    model.guideItineraryDetailResponse!
                                                            .data.finalPaid ==
                                                        0 &&
                                                    model.guideItineraryDetailResponse!.data.initialPaid != 0)
                                                ? (model.guideItineraryDetailResponse!.data.isComplete == 0 && model.guideItineraryDetailResponse!.data.finalPaid == 0)
                                                    ? AppColor.errorBorderColor
                                                    : AppColor.ratingbarColor
                                                : AppColor.pendingColor)
                                    : TextView.normalText(context: context, text: value.toString(), textSize: AppSizes().fontSize.xsimpleFontSize, fontFamily: AppFonts.nunitoSemiBold, textColor: AppColor.textBlack),
                              ),
                            );
                          }).toList(),
                        ),
              UiSpacer.horizontalSpace(
                  context: context, space: AppSizes().widgetSize.smallPadding),
            ],
          )),
    );
  }
*/
/*ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02),
                                  leading: profileImage(model.guideItineraryDetailResponse != null && model.guideItineraryDetailResponse!.data.travellerDetails.userDetail != null
                                      ? model
                                          .guideItineraryDetailResponse!
                                          .data
                                          .travellerDetails
                                          .userDetail!
                                          .profilePicture
                                      : ""),
                                  title: TextView.normalText(
                                      textColor: AppColor.appthemeColor,
                                      textSize:
                                          AppSizes().fontSize.simpleFontSize,
                                      fontFamily: AppFonts.nunitoBold,
                                      text: model.guideItineraryDetailResponse != null
                                          ? GlobalUtility().firstLetterCapital(
                                              "${model.guideItineraryDetailResponse!.data.firstName} ${model.guideItineraryDetailResponse!.data.lastName != "null" ? model.guideItineraryDetailResponse!.data.lastName : ""}")
                                          : "",
                                      context: context),
                                  isThreeLine: false,
                                  trailing: model.guideItineraryDetailResponse != null
                                      ? buttonContainer(AppColor.buttonDisableColor, "Ongoing", AppColor.appthemeColor, () {}, model)
                                      : const SizedBox()),*/
