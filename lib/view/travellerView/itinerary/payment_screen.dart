// ignore_for_file: use_build_context_synchronously, must_be_immutable, invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';
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
import 'package:http/http.dart';
import '../../../api_requests/traveller_transaction_viewRequest.dart';
import '../../../response_pojo/get_payment_methods_traveller.dart';

class StripePaymentScreen extends StatefulWidget {
  StripePaymentScreen({
    super.key,
    required int bookingId,
  }) {
    bookingID = bookingId;
  }

  int? bookingID;

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isPay = false;

  final cardController = CardFormEditController();

  PaymentMethodList? savedCardData;

  @override
  void initState() {
    fetchPaymentMethodsApi();
    super.initState();
  }

  List<PaymentMethodList>? paymentMethodsList;

  List<bool> isPaymentCardSelected = [];
  bool isNewCardSelected = false;

  ValueNotifier<bool> paymentCardViewNotifier = ValueNotifier(false);
  int? addCardSelect;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
          title: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Text(
                "Payment",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColor.whiteColor,
                    fontFamily: AppFonts.nunitoSemiBold,
                    fontSize: MediaQuery.of(context).size.height *
                        AppSizes().fontSize.largeTextSize),
              ),
            ],
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
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 5),
          child: Text(
            "Always safe with us",
            textAlign: TextAlign.start,
            style: TextStyle(
                height: 1.5,
                color: AppColor.appthemeColor,
                fontFamily: AppFonts.nunitoMedium,
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.normalFontSize),
          ),
        ),
        paymentMethodList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: payButton()),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: CommonButton.commonNormalButton(
                  context: context,
                  text: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: AppColor.textbuttonColor,
                  backColor: AppColor.textbuttonColors.withOpacity(0.2)),
            ),
          ],
        ),
      ],
    );
  }

  paymentMethodList() {
    return SizedBox(
      height: screenHeight * 0.5,
      child: ListView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          RadioListTile<int>(
            dense: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
            groupValue: isNewCardSelected ? 1 : 0,
            activeColor: AppColor.appthemeColor,
            title: Text(
              "Pay with New Card",
              textAlign: TextAlign.start,
              style: TextStyle(
                  height: 2,
                  color: AppColor.blackColor,
                  fontFamily: AppFonts.nunitoBold,
                  fontSize: MediaQuery.of(context).size.height *
                      AppSizes().fontSize.simpleFontSize),
            ),
            isThreeLine: false,
            value: 1,
            contentPadding: EdgeInsets.zero,
            toggleable: true,
            onChanged: (val) {
              for (int i = 0; i < isPaymentCardSelected.length; i++) {
                isPaymentCardSelected[i] = false;
              }
              if (val == 1) {
                isNewCardSelected = true;
              } else {
                isNewCardSelected = false;
              }
              setState(() {});
            },
          ),
          isNewCardSelected == true ? dataField() : const SizedBox(),
          paymentMethodsList != null
              ? Text(
                  "Payment with saved cards",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppColor.blackColor,
                      fontFamily: AppFonts.nunitoSemiBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.normalFontSize),
                )
              : const SizedBox(),
          const SizedBox(height: 5),
          paymentMethodsList != null
              ? ValueListenableBuilder(
                  valueListenable: paymentCardViewNotifier,
                  builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentMethodsList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RadioListTile<int>(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -2),
                          groupValue:
                              isPaymentCardSelected[index] == true ? 1 : 0,
                          activeColor: AppColor.appthemeColor,
                          title: Text(
                            "**** **** **** ${paymentMethodsList![index].card!.last4}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                height: 2,
                                color: AppColor.blackColor,
                                fontFamily: AppFonts.nunitoSemiBold,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppSizes().fontSize.simpleFontSize),
                          ),
                          isThreeLine: false,
                          value: 1,
                          contentPadding: EdgeInsets.zero,
                          toggleable: true,
                          onChanged: (val) {
                            isNewCardSelected = false;
                            for (int i = 0;
                                i < isPaymentCardSelected.length;
                                i++) {
                              if (i == index) {
                                isPaymentCardSelected[i] =
                                    !isPaymentCardSelected[i];
                                if (isPaymentCardSelected[i] == true) {
                                  savedCardData = paymentMethodsList![index];
                                }
                              } else {
                                isPaymentCardSelected[i] = false;
                              }
                            }
                            paymentCardViewNotifier.value = true;
                            setState(() {});
                            paymentCardViewNotifier.notifyListeners();
                          },
                        );
                      },
                    );
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void fetchPaymentMethodsApi() async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoader(context);
      Response apiResponse =
          await TravellerTransactionViewRequest.getPaymentMethods();

      debugPrint("GET PAYMENT METHODS RESPONSE :- ${apiResponse.body}");
      Navigator.pop(context);
      Map jsonData = jsonDecode(apiResponse.body);
      var statusCode = jsonData['statusCode'];
      var message = jsonData['message'];
      Map checkData = jsonData['data'];

      if (statusCode == 200 && checkData.isEmpty == false) {
        PaymentMethodsResponse paymentMethodsResponse =
            paymentMethodsResponseFromJson(apiResponse.body);

        paymentMethodsList = paymentMethodsResponse.data!.data;
        isPaymentCardSelected.clear();
        for (int i = 0; i < paymentMethodsList!.length; i++) {
          isPaymentCardSelected.add(false);
        }

        setState(() {});
      } else if (statusCode == 400) {
        setState(() {});
        GlobalUtility.showToast(context, message);
      } else if (statusCode == 200 && checkData.isEmpty) {
        setState(() {});
      } else if (statusCode == 401) {
        setState(() {});
        GlobalUtility.showToast(context, message);
        GlobalUtility().handleSessionExpire(context);
      }
    } else {
      GlobalUtility.showToast(context, AppStrings().INTERNET);
    }
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
        if (isNewCardSelected == true) {
          _handlePayPress();
        } else {
          stripePaymentApiCall(savedCardData!.id.toString(),
              widget.bookingID.toString(), "savedCard");
        }
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
      stripePaymentApiCall(paymentMethod.id, tokenData.id, "newCard");
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
  stripePaymentApiCall(String paymentToken, String tokenId, String from) async {
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
          'STRIPE == >> Url Api :- ${Uri.parse(Api.baseUrl + Api.paymentApi)}\n $map \n Response:-- '
          '${apiResponse.body} ');

      var jsonData = json.decode(apiResponse.body);
      int status = jsonData['statusCode'];
      String message = jsonData['message'];
      Navigator.pop(context);
      GlobalUtility.showToast(context, "Please wait payment under process!");
      if (status == 200) {
        StripePaymentInitial stripePaymentInitial =
            stripePaymentInitialFromJson(apiResponse.body);

        if (stripePaymentInitial.data!.clientSecret != null) {
          confirmStripePayment(
              stripePaymentInitial.data!.clientSecret.toString(),
              from,
              stripePaymentInitial);
        }
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

  Future<void> confirmStripePayment(String clientSecret, String from,
      StripePaymentInitial stripePaymentInitial) async {
    if (Platform.isIOS) {
      GlobalUtility().showLoaderDialog(context);
    }
    TokenData tokenData;
    var params;
    if (from != "savedCard") {
      tokenData = await Stripe.instance.createToken(CreateTokenParams.card(
          params: CardTokenParams.fromJson(cardController.details.toJson())));

      params = PaymentMethodParams.cardFromToken(
          paymentMethodData:
              PaymentMethodDataCardFromToken(token: tokenData.id));
    }

    var res = await Stripe.instance
        .confirmPayment(
      paymentIntentClientSecret: clientSecret,
    )
        .then((value) {
      if (Platform.isIOS) {
        Navigator.pop(context);
      }
      if (value.status == PaymentIntentsStatus.Succeeded) {
        setState(() {
          paymentStatus = true;
        });
        if (paymentStatus != null && paymentStatus == true) {
          confirmFinalStripePayment(
            stripePaymentInitial.data!.clientSecretFinal.toString(),
          );
        }
      } else {
        setState(() {
          paymentStatus = false;
        });
      }
    });
  }

  Future<void> confirmFinalStripePayment(
    String clientSecret,
  ) async {
    if (Platform.isIOS) {
      GlobalUtility().showLoaderDialog(context);
    }
    var res = await Stripe.instance
        .confirmPayment(
      paymentIntentClientSecret: clientSecret,
    )
        .then((value) {
      if (Platform.isIOS) {
        Navigator.pop(context);
      }

      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.transactionHistory, (route) => false);
    });
  }
}
