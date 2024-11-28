import 'dart:convert';

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/api_requests/api_request.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../app_constants/app_strings.dart';
import '../../response_pojo/county_pojo.dart';
import '../../utility/globalUtility.dart';

class EditGuideProfileModel extends BaseViewModel implements Initialisable {
  int yearValue = 0;
  int monthValue = 0;
  String? selectedPronounValue;

  TextEditingController countryNameController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  ValueNotifier<bool> destinationNotifier = ValueNotifier(false);

  List<String> countryList = ["Select Country"];
  List<String> stateList = ["Select State"];
  List<String> cityList = ["Select City"];

  @override
  void initialise() {
    // call get Profile
  }

  void increaseHostValue(String type) {
    if (type == "year") {
      yearValue++;
    } else {
      if (monthValue < 11) {
        monthValue++;
      }
    }
    notifyListeners();
  }

  void decreaseHostValue(String type) {
    if (type == "year" && yearValue > 0) {
      yearValue--;
    } else if (type == "month" && monthValue > 0) {
      monthValue--;
    }
    notifyListeners();
  }

  Future<bool> getLocationApi(
      {BuildContext? viewContext, String? countryId, String? stateId}) async {
    try {
      if (await GlobalUtility.isConnected()) {
        GlobalUtility().showLoaderDialog(viewContext!);

        Map map = {
          "countryName": countryId ?? "",
          "stateName": stateId ?? "",
        };
        final apiResponse =
            await ApiRequest().postWithMap(map, Api.getLocation);
        Map jsonData = jsonDecode(apiResponse.body);
        debugPrint("MAP --- $map ----- \n$jsonData");
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        // Navigator.pop(viewContext);
        if (status == 200) {
          CountryResponse countryResponse =
              countryResponseFromJson(apiResponse.body);
          if (countryId!.isEmpty && stateId!.isEmpty) {
            countryList.clear();
            for (int i = 0; i < countryResponse.data!.length; i++) {
              countryList.add(countryResponse.data![i].name!);
            }
          } else if (countryId.isNotEmpty && stateId!.isEmpty) {
            stateList.clear();
            for (int i = 0; i < countryResponse.data!.length; i++) {
              stateList.add(countryResponse.data![i].name!);
            }
            debugPrint("state list : ${stateList.toString()}");
          } else if (countryId.isNotEmpty && stateId!.isNotEmpty) {
            cityList.clear();
            for (int i = 0; i < countryResponse.data!.length; i++) {
              cityList.add(countryResponse.data![i].name!);
            }
          }

          return true;
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
        GlobalUtility.showToast(viewContext!, AppStrings().INTERNET);
      }
    } catch (e) {
      GlobalUtility.showToast(viewContext!, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(viewContext!);
    }
    return false;
  }
}
