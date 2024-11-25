// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/response_pojo/getMessageThreadPojo.dart';
import 'package:Siesta/response_pojo/traveller_findeguide_detail_response.dart';
import 'package:Siesta/view_models/bookYourTripTravellerModel.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:typewritertext/typewritertext.dart';

class BookTripPage extends StatefulWidget {
  BookTripPage({Key? key, Object? guideId, Object? guideData})
      : super(key: key) {
    Map map = guideId as Map;
    guide_Id = map["guideId"];
    guideDetails = map["guideData"];
  }

  String? guide_Id;
  GuideDetailData? guideDetails;
  @override
  State<BookTripPage> createState() => _BookTripPageState();
}

class _BookTripPageState extends State<BookTripPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  GetMessagesResponse? getTravellerProfileResponse;
  final counterNotifier = ValueNotifier<int>(0);

  /* @override
  initState() {
    super.initState();
    BookYourTravellerModel()
        .getLocationApi(viewContext: context, countryId: "", stateId: "");
  }*/

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<BookYourTravellerModel>.reactive(
        viewModelBuilder: () =>
            BookYourTravellerModel(data: widget.guideDetails),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          /*model.getLocationApi(
              viewContext: context, countryId: "", stateId: "");*/
          /*model.getLocationApi(
              viewContext: context, countryId: "India", stateId: "");
          model.getLocationApi(
              viewContext: context, countryId: "India", stateId: "Punjab");*/
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: TextView.headingWhiteText(
                  text: AppStrings().booktrip, context: context),
            ),
            body: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(
                  screenWidth * AppSizes().widgetSize.horizontalPadding),
              children: [
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.xsmallPadding,
                    context: context),
                TextView.headingWhiteText(
                    text: "Request info",
                    context: context,
                    textColor: AppColor.blackColor),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.xsmallPadding,
                    context: context),
                TextView.normalText(
                    context: context,
                    text:
                        "Your dreams destination awaits: Secure your adventure today!",
                    textColor: AppColor.dontHaveTextColor,
                    textSize: AppSizes().fontSize.mediumFontSize,
                    fontFamily: AppFonts.nunitoSemiBold),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),
                nameFields(model),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding,
                    context: context),
                TextView.normalText(
                    context: context,
                    text: "Travel Destination",
                    textColor: AppColor.dontHaveTextColor,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    fontFamily: AppFonts.nunitoSemiBold),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding,
                    context: context),

                // country state city view
                destinationFields(model),

                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.mediumPadding,
                    context: context),
                TextView.normalText(
                    context: context,
                    text: "Type",
                    textColor: AppColor.dontHaveTextColor,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    fontFamily: AppFonts.nunitoSemiBold),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding09,
                    context: context),
                familyTypeDropDown(model),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.mediumPadding,
                    context: context),
                TextView.normalText(
                    context: context,
                    text: "Activities",
                    textColor: AppColor.dontHaveTextColor,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    fontFamily: AppFonts.nunitoSemiBold),
                activitiesField(model),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding09,
                    context: context),
                TextView.normalText(
                    context: context,
                    text: AppStrings().selectDate,
                    textColor: AppColor.lightBlack,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    fontFamily: AppFonts.nunitoSemiBold),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),
                dateFields(model),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),
                Visibility(
                  visible: model.showManualOption,
                  child: TextView.normalText(
                      context: context,
                      text: AppStrings().selectTime,
                      textColor: AppColor.lightBlack,
                      textSize: AppSizes().fontSize.normalFontSize,
                      fontFamily: AppFonts.nunitoSemiBold),
                ),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),
                Visibility(
                    visible: model.showManualOption,
                    child: manuallyOptionField(model)),
                model.isBusy == true
                    ? SizedBox(
                        width: screenWidth * 0.1,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColor.appthemeColor),
                        ),
                      )
                    : Column(
                        children: [
                          CommonButton.commonSendButton(
                              onPressed: () {
                                if (validate(model)) {
                                  if (model.isCreateItineraryEnable) {
                                    DateTime dt1 = DateTime.parse(
                                        model.fromDateController.text);
                                    DateTime dt2 = DateTime.parse(
                                        model.toDateController.text);
                                    if (dt1.compareTo(dt2) == 0 ||
                                        dt1.compareTo(dt2) < 0) {
                                      model.generateAiDetailsApi(
                                          context, widget.guide_Id);
                                    } else {
                                      GlobalUtility.showToast(context,
                                          "From Date Should be greater than to date!!");
                                    }
                                  } else {
                                    GlobalUtility.showToast(
                                        context, "Please fill the details.");
                                  }
                                }
                                model.notifyListeners();
                              },
                              text: "Create AI Itinerary",
                              context: context,
                              isButtonEnable: model.isCreateItineraryEnable),
                          model.aiDetailsTEC.text != null &&
                                  model.aiDetailsTEC.text != ""
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: screenHeight * 0.015),
                                  child: CommonButton.commonSendButton(
                                      onPressed: () {
                                        if (validate(model)) {
                                          showAiDialog(model);
                                        }
                                        model.notifyListeners();
                                      },
                                      text: "View Itinerary",
                                      context: context,
                                      isButtonEnable:
                                          model.isSubmitButtonEnable),
                                )
                              : const SizedBox(),
                          UiSpacer.verticalSpace(
                              space: AppSizes().widgetSize.verticalPadding,
                              context: context),
                          CommonButton.commonSendButton(
                              onPressed: () {
                                if (validate(model)) {
                                  if (model.isSubmitButtonEnable) {
                                    DateTime dt1 = DateTime.parse(
                                        model.fromDateController.text);
                                    DateTime dt2 = DateTime.parse(
                                        model.toDateController.text);
                                    debugPrint("ADD Time $dt1 ===== $dt2");
                                    if (dt1.compareTo(dt2) == 0 ||
                                        dt1.compareTo(dt2) < 0) {
                                      model.processBookYourTrip(
                                          context, widget.guide_Id);
                                    } else {
                                      GlobalUtility.showToast(context,
                                          "From Date Should be greater than to date!!");
                                    }
                                  } else {
                                    GlobalUtility.showToast(
                                        context, "Please fill the details.");
                                  }
                                }
                                model.notifyListeners();
                              },
                              text: "       Connect with guide       ",
                              context: context,
                              isButtonEnable: model.isSubmitButtonEnable),
                        ],
                      )
              ],
            ),
          );
        });
  }

  Widget nameFields(model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: screenWidth * 0.43,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView.normalText(
                  context: context,
                  text: "First Name",
                  textColor: AppColor.dontHaveTextColor,
                  textSize: AppSizes().fontSize.simpleFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.mediumPadding, context: context),
              TextFormField(
                controller: model.firstNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == "" || value == null) {
                    model.isSubmitButtonEnable = false;
                    model.isCreateItineraryEnable = false;
                    return AppStrings().enterFirstString;
                  } else if (value.trim().isEmpty) {
                    model.isSubmitButtonEnable = false;
                    model.isCreateItineraryEnable = false;
                    return AppStrings().blankSpace;
                  } else if (value.toString().length < 2) {
                    model.isSubmitButtonEnable = false;
                    model.isCreateItineraryEnable = false;
                    return AppStrings().nameErrorString;
                  }
                  return null;
                },
                onChanged: onTextFieldValueChanged(model),
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoRegular,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
                decoration: TextFieldDecoration.textFieldDecoration(
                    context, 'First name', AppImages().svgImages.icName, ""),
                enableInteractiveSelection: true,
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth * 0.43,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView.normalText(
                  context: context,
                  text: "Last Name",
                  textColor: AppColor.dontHaveTextColor,
                  textSize: AppSizes().fontSize.simpleFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.mediumPadding, context: context),
              TextFormField(
                controller: model.lastNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: onTextFieldValueChanged(model),
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoRegular,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
                decoration: TextFieldDecoration.textFieldDecoration(
                    context, 'Last name', AppImages().svgImages.icName, ""),
                enableInteractiveSelection: true,
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
        ),
      ],
    );
  }

  onTextFieldValueChanged(BookYourTravellerModel model) {
    if (model.firstNameController.text.isNotEmpty &&
        /* model.emailController.text.isNotEmpty &&
        model.mobileNumberController.text.isNotEmpty &&*/
        model.countryController.text.isNotEmpty &&
        model.stateController.text.isNotEmpty &&
        model.cityController.text.isNotEmpty &&
        model.fromDateController.text.isNotEmpty &&
        model.toDateController.text.isNotEmpty &&
        model.chooseFamilyType != null) {
      model.isSubmitButtonEnable = true;
      model.isCreateItineraryEnable = true;
    } else {
      model.isSubmitButtonEnable = false;
      model.isCreateItineraryEnable = false;
    }
  }

  Widget dateFields(BookYourTravellerModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            height: screenHeight * AppSizes().widgetSize.textFieldheight,
            width: screenWidth * 0.42,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectDate(context, model, 1);
              },
              child: TextFormField(
                controller: model.fromDateController,
                enabled: false,
                onChanged: (val) {
                  model.aiDetailsTEC.clear();
                  model.aiNotifier.value = true;
                  model.aiNotifier.notifyListeners();
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) {
                    model.isSubmitButtonEnable = false;
                    model.isCreateItineraryEnable = false;
                    model.notifyListeners();
                    return 'Please enter from date';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoRegular,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
                decoration: TextFieldDecoration.textFieldDecorationWithSuffix(
                    context, 'From', AppImages().svgImages.icCalendar),
                enableInteractiveSelection: true,
                textInputAction: TextInputAction.next,
              ),
            )),
        SizedBox(
            height: screenHeight * AppSizes().widgetSize.textFieldheight,
            width: screenWidth * 0.43,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectDate(context, model, 2);
              },
              child: TextFormField(
                controller: model.toDateController,
                enabled: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (val) {
                  model.aiDetailsTEC.clear();
                  model.aiNotifier.value = true;
                  model.aiNotifier.notifyListeners();
                },
                validator: (value) {
                  if (value == null) {
                    model.isSubmitButtonEnable = false;
                    model.isCreateItineraryEnable = false;
                    model.notifyListeners();
                    return 'Please enter to date';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoRegular,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
                decoration: TextFieldDecoration.textFieldDecorationWithSuffix(
                    context, 'To', AppImages().svgImages.icCalendar),
                enableInteractiveSelection: true,
                textInputAction: TextInputAction.next,
              ),
            )),
      ],
    );
  }

  destinationFields(BookYourTravellerModel model) {
    return ValueListenableBuilder(
      valueListenable: model.destinationNotifier,
      builder: (context, value, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Country",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: AppColor.dontHaveTextColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
            ),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.smallPadding, context: context),
            GestureDetector(
              onTap: () {
                model
                    .getLocationApi(
                        viewContext: context, countryId: "", stateId: "")
                    .then((value) {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    builder: (cxt) {
                      return Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.03),
                          child: Scaffold(
                              /*   appBar: AppBar(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                automaticallyImplyLeading: false,
                                title: Column(
                                  children: [
                                    Container(
                                      height: screenHeight * 0.06,
                                      width: screenWidth,
                                      alignment: Alignment.bottomLeft,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColor.disableColor)),
                                      child: TextFormField(
                                        maxLines: 1,
                                        maxLength: 60,
                                        onChanged: (value) {},
                                        textAlign: TextAlign.start,
                                        decoration: const InputDecoration(
                                            hintText: "Search country...",
                                            counterText: "",
                                            border: InputBorder.none,
                                            prefixIcon: Icon(Icons.search)),
                                      ),
                                    )
                                  ],
                                ),
                              ),*/
                              body: ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.countryList.length,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () {
                                if (model.countryController.text !=
                                    model.countryList[index]) {
                                  model.countryController.text =
                                      model.countryList[index];
                                  model.stateController.clear();
                                  model.cityController.clear();
                                } else {
                                  model.countryController.text =
                                      model.countryList[index];
                                }

                                Navigator.pop(cxt);
                              },
                              title: Text(model.countryList[index]),
                            ),
                          )));
                    },
                  ).whenComplete(() {
                    setState(() {});
                  });
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(model.countryController.text == ""
                      ? "Select Country"
                      : model.countryController.text),
                  titleTextStyle: TextStyle(
                      color: AppColor.lightBlack,
                      fontFamily: AppFonts.nunitoRegular,
                      fontSize:
                          screenHeight * AppSizes().fontSize.simpleFontSize),
                  trailing: const Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.smallPadding, context: context),
            Text(
              "State",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: AppColor.dontHaveTextColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
            ),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.smallPadding, context: context),
            GestureDetector(
              onTap: () {
                if (model.countryController.text.isEmpty) {
                  GlobalUtility.showToast(context, "Please Select country");
                } else {
                  model
                      .getLocationApi(
                          viewContext: context,
                          countryId: model.countryController.text,
                          stateId: "")
                      .then((value) {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      builder: (cxt) {
                        return Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.03),
                            child: Scaffold(
                                /* appBar: AppBar(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  automaticallyImplyLeading: false,
                                  title: Column(
                                    children: [
                                      Container(
                                        height: screenHeight * 0.06,
                                        width: screenWidth,
                                        alignment: Alignment.bottomLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColor.disableColor)),
                                        child: TextFormField(
                                          maxLines: 1,
                                          maxLength: 60,
                                          textAlign: TextAlign.start,
                                          decoration: const InputDecoration(
                                              hintText: "Search state...",
                                              counterText: "",
                                              border: InputBorder.none,
                                              prefixIcon: Icon(Icons.search)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),*/
                                body: ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.stateList.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {
                                  if (model.stateController.text !=
                                      model.stateList[index]) {
                                    model.stateController.text =
                                        model.stateList[index];
                                    model.cityController.clear();
                                  }
                                  Navigator.pop(cxt);
                                },
                                title: Text(model.stateList[index]),
                              ),
                            )));
                      },
                    ).whenComplete(() {
                      setState(() {});
                    });
                  });
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(model.stateController.text == ""
                      ? "Select State"
                      : model.stateController.text),
                  titleTextStyle: TextStyle(
                      color: AppColor.lightBlack,
                      fontFamily: AppFonts.nunitoRegular,
                      fontSize:
                          screenHeight * AppSizes().fontSize.simpleFontSize),
                  trailing: const Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.smallPadding, context: context),
            Text(
              "City",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: AppColor.dontHaveTextColor,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
            ),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.smallPadding, context: context),
            GestureDetector(
              onTap: () {
                if (model.countryController.text.isEmpty) {
                  GlobalUtility.showToast(context, "Please Select country");
                } else if (model.stateController.text.isEmpty) {
                  GlobalUtility.showToast(context, "Please Select State");
                } else {
                  model
                      .getLocationApi(
                          viewContext: context,
                          countryId: model.countryController.text,
                          stateId: model.stateController.text)
                      .then((value) {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      context: context,
                      enableDrag: true,
                      builder: (cxt) {
                        return Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.03),
                            child: Scaffold(
                                /*     appBar: AppBar(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  automaticallyImplyLeading: false,
                                  title: Column(
                                    children: [
                                      Container(
                                        height: screenHeight * 0.06,
                                        width: screenWidth,
                                        alignment: Alignment.bottomLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColor.disableColor)),
                                        child: TextFormField(
                                          maxLines: 1,
                                          maxLength: 60,
                                          textAlign: TextAlign.start,
                                          decoration: const InputDecoration(
                                              hintText: "Search city...",
                                              counterText: "",
                                              border: InputBorder.none,
                                              prefixIcon: Icon(Icons.search)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),*/
                                body: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: model.cityList.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {
                                  model.cityController.text =
                                      model.cityList[index];
                                  Navigator.pop(cxt);
                                },
                                title: Text(model.cityList[index]),
                              ),
                            )));
                      },
                    ).whenComplete(() {
                      setState(() {});
                    });
                  });
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  // contentPadding: EdgeInsets.zero,
                  title: Text(model.cityController.text == ""
                      ? "Select City"
                      : model.cityController.text),
                  titleTextStyle: TextStyle(
                      color: AppColor.lightBlack,
                      fontFamily: AppFonts.nunitoRegular,
                      fontSize:
                          screenHeight * AppSizes().fontSize.simpleFontSize),
                  trailing: const Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // copy of destination field view

  /*destinationFields(BookYourTravellerModel model) {
    return ValueListenableBuilder(
      valueListenable: model.destinationNotifier,
      builder: (context, value, child) {
        return CountryStateCityPicker(
            country: model.countryController,
            state: model.stateController,
            city: model.cityController,
            dialogColor: Colors.grey.shade200,
            textFieldDecoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColor.disableColor)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColor.disableColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColor.disableColor)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColor.disableColor))));
      },
    );
  }*/

  aiDetailsField(BookYourTravellerModel model) {
    return Container(
      height: screenHeight * 0.2,
      width: screenWidth,
      margin: EdgeInsets.only(top: screenHeight * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.buttonDisableColor)),
      child: Scrollbar(
          thickness: 5,
          interactive: false,
          trackVisibility: true,
          thumbVisibility: true,
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) => ValueListenableBuilder(
                  valueListenable: model.aiNotifier,
                  builder: (context, current, child) {
                    return TypeWriterText(
                      alignment: Alignment.topCenter,
                      text: Text(
                        model.aiDetailsTEC.text,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppColor.lightBlack,
                            fontFamily: AppFonts.nunitoRegular,
                            fontSize: screenHeight *
                                AppSizes().fontSize.simpleFontSize),
                      ),
                      duration: const Duration(milliseconds: 8),
                    );
                  }))),
    );
  }

  showAiDialog(BookYourTravellerModel model) {
    return showDialog(
      barrierDismissible: false,
      useSafeArea: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.045,
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.all(screenWidth * 0.04),
                    padding: EdgeInsets.all(screenWidth * 0.02),
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
                              fontSize: screenHeight *
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
                SizedBox(
                  height: screenHeight * 0.7,
                  child: Scrollbar(
                      thickness: 5,
                      interactive: false,
                      trackVisibility: true,
                      thumbVisibility: true,
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          ValueListenableBuilder(
                              valueListenable: model.aiNotifier,
                              builder: (context, current, child) {
                                return Text(
                                  model.aiDetailsTEC.text,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppColor.lightBlack,
                                      fontFamily: AppFonts.nunitoRegular,
                                      fontSize: screenHeight *
                                          AppSizes().fontSize.simpleFontSize),
                                );
                              })
                        ],
                      )),
                )
              ],
            ));
      },
    );
  }

  Widget emailField(model) {
    return TextFormField(
      controller: model.emailController,
      validator: (value) {
        if (value == "" || value == null) {
          model.isSubmitButtonEnable = false;
          model.isCreateItineraryEnable = false;
          model.notifyListeners();
          return AppStrings().enterEmail;
        } else if (GlobalUtility().validateEmail(value.toString()) == false) {
          model.isSubmitButtonEnable = false;
          model.isCreateItineraryEnable = false;
          model.notifyListeners();
          return AppStrings().emailErrorString;
        }
        return null;
      },
      onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldDecoration(
          context, AppStrings().enterEmail, AppImages().svgImages.icEmail, ""),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget phoneNumberField(model, String countryCode) {
    return TextFormField(
      controller: model.mobileNumberController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == "" || value == null) {
          model.isSubmitButtonEnable = false;
          model.isCreateItineraryEnable = false;
          model.notifyListeners();
          return AppStrings().enterPhoneNumber;
        } else if (value.trim().isEmpty) {
          model.isSubmitButtonEnable = false;
          model.isCreateItineraryEnable = false;
          model.notifyListeners();
          return AppStrings().blankSpace;
        } else if (value.toString().length < 10) {
          model.isSubmitButtonEnable = false;
          model.isCreateItineraryEnable = false;
          model.notifyListeners();
          return AppStrings().phoneErrorString;
        } else if (GlobalUtility().validateContact(value)) {
          model.isSubmitButtonEnable = false;
          model.isCreateItineraryEnable = false;
          model.notifyListeners();
          return AppStrings().EnterValidMobile;
        }

        return null;
      },
      onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: InputDecoration(
        hintText: "Contact Number",
        prefixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    countryListTheme: CountryListThemeData(
                      flagSize: 25,
                      backgroundColor: Colors.white,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.blueGrey),
                      bottomSheetHeight: 500,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      inputDecoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Start typing to search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    onSelect: (Country country) {
                      setState(() {
                        model.countryCode = model.countryCode == ""
                            ? "+1"
                            : '+ ${country.phoneCode}';
                        model.notifyListeners();
                      });
                    },
                  );
                },
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 15, right: 8),
                        child:
                            // Text(countryCode == "" ? "+91" : countryCode),
                            Text(countryCode)),
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                            AppImages().svgImages.chevronDown)),
                  ],
                ),
              ),
            ]),
        hintStyle: TextStyle(
            color: AppColor.hintTextColor,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: MediaQuery.of(context).size.height *
                AppSizes().fontSize.simpleFontSize),
        contentPadding: const EdgeInsets.only(top: 20, bottom: 2),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldEnableColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
        ),
      ),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
    );
    // });
  }

  Widget locationField(model) {
    return SizedBox(
      child: TextFormField(
        controller: model.destinationController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == "" || value == null) {
            model.isSubmitButtonEnable = false;
            model.isCreateItineraryEnable = false;
            model.notifyListeners();
            return AppStrings().enterLocation;
          } else if (value.trim().isEmpty) {
            model.isSubmitButtonEnable = false;
            model.isCreateItineraryEnable = false;
            model.notifyListeners();
            return AppStrings().blankSpace;
          }
          return null;
        },
        onChanged: onTextFieldValueChanged(model),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.textFieldDecoration(context,
            AppStrings().enterLocation, AppImages().svgImages.icLocation, ""),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget numberOfPeopleFields(BookYourTravellerModel model) {
    return SizedBox(
      width: screenWidth,
      child: TextFormField(
        controller: model.numberOfPeopleTEC,
        maxLines: 1,
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == "" || value == null) {
            model.isSubmitButtonEnable = false;
            model.isCreateItineraryEnable = false;
            model.notifyListeners();
            return "Please enter number of people";
          } else if (value.trim().isEmpty) {
            model.isSubmitButtonEnable = false;
            model.isCreateItineraryEnable = false;
            model.notifyListeners();
            return AppStrings().blankSpace;
          }
          return null;
        },
        onChanged: onTextFieldValueChanged(model),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          hintText: 'Number of people',
          prefixIcon: IconButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.people_outline,
                color: AppColor.textColorLightBlack,
              ),
            ),
          ),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.simpleFontSize),
          errorStyle: TextStyle(
              color: AppColor.textbuttonColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.mediumFontSize),
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 0,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldEnableColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
        ),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  familyTypeDropDown(BookYourTravellerModel model) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.065,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.fieldBorderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        value: model.chooseFamilyType,
        isExpanded: true,
        underline: const SizedBox(),
        iconEnabledColor: Colors.black,
        items: model.familyTypeList.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        hint: const Text(
          "Select Type",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        onChanged: (String? value) {
          model.aiDetailsTEC.clear();
          model.aiNotifier.value = true;
          model.aiNotifier.notifyListeners();
          model.chooseFamilyType = value.toString();
          setState(() {});
        },
      ),
    );
  }

  Widget activitiesField(BookYourTravellerModel model) {
    return SizedBox(
      child: TextFormField(
        controller: model.activitiesTEC,
        validator: (value) {
          if (value == "" || value == null) {
            model.isSubmitButtonEnable = false;
            model.isCreateItineraryEnable = false;
            model.notifyListeners();
            return "Please enter your activities";
          } else if (value.trim().isEmpty) {
            model.isSubmitButtonEnable = false;
            model.isCreateItineraryEnable = false;
            model.notifyListeners();
            return AppStrings().blankSpace;
          }
          return null;
        },
        onChanged: onTextFieldValueChanged(model),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          hintText: "e.g. Hiking, Sleeping ...",
          prefixIcon: IconButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.emoji_people_outlined,
                color: AppColor.textColorLightBlack,
              ),
            ),
          ),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.simpleFontSize),
          errorStyle: TextStyle(
              color: AppColor.textbuttonColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.mediumFontSize),
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 0,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldEnableColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget manuallyOptionField(model) {
    return SizedBox(
        width: screenWidth,
        height: screenHeight * AppSizes().widgetSize.textFieldheight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.4,
              height: screenHeight * AppSizes().widgetSize.textFieldheight,
              child: TextFormField(
                controller: model.manualStartTimeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == "" || value == null) {
                    model.isSubmitButtonEnable = true;
                    model.isCreateItineraryEnable = true;
                    return AppStrings().enterLocation;
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 10, minute: 00),
                    initialEntryMode: TimePickerEntryMode.dial,
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child ?? Container(),
                      );
                    },
                  );
                  final localizations = MaterialLocalizations.of(context);
                  final formattedTimeOfDay =
                      localizations.formatTimeOfDay(newTime!);
                  model.manualStartTimeController.text = formattedTimeOfDay;
                  model.notifyListeners();
                },
                onChanged: onTextFieldValueChanged(model),
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoRegular,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
                decoration: TextFieldDecoration.textFieldDecorationWithSuffix(
                    context,
                    AppStrings().startTime,
                    AppImages().svgImages.icClock),
                enableInteractiveSelection: true,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.4,
              height: screenHeight * AppSizes().widgetSize.textFieldheight,
              child: TextFormField(
                onChanged: onTextFieldValueChanged(model),
                controller: model.manualEndTimeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == "" || value == null) {
                    model.isSubmitButtonEnable = true;
                    model.isCreateItineraryEnable = true;
                    return AppStrings().enterLocation;
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 12, minute: 00),
                    initialEntryMode: TimePickerEntryMode.dial,
                  );
                  final localizations = MaterialLocalizations.of(context);
                  final formattedTimeOfDay =
                      localizations.formatTimeOfDay(newTime!);

                  model.manualEndTimeController.text = formattedTimeOfDay;
                  model.notifyListeners();
                },
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoRegular,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
                decoration: TextFieldDecoration.textFieldDecorationWithSuffix(
                    context,
                    AppStrings().endTime,
                    AppImages().svgImages.icClock),
                enableInteractiveSelection: true,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ));
  }

  _selectDate(BuildContext context, model, typeDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      // 1 == from date
      // 2 == to date
      if (typeDate == 1) {
        debugPrint(formattedDate);
        model.fromDateController.text = formattedDate;
        model.notifyListeners();
      } else {
        model.toDateController.text = formattedDate;
        model.notifyListeners();
      }
      model.aiDetailsTEC.clear();
      model.aiNotifier.value = true;
      model.aiNotifier.notifyListeners();
    }
  }

  bool validate(BookYourTravellerModel model) {
    String firstName = model.firstNameController.text;
    String lastName = model.lastNameController.text;
    String email = model.emailController.text;
    String mobileNumber = model.mobileNumberController.text;
    String country = model.countryController.text;
    String state = model.stateController.text;
    String city = model.cityController.text;
    String fromDate = model.fromDateController.text;
    String toDate = model.toDateController.text;
    String numberOfPeople = model.chooseFamilyType != null
        ? model.chooseFamilyType!
        : model.familyTypeList[0];
    // String activities = model.activitiesTEC.text;

    if (firstName.replaceAll("", "") == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterFirstName);
      return false;
    } else if (lastName.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, AppStrings().enterlastName);
      return false;
    } else if (email.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, AppStrings().enterEmailName);
      return false;
    } else if (mobileNumber.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, AppStrings().enterMobileNumber);
      return false;
    } else if (country.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, AppStrings().enterDestination);
      return false;
    } else if (state.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, AppStrings().enterDestination);
      return false;
    } else if (city.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, AppStrings().enterDestination);
      return false;
    } else if (fromDate.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, AppStrings().enterFromDate);
      return false;
    } else if (toDate.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, AppStrings().enterToDate);
      return false;
    } else if (numberOfPeople.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, "Choose family type");
      return false;
    } /*else if (activities.replaceAll("", "") == "") {
      GlobalUtility.showToast(context, "Enter activities");
      return false;
    }*/

    return true;
  }
}
