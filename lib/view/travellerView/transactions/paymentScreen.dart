// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/response_pojo/stripe_payment_response.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeWithdrawPaymentScreen extends StatefulWidget {
  StripeWithdrawPaymentScreen({
    super.key,
    required int bookingId,
  }) {
    bookingID = bookingId;
  }

  int? bookingID;

  @override
  State<StripeWithdrawPaymentScreen> createState() =>
      _StripeWithdrawPaymentScreenState();
}

class _StripeWithdrawPaymentScreenState
    extends State<StripeWithdrawPaymentScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isPay = false;

  final cardController = CardFormEditController();
  String stripeToken = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
          horizontal: screenHeight * AppSizes().widgetSize.normalPadding,
          vertical: screenHeight * AppSizes().widgetSize.normalPadding),
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius)),
          tileColor: AppColor.appthemeColor,
          title: Text(
            "Advance Payment Details",
            style: TextStyle(
                fontSize: screenHeight * AppSizes().fontSize.headingTextSize,
                fontFamily: AppFonts.nunitoMedium,
                color: AppColor.whiteColor),
          ),
          trailing: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: AppColor.whiteColor,
              )),
        ),
        paymentDetailsFields()
      ],
    );
  }

  Widget paymentDetailsFields() {
    return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        dataField(),
        SizedBox(height: screenHeight * 0.02),
        payButton(),
      ],
    );
  }

  Widget dataField() {
    return CardFormField(
      controller: cardController,
      style: CardFormStyle(
        borderColor: Colors.grey.shade200,
        borderWidth: 1,
        textColor: AppColor.blackColor,
        placeholderColor: AppColor.hintTextColor,
      ),
    );
  }

  Widget payButton() {
    return CommonButton.commonThemeColorButton(
      context: context,
      text: AppStrings.pays,
      onPressed: () {
        _handlePayPress();
      },
    );
  }

  Future<void> _handlePayPress() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    GlobalUtility().showLoader(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (!cardController.details.complete) {
      setState(() {
        isPay = false;
      });
      Navigator.pop(context);
      GlobalUtility.showToast(context, "Please fill the form");
      return;
    }
    try {
      setState(() {
        isPay = true;
      });

      TokenData tokenData = await Stripe.instance.createToken(
          CreateTokenParams.card(
              params:
                  CardTokenParams.fromJson(cardController.details.toJson())));

      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.cardFromToken(
              paymentMethodData:
                  PaymentMethodDataCardFromToken(token: tokenData.id)));
      Navigator.pop(context);
      stripePaymentApiCall(paymentMethod.id, tokenData.id);
    } catch (e) {
      Navigator.pop(context);
      GlobalUtility.showToast(context,
          'There is an error with the information that you entered. Please try again or contact us .');
      setState(() {
        isPay = false;
      });
      rethrow;
    }
  }

  /// ANDROID
  /// API FOR STRIPE PAYMENT
  stripePaymentApiCall(String paymentToken, String tokenId) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoaderDialog(context);
      Map map = {
        "paymentToken": paymentToken,
        "booking_id": widget.bookingID.toString()
      };
      var apiResponse = await http.post(
        Uri.parse(Api.baseUrl + Api.paymentApi),
        body: jsonEncode(map),
        headers: <String, String>{
          "Content-Type": "application/json",
          'access_token': "${await PreferenceUtil().getToken()}"
        },
      );
      debugPrint(
          'STRIPE == >> Url Api :- ${Uri.parse(Api.baseUrl + Api.paymentApi)}\n $map \n Response:-- ${apiResponse.body} ');
      var jsonData = json.decode(apiResponse.body);
      int status = jsonData['statusCode'];
      String message = jsonData['message'];
      Navigator.pop(context);
      if (status == 200) {
        StripePaymentInitial stripePaymentInitial =
            stripePaymentInitialFromJson(apiResponse.body);
        confirmStripePayment(
          stripePaymentInitial.data!.clientSecret.toString(),
          tokenId,
          stripePaymentInitial.data!.transactionId.toString(),
        );
        // final secret
        confirmStripePayment(
          stripePaymentInitial.data!.clientSecretFinal.toString(),
          tokenId,
          stripePaymentInitial.data!.transactionId.toString(),
        );
      } else if (status == 400) {
        GlobalUtility.showToast(context, message);
      } else {
        GlobalUtility.showToast(context, message);
      }
    } else {
      GlobalUtility.showToast(context, "Internet error");
    }
  }

  Future<void> confirmStripePayment(
      String clientSecret, String tokenId, String transactionId) async {
    TokenData tokenData = await Stripe.instance.createToken(
        CreateTokenParams.card(
            params: CardTokenParams.fromJson(cardController.details.toJson())));

    var params = PaymentMethodParams.cardFromToken(
        paymentMethodData: PaymentMethodDataCardFromToken(token: tokenData.id));

    var res = await Stripe.instance
        .confirmPayment(
      paymentIntentClientSecret: clientSecret,
      data: params,
    )
        .then((value) {
      if (value.status == PaymentIntentsStatus.Succeeded) {
        setState(() {
          paymentStatus = true;
        });
        if (paymentStatus != null && paymentStatus == true) {
          debugPrint(" inside successs");
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.transactionHistory, (route) => false);
        }
      } else {
        setState(() {
          paymentStatus = false;
        });
      }
    });
  }

  bool? paymentStatus;

  /*/// PAYMENT STATUS API
  paymentStatusApiCall(String transactionId, bool paymentStatus) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoaderDialog(context);
      Map map = {
        "booking_id": widget.bookingID.toString(),
        "transaction_id": transactionId,
        "payment_status": paymentStatus
      };
      var apiResponse = await http.post(
        Uri.parse(Api.baseUrl + Api.paymentStatusApi),
        body: jsonEncode(map),
        headers: <String, String>{
          "Content-Type": "application/json",
          'access_token': "${await PreferenceUtil().getToken()}"
        },
      );
      debugPrint(
          'STRIPE == >> Payment Status Url Api :- ${Uri.parse(Api.baseUrl + Api.paymentStatusApi)}\n $map \n Response:-- ${apiResponse.body} ');
      var jsonData = json.decode(apiResponse.body);
      int status = jsonData['statusCode'];
      String message = jsonData['message'];
      Navigator.pop(context);
      if (status == 200) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.transactionHistory, (route) => false);
        GlobalUtility.showToast(context, "Payment Successfully");
      } else if (status == 400) {
        GlobalUtility.showToast(context, message);
      } else {
        GlobalUtility.showToast(context, message);
      }
    } else {
      GlobalUtility.showToast(context, "Internet error");
    }
  }*/
}
