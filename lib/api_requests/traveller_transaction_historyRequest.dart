import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';

class TravellerTransactionHistoryRequest extends HttpService {
  Future<Response> travellerTranHistory({
    required String pageNo,
    required String number_of_rows,
    required String searchText,
    required String filterType,
  }) async {
    debugPrint("accesstoken:-- ${await PreferenceUtil().getToken()}");
    final apiResult = await get(
      Uri.parse("${Api.baseUrl}${Api.travellerTransactionHistory}"
          "?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$searchText&filter_text=$filterType"),
      headers: {"Content-Type": "application/json",
      "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint("Api ==>> ${Api.baseUrl + Api.travellerTransactionHistory}?page_no=$pageNo&number_of_rows=$number_of_rows&search_text=$searchText&filter_text=$filterType");

    debugPrint("Api ==>> ${Api.baseUrl + Api.travellerTransactionHistory} response = $apiResult");
    return apiResult;
  }
}