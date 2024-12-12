// ignore_for_file: unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/custom_widgets/custom_textfield.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../view_models/traveller_models/create_traveller_view_model.dart';

class CreateTravellerProfile extends StatefulWidget {
  const CreateTravellerProfile({Key? key}) : super(key: key);

  @override
  State<CreateTravellerProfile> createState() => _CreateTravellerProfileState();
}

class _CreateTravellerProfileState extends State<CreateTravellerProfile> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<CreateTravellerViewModel>.reactive(
        viewModelBuilder: () => CreateTravellerViewModel(),
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColor.whiteColor,

              // body
              body: Padding(
                padding: EdgeInsets.all(
                    screenWidth * AppSizes().widgetSize.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appbarTitleText(),
                        SizedBox(
                            height: screenHeight *
                                AppSizes().widgetSize.smallPadding),
                        normalTitleText(AppStrings().createProfileContent,
                            AppFonts.nunitoRegular)
                      ],
                    ),
                    UiSpacer.verticalSpace(context: context, space: 0.02),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          profilePic(model),
                          UiSpacer.verticalSpace(space: 0.01, context: context),

                          Center(
                              child: normalTitleText(AppStrings().uploadProfile,
                                  AppFonts.nunitoSemiBold)),
                          UiSpacer.verticalSpace(space: 0.04, context: context),

                          // Name field
                          nameField(model),
                          UiSpacer.verticalSpace(
                              space: 0.018, context: context),

                          // Email field
                          emailField(model),
                          UiSpacer.verticalSpace(
                              space: 0.018, context: context),

                          // country field
                          countryCityField(model),
                          UiSpacer.verticalSpace(
                              space: 0.018, context: context),

                          // submit button
                          submitButton(model)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget profilePic(CreateTravellerViewModel model) {
    return Stack(
      children: [
        model.profilePictureLocal != null
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
                        File(model.profilePictureLocal!),
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
                  CommonImageView.chooseImageDialog(
                    context: context,
                    onTapGallery: () async {
                      Navigator.pop(context);
                      final pickedFile =
                          await CommonImageView.pickFromGallery();
                      if (pickedFile != null) {
                        model.profilePictureLocal = pickedFile;
                        model.updateProfileImage(context);
                      }
                    },
                    onTapCamera: () async {
                      Navigator.pop(context);
                      final pickedFile = await CommonImageView.pickFromCamera();
                      if (pickedFile != null) {
                        model.profilePictureLocal = pickedFile;
                        model.updateProfileImage(context);
                      }
                    },
                  );
                },
                child: Image.asset(AppImages().pngImages.icCamera)))
      ],
    );
  }

  Widget nameField(CreateTravellerViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          headingText: "Name",
          textEditingController: model.firstNameTEC,
          hintText: "Enter name",
          readOnly: true,
          isFilled: true,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),
        CustomTextField(
          headingText: "Last Name",
          textEditingController: model.lastNameTEC,
          hintText: "Enter last name",
          readOnly: true,
          isFilled: true,
        ),
      ],
    );
  }

  Widget emailField(CreateTravellerViewModel model) {
    return CustomTextField(
      headingText: "Email",
      hintText: "Enter email",
      textEditingController: model.emailTEC,
      readOnly: true,
      isFilled: true,
    );
  }

  Widget countryCityField(CreateTravellerViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // country
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            normalTitleText("Country", AppFonts.nunitoSemiBold),
            UiSpacer.verticalSpace(space: 0.01, context: context),
            GestureDetector(
              onTap: () {
                model
                    .getLocationApi(
                        viewContext: context, countryId: "", stateId: "")
                    .then((value) {
                  if (value == true) {
                    List<String> tempCountryList = model.countryList;

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (cxt) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
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
                                        onChanged: (value) {
                                          tempCountryList = model.countryList
                                              .where((element) => element
                                                  .toLowerCase()
                                                  .contains(value
                                                      .trim()
                                                      .toLowerCase()))
                                              .toList();
                                          setState(() {});
                                        },
                                        textAlign: TextAlign.start,
                                        decoration: const InputDecoration(
                                            hintText: "Search country...",
                                            counterText: "",
                                            border: InputBorder.none,
                                            prefixIcon: Icon(Icons.search)),
                                      ),
                                    ),
                                    UiSpacer.verticalSpace(
                                        context: context, space: 0.02),
                                    SizedBox(
                                      height: screenHeight * 0.5,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: tempCountryList.length,
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                          onTap: () {
                                            if (model.countryNameController
                                                    .text !=
                                                tempCountryList[index]) {
                                              model.countryNameController.text =
                                                  tempCountryList[index];
                                              model.stateNameController.clear();
                                              model.cityNameController.clear();
                                            } else {
                                              model.countryNameController.text =
                                                  tempCountryList[index];
                                            }
                                            model.notifyListeners();
                                            Navigator.pop(cxt);
                                          },
                                          title: Text(tempCountryList[index]),
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                          },
                        );
                      },
                    );
                  }
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -3),
                  title: Text(model.countryNameController.text == ""
                      ? "Select Country"
                      : model.countryNameController.text),
                  titleTextStyle: TextStyle(
                      color: AppColor.lightBlack,
                      fontFamily: AppFonts.nunitoRegular,
                      fontSize:
                          screenHeight * AppSizes().fontSize.simpleFontSize),
                  trailing: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
              ),
            ),
          ],
        ),
        UiSpacer.verticalSpace(space: 0.02, context: context),

        // state
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            normalTitleText("State", AppFonts.nunitoSemiBold),
            UiSpacer.verticalSpace(space: 0.01, context: context),
            GestureDetector(
              onTap: () {
                if (model.countryNameController.text.isEmpty) {
                  GlobalUtility.showToast(context, "Please Select country");
                } else {
                  model
                      .getLocationApi(
                          viewContext: context,
                          countryId: model.countryNameController.text,
                          stateId: "")
                      .then((value) {
                    if (value == true) {
                      List<String> tempStateList = model.stateList;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,

                        // constraints:
                        //     BoxConstraints(maxHeight: screenHeight * 0.5),
                        builder: (cxt) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // search field
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
                                          onChanged: (value) {
                                            tempStateList = model.stateList
                                                .where((element) => element
                                                    .toLowerCase()
                                                    .contains(value
                                                        .trim()
                                                        .toLowerCase()))
                                                .toList();
                                            setState(() {});
                                          },
                                          decoration: const InputDecoration(
                                              hintText: "Search state...",
                                              counterText: "",
                                              border: InputBorder.none,
                                              prefixIcon: Icon(Icons.search)),
                                        ),
                                      ),
                                      UiSpacer.verticalSpace(
                                          context: context, space: 0.02),

                                      SizedBox(
                                        height: screenHeight * 0.5,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: tempStateList.length,
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            onTap: () {
                                              if (model.stateNameController
                                                      .text !=
                                                  tempStateList[index]) {
                                                model.stateNameController.text =
                                                    tempStateList[index];
                                                model.cityNameController
                                                    .clear();
                                              } else {
                                                model.stateNameController.text =
                                                    tempStateList[index];
                                              }
                                              model.notifyListeners();
                                              Navigator.pop(cxt);
                                            },
                                            title: Text(tempStateList[index]),
                                          ),
                                        ),
                                      )
                                    ],
                                  ));
                            },
                          );
                        },
                      );
                    }
                  });
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -3),
                  title: Text(model.stateNameController.text == ""
                      ? "Select State"
                      : model.stateNameController.text),
                  titleTextStyle: TextStyle(
                      color: AppColor.lightBlack,
                      fontFamily: AppFonts.nunitoRegular,
                      fontSize:
                          screenHeight * AppSizes().fontSize.simpleFontSize),
                  trailing: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
              ),
            ),
          ],
        ),
        UiSpacer.verticalSpace(space: 0.02, context: context),

        // city
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            normalTitleText("City", AppFonts.nunitoSemiBold),
            UiSpacer.verticalSpace(space: 0.01, context: context),
            GestureDetector(
              onTap: () {
                if (model.countryNameController.text.isEmpty) {
                  GlobalUtility.showToast(context, "Please Select country");
                } else if (model.stateNameController.text.isEmpty) {
                  GlobalUtility.showToast(context, "Please Select State");
                } else {
                  model
                      .getLocationApi(
                          viewContext: context,
                          countryId: model.countryNameController.text,
                          stateId: model.stateNameController.text)
                      .then((value) {
                    if (value == true) {
                      List<String> tempCityList = model.cityList;

                      showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        isScrollControlled: true,
                        builder: (cxt) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
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
                                          onChanged: (value) {
                                            tempCityList = model.cityList
                                                .where((element) => element
                                                    .toLowerCase()
                                                    .contains(value
                                                        .trim()
                                                        .toLowerCase()))
                                                .toList();
                                            setState(() {});
                                          },
                                          textAlign: TextAlign.start,
                                          decoration: const InputDecoration(
                                              hintText: "Search city...",
                                              counterText: "",
                                              border: InputBorder.none,
                                              prefixIcon: Icon(Icons.search)),
                                        ),
                                      ),
                                      UiSpacer.verticalSpace(
                                          context: context, space: 0.02),
                                      SizedBox(
                                        height: screenHeight * 0.5,
                                        child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: tempCityList.length,
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            onTap: () {
                                              model.cityNameController.text =
                                                  tempCityList[index];
                                              model.notifyListeners();
                                              Navigator.pop(cxt);
                                            },
                                            title: Text(tempCityList[index]),
                                          ),
                                        ),
                                      )
                                    ],
                                  ));
                            },
                          );
                        },
                      );
                    }
                  });
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -3),

                  // contentPadding: EdgeInsets.zero,
                  title: Text(model.cityNameController.text == ""
                      ? "Select City"
                      : model.cityNameController.text),
                  titleTextStyle: TextStyle(
                      color: AppColor.lightBlack,
                      fontFamily: AppFonts.nunitoRegular,
                      fontSize:
                          screenHeight * AppSizes().fontSize.simpleFontSize),
                  trailing: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget submitButton(CreateTravellerViewModel model) {
    return model.isBusy == false
        ? CommonButton.commonBoldTextButton(
            context: context,
            text: AppStrings().submit,
            onPressed: () {
              if (validate(model)) {
                model.createTravellerProfileAPI(context);
              }
            },
            isButtonEnable: true,
          )
        : CommonButton.commonLoadingButton(context: context);
  }

  bool validate(CreateTravellerViewModel model) {
    String country = model.countryNameController.text.trim();
    String state = model.stateNameController.text.trim();
    String city = model.cityNameController.text.trim();

    if (country.isEmpty) {
      GlobalUtility.showToast(context, AppStrings().countryEnter);
      return false;
    } else if (state.isEmpty) {
      GlobalUtility.showToast(context, AppStrings().stateEnter);
      return false;
    } else if (city.isEmpty) {
      GlobalUtility.showToast(context, AppStrings().cityEnter);
      return false;
    }
    return true;
  }
}
