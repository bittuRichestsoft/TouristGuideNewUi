import 'dart:convert';
import 'package:Siesta/api_requests/guide_trancaction_list_request.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/all_dialogs/api_success_dialog.dart';
import 'package:Siesta/view/touristGuideView/guide_transaction_history/guide_transaction_response_pojo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

class GuideTransactionHistoryModel extends BaseViewModel
    implements Initialisable {
  final GuideTransactionListRequest _guideTransactionListRequest =
      GuideTransactionListRequest();
  BuildContext? viewContext;
  GuideTransactionListPojo? guideTransactionListPojo;
  List<GuideTransListData>? guideTransactionList = [];
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
  @override
  void initialise() async {
    getGuideHistoryApi(viewContext, pageNo, searchController.text, filterValue);
  }

  void getGuideHistoryApi(
      viewContext, int pageNo, String searchText, String filterType) async {
    if (pageNo <= lastPage) {
      setBusy(true);
      notifyListeners();
      if (await GlobalUtility.isConnected()) {
        Response apiResponse =
            await _guideTransactionListRequest.guideTransactionList(
                pageNo: pageNo.toString(),
                numberRows: "10",
                searchText: searchText,
                filterType: filterType);
        debugPrint("GUIDE TRANSACTION HISTORY ==>> ${apiResponse.body}");
        Map jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        if (status == 200) {
          setBusy(false);
          guideTransactionListPojo =
              guideTransactionListPojoFromJson(apiResponse.body);
          if (pageNo == 1) {
            lastPage = (guideTransactionListPojo!.data.count / 10).round();
            lastPage = lastPage + 1;
            guideTransactionList = [];
            guideTransactionList = guideTransactionListPojo!.data.rows;
          } else {
            guideTransactionList = [
              ...guideTransactionList!,
              ...guideTransactionListPojo!.data.rows
            ];
          }
          notifyListeners();
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
