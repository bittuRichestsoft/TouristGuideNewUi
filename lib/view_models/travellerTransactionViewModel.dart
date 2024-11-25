import 'dart:convert';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/response_pojo/travellerTransactionViewResponse.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import '../api_requests/traveller_transaction_viewRequest.dart';
import '../app_constants/app_strings.dart';
import '../view/all_dialogs/api_success_dialog.dart';

class TravellerTransactionViewModel extends BaseViewModel {
 
  TravellerTransactionViewModel(viewContext, bookId) {
    bookedId = bookId;
    gettransactionViewDetail(viewContext, bookId);
  }
  int? bookedId;
  final TravellerTransactionViewRequest _travellerTransactionViewRequest = TravellerTransactionViewRequest();
  BuildContext? viewContext;
   TravellerTransactionViewResponse?travellerTransactionViewResponse;

 void gettransactionViewDetail(viewContext, bookingId) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _travellerTransactionViewRequest.getTransactionView(
          booking_id:bookingId.toString());

      debugPrint(
          "TRAVELLER TRANSACTION VIEW DETAIL ---- ${apiResponse.body}");

      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        notifyListeners();
        travellerTransactionViewResponse =
            travellerTransactionViewResponseFromJson(apiResponse.body);
     } else if (status == 400) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  successDialog(String from, BuildContext context, String message) {
    GlobalUtility.showDialogFunction(
        context,
        ApiSuccessDialog(
            imagepath: AppImages().pngImages.ivRegisterVerified,
            titletext: message,
            buttonheading: AppStrings().Okay,
            isPng: true,
            fromWhere: from));
  }
}
