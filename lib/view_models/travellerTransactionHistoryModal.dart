import 'dart:convert';
import 'package:Siesta/api_requests/traveller_transaction_historyRequest.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/response_pojo/travellerTransactionHistoryResponse.dart';
import 'package:Siesta/response_pojo/traveller_transaction_details_model.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import '../app_constants/app_strings.dart';
import '../view/all_dialogs/api_success_dialog.dart';

class TravellerTransactionHistoryModel extends BaseViewModel
    implements Initialisable {
  final TravellerTransactionHistoryRequest _travellerTransactionHistoryRequest =
      TravellerTransactionHistoryRequest();
  BuildContext? viewContext;
  TravellerTransactionHistoryResponse? travellerTransactionHistoryResponse;
  List<TransationList>? travellerTransactionList = [];
  int pageNo = 1;
  int lastPage = 1;
  int? bookingId;
  String filterValue = 'All';
  int filterselectedValue = 1;
  var filterItems = [
    'All',
    'Completed',
    'Failed',
  ];
  TextEditingController searchController = TextEditingController();
  TransactionViewDetail? transactionViewDetail;

  @override
  void initialise() async {
    gettravellerhistory(
        viewContext, pageNo, searchController.text, filterValue);
  }

  //get traveller transaction list
  void gettravellerhistory(
      viewContext, int pageNo, String searchText, String filterType) async {
    if (pageNo <= lastPage) {
      setBusy(true);
      notifyListeners();
      if (await GlobalUtility.isConnected()) {
        Response apiResponse =
            await _travellerTransactionHistoryRequest.travellerTranHistory(
                pageNo: pageNo.toString(),
                number_of_rows: "10",
                searchText: searchText,
                filterType: filterType);

        debugPrint("TRAVELLER TRANSACTION HISTORY ==>> ${apiResponse.body}");

        Map jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        if (status == 200) {
          setBusy(false);
          notifyListeners();
          travellerTransactionHistoryResponse =
              travellerTransactionHistoryResponseFromJson(apiResponse.body);
          if (pageNo == 1) {
            lastPage =
                (travellerTransactionHistoryResponse!.data!.count / 10).round();
            lastPage = lastPage + 1;
            travellerTransactionList!.clear();
            travellerTransactionList = [];
            travellerTransactionList =
                travellerTransactionHistoryResponse!.data!.rows;
          } else {
            travellerTransactionList = [
              ...travellerTransactionList!,
              ...travellerTransactionHistoryResponse!.data!.rows
            ];
          }
          notifyListeners();
        } else if (status == 400) {
          setBusy(false);

          GlobalUtility.showToast(viewContext, message);
        } else if (status == 401) {
          setBusy(false);
          GlobalUtility().handleSessionExpire(viewContext);
        }
      } else {
        GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
      }
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
