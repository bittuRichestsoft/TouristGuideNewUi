// ignore_for_file: prefer_is_empty, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unnecessary_null_comparison

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
import 'package:Siesta/view_models/create_profile.view_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

import '../../../custom_widgets/common_widgets.dart';

// FOR LOCALITE(GUIDE) create profile
class CreateTouristProfileScreen extends StatefulWidget {
  const CreateTouristProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateTouristProfileScreen> createState() =>
      _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateTouristProfileScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isNameFilled = false,
      isCountryFilled = false,
      isContactFilled = false,
      isEmailFilled = false;

  final counterNotifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<CreateProfileViewModel>.reactive(
        viewModelBuilder: () => CreateProfileViewModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: model.hasError
                ? CommonWidgets().inAppErrorWidget(model.modelError.toString(),
                    () {
                    model.initialise();
                  }, context: context)
                : model.initialised == false
                    ? CommonWidgets().inPageLoader()
                    : ListView(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                AppSizes().widgetSize.horizontalPadding),
                        children: [
                          UiSpacer.verticalSpace(space: 0.06, context: context),
                          firstTextView(),
                          enrollmentAndNote(model),
                          UiSpacer.verticalSpace(
                              space: 0.015, context: context),
                          profilePic(model),
                          UiSpacer.verticalSpace(space: 0.01, context: context),
                          Center(
                              child: normalTitleText(
                                  "${AppStrings().uploadProfile}  ",
                                  AppFonts.nunitoSemiBold)),
                          UiSpacer.verticalSpace(space: 0.03, context: context),
                          detailFields(model),
                          UiSpacer.verticalSpace(space: 0.04, context: context),
                          buttonContainer(model),
                        ],
                      ),
          );
        });
  }

  Widget normalTitleText(String text, String fontFamily) {
    return Text(
      text,
      style: TextStyle(
        color: AppColor.lightBlack,
        fontSize: screenHeight * AppSizes().fontSize.simpleFontSize,
        fontFamily: fontFamily,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget firstTextView() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        AppStrings().createYourProfile,
        style: TextStyle(
            fontSize: screenHeight * AppSizes().fontSize.largeTextSize,
            fontFamily: AppFonts.nunitoBold,
            color: AppColor.appthemeColor),
        textAlign: TextAlign.start,
      ),
      subtitle: Text(
        AppStrings().createProfileContent,
        style: TextStyle(
            fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize,
            fontFamily: AppFonts.nunitoLight,
            color: AppColor.lightBlack),
        textAlign: TextAlign.start,
      ),
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
                child: Image.asset(AppImages().pngImages.icCamera))),
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
        } else if (fromWhere == "idProof") {
          model.idProofFile.add(File(pickedFile.path));
        }
        debugPrint("Id Proof list camera-- ${model.idProofFile.length}");
        onCreateProfileValueChanged(model);
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
        } else if (fromWhere == "idProof") {
          model.idProofFile.add(File(pickedFile.path));
        }
        onCreateProfileValueChanged(model);
      }
    });
  }

  /// FIELDS
  Widget detailFields(CreateProfileViewModel model) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        /* contactField(model),
        UiSpacer.verticalSpace(space: 0.011, context: context),*/
        // Host since view
        hostSinceView(model),
        UiSpacer.verticalSpace(space: 0.02, context: context),

        pronounView(model),
        UiSpacer.verticalSpace(space: 0.02, context: context),

        // Bio
        describeYourself(model),
        UiSpacer.verticalSpace(space: 0.02, context: context),

        // Email
        emailView(model),
        UiSpacer.verticalSpace(space: 0.02, context: context),

        // Contact number
        contactNumberView(model),
        UiSpacer.verticalSpace(space: 0.02, context: context),

        // Activities
        activitiesView(model),
        UiSpacer.verticalSpace(space: 0.02, context: context),

        countryCityField(model),
        UiSpacer.verticalSpace(space: 0.02, context: context),

        // zipcode
        pinCode(model),
        // Text(
        //   "(Siesta will deduct ${model.adminCommission}% commission)",
        //   style: TextStyle(
        //       color: AppColor.dontHaveTextColor,
        //       fontFamily: AppFonts.nunitoRegular,
        //       fontSize: screenHeight * AppSizes().fontSize.mediumFontSize),
        // ),
        // enterPrice(model),
      ],
    );
  }

  /// Contact number
/*  Widget contactField(EditProfileViewModel model) {
    return ValueListenableBuilder(
        valueListenable: counterNotifier,
        builder: (context, current, child) {
          return SizedBox(
            child: TextFormField(
              controller: model.phoneNumController,
              onChanged: (value) {
                onCreateProfileValueChanged(model);
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
                              debugPrint(
                                  "country code value:--- ${country.phoneCode}");
                              model.countryCode = model.countryCode == ""
                                  ? "+91"
                                  : '+ ${country.phoneCode}';
                              counterNotifier.notifyListeners();
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
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == "" || value == null) {
                  model.isSubmitProfileButtonEnable = false;
                  model.notifyListeners();
                  return AppStrings().enterPhoneNumber;
                } else if (value.trim().isEmpty) {
                  model.isSubmitProfileButtonEnable = false;
                  model.notifyListeners();
                  return AppStrings().blankSpace;
                } else if (value.toString().length < 10) {
                  model.isSubmitProfileButtonEnable = false;
                  model.notifyListeners();
                  return AppStrings().phoneErrorString;
                } else if (GlobalUtility().validateContact(value)) {
                  model.isSubmitProfileButtonEnable = false;
                  model.notifyListeners();
                  return AppStrings().EnterValidMobile;
                }

                return null;
              },
            ),
          );
        });
  }*/

  Widget emailView(CreateProfileViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        normalTitleText("Email", AppFonts.nunitoSemiBold),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        SizedBox(
          height: screenHeight * 0.06,
          child: TextFormField(
            readOnly: true,
            controller: model.emailController,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            decoration: InputDecoration(
              hintText: "Email",
              filled: true,
              hintStyle: TextStyle(
                  color: AppColor.hintTextColor,
                  fontFamily: AppFonts.nunitoRegular,
                  fontSize: MediaQuery.of(context).size.height *
                      AppSizes().fontSize.simpleFontSize),
              contentPadding:
                  const EdgeInsets.only(top: 10, bottom: 0, left: 13),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.fieldBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.fieldBorderColor),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.fieldBorderColor),
              ),
            ),
            enableInteractiveSelection: false,
            autofillHints: const [AutofillHints.email],
          ),
        )
      ],
    );
  }

  Widget contactNumberView(CreateProfileViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        normalTitleText("Contact Number", AppFonts.nunitoSemiBold),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        SizedBox(
          height: screenHeight * 0.06,
          child: TextFormField(
            readOnly: true,
            controller: model.phoneNumController,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            decoration: InputDecoration(
              hintText: "Contact Number",
              filled: true,
              hintStyle: TextStyle(
                  color: AppColor.hintTextColor,
                  fontFamily: AppFonts.nunitoRegular,
                  fontSize: MediaQuery.of(context).size.height *
                      AppSizes().fontSize.simpleFontSize),
              contentPadding:
                  const EdgeInsets.only(top: 10, bottom: 0, left: 13),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.fieldBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.fieldBorderColor),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.fieldBorderColor),
              ),
            ),
            enableInteractiveSelection: false,
            autofillHints: const [AutofillHints.email],
          ),
        )
      ],
    );
  }

  Widget countryCityField(CreateProfileViewModel model) {
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
                            builder: (context, setModelState) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
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
                                                .contains(
                                                    value.trim().toLowerCase()))
                                            .toList();
                                        setModelState(() {});
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
                                    height: screenHeight * 0.4,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: tempCountryList.length,
                                      itemBuilder: (context, index) => ListTile(
                                        onTap: () {
                                          if (model
                                                  .countryNameController.text !=
                                              tempCountryList[index]) {
                                            model.countryNameController.text =
                                                tempCountryList[index];
                                            model.stateNameController.clear();
                                            model.cityNameController.clear();
                                          } else {
                                            model.countryNameController.text =
                                                tempCountryList[index];
                                          }

                                          Navigator.pop(cxt);
                                        },
                                        title: Text(tempCountryList[index]),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                        });
                      },
                    ).whenComplete(() {
                      onCreateProfileValueChanged(model);
                      setState(() {});
                    });
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
                        //     BoxConstraints(maxHeight: screenHeight * 0.4),
                        builder: (cxt) {
                          return StatefulBuilder(
                              builder: (context, setModelState) {
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
                                          setModelState(() {});
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
                                      height: screenHeight * 0.4,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: tempStateList.length,
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                          onTap: () {
                                            if (model
                                                    .stateNameController.text !=
                                                tempStateList[index]) {
                                              model.stateNameController.text =
                                                  tempStateList[index];
                                              model.cityNameController.clear();
                                            }
                                            Navigator.pop(cxt);
                                          },
                                          title: Text(tempStateList[index]),
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                          });
                        },
                      ).whenComplete(() {
                        onCreateProfileValueChanged(model);
                        setState(() {});
                      });
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
                              builder: (context, setModelState) {
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
                                          setModelState(() {});
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
                                      height: screenHeight * 0.4,
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
                                            Navigator.pop(cxt);
                                          },
                                          title: Text(tempCityList[index]),
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                          });
                        },
                      ).whenComplete(() {
                        onCreateProfileValueChanged(model);
                        setState(() {});
                      });
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

  /// HOST SINCE
  Widget hostSinceView(CreateProfileViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Host since text
        normalTitleText("Host since", AppFonts.nunitoSemiBold),
        UiSpacer.verticalSpace(space: 0.01, context: context),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller:
                    TextEditingController(text: model.yearValue.toString()),
                onChanged: (value) {},
                readOnly: true,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoRegular,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
                decoration: InputDecoration(
                  hintText: "0",
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Years",
                        style: TextStyle(
                          color: AppColor.hintTextColor,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            model.decreaseHostValue("year");
                          },
                          child: SizedBox(
                            height: screenHeight * 0.04,
                            width: screenHeight * 0.04,
                            child: Icon(
                              Icons.remove,
                              color: AppColor.hintTextColor,
                              size: 15,
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            model.increaseHostValue("year");
                          },
                          child: SizedBox(
                            height: screenHeight * 0.04,
                            width: screenHeight * 0.04,
                            child: Icon(
                              Icons.add,
                              color: AppColor.hintTextColor,
                              size: 15,
                            ),
                          )),
                    ],
                  ),
                  hintStyle: TextStyle(
                      color: AppColor.hintTextColor,
                      fontFamily: AppFonts.nunitoRegular,
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.simpleFontSize),
                  contentPadding:
                      const EdgeInsets.only(top: 10, bottom: 0, left: 13),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.fieldBorderColor),
                      borderRadius: BorderRadius.all(Radius.circular(
                          MediaQuery.of(context).size.width *
                              AppSizes().widgetSize.smallBorderRadius))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.fieldBorderColor),
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
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  return null;
                },
              ),
            ),
            UiSpacer.horizontalSpace(space: 0.04, context: context),
            Expanded(
              child: TextFormField(
                controller:
                    TextEditingController(text: model.monthValue.toString()),
                onChanged: (value) {},
                readOnly: true,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoRegular,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
                decoration: InputDecoration(
                  hintText: "0",
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Months",
                        style: TextStyle(
                          color: AppColor.hintTextColor,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            model.decreaseHostValue("month");
                          },
                          child: SizedBox(
                            height: screenHeight * 0.04,
                            width: screenHeight * 0.04,
                            child: Icon(
                              Icons.remove,
                              color: AppColor.hintTextColor,
                              size: 15,
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            model.increaseHostValue("month");
                          },
                          child: SizedBox(
                            height: screenHeight * 0.04,
                            width: screenHeight * 0.04,
                            child: Icon(
                              Icons.add,
                              color: AppColor.hintTextColor,
                              size: 15,
                            ),
                          )),
                    ],
                  ),
                  hintStyle: TextStyle(
                      color: AppColor.hintTextColor,
                      fontFamily: AppFonts.nunitoRegular,
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.simpleFontSize),
                  contentPadding:
                      const EdgeInsets.only(top: 10, bottom: 0, left: 13),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.fieldBorderColor),
                      borderRadius: BorderRadius.all(Radius.circular(
                          MediaQuery.of(context).size.width *
                              AppSizes().widgetSize.smallBorderRadius))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.fieldBorderColor),
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
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  return null;
                },
              ),
            )
          ],
        ),
        // Year text field

        // month text field
      ],
    );
  }

  /// PRONOUNS
  Widget pronounView(CreateProfileViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        normalTitleText("Pronouns(optional)", AppFonts.nunitoSemiBold),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              "Select",
              style: TextStyle(
                  color: AppColor.hintTextColor,
                  fontFamily: AppFonts.nunitoRegular,
                  fontSize: MediaQuery.of(context).size.height *
                      AppSizes().fontSize.simpleFontSize),
            ),
            value: model.selectedPronounValue,
            onChanged: (value) {
              model.selectedPronounValue = value;
              model.notifyListeners();
            },
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            iconStyleData: IconStyleData(
              icon: Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.04),
                child: Icon(Icons.keyboard_arrow_down_outlined),
              ),
            ),
            items: [
              DropdownMenuItem(
                child: Text(model.pronounsList[0]),
                value: model.pronounsList[0],
              ),
              DropdownMenuItem(
                child: Text(model.pronounsList[1]),
                value: model.pronounsList[1],
              ),
            ],
            buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.fieldBorderColor),
            )),
          ),
        ),
      ],
    );
  }

  /// ACTIVITIES
  Widget activitiesView(CreateProfileViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        normalTitleText("Activities", AppFonts.nunitoSemiBold),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            alignment: Alignment.centerLeft,
            hint: Text(
              "Select",
              style: TextStyle(
                  color: AppColor.hintTextColor,
                  fontFamily: AppFonts.nunitoRegular,
                  fontSize: MediaQuery.of(context).size.height *
                      AppSizes().fontSize.simpleFontSize),
            ),
            value: model.activitiesList.isEmpty
                ? null
                : model.activitiesList.any((activity) => activity.isSelect)
                    ? model.activitiesList.last.id.toString()
                    : null,
            onChanged: (value) {},
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            iconStyleData: IconStyleData(
              icon: Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.04),
                child: Icon(Icons.keyboard_arrow_down_outlined),
              ),
            ),
            items: model.activitiesList.map((item) {
              return DropdownMenuItem(
                value: item.id.toString(),
                //disable default onTap to avoid closing menu when selecting an item
                enabled: false,
                child: StatefulBuilder(
                  builder: (context, menuSetState) {
                    return InkWell(
                      onTap: () {
                        if (item.isSelect) {
                          item.isSelect = false;
                        } else {
                          item.isSelect = true;
                        }
                        //This rebuilds the StatefulWidget to update the button's text
                        setState(() {});
                        //This rebuilds the dropdownMenu Widget to update the check mark
                        menuSetState(() {});
                      },
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (item.isSelect)
                              const Icon(Icons.check_box_outlined)
                            else
                              const Icon(Icons.check_box_outline_blank),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
            buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.fieldBorderColor),
            )),
            selectedItemBuilder:
                model.activitiesList.any((activity) => activity.isSelect)
                    ? (context) {
                        return model.activitiesList.map(
                          (item) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                model.activitiesList
                                    .where((activity) => activity
                                        .isSelect) // Filter selected activities
                                    .map((activity) =>
                                        activity.title) // Extract titles
                                    .join(', '),
                                style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            );
                          },
                        ).toList();
                      }
                    : null,
          ),
        ),
      ],
    );
  }

  /// Pin Code
  Widget pinCode(CreateProfileViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        normalTitleText("Zipcode", AppFonts.nunitoSemiBold),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        SizedBox(
          height: screenHeight * 0.06,
          child: TextFormField(
            controller: model.pincodeController,
            onChanged: (value) {
              onCreateProfileValueChanged(model);
            },
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            decoration: TextFieldDecoration.textFieldDecorationNew(
                context, "Enter your zipcode",
                isFilled: isContactFilled),
            enableInteractiveSelection: true,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == "" || value == null) {
                model.isSubmitProfileButtonEnable = false;
                model.notifyListeners();
                return AppStrings().enterPin;
              } else if (value.trim().isEmpty) {
                model.isSubmitProfileButtonEnable = false;
                model.notifyListeners();
                return AppStrings().blankSpace;
              } else if (value.toString().length < 5) {
                model.isSubmitProfileButtonEnable = false;
                model.notifyListeners();
                return AppStrings().enterValidPin;
              } else if (GlobalUtility().validatePinCode(value)) {
                model.isSubmitProfileButtonEnable = false;
                model.notifyListeners();
                return AppStrings().enterValidPin;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  /// Price
  Widget enterPrice(model) {
    return TextFormField(
      controller: model.priceController,
      onChanged: (value) {
        onCreateProfileValueChanged(model);
      },
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == "" || value == null) {
          model.isSubmitProfileButtonEnable = false;
          model.notifyListeners();
          return AppStrings().enterPrice;
        } else if (value.trim().isEmpty) {
          model.isSubmitProfileButtonEnable = false;
          model.notifyListeners();
          return AppStrings().blankSpace;
        } else if (GlobalUtility().validatePinPrice(value)) {
          model.isSubmitProfileButtonEnable = false;
          model.notifyListeners();
          return AppStrings().enterValidPrice;
        }

        return null;
      },
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: InputDecoration(
        hintText: AppStrings().enterPrice,
        suffixIcon: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.015),
          child: const Text('/per hour  ',
              style: TextStyle(color: Colors.black38)),
        ),
        contentPadding: const EdgeInsets.only(
          top: 10,
          bottom: 0,
          left: 10,
        ),
        hintStyle: TextStyle(
            color: AppColor.hintTextColor,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
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
            borderSide: BorderSide(color: AppColor.errorBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
      ),
    );
  }

  ///describe yourself
  Widget describeYourself(CreateProfileViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        normalTitleText("Bio", AppFonts.nunitoSemiBold),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        TextFormField(
          onChanged: (value) {
            onCreateProfileValueChanged(model);
          },
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.start,
          controller: model.bioController,
          style: TextStyle(
              color: AppColor.lightBlack,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
          decoration: InputDecoration(
            hintText: AppStrings().enterYourBio,
            hintStyle: TextStyle(
                color: AppColor.hintTextColor,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.simpleFontSize),
            contentPadding: const EdgeInsets.only(top: 10, bottom: 0, left: 10),
            fillColor: AppColor.textfieldFilledColor,
            filled: isContactFilled,
            counterText: "",
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.textfieldborderColor),
                borderRadius: BorderRadius.all(Radius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.smallBorderRadius))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.textfieldborderColor),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.textfieldborderColor),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.textfieldborderColor),
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
          keyboardType: TextInputType.text,
          maxLines: 5,
        ),
      ],
    );
  }

  /// Upload id proof
  /* Widget uploadIdProofView(CreateProfileViewModel model) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Text(
          AppStrings().uploadIdProof,
          style: TextStyle(
              fontSize: screenHeight * AppSizes().fontSize.normalFontSize,
              fontFamily: AppFonts.nunitoBold,
              color: AppColor.lightBlack),
          textAlign: TextAlign.start,
        ),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        dottedContainer(model),
        UiSpacer.verticalSpace(space: 0.03, context: context),
      ],
    );
  }*/

  /// id proof image listing builder
  /* Widget idProofImageList(BuildContext context, CreateProfileViewModel model) {
    return Visibility(
      visible: model.idProofFile.isNotEmpty ? true : false,
      child: SizedBox(
        height: screenHeight * 0.1,
        width: screenWidth,
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            itemCount: model.idProofFile.length,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
                child: Image.file(
                  model.idProofFile[index],
                  fit: BoxFit.fill,
                ),
              );
            }),
      ),
    );
  }*/

  /// DOTTED BORDER CONTAINER
/*  Widget dottedContainer(CreateProfileViewModel model) {
    return GestureDetector(
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
            return showImagePicker(model, "idProof");
          },
        );
      },
      child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: DottedDecoration(
            color: AppColor.hintTextColor,
            shape: Shape.box,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      color: AppColor.shadowLocation, shape: BoxShape.circle),
                  child: Image.asset(
                    AppImages().pngImages.icUpload,
                    fit: BoxFit.cover,
                    width: AppSizes().widgetSize.iconWidth,
                    height: AppSizes().widgetSize.iconHeight,
                  )),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: AppStrings().clickToUpload,
                      style: TextStyle(
                          fontFamily: AppFonts.nunitoSemiBold,
                          color: AppColor.appthemeColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.normalFontSize)),
                  TextSpan(
                      text: AppStrings().dragDrop,
                      style: TextStyle(
                          fontFamily: AppFonts.nunitoSemiBold,
                          color: AppColor.dontHaveTextColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.normalFontSize),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                  TextSpan(
                      text: "\n${AppStrings().pngJpg}",
                      style: TextStyle(
                          fontFamily: AppFonts.nunitoRegular,
                          color: AppColor.dontHaveTextColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.xsimpleFontSize),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                ]),
              )
            ],
          )),
    );
  }*/

  Widget enrollmentAndNote(CreateProfileViewModel model) {
    return Column(
      children: [
        Text(
          AppStrings().guideNote,
          style: TextStyle(
              fontSize: screenHeight * AppSizes().fontSize.mediumFontSize,
              fontFamily: AppFonts.nunitoSemiBold,
              color: AppColor.blackColor),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                value: model.checkBoxVal,
                onChanged: (v) {
                  model.checkBoxVal = v!;
                  model.notifyListeners();
                },
                side: BorderSide(color: AppColor.hintTextColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                AppStrings().enrollment,
                style: TextStyle(
                    fontSize: screenHeight * AppSizes().fontSize.mediumFontSize,
                    fontFamily: AppFonts.nunitoSemiBold,
                    color: AppColor.blackColor),
                textAlign: TextAlign.start,
              ),
            )
          ],
        )
      ],
    );
  }

  /// submit button
  Widget buttonContainer(CreateProfileViewModel model) {
    return model.isBusy == false
        ? Container(
            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
            child: CommonButton.commonBoldTextButton(
                context: context,
                text: AppStrings().submit,
                onPressed: () {
                  if (validate(model)) {
                    model.createGuideProfile(context);
                  }
                },
                isButtonEnable: model.isSubmitProfileButtonEnable),
          )
        : SizedBox(
            width: screenWidth * 0.1,
            child: Center(
              child: CircularProgressIndicator(color: AppColor.appthemeColor),
            ),
          );
  }

  onCreateProfileValueChanged(CreateProfileViewModel model) {
    if (/*model.phoneNumController.text.isNotEmpty &&*/
        model.countryNameController.text.isNotEmpty &&
            model.stateNameController.text.isNotEmpty &&
            model.cityNameController.text.isNotEmpty &&
            model.pincodeController.text.isNotEmpty &&
            model.bioController.text.isNotEmpty) {
      model.isSubmitProfileButtonEnable = true;
      model.notifyListeners();
    } else {
      model.isSubmitProfileButtonEnable = false;
      model.notifyListeners();
    }
  }

  bool validate(CreateProfileViewModel model) {
    // String contact = model.phoneNumController.text;
    String country = model.countryNameController.text;
    String state = model.stateNameController.text;
    String city = model.cityNameController.text;
    String pincode = model.pincodeController.text;
    String bio = model.bioController.text.trim();

    if (model.checkBoxVal == false) {
      GlobalUtility.showToast(context,
          "Read note and agree with the enrollment as a guide with Imerzn");
      return false;
    }
    if (model.profilePicture == null) {
      GlobalUtility.showToast(context, AppStrings().uploadProfile);
      return false;
    }
    if (bio == "") {
      GlobalUtility.showToast(context, "Please describe yourself");
      return false;
    }
    if (activitiesSelected(model) == false) {
      GlobalUtility.showToast(context, "Please select activity");
      return false;
    }
    if (country == "") {
      GlobalUtility.showToast(context, AppStrings().countryEnter);
      return false;
    }
    if (state == "") {
      GlobalUtility.showToast(context, AppStrings().stateEnter);
      return false;
    }
    if (city == "") {
      GlobalUtility.showToast(context, AppStrings().cityEnter);
      return false;
    }

    if (pincode == "") {
      GlobalUtility.showToast(context, "Enter Zipcode");
      return false;
    }

    /* if (model.idProofFile.isEmpty) {
      GlobalUtility.showToast(context, "Please upload id proof");
      return false;
    }*/

    return true;
  }

  bool activitiesSelected(CreateProfileViewModel model) {
    for (int i = 0; i < model.activitiesList.length; i++) {
      if (model.activitiesList[i].isSelect == true) {
        return true;
      }
    }
    return false;
  }
}
