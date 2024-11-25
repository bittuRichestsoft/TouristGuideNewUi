// ignore_for_file: must_be_immutable, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_is_empty

import 'dart:convert';
import 'package:Siesta/view/travellerView/transactions/paymentScreen.dart';
import 'package:Siesta/view/travellerView/transactions/stripe_final_payment_screen.dart';
import 'package:Siesta/view_models/travellerTransactionHistoryModal.dart';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/response_pojo/traveller_transaction_details_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:Siesta/response_pojo/travellerTransactionHistoryResponse.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:Siesta/api_requests/api.dart';
import '../../../utility/globalUtility.dart';

class WithdrawRequestDialog extends StatefulWidget {
  WithdrawRequestDialog({Key? key, TransationList? data}) : super(key: key) {
    viewData = data;
  }

  TransationList? viewData;
  @override
  State<WithdrawRequestDialog> createState() => _WithdrawRequestDialogState();
}

class _WithdrawRequestDialogState extends State<WithdrawRequestDialog> {
  double screenWidth = 0.0, screenHeight = 0.0;

  TransactionViewDetail? transactionViewDetail;
  String paymentCompletedType = "";

  @override
  void initState() {
    super.initState();
    transactionPaymentViewApi(widget.viewData!.bookingId!);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<TravellerTransactionHistoryModel>.reactive(
        viewModelBuilder: () => TravellerTransactionHistoryModel(),
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
                TextView.headingText(
                    text: transactionViewDetail != null &&
                            transactionViewDetail!.data != null
                        ? "${transactionViewDetail!.data!.user!.name} ${transactionViewDetail!.data!.user!.lastName}"
                        : widget.viewData!.bookingDetails!.user.name,
                    context: context),
                /*  TextView.subHeadingText(
                    text: transactionViewDetail != null &&
                            transactionViewDetail!.data != null
                        ? transactionViewDetail!.data!.user!.email.toString()
                        : "",
                    context: context),*/
                advancePaymentView(),
                UiSpacer.verticalSpace(space: 0.02, context: context),
                // bottomNote(),
                // UiSpacer.verticalSpace(space: 0.02, context: context),
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
        height: screenHeight * 0.12,
        width: screenHeight * 0.12,
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
          child: transactionViewDetail != null &&
                  transactionViewDetail!.data != null
              ? transactionViewDetail!.data!.user!.userDetail!.profilePicture !=
                      null
                  ? Image.network(
                      transactionViewDetail!
                          .data!.user!.userDetail!.profilePicture!,
                      fit: BoxFit.fill,
                    )
                  : Image.asset(AppImages().pngImages.icProfilePlaceholder)
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
            text: transactionViewDetail != null &&
                    transactionViewDetail!.data != null
                ? transactionViewDetail!.data!.destination
                : " ",
            style: TextStyle(
                fontFamily: AppFonts.nunitoRegular,
                color: AppColor.dontHaveTextColor,
                fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize)),
      ]),
    );
  }

  Widget advancePaymentView() {
    if (transactionViewDetail != null && transactionViewDetail!.data != null) {
      if (transactionViewDetail!.data!.payments!.length != 0) {
        for (int i = 0;
            i < transactionViewDetail!.data!.payments!.length;
            i++) {
          paymentCompletedType =
              transactionViewDetail!.data!.payments![i].paymentType!;
        }
      }
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      itemCount:
          transactionViewDetail != null && transactionViewDetail!.data != null
              ? transactionViewDetail!.data!.payments!.length
              : 0,
      itemBuilder: (BuildContext context, int index) {
        return widget.viewData!.paymentType ==
                transactionViewDetail!.data!.payments![index].paymentType
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(children: [
                      TextSpan(
                        text: transactionViewDetail!
                                    .data!.payments![index].paymentType ==
                                "INITIAL"
                            ? AppStrings().advancePayment
                            : (transactionViewDetail!.data!.payments![index]
                                            .paymentType ==
                                        "FINAL" &&
                                    transactionViewDetail!.data!
                                            .payments![index].paymentStatus ==
                                        2)
                                ? ""
                                : "Total Payment:",
                        style: TextStyle(
                            fontFamily: AppFonts.nunitoSemiBold,
                            color: AppColor.lightBlack,
                            fontSize: screenHeight *
                                AppSizes().fontSize.xsimpleFontSize),
                      ),
                      TextSpan(
                          text: (transactionViewDetail!
                                          .data!.payments![index].paymentType ==
                                      "FINAL" &&
                                  transactionViewDetail!.data!.payments![index]
                                          .paymentStatus ==
                                      2)
                              ? ""
                              : "\$${transactionViewDetail!.data!.payments![index].amount}",
                          style: TextStyle(
                              fontFamily: AppFonts.nunitoRegular,
                              color: AppColor.dontHaveTextColor,
                              fontSize: screenHeight *
                                  AppSizes().fontSize.xsimpleFontSize)),
                    ]),
                  ),
                  (transactionViewDetail!.data!.payments![index].paymentType ==
                              "INITIAL" ||
                          (transactionViewDetail!
                                      .data!.payments![index].paymentType ==
                                  "FINAL" &&
                              transactionViewDetail!
                                      .data!.payments![index].paymentStatus ==
                                  1))
                      ? Row(
                          children: [
                            Icon(Icons.circle,
                                color: AppColor.progressbarColor, size: 5),
                            Text(" ${AppStrings.completed}",
                                style: TextStyle(
                                    fontFamily: AppFonts.nunitoBold,
                                    color: AppColor.progressbarColor,
                                    fontSize: screenHeight *
                                        AppSizes().fontSize.xsimpleFontSize)),
                          ],
                        )
                      : const SizedBox(),
                ],
              )
            : const SizedBox();
      },
      separatorBuilder: (BuildContext context, int index) {
        return widget.viewData!.paymentType ==
                transactionViewDetail!.data!.payments![index].paymentType
            ? Divider(
                color: AppColor.hintTextColor,
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
              text: AppStrings().remainingPaymentView +
                  ": \$ ${transactionViewDetail!.data!.itinerary!.finalPrice.toString()}",
              style: TextStyle(
                  fontFamily: AppFonts.nunitoSemiBold,
                  color: AppColor.lightBlack,
                  fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize),
            ),
          ]),
        ),
        // makePaymentButton(),
      ],
    );
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
                  text: transactionViewDetail != null &&
                          transactionViewDetail!.data != null
                      ? "\$${transactionViewDetail!.data!.totalBookingPrice}"
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
              Icon(Icons.circle, color: AppColor.progressbarColor, size: 5),
              Text(" ${AppStrings.completed}",
                  style: TextStyle(
                      fontFamily: AppFonts.nunitoBold,
                      color: AppColor.progressbarColor,
                      fontSize:
                          screenHeight * AppSizes().fontSize.xsimpleFontSize)),
            ],
          )
        ],
      ),
    );
  }

  Widget advancePayDialog() {
    return WillPopScope(
      child: StatefulBuilder(builder: (context, setState) {
        return Dialog(
          insetPadding: EdgeInsets.all(screenWidth * 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          child: Container(
              height: screenHeight * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: StripeWithdrawPaymentScreen(
                bookingId: widget.viewData!.bookingId!,
              )),
        );
      }),
      onWillPop: () async {
        return true;
      },
    );
  }

  Widget makePaymentBtnAdvancePay() {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          AppSizes().widgetSize.smallbuttonHeight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          GlobalUtility.showDialogFunction(context, advancePayDialog());
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColor.appthemeColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.roundBorderRadius))),
        child: Text(
          AppStrings().makePayment,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.xsimpleFontSize,
              color: AppColor.whiteColor,
              fontFamily: AppFonts.nunitoSemiBold),
        ),
      ),
    );
  }

  Widget showDialogStripe() {
    return WillPopScope(
      child: StatefulBuilder(builder: (context, setState) {
        return Dialog(
          insetPadding: EdgeInsets.all(screenWidth * 0.03),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: StripeFinalPaymentScreen(
                bookingId: widget.viewData!.bookingId!,
                amount: transactionViewDetail!.data!.itinerary!.finalPrice
                    .toString(),
              )),
        );
      }),
      onWillPop: () async {
        return true;
      },
    );
  }

  Widget makePaymentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          AppSizes().widgetSize.smallbuttonHeight,
      child: ElevatedButton(
        onPressed: () {
          if (transactionViewDetail!.data!.isCompleted != 0) {
            Navigator.pop(context);
            GlobalUtility.showDialogFunction(context, showDialogStripe());
          }
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: transactionViewDetail != null &&
                    transactionViewDetail!.data != null
                ? transactionViewDetail!.data!.isCompleted != 0
                    ? AppColor.appthemeColor
                    : AppColor.buttonDisableColor
                : AppColor.buttonDisableColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.roundBorderRadius))),
        child: Text(
          AppStrings().makePayment,
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
            Api.travellerTransactionView +
            "?booking_id=" +
            bookingId.toString()),
        headers: <String, String>{
          "Content-Type": "application/json",
          'access_token': "${await PreferenceUtil().getToken()}"
        },
      );
      debugPrint('TRANSACTION DETAIL == >> Url Api :- '
          '${Uri.parse(Api.baseUrl + Api.travellerTransactionView)} \n Response:-- ${apiResponse.body} ');
      var jsonData = json.decode(apiResponse.body);

      int status = jsonData['statusCode'];
      String message = jsonData['message'];
      Navigator.pop(context);
      if (status == 200) {
        setState(() {
          TransactionViewDetail transactionView =
              transactionViewDetailFromJson(apiResponse.body);
          List<Payment> paymentList = [];
          for (int i = 0; i < transactionView.data!.payments!.length; i++) {
            if (i == 0) {
              paymentList.add(transactionView.data!.payments![i]);
            } else {
              if (transactionView.data!.payments![i - 1].paymentType !=
                  transactionView.data!.payments![i].paymentType) {
                paymentList.add(transactionView.data!.payments![i]);
              }
            }
          }
          transactionView.data!.payments = paymentList;
          transactionViewDetail = transactionView;
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
}
