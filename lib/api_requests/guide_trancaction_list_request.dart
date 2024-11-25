import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_services/http.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:Siesta/utility/preference_util.dart';

class GuideTransactionListRequest extends HttpService {
  Future<Response> guideTransactionList({
    required String pageNo,
    required String numberRows,
    required String searchText,
    required String filterType,
  }) async {
    final apiResult = await get(
      Uri.parse(
          "${Api.baseUrl}${Api.guideTransactionListApi}?page_no=$pageNo&number_of_rows=$numberRows&search_text=$searchText&filter_text=$filterType"),
      headers: {
        "Content-Type": "application/json",
        "access_token": await PreferenceUtil().getToken()
      },
    );
    debugPrint(
        "GUIDE TRANSACTION LIST API ==>> ${Api.baseUrl + Api.guideTransactionListApi}?page_no=$pageNo&number_of_rows=$numberRows&search_text=$searchText&filter_text=$filterType");

    return apiResult;
  }

  Future<Response> userSocialLinksApi() async {
    final apiResult = await get(
      Uri.parse(Api.baseUrl + Api.socialLinks),
      headers: {
        "Content-Type": "application/json",
      },
    );
    debugPrint("SOCIAL LINKS ;--- ${Api.baseUrl + Api.socialLinks}");
    return apiResult;
  }




}
