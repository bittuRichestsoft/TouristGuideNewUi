// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/response_pojo/stripe_payment_response.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeFinalPaymentScreen extends StatefulWidget {
  StripeFinalPaymentScreen(
      {super.key, required int bookingId, required String amount}) {
    bookingID = bookingId;
    finalAmount = amount;
    debugPrint("FINAL AMOUNT $amount--- $finalAmount");
  }

  int? bookingID;
  String? finalAmount;

  @override
  State<StripeFinalPaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripeFinalPaymentScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isPay = false;

  final cardController = CardFormEditController();
  String stripeToken = "";
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    amountController.text = widget.finalAmount.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius)),
          tileColor: AppColor.appthemeColor,
          title: Text(
            "Final Payment Details",
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
        SizedBox(height: screenHeight * 0.015),
        amountField(),
        SizedBox(height: screenHeight * 0.015),
        dataField(),
        SizedBox(height: screenHeight * 0.015),
        payButton()
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

  Widget amountField() {
    return TextFormField(
      controller: amountController,
      onTap: () {},
      maxLength: 8,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.disabled,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecorationDollar(
          context, "Enter Amount", ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
    );
  }

  Widget payButton() {
    return CommonButton.commonThemeColorButton(
      context: context,
      text: AppStrings.pays,
      onPressed: () {
        if (amountController.text.replaceAll(" ", "") != "") {
          _handlePayPress();
        } else {
          GlobalUtility.showToast(context, "Please enter amount");
        }
      },
    );
  }

  Future<void> _handlePayPress() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    GlobalUtility().showLoaderDialog(context);
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
      Navigator.pop(context);
      TokenData tokenData = await Stripe.instance.createToken(
          CreateTokenParams.card(
              params:
                  CardTokenParams.fromJson(cardController.details.toJson())));

      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.cardFromToken(
              paymentMethodData:
                  PaymentMethodDataCardFromToken(token: tokenData.id)));

      finalPaymentApiCall(paymentMethod.id, tokenData.id);
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

  /// API FOR STRIPE PAYMENT
  finalPaymentApiCall(String paymentToken, String tokenId) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoaderDialog(context);
      Map map = {
        "paymentToken": paymentToken,
        "booking_id": widget.bookingID.toString(),
        "remainingAmount": amountController.text,
      };
      var apiResponse = await http.post(
        Uri.parse(Api.baseUrl + Api.finalTravellerPaymentApi),
        body: jsonEncode(map),
        headers: <String, String>{
          "Content-Type": "application/json",
          'access_token': "${await PreferenceUtil().getToken()}"
        },
      );
      debugPrint(
          'STRIPE == >> Url Api :- ${Uri.parse(Api.baseUrl + Api.finalTravellerPaymentApi)}\n $map \n Response:-- ${apiResponse.body} ');
      var jsonData = json.decode(apiResponse.body);
      int status = jsonData['statusCode'];
      String message = jsonData['message'];
      Navigator.pop(context);
      if (status == 200) {
        StripePaymentInitial stripePaymentInitial =
            stripePaymentInitialFromJson(apiResponse.body);
        confirmStripePayment(stripePaymentInitial.data!.clientSecret.toString(),
            tokenId, stripePaymentInitial.data!.transactionId.toString());

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
  }

  bool? paymentStatus;

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
          //finalPaymentStatusApiCall(transactionId, paymentStatus!);
        }
      } else {
        setState(() {
          paymentStatus = false;
        });
      }
    });
  }

  /// PAYMENT STATUS API
  finalPaymentStatusApiCall(String transactionId, bool paymentStatus) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoaderDialog(context);
      Map map = {
        "booking_id": widget.bookingID.toString(),
        "transaction_id": transactionId,
        "payment_status": paymentStatus
      };
      var apiResponse = await http.post(
        Uri.parse(Api.baseUrl + Api.finalTravellerPaymentStatusApi),
        body: jsonEncode(map),
        headers: <String, String>{
          "Content-Type": "application/json",
          'access_token': "${await PreferenceUtil().getToken()}"
        },
      );
      debugPrint(
          'STRIPE == >> Payment Status Url Api :- ${Uri.parse(Api.baseUrl + Api.finalTravellerPaymentStatusApi)}\n $map \n Response:-- ${apiResponse.body} ');
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
  }
}
