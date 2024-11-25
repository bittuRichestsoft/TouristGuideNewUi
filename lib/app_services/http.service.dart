import 'dart:io';
import 'package:Siesta/api_requests/api.dart';

class HttpService {
  String host = Api.baseUrl;

  Future<Map<String, String>> getHeaders() async {
    //final userToken = await AuthServices.getAuthBearerToken();
    return {
      HttpHeaders.acceptHeader: "application/json",
      //   HttpHeaders.authorizationHeader: "Bearer $userToken",
    };
  }
}
