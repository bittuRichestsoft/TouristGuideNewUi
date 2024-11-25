// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:Siesta/api_requests/ai_request.dart';
import 'package:Siesta/response_pojo/traveller_findeguide_detail_response.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import '../api_requests/traveller_find_guide.dart';
import '../app_constants/app_color.dart';
import '../app_constants/app_fonts.dart';
import '../app_constants/app_sizes.dart';
import '../app_constants/app_strings.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:intl/intl.dart';

import '../response_pojo/county_pojo.dart';

class BookYourTravellerModel extends BaseViewModel implements Initialisable {
  BookYourTravellerModel({GuideDetailData? data}) {
    guideData = data;
  }
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController manualStartTimeController = TextEditingController();
  TextEditingController manualEndTimeController = TextEditingController();
  TextEditingController numberOfPeopleTEC = TextEditingController();
  TextEditingController activitiesTEC = TextEditingController();
  TextEditingController aiDetailsTEC = TextEditingController();

  final FindGuideRequest _findGuideRequest = FindGuideRequest();
  GuideDetailData? guideData;

  BuildContext? viewContext;
  String countryName = "";
  String countryCode = "";
  bool showManualOption = false;
  bool isSubmitButtonEnable = false;
  bool isCreateItineraryEnable = false;
  String? chooseFamilyType;
  List<String> familyTypeList = [
    "Solo",
    "Family",
    "Couple",
  ];

  CscCountry? defaultValue;

  ValueNotifier<bool> aiNotifier = ValueNotifier(false);
  ValueNotifier<bool> destinationNotifier = ValueNotifier(false);

  List<String> countryList = ["Select Country"];
  List<String> stateList = ["Select State"];
  List<String> cityList = ["Select City"];

  @override
  void initialise() async {
    emailController.text = await PreferenceUtil().getEmail();
    firstNameController.text = await PreferenceUtil().getFirstName();
    if (await PreferenceUtil().getLastName() != null &&
        await PreferenceUtil().getLastName() != "null") {
      lastNameController.text = await PreferenceUtil().getLastName();
    }
    mobileNumberController.text = await PreferenceUtil().getphone();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String string = dateFormat.format(DateTime.now());
    fromDateController.text = string;
    toDateController.text = string;

    notifyListeners();

    if (await PreferenceUtil().getcountryCode() != null) {
      countryCode = await PreferenceUtil().getcountryCode();
    }
    countryController.text = guideData!.guideDetails!.country.toString();
    stateController.text = guideData!.guideDetails!.state.toString();
    cityController.text = guideData!.guideDetails!.city.toString();
    for (int i = 0; i < CscCountry.values.length; i++) {
      if (countryController.text.replaceAll(" ", "_").toLowerCase() ==
          CscCountry.values[i].name.toLowerCase()) {
        defaultValue = CscCountry.values[i];
        cityController.text = guideData!.guideDetails!.city.toString();
      }
    }
    debugPrint(
        "Country & State :-- ${countryController.text} --- ${stateController.text}");
    destinationNotifier.value = true;
    destinationNotifier.notifyListeners();
    debugPrint(
        "Country Code:-- ${await PreferenceUtil().getcountryCode()} --- $countryCode");
    countryCode = await PreferenceUtil().getcountryCode();

    notifyListeners();
  }

  Future<int> getDifference(String time1, String time2) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    var date = dateFormat.format(DateTime.now());
    DateTime a = DateTime.parse('$date $time1');
    DateTime b = DateTime.parse('$date $time2');

    debugPrint("${b.difference(a).inHours}");
    debugPrint("${b.difference(a).inMinutes}");

    return b.difference(a).inMinutes;
  }

  checkIfSlotIsValid(slotStartTime, viewContext) async {
    DateTime dt1 = DateTime.parse(fromDateController.text);
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime dt2 = DateTime.parse(formattedDate);
    if (dt1.compareTo(dt2) == 0 || dt1.compareTo(dt2) < 0) {
      String currentTime = DateFormat("HH:mm:ss").format(DateTime.now());
      var checkDif = await getDifference(currentTime, slotStartTime.toString());
      if (checkDif < 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void processBookYourTrip(viewContext, guideId) async {
    setBusy(true);
    notifyListeners();
    GlobalUtility().showLoaderDialog(viewContext);
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _findGuideRequest.bookYourTrip(
          context: viewContext,
          guide_id: guideId,
          first_name: firstNameController.text,
          last_name: lastNameController.text,
          email: emailController.text,
          country: countryController.text,
          state: stateController.text,
          city: cityController.text,
          country_code: countryCode == "" ? "+1" : countryCode,
          country_code_iso: countryName == "" ? "US" : countryName,
          phone: mobileNumberController.text,
          booking_start: fromDateController.text,
          booking_end: toDateController.text,
          booking_slot_start: "",
          booking_slot_end: "",
          activities: activitiesTEC.text,
          familyType: chooseFamilyType!,
          itineraryText: aiDetailsTEC.text);
      Map jsonData = jsonDecode(apiResponse.body);

      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Navigator.pop(viewContext);
      if (status == 200) {
        setBusy(false);
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(
            viewContext, AppRoutes.travellerHomePageTab2, (route) => false);
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

  Future<void> getLocationApi(
      {BuildContext? viewContext, String? countryId, String? stateId}) async {
    setBusy(true);
    notifyListeners();
    GlobalUtility().showLoaderDialog(viewContext!);
    if (await GlobalUtility.isConnected()) {
      Map map = {
        "countryName": countryId ?? "",
        "stateName": stateId ?? "",
      };
      Response apiResponse = await _findGuideRequest.getLocation(map);
      Map jsonData = jsonDecode(apiResponse.body);
      debugPrint("MAP --- $map ----- \n$jsonData");
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Navigator.pop(viewContext);
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

        setBusy(false);
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

  void generateAiDetailsApi(viewContext, guideId) async {
    GlobalUtility().showLoader(viewContext);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await AIRequest().sendAiRequest(
        context: viewContext,
        guideId: guideId,
        firstName: firstNameController.text,
        country: countryController.text,
        state: stateController.text,
        city: cityController.text,
        activities: activitiesTEC.text,
        familyType: chooseFamilyType!,
        bookingEnd: toDateController.text,
        bookingStart: fromDateController.text,
      );
      if (isJSON(apiResponse.body) == false) {
        Navigator.pop(viewContext);
        aiDetailsTEC.text = apiResponse.body;
        const duration = Duration(milliseconds: 15);
        int index = 0;
        String text = '';
        final String fullText = apiResponse.body;
        Timer.periodic(duration, (timer) {
          if (index < fullText.length) {
            text += fullText[index];
            index++;
            aiDetailsTEC.text = text;
            aiNotifier.value = true;
            aiNotifier.notifyListeners();
          } else {
            timer.cancel();
          }
        });
        showDialog(
          barrierDismissible: false,
          useSafeArea: false,
          context: viewContext,
          builder: (BuildContext context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.045,
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.04),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02),
                        color: AppColor.appthemeColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Close",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontFamily: AppFonts.nunitoRegular,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppSizes().fontSize.simpleFontSize),
                            ),
                            Icon(
                              Icons.clear,
                              color: AppColor.whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.04),
                      child: ValueListenableBuilder(
                          valueListenable: aiNotifier,
                          builder: (context, current, child) {
                            return TextFormField(
                              controller: aiDetailsTEC,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              minLines: 1,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              maxLines: null,
                              enabled: true,
                              style: TextStyle(
                                  color: AppColor.lightBlack,
                                  fontFamily: AppFonts.nunitoRegular,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppSizes().fontSize.simpleFontSize),
                            );
                            /*TypeWriterText(
                              alignment: Alignment.topCenter,
                              text: Text(
                                aiDetailsTEC.text,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppColor.lightBlack,
                                    fontFamily: AppFonts.nunitoRegular,
                                    fontSize: MediaQuery.of(context)
                                            .size
                                            .height *
                                        AppSizes()
                                            .fontSize
                                            .simpleFontSize),
                              )
                              duration: const Duration(milliseconds: 8),
                            )*/
                          }),
                    )
                  ],
                ));
          },
        );
      } else {
        Navigator.pop(viewContext);
        Map jsonData = jsonDecode(apiResponse.body);

        if (jsonData.containsKey("statusCode")) {
          if (jsonData["statusCode"] == 401) {
            GlobalUtility().setSessionEmpty(viewContext);
          }
        }
      }
      notifyListeners();
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  bool isJSON(str) {
    try {
      jsonDecode(str);
    } catch (e) {
      return false;
    }
    return true;
  }
}
