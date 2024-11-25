// ignore_for_file: must_be_immutable, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_is_empty

import 'dart:convert';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/view/touristGuideView/guide_transaction_history/guide_transaction_data.dart';
import 'package:Siesta/view/touristGuideView/guide_transaction_history/guide_transaction_history_view_model.dart';
import 'package:Siesta/view/touristGuideView/guide_transaction_history/guide_transaction_response_pojo.dart';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/view/touristGuideView/guide_transaction_history/withdraw_api_request.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:Siesta/api_requests/api.dart';
import '../../../utility/globalUtility.dart';

class GuideWithdrawRequestDialog extends StatefulWidget {
  GuideWithdrawRequestDialog({Key? key, GuideTransListData? data})
      : super(key: key) {
    viewData = data;
  }

  GuideTransListData? viewData;
  @override
  State<GuideWithdrawRequestDialog> createState() =>
      _WithdrawRequestDialogState();
}

class _WithdrawRequestDialogState extends State<GuideWithdrawRequestDialog> {
  double screenWidth = 0.0, screenHeight = 0.0;
  GuideTransactionDataPojo? guideTransactionDataPojo;
  String paymentCompletedType = "";

  var totalPay;
  String withDrawPaymentStatus = "";
  @override
  void initState() {
    super.initState();
    getGuideData();
    transactionPaymentViewApi(widget.viewData!.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<GuideTransactionHistoryModel>.reactive(
        viewModelBuilder: () => GuideTransactionHistoryModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          model.bookingId = widget.viewData!.bookingId;
          return Dialog(
            insetPadding: EdgeInsets.all(screenWidth * 0.04),
            alignment: Alignment.center,
            backgroundColor: AppColor.whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.mediumBorderRadius))),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.horizontalPadding,
                  vertical: MediaQuery.of(context).size.height *
                      AppSizes().widgetSize.verticalPadding),
              children: [
                closeBtn(),
                profilePic(),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                TextView.headingText(
                    text: guideTransactionDataPojo != null
                        ? "${guideTransactionDataPojo!.data.travellerDetails!.name} ${guideTransactionDataPojo!.data.travellerDetails!.lastName}"
                        : widget.viewData!.bookingDetails.travellerDetails.name,
                    context: context),
                /* UiSpacer.verticalSpace(space: 0.005, context: context),
                TextView.subHeadingText(
                    text: guideTransactionDataPojo != null
                        ? guideTransactionDataPojo!.data.travellerDetails!.email
                            .toString()
                        : "",
                    context: context),*/
                UiSpacer.verticalSpace(space: 0.02, context: context),
                advancePaymentView(),
                Divider(
                  color: AppColor.hintTextColor,
                ),
                UiSpacer.verticalSpace(space: 0.01, context: context),
                // bottomNote(),
                //  UiSpacer.verticalSpace(space: 0.02, context: context),
              ],
            ),
          );
        });
  }

  Widget closeBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: CommonImageView.largeSvgImageView(
              imagePath: AppImages().svgImages.icClose),
        )
      ],
    );
  }

  Widget profilePic() {
    return Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(color: AppColor.whiteColor, width: 2),
          shape: BoxShape.circle,
        ),
        child: CircularProfileAvatar(
          '',
          animateFromOldImageOnUrlChange: true,
          cacheImage: true,
          elevation: 0,
          radius: 40,
          child: guideTransactionDataPojo != null &&
                  guideTransactionDataPojo!.data.travellerDetails!.userDetail !=
                      null &&
                  guideTransactionDataPojo!
                          .data.travellerDetails!.userDetail!.profilePicture !=
                      null
              ? Image.network(
                  guideTransactionDataPojo!
                      .data.travellerDetails!.userDetail!.profilePicture!,
                  fit: BoxFit.fill,
                )
              : Image.asset(AppImages().pngImages.icProfilePlaceholder),
        ));
  }

  Widget locationRow() {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: [
        TextSpan(
          text: AppStrings().location,
          style: TextStyle(
              fontFamily: AppFonts.nunitoSemiBold,
              color: AppColor.lightBlack,
              fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize),
        ),
        TextSpan(
            text: guideTransactionDataPojo != null &&
                    guideTransactionDataPojo!.data != null
                ? guideTransactionDataPojo!.data.destination
                : " ",
            style: TextStyle(
                fontFamily: AppFonts.nunitoRegular,
                color: AppColor.dontHaveTextColor,
                fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize)),
      ]),
    );
  }

  Widget advancePaymentView() {
    return ListView.separated(
      shrinkWrap: true,
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 5),
      itemCount: guideTransactionDataPojo != null &&
              guideTransactionDataPojo!.data != null
          ? guideTransactionDataPojo!.data.payments!.length
          : 0,
      itemBuilder: (BuildContext context, int index) {
        getTotalPayment(index);
        return widget.viewData!.paymentType ==
                guideTransactionDataPojo!.data.payments![index].paymentType
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(children: [
                      TextSpan(
                        text: guideTransactionDataPojo != null &&
                                guideTransactionDataPojo!.data != null
                            ? guideTransactionDataPojo!
                                        .data.payments![index].paymentStatus ==
                                    1
                                ? guideTransactionDataPojo!.data
                                            .payments![index].paymentType ==
                                        "INITIAL"
                                    ? AppStrings().advancePayment
                                    : AppStrings().totalPayment
                                : ""
                            : "",
                        style: TextStyle(
                            fontFamily: AppFonts.nunitoSemiBold,
                            color: AppColor.lightBlack,
                            fontSize: screenHeight *
                                AppSizes().fontSize.xsimpleFontSize),
                      ),
                      TextSpan(
                          text: guideTransactionDataPojo != null &&
                                  guideTransactionDataPojo!.data != null
                              ? guideTransactionDataPojo!.data.payments![index]
                                          .paymentStatus ==
                                      1
                                  ? guideTransactionDataPojo!.data
                                              .payments![index].paymentType ==
                                          "FINAL"
                                      ? "\$${guideTransactionDataPojo!.data.finalPaid}"
                                      : "\$${guideTransactionDataPojo!.data.payments![index].amount}"
                                  : ""
                              : "",
                          style: TextStyle(
                              fontFamily: AppFonts.nunitoRegular,
                              color: AppColor.dontHaveTextColor,
                              fontSize: screenHeight *
                                  AppSizes().fontSize.xsimpleFontSize)),
                    ]),
                  ),
                  (guideTransactionDataPojo!
                                  .data.payments![index].paymentStatus ==
                              1 &&
                          guideTransactionDataPojo!.data.payments![index]
                                  .withdrawPaymentStatus ==
                              null)
                      ? guideTransactionDataPojo!
                                  .data.payments![index].paymentType ==
                              "FINAL"
                          ? totalWithdrawPaymentButton()
                          : withDrawBtnAdvancePay(index)
                      : guideTransactionDataPojo!.data.payments![index]
                                  .withdrawPaymentStatus !=
                              null
                          ? Row(
                              children: [
                                Icon(Icons.circle,
                                    color: guideTransactionDataPojo!
                                                .data
                                                .payments![index]
                                                .paymentStatus ==
                                            1
                                        ? AppColor.completedStatusColor
                                        : AppColor.pendingColor,
                                    size: 5),
                                Text(
                                    "  ${guideTransactionDataPojo!.data.payments![index].withdrawPaymentStatus}",
                                    style: TextStyle(
                                        fontFamily: AppFonts.nunitoBold,
                                        color: guideTransactionDataPojo!
                                                    .data
                                                    .payments![index]
                                                    .paymentStatus ==
                                                1
                                            ? AppColor.completedStatusColor
                                            : AppColor.pendingColor,
                                        fontSize: screenHeight *
                                            AppSizes()
                                                .fontSize
                                                .xsimpleFontSize)),
                              ],
                            )
                          : const SizedBox()
                ],
              )
            : const SizedBox();
      },
      separatorBuilder: (BuildContext context, int index) {
        return widget.viewData!.paymentType ==
                guideTransactionDataPojo!.data.payments![index].paymentType
            ? Divider(
                color: guideTransactionDataPojo!
                            .data.payments![index].paymentStatus ==
                        1
                    ? AppColor.hintTextColor
                    : AppColor.whiteColor,
              )
            : const SizedBox();
      },
    );
  }

  Widget remainingPaymentView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(children: [
            TextSpan(
              text: AppStrings().remainingPaymentView,
              style: TextStyle(
                  fontFamily: AppFonts.nunitoSemiBold,
                  color: AppColor.lightBlack,
                  fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize),
            ),
            TextSpan(
                text: guideTransactionDataPojo != null &&
                        guideTransactionDataPojo!.data != null
                    ? "\$${guideTransactionDataPojo!.data.remainingAmount}"
                    : "",
                style: TextStyle(
                    fontFamily: AppFonts.nunitoRegular,
                    color: AppColor.dontHaveTextColor,
                    fontSize:
                        screenHeight * AppSizes().fontSize.xsimpleFontSize)),
          ]),
        ),
        Row(
          children: [
            Icon(Icons.circle, color: AppColor.pendingColor, size: 5),
            Text(" ${AppStrings.pending}",
                style: TextStyle(
                    fontFamily: AppFonts.nunitoBold,
                    color: AppColor.pendingColor,
                    fontSize:
                        screenHeight * AppSizes().fontSize.xsimpleFontSize)),
          ],
        ),
      ],
    );
  }

  getTotalPayment(int index) {
    totalPay = guideTransactionDataPojo!.data.remainingAmount! +
        guideTransactionDataPojo!.data.payments![index].amount;
  }

  Widget totalPaymentView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(children: [
              TextSpan(
                text: AppStrings().totalPayment,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoSemiBold,
                    color: AppColor.lightBlack,
                    fontSize:
                        screenHeight * AppSizes().fontSize.xsimpleFontSize),
              ),
              TextSpan(
                  text: guideTransactionDataPojo != null &&
                          guideTransactionDataPojo!.data != null
                      ? "\$${guideTransactionDataPojo!.data.totalBookingPrice ?? totalPay}"
                      : "",
                  style: TextStyle(
                      fontFamily: AppFonts.nunitoRegular,
                      color: AppColor.dontHaveTextColor,
                      fontSize:
                          screenHeight * AppSizes().fontSize.xsimpleFontSize)),
            ]),
          ),
          paymentCompletedType == "FINAL" && withDrawPaymentStatus == "null"
              ? totalWithdrawPaymentButton()
              : disablePaymentButton()
        ],
      ),
    );
  }

  String? createdDate;
  String guideName = "";
  String guideEmail = "";
  void dateString(int index) {
    createdDate = guideTransactionDataPojo != null
        ? guideTransactionDataPojo!.data.payments![index].createdAt
        : "";
    var date = DateTime.parse(createdDate!);
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    debugPrint("kjjdsfsdf $formattedDate");
  }

  getGuideData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      guideName =
          preferences.getString(SharedPreferenceValues.firstName).toString() +
              " " +
              preferences.getString(SharedPreferenceValues.lastName).toString();
      guideEmail =
          preferences.getString(SharedPreferenceValues.email).toString();
    });
  }

  Widget withDrawDetailsPopUpAdvance(int index) {
    dateString(index);
    return Dialog(
        insetPadding: EdgeInsets.all(screenWidth * 0.04),
        alignment: Alignment.center,
        backgroundColor: AppColor.whiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.mediumBorderRadius))),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(screenWidth * 0.03),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            UiSpacer.verticalSpace(space: 0.02, context: context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Withdraw Payment",
                  style: TextStyle(
                      fontFamily: AppFonts.nunitoBold,
                      color: AppColor.lightBlack,
                      fontSize:
                          screenHeight * AppSizes().fontSize.largeTextSize),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CommonImageView.largeSvgImageView(
                      imagePath: AppImages().svgImages.icClose),
                )
              ],
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            Text(
              "Effortlessly Withdraw Payments Whenever You Need",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoSemiBold,
                  color: AppColor.hintTextColor,
                  fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            Text(
              " Name",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.blackColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.hintTextColor.withOpacity(0.2)),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: guideName != null && guideName != "null"
                        ? guideName
                        : "",
                    hintStyle: TextStyle(
                        fontFamily: AppFonts.nunitoMedium,
                        color: AppColor.blackColor,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              ),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            /* Text(
              " Email Id",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.blackColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.hintTextColor.withOpacity(0.2)),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: guideEmail != null && guideEmail != "null"
                        ? guideEmail
                        : "",
                    hintStyle: TextStyle(
                        fontFamily: AppFonts.nunitoMedium,
                        color: AppColor.blackColor,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              ),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),*/
            Text(
              " Date of booking",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.blackColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.hintTextColor.withOpacity(0.2)),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: guideTransactionDataPojo != null
                        ? DateFormat('dd-MM-yyyy')
                            .format(
                                guideTransactionDataPojo!.data.bookingStart!)
                            .toString()
                        : "",
                    hintStyle: TextStyle(
                        fontFamily: AppFonts.nunitoMedium,
                        color: AppColor.blackColor,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              ),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            Text(
              " Payment date",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.blackColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.hintTextColor.withOpacity(0.2)),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Jiffy.parse(createdDate!).yMMMd ?? "",
                    hintStyle: TextStyle(
                        fontFamily: AppFonts.nunitoMedium,
                        color: AppColor.blackColor,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              ),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            Text(
              " Amount",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.blackColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.hintTextColor.withOpacity(0.2)),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: guideTransactionDataPojo != null
                        ? "\$${guideTransactionDataPojo!.data.payments![index].amount}"
                        : "",
                    hintStyle: TextStyle(
                        fontFamily: AppFonts.nunitoMedium,
                        color: AppColor.blackColor,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              ),
            ),
            UiSpacer.verticalSpace(space: 0.03, context: context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  advancePayWithdraw(context);
                },
                style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    elevation: 0,
                    backgroundColor: AppColor.appthemeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width *
                                AppSizes().widgetSize.roundBorderRadius))),
                child: Text(
                  AppStrings().submit,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.xsimpleFontSize,
                      color: AppColor.whiteColor,
                      fontFamily: AppFonts.nunitoSemiBold),
                ),
              ),
            )
          ],
        ));
  }

  Widget withDrawBtnAdvancePay(int index) {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          AppSizes().widgetSize.smallbuttonHeight,
      child: ElevatedButton(
        onPressed: () {
          GlobalUtility.showDialogFunction(
              context, withDrawDetailsPopUpAdvance(index));
          // advancePayWithdraw(context);
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColor.appthemeColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.roundBorderRadius))),
        child: Text(
          AppStrings().withdraw,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.xsimpleFontSize,
              color: AppColor.whiteColor,
              fontFamily: AppFonts.nunitoSemiBold),
        ),
      ),
    );
  }

  Widget withDrawDetailsPopUpTotal() {
    return Dialog(
        insetPadding: EdgeInsets.all(screenWidth * 0.04),
        alignment: Alignment.center,
        backgroundColor: AppColor.whiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.mediumBorderRadius))),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(screenWidth * 0.03),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            UiSpacer.verticalSpace(space: 0.02, context: context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Withdraw Payment",
                  style: TextStyle(
                      fontFamily: AppFonts.nunitoBold,
                      color: AppColor.lightBlack,
                      fontSize:
                          screenHeight * AppSizes().fontSize.largeTextSize),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CommonImageView.largeSvgImageView(
                      imagePath: AppImages().svgImages.icClose),
                )
              ],
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            Text(
              "Effortlessly Withdraw Payments Whenever You Need",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoSemiBold,
                  color: AppColor.hintTextColor,
                  fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            Text(
              " Name",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.blackColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.hintTextColor.withOpacity(0.2)),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: guideName != null && guideName != "null"
                        ? guideName
                        : "",
                    hintStyle: TextStyle(
                        fontFamily: AppFonts.nunitoMedium,
                        color: AppColor.blackColor,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              ),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            /*Text(
              " Email Id",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.blackColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.hintTextColor.withOpacity(0.2)),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: guideEmail != null && guideEmail != "null"
                        ? guideEmail
                        : "",
                    hintStyle: TextStyle(
                        fontFamily: AppFonts.nunitoMedium,
                        color: AppColor.blackColor,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              ),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),*/
            Text(
              " Date of booking",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.blackColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.hintTextColor.withOpacity(0.2)),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: guideTransactionDataPojo != null
                        ? DateFormat('dd-MM-yyyy')
                            .format(
                                guideTransactionDataPojo!.data.bookingStart!)
                            .toString()
                        : "",
                    hintStyle: TextStyle(
                        fontFamily: AppFonts.nunitoMedium,
                        color: AppColor.blackColor,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              ),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            Text(
              " Amount",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.blackColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.hintTextColor.withOpacity(0.2)),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: guideTransactionDataPojo != null
                        ? "\$${guideTransactionDataPojo!.data.finalPaid}"
                        : "",
                    hintStyle: TextStyle(
                        fontFamily: AppFonts.nunitoMedium,
                        color: AppColor.blackColor,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              ),
            ),
            UiSpacer.verticalSpace(space: 0.02, context: context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  totalPayWithdraw(context);
                },
                style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    elevation: 0,
                    backgroundColor: AppColor.appthemeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width *
                                AppSizes().widgetSize.roundBorderRadius))),
                child: Text(
                  AppStrings().submit,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.xsimpleFontSize,
                      color: AppColor.whiteColor,
                      fontFamily: AppFonts.nunitoSemiBold),
                ),
              ),
            )
          ],
        ));
  }

  Widget totalWithdrawPaymentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          AppSizes().widgetSize.smallbuttonHeight,
      child: ElevatedButton(
        onPressed: () {
          GlobalUtility.showDialogFunction(
              context, withDrawDetailsPopUpTotal());

          // totalPayWithdraw(context);
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColor.appthemeColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.roundBorderRadius))),
        child: Text(
          AppStrings().withdraw,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.xsimpleFontSize,
              color: AppColor.whiteColor,
              fontFamily: AppFonts.nunitoSemiBold),
        ),
      ),
    );
  }

  Widget disablePaymentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          AppSizes().widgetSize.smallbuttonHeight,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            elevation: 0,
            backgroundColor: AppColor.fieldEnableColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.roundBorderRadius))),
        child: Text(
          AppStrings().withdraw,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.xsimpleFontSize,
              color: AppColor.whiteColor,
              fontFamily: AppFonts.nunitoSemiBold),
        ),
      ),
    );
  }

  Widget bottomNote() {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: [
        TextSpan(
          text: AppStrings().note,
          style: TextStyle(
              fontFamily: AppFonts.nunitoSemiBold,
              color: AppColor.lightBlack,
              fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize),
        ),
        TextSpan(
            text: AppStrings().totalPaymentAndHoursWillReflectAfterTour,
            style: TextStyle(
                fontFamily: AppFonts.nunitoRegular,
                color: AppColor.dontHaveTextColor,
                fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize)),
      ]),
    );
  }

  void transactionPaymentViewApi(int bookingId) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoaderDialog(context);
      var apiResponse = await http.get(
        Uri.parse(Api.baseUrl +
            Api.guideTransactionView +
            "?booking_id=" +
            bookingId.toString()),
        headers: <String, String>{
          "Content-Type": "application/json",
          'access_token': "${await PreferenceUtil().getToken()}"
        },
      );
      debugPrint('GUIDE TRANSACTION DETAILS == >> Url Api :- '
          '${Uri.parse(Api.baseUrl + Api.guideTransactionView)} \n guideTransactionView:-- ${apiResponse.body} ');
      var jsonData = json.decode(apiResponse.body);

      int status = jsonData['statusCode'];
      String message = jsonData['message'];
      Navigator.pop(context);
      if (status == 200) {
        setState(() {
          guideTransactionDataPojo =
              guideTransactionDataPojoFromJson(apiResponse.body);
        });
      } else if (status == 400) {
        GlobalUtility.showToast(context, message);
      } else {
        GlobalUtility.showToast(context, message);
      }
    } else {
      GlobalUtility.showToast(context, "Internet error");
    }
  }

  void advancePayWithdraw(viewContext) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoaderDialog(context);
      Response apiResponse = await WithdrawPaymentRequest()
          .withDrawAdvancePay(bookingId: widget.viewData!.bookingId.toString());
      debugPrint("ADVANCE PAY Draw ==>> ${apiResponse.body}");
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Navigator.pop(context);
      if (status == 200) {
        GlobalUtility.showToast(context, message);
        Navigator.pushReplacementNamed(
            context, AppRoutes.transactionHistoryGuide);
        setState(() {});
      } else if (status == 400) {
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void totalPayWithdraw(viewContext) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoaderDialog(context);
      Response apiResponse = await WithdrawPaymentRequest()
          .withDrawTotalPay(bookingId: widget.viewData!.bookingId.toString());
      debugPrint("TOTAL PAY Draw ==>> ${apiResponse.body}");
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Navigator.pop(context);
      if (status == 200) {
        GlobalUtility.showToast(context, message);
        Navigator.pushReplacementNamed(
            context, AppRoutes.transactionHistoryGuide);
        setState(() {});
      } else if (status == 400) {
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        PreferenceUtil().logout();
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.loginPage, (route) => false);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }
}
