import 'dart:convert';

import 'package:Siesta/api_requests/api_request.dart';
import 'package:Siesta/response_pojo/guideAccountDeatilsPojo.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../api_requests/api.dart';
import '../../../app_constants/app_strings.dart';
import '../../../main.dart';
import '../../../utility/globalUtility.dart';

class GuideBankingDetailModel extends BaseViewModel implements Initialisable {
  //banking controller
  TextEditingController accountHolderNameTEC = TextEditingController();
  TextEditingController bankNameTEC = TextEditingController();
  TextEditingController accountNumberTEC = TextEditingController();
  TextEditingController ifscTEC = TextEditingController();

  bool isBankButtonEnable = true;

  @override
  void initialise() {
    setError(null);
    getGuideAccountDetailsAPI();
  }

  bool validate(BuildContext context) {
    if (accountHolderNameTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(
          context, "Please enter valid account holder name");
      return false;
    } else if (bankNameTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter valid bank name");
      return false;
    } else if (accountNumberTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter valid account number");
      return false;
    } else if (ifscTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter valid routing number");
      return false;
    }
    return true;
  }

  void getGuideAccountDetailsAPI() async {
    BuildContext context = navigatorKey.currentContext!;

    try {
      // GlobalUtility().showLoaderDialog(context);
      if (await GlobalUtility.isConnected()) {
        final apiResponse =
            await ApiRequest().getWithHeader(Api.guideGetBankAccountApi);

        Map jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'] ?? 404;
        var message = jsonData['message'] ?? "";

        if (status == 200) {
          GuideGetAccountDetailsPojo guideGetAccountDetailsPojo =
              guideGetAccountDetailsPojoFromJson(apiResponse.body);

          if (guideGetAccountDetailsPojo.data.value.isNotEmpty) {
            Map valuesMap = jsonDecode(guideGetAccountDetailsPojo.data.value);
            accountHolderNameTEC.text = valuesMap["account_user_name"] ?? "";
            accountNumberTEC.text = valuesMap["account_number"] ?? "";
            bankNameTEC.text = valuesMap["bank_name"] ?? "";
            ifscTEC.text = valuesMap["bank_ifsc"] ?? "";
            setInitialised(true);
          }
        } else if (status == 400) {
          setError("Error occurred");
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          setError("Error occurred");
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        setError(AppStrings().INTERNET);
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      setError("Error occurred");
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
    }
  }

  void guideUpdateAccountAPI(BuildContext context) async {
    try {
      GlobalUtility().showLoaderDialog(context);
      if (await GlobalUtility.isConnected()) {
        Map map = {
          "account_number": accountNumberTEC.text,
          "account_user_name": accountHolderNameTEC.text,
          "bank_name": bankNameTEC.text,
          "bank_ifsc": ifscTEC.text
        };
        final apiResponse = await ApiRequest()
            .putWithMap(map, Api.guideUpdateBankAccountApi)
            .timeout(const Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'] ?? 404;
        var message = jsonData['message'] ?? "";

        if (jsonData != null) {
          if (status == 200) {
            GlobalUtility.showToast(context, message);
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (status == 400) {
            GlobalUtility.showToast(context, message);
          } else if (status == 401) {
            GlobalUtility().handleSessionExpire(context);
          }
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(context);
    }
  }
}
