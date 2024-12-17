// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unnecessary_null_comparison

import 'dart:io';

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/response_pojo/getTravellerProfileResponse.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view_models/updateTravellerProfileModel.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

import '../delete_account.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  String countryName = "";
  bool currentPasswordSuffixVisibility = false;
  bool newPasswordSuffixVisibility = false;
  bool newPasswordAgainSuffixVisibility = false;
  GetTravellerProfileResponse? getTravellerProfileResponse;
  UpdateTravellerProfileViewModel? initializedModel;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<UpdateTravellerProfileViewModel>.reactive(
        viewModelBuilder: () => UpdateTravellerProfileViewModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          initializedModel = model;
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            /* appBar: AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              leading: IconButton(
                icon: Icon(Icons.clear, color: AppColor.whiteColor),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.travellerHomePage);
                },
              ),
              title: TextView.headingWhiteText(
                  text: AppStrings().profile, context: context),
            ),*/
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(screenWidth * 0.03),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      profileImageView(model.profileImage),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding,
                          context: context),
                      TextView.headingText(
                          context: context, text: model.username),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          editProfileBottomSheet(model);
                        },
                        child: editProfileContainer()),
                    InkWell(
                        onTap: () {
                          editPasswordBottomSheet(model);
                        },
                        child: passwordContainer())
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          GlobalUtility.showDialogFunction(
                              context,
                              DialogDeleteAccount(
                                  from: "delete",
                                  cancelText: AppStrings().logoutNo,
                                  headingText: AppStrings().deleteAcc,
                                  okayText: AppStrings().logoutYes,
                                  subContent: AppStrings().deleteHeading));
                        },
                        child: deleteProfileContainer()),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget showImagePicker(UpdateTravellerProfileViewModel model) {
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
                imageFromGallery(model);
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
                imageFromCamera(model);
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
  imageFromCamera(UpdateTravellerProfileViewModel model) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedFile != null) {
      model.profilePicture = File(pickedFile.path);
      debugPrint("model.profilePicture-- ${model.profilePicture}");
      model.counterNotifier.notifyListeners();
      model.counterNotifier.value++;
    }
  }

  /// IMAGE SELECTION WITH Gallery
  imageFromGallery(UpdateTravellerProfileViewModel model) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      model.profilePicture = File(pickedFile.path);
      debugPrint("model.profilePicture-- ${model.profilePicture}");
      model.counterNotifier.notifyListeners();

      model.counterNotifier.value++;
    }
  }

  Widget profileImageView(img) {
    return Container(
      width: screenWidth * 0.25,
      height: screenWidth * 0.25,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(color: AppColor.buttonDisableColor, width: 2),
          shape: BoxShape.circle,
          image: img != null && img != ""
              ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(img))
              : DecorationImage(
                  image:
                      AssetImage(AppImages().pngImages.icProfilePlaceholder))),
    );
  }

  Widget profileImageEdit(UpdateTravellerProfileViewModel model) {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(2),
              height: screenHeight * 0.15,
              width: screenHeight * 0.15,
              child: ClipOval(
                child: model.profileImage != ""
                    ? Image.network(
                        model.profileImage,
                        fit: BoxFit.cover,
                      )
                    : model.profilePicture != null
                        ? Image.file(
                            model.profilePicture!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            AppImages().pngImages.icProfilePlaceholder),
              )),
          Positioned(
            bottom: 5,
            right: 10,
            child: CircleAvatar(
                radius: 12.0,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                      useSafeArea: false,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                              MediaQuery.of(context).size.width *
                                  AppSizes().widgetSize.largeBorderRadius),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return showImagePicker(model);
                      },
                    );
                  },
                  child: Image.asset(AppImages().pngImages.iceditProfile),
                )),
          ),
        ],
      ),
    );
  }

  Widget editProfileContainer() {
    return SizedBox(
      width: screenWidth * 0.46,
      height: screenWidth * 0.35,
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor.buttonDisableColor, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(
                screenWidth * AppSizes().widgetSize.mediumBorderRadius)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconView(AppColor.buttonDisableColor,
                  AppImages().pngImages.icSelectedProfile),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Text(
                AppStrings().editProfileText,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoMedium,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
              ),
            ],
          )),
    );
  }

  Widget deleteProfileContainer() {
    return SizedBox(
      width: screenWidth * 0.46,
      height: screenWidth * 0.35,
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor.buttonDisableColor, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(
                screenWidth * AppSizes().widgetSize.mediumBorderRadius)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                          screenWidth *
                              AppSizes().widgetSize.smallBorderRadius)),
                      color: AppColor.gallerbackbuttonColor),
                  child: Image.asset(
                    AppImages().pngImages.icSelectedProfile,
                    color: AppColor.textbuttonColor,
                    width: 30,
                    height: 30,
                  )),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Text(
                AppStrings().deleteAcc,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoMedium,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
              ),
            ],
          )),
    );
  }

  Widget passwordContainer() {
    return SizedBox(
      width: screenWidth * 0.46,
      height: screenWidth * 0.35,
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor.marginBorderColor, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(
                screenWidth * AppSizes().widgetSize.mediumBorderRadius)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconView(AppColor.marginBorderColor,
                  AppImages().pngImages.icChangePassword),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Text(
                AppStrings().changePassword,
                style: TextStyle(
                    color: AppColor.lightBlack,
                    fontFamily: AppFonts.nunitoMedium,
                    fontSize:
                        screenHeight * AppSizes().fontSize.simpleFontSize),
              ),
            ],
          )),
    );
  }

  Widget iconView(Color backColor, String imagePath) {
    return Container(
        width: screenWidth * 0.15,
        height: screenWidth * 0.15,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(
                screenWidth * AppSizes().widgetSize.smallBorderRadius)),
            color: backColor),
        child: Image.asset(
          imagePath,
          width: 30,
          height: 30,
        ));
  }

  // Edit profile bottom sheet
  editProfileBottomSheet(UpdateTravellerProfileViewModel model) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30.0),
      )),
      builder: (context) => ValueListenableBuilder(
        valueListenable: model.counterNotifier,
        builder: (context, current, child) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(
                    screenWidth * AppSizes().widgetSize.largePadding),
                children: [
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),
                  Center(
                      child: TextView.normalText(
                          context: context,
                          text: AppStrings().editProfileText,
                          textColor: AppColor.lightBlack,
                          textSize: AppSizes().fontSize.headingTextSize,
                          fontFamily: AppFonts.nunitoSemiBold)),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),
                  Container(
                    height: 1.8,
                    width: screenWidth,
                    color: Colors.black12,
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),
                  profileImageEdit(initializedModel!),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.43,
                        child: TextFormField(
                          controller: initializedModel!.firstNameController,
                          onChanged: onTextFieldChange(model),
                          maxLength: 50,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.start,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                              color: AppColor.lightBlack,
                              fontFamily: AppFonts.nunitoRegular,
                              fontSize: screenHeight *
                                  AppSizes().fontSize.simpleFontSize),
                          decoration: TextFieldDecoration.textFieldDecoration(
                              context,
                              'First name',
                              AppImages().svgImages.icName,
                              ""),
                          enableInteractiveSelection: true,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == "" || value == null) {
                              model.isProfileButtonEnable = false;
                              return AppStrings().enterFirstString;
                            } else if (value.trim().isEmpty) {
                              model.isProfileButtonEnable = false;
                              return AppStrings().blankSpace;
                            } else if (value.toString().length < 2) {
                              model.isProfileButtonEnable = false;
                              return AppStrings().nameErrorString;
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.43,
                        child: TextFormField(
                          controller: model.lastNameController,
                          onChanged: onTextFieldChange(model),
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.start,
                          maxLength: 50,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                              color: AppColor.lightBlack,
                              fontFamily: AppFonts.nunitoRegular,
                              fontSize: screenHeight *
                                  AppSizes().fontSize.simpleFontSize),
                          decoration: TextFieldDecoration.textFieldDecoration(
                              context,
                              'Last name',
                              AppImages().svgImages.icName,
                              ""),
                          enableInteractiveSelection: true,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == "" || value == null) {
                              return AppStrings().enterLastName;
                            } else if (value.trim().isEmpty) {
                              return AppStrings().blankSpace;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding022,
                      context: context),
                  // Email field
                  SizedBox(
                    height:
                        screenHeight * AppSizes().widgetSize.textFieldheight,
                    width: screenWidth,
                    child: TextFormField(
                      controller: model.emailController,
                      onChanged: onTextFieldChange(model),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.start,
                      readOnly: true,
                      style: TextStyle(
                          color: AppColor.lightBlack,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: screenHeight *
                              AppSizes().fontSize.simpleFontSize),
                      decoration: TextFieldDecoration.textFieldDecoration(
                          context,
                          AppStrings().enterEmail,
                          AppImages().svgImages.icEmail,
                          ""),
                      enableInteractiveSelection: false,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.smallPadding,
                      context: context),

                  // Contact number field
                  SizedBox(
                    width: screenWidth,
                    child: TextFormField(
                      controller: model.contactController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == "" || value == null) {
                          model.isProfileButtonEnable = false;

                          return AppStrings().enterPhoneNumber;
                        } else if (value.trim().isEmpty) {
                          model.isProfileButtonEnable = false;

                          return AppStrings().blankSpace;
                        } else if (value.toString().length < 10) {
                          model.isProfileButtonEnable = false;

                          return AppStrings().phoneErrorString;
                        } else if (GlobalUtility().validateContact(value)) {
                          model.isProfileButtonEnable = false;

                          return AppStrings().EnterValidMobile;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onChanged: onTextFieldChange(model),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppColor.lightBlack,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: screenHeight *
                              AppSizes().fontSize.simpleFontSize),
                      decoration: InputDecoration(
                        hintText: "Contact Number",
                        prefixIcon: InkWell(
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
                                    ? "+1"
                                    : '+ ${country.phoneCode}';
                                model.counterNotifier.value++;
                                model.counterNotifier.notifyListeners();
                              },
                            );
                          },
                          child: SizedBox(
                            width: screenWidth * 0.25,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, right: 8),
                                  child: Text(model.countryCode == ""
                                      ? "+1"
                                      : model.countryCode),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                        AppImages().svgImages.chevronDown)),
                              ],
                            ),
                          ),
                        ),
                        hintStyle: TextStyle(
                            color: AppColor.hintTextColor,
                            fontFamily: AppFonts.nunitoRegular,
                            fontSize: MediaQuery.of(context).size.height *
                                AppSizes().fontSize.simpleFontSize),
                        contentPadding:
                            const EdgeInsets.only(top: 20, bottom: 2),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.fieldBorderColor),
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width *
                                    AppSizes().widgetSize.smallBorderRadius))),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.fieldEnableColor),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.fieldBorderColor),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.fieldBorderColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.errorBorderColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.errorBorderColor),
                        ),
                      ),
                      enableInteractiveSelection: true,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  //pinCode(model),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.smallPadding,
                      context: context),

                  countryCityField(model),

                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.horizontalPadding,
                      context: context),

                  /// button save changes
                  model.isBusy == false
                      ? CommonButton.commonBoldTextButton(
                          context: context,
                          text: AppStrings().saveChanges,
                          onPressed: () {
                            if (model.isProfileButtonEnable) {
                              model.updateTravellerProfile(
                                context,
                              );
                            }
                          },
                          isButtonEnable: model.isProfileButtonEnable)
                      : SizedBox(
                          width: screenWidth * 0.1,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: AppColor.appthemeColor),
                          ),
                        )
                ],
              ));
        },
      ),
    );
  }

  Widget countryCityField(UpdateTravellerProfileViewModel model) {
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
                          context: context, countryId: "", stateId: "")
                      .then((value) {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      builder: (cxt) {
                        return Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.03),
                            child: Scaffold(
                                /*appBar: AppBar(
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
                                  if (model.countryNameController.text !=
                                      model.countryList[index]) {
                                    model.countryNameController.text =
                                        model.countryList[index];
                                    model.stateNameController.clear();
                                    model.cityNameController.clear();
                                  } else {
                                    model.countryNameController.text =
                                        model.countryList[index];
                                  }
                                  Navigator.pop(cxt);
                                  model.destinationNotifier.value = true;
                                  model.destinationNotifier.notifyListeners();
                                },
                                title: Text(model.countryList[index]),
                              ),
                            )));
                      },
                    );
                  });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(model.countryNameController.text == ""
                        ? "Select Country"
                        : model.countryNameController.text),
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
                  if (model.countryNameController.text.isEmpty) {
                    GlobalUtility.showToast(context, "Please Select country");
                  } else {
                    model
                        .getLocationApi(
                            context: context,
                            countryId: model.countryNameController.text,
                            stateId: "")
                        .then((value) {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        builder: (cxt) {
                          return Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.03),
                              child: Scaffold(
                                  /*appBar: AppBar(
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
                                    if (model.stateNameController.text !=
                                        model.stateList[index]) {
                                      model.stateNameController.text =
                                          model.stateList[index];
                                      model.cityNameController.clear();
                                    }

                                    Navigator.pop(cxt);
                                    model.destinationNotifier.value = true;
                                    model.destinationNotifier.notifyListeners();
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
                    title: Text(model.stateNameController.text == ""
                        ? "Select State"
                        : model.stateNameController.text),
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
                  if (model.countryNameController.text.isEmpty) {
                    GlobalUtility.showToast(context, "Please Select country");
                  } else if (model.stateNameController.text.isEmpty) {
                    GlobalUtility.showToast(context, "Please Select State");
                  } else {
                    model
                        .getLocationApi(
                            context: context,
                            countryId: model.countryNameController.text,
                            stateId: model.stateNameController.text)
                        .then((value) {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        context: context,
                        enableDrag: true,
                        builder: (cxt) {
                          return Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.03),
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
                                    model.cityNameController.text =
                                        model.cityList[index];

                                    Navigator.pop(cxt);
                                    model.destinationNotifier.value = true;
                                    model.destinationNotifier.notifyListeners();
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
                    title: Text(model.cityNameController.text == ""
                        ? "Select City"
                        : model.cityNameController.text),
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
        });
  }
/*
Widget countryCityField(UpdateTravellerProfileViewModel model) {
    return CountryStateCityPicker(
        country: model.countryNameController,
        state: model.stateNameController,
        city: model.cityNameController,
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
  }
*/

  editPasswordBottomSheet(UpdateTravellerProfileViewModel model) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        )),
        builder: (context) => ValueListenableBuilder(
            valueListenable: model.counterNotifier1,
            builder: (context, current, child) {
              return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(
                        screenWidth * AppSizes().widgetSize.horizontalPadding),
                    children: [
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      Center(
                        child: Container(
                          height: 4,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding,
                          context: context),
                      Center(
                          child: TextView.normalText(
                              context: context,
                              fontFamily: AppFonts.nunitoSemiBold,
                              textSize: AppSizes().fontSize.headingTextSize,
                              textColor: AppColor.lightBlack,
                              text: AppStrings().changePassword)),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding,
                          context: context),
                      Container(
                        height: 1.8,
                        width: screenWidth,
                        color: Colors.black12,
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      TextView.normalText(
                          text: AppStrings().changePassContent,
                          textColor: AppColor.dontHaveTextColor,
                          textSize: AppSizes().fontSize.mediumFontSize,
                          fontFamily: AppFonts.nunitoRegular,
                          context: context),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                      currentPasswordField(model),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding022,
                          context: context),
                      newPasswordField(model),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding022,
                          context: context),
                      newPasswordAgainField(model),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.horizontalPadding,
                          context: context),
                      updatePasswordButton(model)
                    ],
                  ));
            }));
  }

  /// passwords
  Widget currentPasswordField(UpdateTravellerProfileViewModel model) {
    return SizedBox(
      // height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        controller: model.currentPasswordController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return GlobalUtility().validatePassword(value!);
        },
        onChanged: onPasswordFieldChange(model),
        obscureText: currentPasswordSuffixVisibility,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        obscuringCharacter: "✯",
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                currentPasswordSuffixVisibility =
                    !currentPasswordSuffixVisibility;
              });
              model.counterNotifier1.notifyListeners();

              model.counterNotifier1.value++;
            },
            icon: currentPasswordSuffixVisibility
                ? Icon(Icons.visibility_off_outlined,
                    color: AppColor.disableColor,
                    size: AppSizes().widgetSize.iconWidth)
                : Icon(
                    Icons.visibility_outlined,
                    color: AppColor.lightBlack,
                    size: AppSizes().widgetSize.iconWidth,
                  ),
          ),
          hintText: "Current Password",
          contentPadding: const EdgeInsets.only(
            top: 8,
            bottom: 0,
          ),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
          prefixIcon: IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            onPressed: () {},
            icon: SvgPicture.asset(AppImages().svgImages.icPassword),
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
      ),
    );
  }

  Widget newPasswordField(model) {
    return SizedBox(
      child: TextFormField(
        controller: model.newPasswordController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return GlobalUtility().validatePassword(value!);
        },
        onChanged: onPasswordFieldChange(model),
        obscureText: newPasswordSuffixVisibility,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        obscuringCharacter: "✯",
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                newPasswordSuffixVisibility = !newPasswordSuffixVisibility;
              });
              model.counterNotifier1.notifyListeners();

              model.counterNotifier1.value++;
            },
            icon: newPasswordSuffixVisibility
                ? Icon(Icons.visibility_off_outlined,
                    color: AppColor.disableColor,
                    size: AppSizes().widgetSize.iconWidth)
                : Icon(
                    Icons.visibility_outlined,
                    color: AppColor.lightBlack,
                    size: AppSizes().widgetSize.iconWidth,
                  ),
          ),
          hintText: "New Password",
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 0,
          ),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
          prefixIcon: IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            onPressed: () {},
            icon: SvgPicture.asset(AppImages().svgImages.icPassword),
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
      ),
    );
  }

  Widget newPasswordAgainField(model) {
    return SizedBox(
      child: TextFormField(
        controller: model.newPasswordAgainController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return GlobalUtility().validatePassword(value!);
        },
        onChanged: onPasswordFieldChange(model),
        obscureText: newPasswordAgainSuffixVisibility,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        obscuringCharacter: "✯",
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                newPasswordAgainSuffixVisibility =
                    !newPasswordAgainSuffixVisibility;
              });
              model.counterNotifier1.value++;
              model.counterNotifier1.notifyListeners();
            },
            icon: newPasswordAgainSuffixVisibility
                ? Icon(Icons.visibility_off_outlined,
                    color: AppColor.disableColor,
                    size: AppSizes().widgetSize.iconWidth)
                : Icon(
                    Icons.visibility_outlined,
                    color: AppColor.lightBlack,
                    size: AppSizes().widgetSize.iconWidth,
                  ),
          ),
          hintText: "New password again",
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 0,
          ),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
          prefixIcon: IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            onPressed: () {},
            icon: SvgPicture.asset(AppImages().svgImages.icPassword),
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
      ),
    );
  }

  Widget updatePasswordButton(UpdateTravellerProfileViewModel model) {
    return model.isBusy == false
        ? CommonButton.commonBoldTextButton(
            text: AppStrings().updatePassword,
            context: context,
            onPressed: () {
              model.counterNotifier1.value++;
              if (validate(model)) {
                if (model.updatePasswordButtonEnable) {
                  if (model.newPasswordController.text ==
                      model.newPasswordAgainController.text) {
                    model.updatePassword(context);
                  } else {
                    GlobalUtility.showToast(context,
                        "New password and New password again not match!!");
                  }
                }
              }
            },
            isButtonEnable: model.updatePasswordButtonEnable)
        : SizedBox(
            width: screenWidth * 0.1,
            child: Center(
              child: CircularProgressIndicator(color: AppColor.appthemeColor),
            ),
          );
  }

  onTextFieldChange(UpdateTravellerProfileViewModel model) {
    if (model.firstNameController.text != "" &&
        model.contactController.text != "" &&
        model.countryNameController.text.replaceAll(" ", "") != "" &&
        model.stateNameController.text.replaceAll(" ", "") != "" &&
        model.cityNameController.text.replaceAll(" ", "") != "") {
      model.isProfileButtonEnable = true;
      model.counterNotifier.value++;
      model.counterNotifier.notifyListeners();
    } else {
      model.isProfileButtonEnable = false;
      model.counterNotifier.value++;
      model.counterNotifier.notifyListeners();
    }
  }

  onPasswordFieldChange(UpdateTravellerProfileViewModel model) {
    if (model.currentPasswordController.text != "" &&
        model.newPasswordController.text != "" &&
        model.newPasswordAgainController.text != "") {
      model.updatePasswordButtonEnable = true;
      model.counterNotifier1.value++;
      model.counterNotifier1.notifyListeners();
    } else {
      model.updatePasswordButtonEnable = false;
      model.counterNotifier1.value++;
      model.counterNotifier1.notifyListeners();
    }
  }

  bool validate(UpdateTravellerProfileViewModel model) {
    String currentPassword = model.currentPasswordController.text;
    String newPassword = model.newPasswordController.text;
    String newPasswordAgain = model.newPasswordAgainController.text;
    if (currentPassword == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterCurrentPassword);
      return false;
    }
    if (newPassword == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterNewPassword);
    }

    if (newPasswordAgain == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterConfirmPassword);
    }
    return true;
  }
}
