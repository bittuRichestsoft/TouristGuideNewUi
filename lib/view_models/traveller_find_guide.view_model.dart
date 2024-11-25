import 'dart:convert';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/response_pojo/traveller_find_guide_response.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import '../api_requests/traveller_find_guide.dart';
import '../app_constants/app_strings.dart';
import '../view/all_dialogs/api_success_dialog.dart';
import 'package:intl/intl.dart';
import 'package:Siesta/app_constants/app_routes.dart';

class TravellerFindGuideModel extends BaseViewModel implements Initialisable {
  final FindGuideRequest _findGuideRequest = FindGuideRequest();
  BuildContext? viewContext;
  TextEditingController searchController = TextEditingController();
  TravellerFindGuideResponse? travellerFindGuideResponse;
  List<Detail>? travellerGuideList = [];
  int pageNo = 1;
  int lastPage = 1;
  bool isEmptyViewShown = false;
  bool isSearchRunnig = false;
  String countryName = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  bool isSubmitButtonEnable = false;
  String email = "";
  String firstname = "";
  String lastName = "";
  String phone = "";
  ScrollController scrollController = ScrollController();
  int pageCount = 1;
  @override
  void initialise() async {
    gettouristGuide(viewContext, pageNo);
    _asyncMethod();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        pageCount = pageCount + 1;
        gettouristGuide(viewContext, pageCount);
      } else {}
    });
  }

  _asyncMethod() async {
    String val1 = await PreferenceUtil().getEmail();
    String val2 = await PreferenceUtil().getFirstName();
    String val4 = await PreferenceUtil().getLastName();
    String val5 = await PreferenceUtil().getphone();
    emailController.text = val1;
    firstNameController.text = val2;
    lastNameController.text = val4;
    mobileNumberController.text = val5;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String string = dateFormat.format(DateTime.now());
    fromDateController.text = string;
    toDateController.text = string;
    notifyListeners();
  }

  Future<void> pullRefresh() async {
    debugPrint("_pullRefresh_pullRefresh");
    travellerGuideList = [];
    gettouristGuide(viewContext, 1);
  }

  void sendEnquiry(viewContext) async {
    debugPrint("emailController>>>>>>${firstNameController.text}");
    debugPrint("lastNameController>>>>>>${lastNameController.text}");
    debugPrint("emailController>>>>>>${emailController.text}");
    debugPrint("mobileNumberController>>>>>>${mobileNumberController.text}");
    debugPrint("destinationController>>>>>>${destinationController.text}");
    debugPrint("fromDateController>>>>>>${fromDateController.text}");
    debugPrint("toDateController>>>>>>${toDateController.text}");
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _findGuideRequest.sendEnquiry(
        context: viewContext,
        first_name: firstNameController.text,
        last_name: lastNameController.text,
        email: emailController.text,
        destination: destinationController.text,
        country_code: '1',
        country_code_iso: countryName == "" ? "US" : countryName,
        phone: mobileNumberController.text,
        booking_start: fromDateController.text,
        booking_end: toDateController.text,
      );
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        setBusy(false);
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(
            viewContext, AppRoutes.travellerHomePage, (route) => false);
        GlobalUtility.showToast(viewContext, message);
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

  //gettouristGuide
  void gettouristGuide(viewContext, int pageNo) async {
    if (pageNo <= lastPage) {
      setBusy(true);
      if (await GlobalUtility.isConnected()) {
        Response apiResponse = await _findGuideRequest.guideSortByRating(
            pageNo: pageNo.toString(), number_of_rows: "10");
        debugPrint("FIND GUIDE RESPONSE ==>> ${apiResponse.body}");
        Map jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        if (status == 200) {
          notifyListeners();
          travellerFindGuideResponse =
              travellerFindGuideResponseFromJson(apiResponse.body);
          lastPage = (travellerFindGuideResponse!.data.counts / 10).round();
          lastPage = lastPage + 1;

          if (pageNo == 1) {
            travellerGuideList = [];
            travellerGuideList = travellerFindGuideResponse!.data.details;
          } else {
            travellerGuideList = [
              ...travellerGuideList!,
              ...travellerFindGuideResponse!.data.details
            ];
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(seconds: 1),
                curve: Curves.linear);
          }
        } else if (status == 400) {
          notifyListeners();
          GlobalUtility.showToastShort(viewContext, message);
        } else if (status == 401) {
          notifyListeners();
          GlobalUtility.showToastShort(viewContext, message);
          GlobalUtility().handleSessionExpire(viewContext);
        }
      } else {
        GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
      }
    }
  }

  void isSearch(viewContext, String searchTerm) async {
    setBusy(true);
    isSearchRunnig = true;
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _findGuideRequest.searchGuide(
          destination: searchTerm.toString());
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Map checkData = jsonData['data'];

      if (status == 200 && checkData.isEmpty == false) {
        setBusy(false);
        isSearchRunnig = false;
        isEmptyViewShown = false;
        notifyListeners();
        travellerFindGuideResponse =
            travellerFindGuideResponseFromJson(apiResponse.body);
        travellerGuideList = travellerFindGuideResponse!.data.details;
      } else if (status == 400) {
        setBusy(false);
        isSearchRunnig = false;
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        isSearchRunnig = false;
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      } else if (status == 200 && checkData.isEmpty) {
        setBusy(false);
        travellerGuideList = [];
        isSearchRunnig = false;
        isEmptyViewShown = true;
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
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
