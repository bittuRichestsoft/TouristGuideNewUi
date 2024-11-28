// ignore_for_file: unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:Siesta/view_models/create_profile.view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class CreateTravellerProfile extends StatefulWidget {
  const CreateTravellerProfile({Key? key}) : super(key: key);

  @override
  State<CreateTravellerProfile> createState() => _CreateTravellerProfileState();
}

class _CreateTravellerProfileState extends State<CreateTravellerProfile> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isNameFilled = false, isContactFilled = false, isEmailFilled = false;
  final counterNotifier = ValueNotifier<int>(0);
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  setData() async {
    nameController.text = await PreferenceUtil().getFirstName() +
        " " +
        await PreferenceUtil().getLastName();
    emailController.text = await PreferenceUtil().getEmail();
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<CreateProfileViewModel>.reactive(
        viewModelBuilder: () => CreateProfileViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
                toolbarHeight: screenHeight * 0.2,
                centerTitle: false,
                elevation: 0,
                backgroundColor: AppColor.whiteColor,
                leading: const SizedBox(),
                leadingWidth: 0.0,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appbarTitleText(),
                    SizedBox(
                        height:
                            screenHeight * AppSizes().widgetSize.smallPadding),
                    normalTitleText(AppStrings().createProfileContent,
                        AppFonts.nunitoRegular)
                  ],
                )),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(
                  screenWidth * AppSizes().widgetSize.horizontalPadding),
              children: [
                profilePic(model),
                UiSpacer.verticalSpace(space: 0.01, context: context),
                Center(
                    child: normalTitleText(
                        AppStrings().uploadProfile, AppFonts.nunitoSemiBold)),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.horizontalPadding,
                    context: context),
                nameField(model),
                UiSpacer.verticalSpace(space: 0.018, context: context),
                emailField(model),
                /* UiSpacer.verticalSpace(space: 0.018, context: context),
                 contactField(model),*/
                UiSpacer.verticalSpace(space: 0.018, context: context),
                countryField(model),
                UiSpacer.verticalSpace(space: 0.018, context: context),
                submitButton(model)
              ],
            ),
          );
        });
  }

  Widget appbarTitleText() {
    return Text(
      AppStrings().createYourProfile,
      style: TextStyle(
        color: AppColor.appthemeColor,
        fontSize: screenHeight * AppSizes().fontSize.largeTextSize,
        fontFamily: AppFonts.nunitoBold,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget normalTitleText(String text, String fontfamily) {
    return Text(
      text,
      style: TextStyle(
        color: AppColor.lightBlack,
        fontSize: screenHeight * AppSizes().fontSize.simpleFontSize,
        fontFamily: fontfamily,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget profilePic(CreateProfileViewModel model) {
    return Stack(
      children: [
        model.profilePicture != null
            ? Align(
                alignment: Alignment.center,
                child: ClipOval(
                  child: Container(
                      width:
                          screenWidth * AppSizes().widgetSize.profilePicWidth,
                      height:
                          screenWidth * AppSizes().widgetSize.profilePicHeight,
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: Image.file(
                        model.profilePicture!,
                        fit: BoxFit.cover,
                      )),
                ),
              )
            : Align(
                alignment: Alignment.center,
                child: Container(
                  width: screenWidth * AppSizes().widgetSize.profilePicWidth,
                  height: screenWidth * AppSizes().widgetSize.profilePicHeight,
                  decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      border:
                          Border.all(color: AppColor.appthemeColor, width: 2),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              AppImages().pngImages.icProfilePlaceholder))),
                )),
        Positioned(
            top: screenHeight * 0.07,
            left: screenWidth * 0.23,
            right: 0,
            bottom: screenHeight * 0.02,
            child: GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    useSafeArea: false,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(MediaQuery.of(context).size.width *
                            AppSizes().widgetSize.largeBorderRadius),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return showImagePicker(model, "profile");
                    },
                  );
                },
                child: Image.asset(AppImages().pngImages.icCamera)))
      ],
    );
  }

  Widget showImagePicker(CreateProfileViewModel model, String fromWhere) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height *
          AppSizes().widgetSize.horizontalPadding),
      children: [
        Text(
          AppStrings().selectOption,
          style: TextStyle(
              fontFamily: AppFonts.nunitoBold,
              color: AppColor.appthemeColor,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.headingTextSize),
          textAlign: TextAlign.center,
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        Divider(
          color: AppColor.disableColor,
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        Center(
          child: ListTile(
              tileColor: AppColor.buttonDisableColor,
              dense: true,
              minVerticalPadding: 5.0,
              visualDensity: const VisualDensity(vertical: 1, horizontal: 4),
              leading: Image.asset(
                AppImages().pngImages.icGallery,
                width: AppSizes().widgetSize.iconWidth,
                height: AppSizes().widgetSize.iconHeight,
              ),
              title: Text(
                AppStrings().chooseFromGallery,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoSemiBold,
                    color: AppColor.appthemeColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppSizes().fontSize.normalFontSize),
              ),
              onTap: () {
                Navigator.pop(context);
                imageFromGallery(model, fromWhere);
              }),
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        Center(
          child: ListTile(
              tileColor: AppColor.buttonDisableColor,
              dense: true,
              visualDensity: const VisualDensity(vertical: 1, horizontal: 4),
              leading: Icon(
                Icons.photo_camera,
                color: AppColor.appthemeColor,
              ),
              title: Text(
                AppStrings().chooseFromCamera,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoSemiBold,
                    color: AppColor.appthemeColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppSizes().fontSize.normalFontSize),
              ),
              onTap: () {
                Navigator.pop(context);
                imageFromCamera(model, fromWhere);
              }),
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        Center(
          child: ListTile(
              dense: true,
              tileColor: AppColor.buttonDisableColor,
              visualDensity: const VisualDensity(vertical: 1, horizontal: 4),
              leading: Icon(
                Icons.clear,
                color: AppColor.appthemeColor,
              ),
              title: Text(
                AppStrings().cancelText,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoSemiBold,
                    color: AppColor.appthemeColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppSizes().fontSize.normalFontSize),
              ),
              onTap: () {
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }

  /// IMAGE SELECTION WITH CAMERA
  imageFromCamera(CreateProfileViewModel model, String fromWhere) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      if (pickedFile != null) {
        if (fromWhere == "profile") {
          model.profilePicture = File(pickedFile.path);
          model.updateProfileImage(context);
        }
        model.notifyListeners();
      }
    });
  }

  /// IMAGE SELECTION WITH Gallery
  imageFromGallery(CreateProfileViewModel model, String fromWhere) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      if (pickedFile != null) {
        if (fromWhere == "profile") {
          model.profilePicture = File(pickedFile.path);
          model.updateProfileImage(context);
          model.notifyListeners();
        }
      }
    });
  }

  Widget nameField(CreateProfileViewModel model) {
    return TextFormField(
      controller: nameController,
      onChanged: (value) {
        setState(() {
          if (value.replaceAll("  ", "") == "") {
            isNameFilled = false;
          } else {
            isNameFilled = true;
          }
          onTextFieldChange(model);
        });
        model.notifyListeners();
      },
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldFilledDecoration(context,
          AppStrings().enterName, AppImages().svgImages.icName, isNameFilled),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget emailField(CreateProfileViewModel model) {
    return TextFormField(
      controller: emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          if (value.replaceAll(" ", "") == "") {
            isEmailFilled = false;
          } else {
            isEmailFilled = true;
          }
          onTextFieldChange(model);
        });
        model.notifyListeners();
      },
      validator: (value) {
        if (GlobalUtility().validateEmail(value.toString()) == false) {
          model.isCreateButtonEnable = false;
          model.notifyListeners();
          return AppStrings().emailErrorString;
        } else if (value == "" || value == null) {
          model.isCreateButtonEnable = false;
          model.notifyListeners();
          return null;
        }
        return null;
      },
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.textFieldFilledDecoration(
          context,
          AppStrings().enterEmail,
          AppImages().svgImages.icEmail,
          isEmailFilled),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }
/*

  Widget contactField(EditProfileViewModel model) {
    return ValueListenableBuilder(
        valueListenable: counterNotifier,
        builder: (context, current, child) {
          return SizedBox(
            child: TextFormField(
              controller: model.userPhoneController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                RegExp regExp = RegExp(pattern);
                if (value == "" || value == null) {
                  model.isCreateButtonEnable = false;
                  model.notifyListeners();
                  return AppStrings().enterPhoneNumber;
                } else if (value.trim().isEmpty) {
                  model.isCreateButtonEnable = false;
                  model.notifyListeners();
                  return AppStrings().blankSpace;
                } else if (value.toString().length < 10) {
                  model.isCreateButtonEnable = false;
                  model.notifyListeners();
                  return AppStrings().phoneErrorString;
                } else if (!regExp.hasMatch(value)) {
                  model.isCreateButtonEnable = false;
                  model.notifyListeners();
                  return AppStrings().EnterValidMobile;
                }

                return null;
              },
              onChanged: (value) {
                setState(() {
                  if (value.replaceAll(" ", "") == "") {
                    isContactFilled = false;
                  } else {
                    isContactFilled = true;
                  }
                  onTextFieldChange(model);
                });
                model.notifyListeners();
              },
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: AppColor.lightBlack,
                  fontFamily: AppFonts.nunitoRegular,
                  fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
              decoration: InputDecoration(
                hintText: AppStrings().contactNumber,
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
                              textStyle: const TextStyle(
                                  fontSize: 16, color: Colors.blueGrey),
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
                                    color: const Color(0xFF8C98A8)
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                            onSelect: (Country country) {
                              model.countryCode = model.countryCode == ""
                                  ? "+91"
                                  : '+ ${country.phoneCode}';
                              counterNotifier.notifyListeners();
                              debugPrint(
                                  "country.phoneCode --- ${country.phoneCode}-- ${country.countryCode}");
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 8),
                              child: Text(model.countryCode == ""
                                  ? "+91"
                                  : model.countryCode),
                            ),
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
            ),
          );
        });
  }
*/

  Widget countryField(CreateProfileViewModel model) {
    return ValueListenableBuilder(
      valueListenable: model.destinationNotifier,
      builder: (context, value, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                if (model.userCountryController.text !=
                                    model.countryList[index]) {
                                  model.userCountryController.text =
                                      model.countryList[index];
                                  model.userStateController.clear();
                                  model.userCityController.clear();
                                } else {
                                  model.userCountryController.text =
                                      model.countryList[index];
                                }

                                Navigator.pop(cxt);
                              },
                              title: Text(model.countryList[index]),
                            ),
                          )));
                    },
                  ).whenComplete(() {
                    setState(() {
                      onTextFieldChange(model);
                    });
                  });
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(model.userCountryController.text == ""
                      ? "Select Country"
                      : model.userCountryController.text),
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
            GestureDetector(
              onTap: () {
                if (model.userCountryController.text.isEmpty) {
                  GlobalUtility.showToast(context, "Please Select country");
                } else {
                  model
                      .getLocationApi(
                          viewContext: context,
                          countryId: model.userCountryController.text,
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
                                  if (model.userStateController.text !=
                                      model.stateList[index]) {
                                    model.userStateController.text =
                                        model.stateList[index];
                                    model.userCityController.clear();
                                  }
                                  Navigator.pop(cxt);
                                },
                                title: Text(model.stateList[index]),
                              ),
                            )));
                      },
                    ).whenComplete(() {
                      setState(() {
                        onTextFieldChange(model);
                      });
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
                  title: Text(model.userStateController.text == ""
                      ? "Select State"
                      : model.userStateController.text),
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
            GestureDetector(
              onTap: () {
                if (model.userCountryController.text.isEmpty) {
                  GlobalUtility.showToast(context, "Please Select country");
                } else if (model.userStateController.text.isEmpty) {
                  GlobalUtility.showToast(context, "Please Select State");
                } else {
                  model
                      .getLocationApi(
                          viewContext: context,
                          countryId: model.userCountryController.text,
                          stateId: model.userStateController.text)
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
                                  model.userCityController.text =
                                      model.cityList[index];
                                  Navigator.pop(cxt);
                                },
                                title: Text(model.cityList[index]),
                              ),
                            )));
                      },
                    ).whenComplete(() {
                      setState(() {
                        onTextFieldChange(model);
                      });
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
                  title: Text(model.userCityController.text == ""
                      ? "Select City"
                      : model.userCityController.text),
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

  Widget submitButton(CreateProfileViewModel model) {
    return model.isBusy == false
        ? CommonButton.commonBoldTextButton(
            context: context,
            text: AppStrings().submit,
            onPressed: () {
              if (validate(model)) {
                if (model.isCreateButtonEnable) {
                  model.createTravellerProfile(context);
                }
              }
            },
            isButtonEnable: model.isCreateButtonEnable)
        : SizedBox(
            width: screenWidth * 0.1,
            child: Center(
              child: CircularProgressIndicator(color: AppColor.appthemeColor),
            ),
          );
  }

  onTextFieldChange(CreateProfileViewModel model) {
    if (nameController.text.replaceAll(" ", "") != "" &&
            emailController.text.replaceAll(" ", "") != "" &&
            model.userStateController.text.replaceAll(" ", "") != "" &&
            model.userCityController.text.replaceAll(" ", "") !=
                "" /*&&
        model.userPhoneController.text.replaceAll(" ", "") != ""*/
        ) {
      model.isCreateButtonEnable = true;
      model.notifyListeners();
    } else {
      model.isCreateButtonEnable = false;
      model.notifyListeners();
    }
  }

  bool validate(CreateProfileViewModel model) {
    String userName = nameController.text;
    String email = emailController.text;
    // String contact = model.userPhoneController.text;
    String country = model.userCountryController.text;
    String state = model.userStateController.text;
    String city = model.userCityController.text;
    debugPrint("country-- $country -- state$state== city$city");
    if (userName == "") {
      GlobalUtility.showToast(context, AppStrings().enterName);
      return false;
    } else if (email == "") {
      GlobalUtility.showToast(context, AppStrings().enterEmail);
      return false;
    } /*else if (contact == "") {
      GlobalUtility.showToast(context, AppStrings().enterPhoneNumber);
      return false;
    } */
    else if (country == "") {
      GlobalUtility.showToast(context, AppStrings().countryEnter);
      return false;
    } else if (state == "") {
      GlobalUtility.showToast(context, AppStrings().stateEnter);
      return false;
    } else if (city == "") {
      GlobalUtility.showToast(context, AppStrings().cityEnter);
      return false;
    }
    return true;
  }
}
