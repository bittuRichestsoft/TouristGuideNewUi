// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unnecessary_null_comparison

import 'dart:io';

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/response_pojo/getTravellerProfileResponse.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view_models/guide_models/guideUpdateProfileModel.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

import '../../travellerView/delete_account.dart';

class TouristProfilePage extends StatefulWidget {
  const TouristProfilePage({Key? key}) : super(key: key);

  @override
  State<TouristProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<TouristProfilePage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  String countryName = "";
  bool currentPasswordSuffixVisibility = false;
  bool newPasswordSuffixVisibility = false;
  bool newPasswordAgainSuffixVisibility = false;
  bool isContactFilled = false;
  bool isPriceFilled = false;

  GetTravellerProfileResponse? getTravellerProfileResponse;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<GuideUpdateProfileModel>.reactive(
        viewModelBuilder: () => GuideUpdateProfileModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return model.isBusy == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding,
                        context: context),
                    // Guide Profile view
                    profileImageView(model.profileImage),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding,
                        context: context),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth *
                            AppSizes().widgetSize.horizontalPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Guide Info
                            guideInfoData(model),
                            UiSpacer.verticalSpace(
                                space: AppSizes().widgetSize.normalPadding,
                                context: context),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                          isScrollControlled: true,
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30.0),
                                            ),
                                          ),
                                          builder: (BuildContext context) =>
                                              editProfileBottomSheet(model));
                                    },
                                    child: editProfileContainer()),
                                InkWell(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30.0),
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return editPasswordBottomSheet(model);
                                        },
                                      );
                                    },
                                    child: passwordContainer())
                              ],
                            ),

                            // gallery container
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // gallery container
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          AppRoutes.galleryListingPage);
                                    },
                                    child: galleryContainer()),

                                // review container
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, AppRoutes.reviewListPage);
                                    },
                                    child: reviewContainer()),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Bank Detail container
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          AppRoutes.guideBankingDetails);
                                    },
                                    child: bankDetailContainer()),
                                GestureDetector(
                                    onTap: () {
                                      GlobalUtility.showDialogFunction(
                                          context,
                                          DialogDeleteAccount(
                                              from: "guide_delete",
                                              cancelText: AppStrings().logoutNo,
                                              headingText:
                                                  AppStrings().deleteAcc,
                                              okayText: AppStrings().logoutYes,
                                              subContent:
                                                  AppStrings().deleteHeading));
                                    },
                                    child: deleteProfileContainer()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        });
  }

  Widget guideInfoData(GuideUpdateProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Guide Name
        TextView.headingText(context: context, text: model.username),
      ],
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

  Widget profileImageView(img) {
    return Container(
      // height: screenHeight * 0.44,
      child: CircleAvatar(
        radius: screenWidth * 0.17,
        child: Container(
            width: screenWidth * 0.35,
            height: screenWidth * 0.35,
            decoration: BoxDecoration(
                color: AppColor.whiteColor,
                border:
                    Border.all(color: AppColor.buttonDisableColor, width: 3),
                shape: BoxShape.circle,
                image: img != null && img != ""
                    ? DecorationImage(
                        fit: BoxFit.fill, image: NetworkImage(img))
                    : DecorationImage(
                        image: AssetImage(
                            AppImages().pngImages.icProfilePlaceholder)))),
      ),
    );
  }

  Widget editProfileContainer() {
    return SizedBox(
      width: screenWidth * 0.45,
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

  Widget galleryContainer() {
    return SizedBox(
      width: screenWidth * 0.45,
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
              iconView(AppColor.gallerbackbuttonColor,
                  AppImages().pngImages.icGalleryPink),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Text(
                AppStrings().gallery,
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

  Widget bankingDetailContainer() {
    return SizedBox(
      width: screenWidth * 0.45,
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
              iconView(AppColor.gallerbackbuttonColor,
                  AppImages().pngImages.icGalleryPink),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Text(
                AppStrings().gallery,
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
      width: screenWidth * 0.45,
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

  Widget iconView(Color backColor, String imagepath) {
    return Container(
        width: screenWidth * 0.15,
        height: screenWidth * 0.15,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(
                screenWidth * AppSizes().widgetSize.smallBorderRadius)),
            color: backColor),
        child: Image.asset(
          imagepath,
          width: 30,
          height: 30,
        ));
  }

  Widget reviewContainer() {
    return SizedBox(
      width: screenWidth * 0.45,
      height: screenWidth * 0.35,
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor.reviewBgColor, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(
                screenWidth * AppSizes().widgetSize.mediumBorderRadius)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconView(AppColor.reviewBgColor,
                  AppImages().pngImages.icGalleryYellow),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Text(
                "Reviews",
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

  // Tourist Bank Detail
  Widget bankDetailContainer() {
    return SizedBox(
      width: screenWidth * 0.45,
      height: screenWidth * 0.35,
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor.bankdetailBgColor, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(
                screenWidth * AppSizes().widgetSize.mediumBorderRadius)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconView(AppColor.bankdetailBgColor,
                  AppImages().pngImages.icGalleryYellow),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Text(
                AppStrings().bankingDetails,
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

  // Edit profile bottom sheet
  Widget editProfileBottomSheet(GuideUpdateProfileModel model) {
    return SizedBox(
      height: screenHeight * 0.9,
      child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ValueListenableBuilder(
              valueListenable: model.counterNotifier,
              builder: (context, current, child) {
                return ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
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
                    profileImageEdit(model),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding,
                        context: context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.43,
                          child: TextFormField(
                            controller: model.firstNameController,
                            onChanged: onTextFieldChange(model),
                            maxLength: 50,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
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
                            textInputAction: TextInputAction.done,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textCapitalization: TextCapitalization.words,
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
                        // last Name field
                        SizedBox(
                          width: screenWidth * 0.43,
                          child: TextFormField(
                            controller: model.lastNameController,
                            onChanged: onTextFieldChange(model),
                            maxLength: 50,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
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
                            textInputAction: TextInputAction.done,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                        readOnly: true,
                        textInputAction: TextInputAction.done,
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
                                            fontSize: 16,
                                            color: Colors.blueGrey),
                                        bottomSheetHeight:
                                            500, // Optional. Country list modal height
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
                                        model.countryCode =
                                            model.countryCode == ""
                                                ? "+1"
                                                : '+ ${country.phoneCode}';
                                        model.counterNotifier.notifyListeners();
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 8),
                                        child: Text(model.countryCode == ""
                                            ? "+1"
                                            : model.countryCode),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: SvgPicture.asset(AppImages()
                                              .svgImages
                                              .chevronDown)),
                                    ],
                                  ),
                                ),
                              ]),
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
                                      AppSizes()
                                          .widgetSize
                                          .smallBorderRadius))),
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
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding022,
                        context: context),
                    countryCityField(model),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding022,
                        context: context),
                    pinCode(model),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.smallPadding,
                        context: context),
                    Text(
                      "(Siesta will deduct 25% commission. the 25% should be a configurable amount)",
                      style: TextStyle(
                          color: AppColor.dontHaveTextColor,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: screenHeight *
                              AppSizes().fontSize.mediumFontSize),
                    ),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.smallPadding,
                        context: context),
                    priceField(model),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.smallPadding,
                        context: context),
                    describeYourself(model),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.smallPadding,
                        context: context),
                    uploadIdProofView(model),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.smallPadding,
                        context: context),
                    idProofImageList(context, model),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.smallPadding,
                        context: context),
                    uploadedIdProofImageList(context, model),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.mediumPadding,
                        context: context),

                    /// button save changes
                    model.isBusy == false
                        ? CommonButton.commonBoldTextButton(
                            context: context,
                            text: AppStrings().saveChanges,
                            onPressed: () {
                              if (model.isProfileButtonEnable) {
                                model.guideUpdateProfile(context);
                              }
                            },
                            isButtonEnable: model.isProfileButtonEnable)
                        : SizedBox(
                            width: screenWidth * 0.1,
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColor.appthemeColor),
                            ),
                          ),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.mediumPadding,
                        context: context),
                  ],
                );
              })),
    );
  }

  Widget countryCityField(GuideUpdateProfileModel model) {
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
                                model.destinationNotifier.value = true;
                                model.destinationNotifier.notifyListeners();
                              },
                              title: Text(model.countryList[index]),
                            ),
                          )));
                    },
                  );
                });
                model.destinationNotifier.value = true;
                model.destinationNotifier.notifyListeners();
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
                                  if (model.stateController.text !=
                                      model.stateList[index]) {
                                    model.stateController.text =
                                        model.stateList[index];
                                    model.cityController.clear();
                                  }
                                  Navigator.pop(cxt);
                                  model.destinationNotifier.value = true;
                                  model.destinationNotifier.notifyListeners();
                                },
                                title: Text(model.stateList[index]),
                              ),
                            )));
                      },
                    );
                  });
                }
                model.destinationNotifier.value = true;
                model.destinationNotifier.notifyListeners();
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
                                  model.destinationNotifier.value = true;
                                  model.destinationNotifier.notifyListeners();
                                },
                                title: Text(model.cityList[index]),
                              ),
                            )));
                      },
                    );
                  });
                }
                model.destinationNotifier.value = true;
                model.destinationNotifier.notifyListeners();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
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

  Widget describeYourself(GuideUpdateProfileModel model) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      controller: model.bioController,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.simpletextFieldDecoration(
          context, AppStrings().describeYourself, isContactFilled),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      maxLines: 5,
    );
  }

  Widget pinCode(GuideUpdateProfileModel model) {
    return SizedBox(
      child: TextFormField(
        controller: model.pincodeController,
        onChanged: (value) {
          onTextFieldChange(model);
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.textFieldFilledDecoration(
            context,
            AppStrings().pinCode,
            AppImages().svgImages.icPinCode,
            isContactFilled),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == "" || value == null) {
            model.isProfileButtonEnable = false;
            return AppStrings().enterPin;
          } else if (value.trim().isEmpty) {
            model.isProfileButtonEnable = false;
            return AppStrings().blankSpace;
          } else if (value.toString().length < 5) {
            model.isProfileButtonEnable = false;
            return AppStrings().enterValidPin;
          } else if (GlobalUtility().validatePinCode(value)) {
            model.isProfileButtonEnable = false;
            return AppStrings().enterValidPin;
          }
          return null;
        },
      ),
    );
  }

  Widget priceField(GuideUpdateProfileModel model) {
    return SizedBox(
      child: TextFormField(
        controller: model.priceController,
        onChanged: (value) {
          onTextFieldChange(model);
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.textFieldFilledDecoration(context,
            "Price per hour", AppImages().svgImages.icDollar, isContactFilled),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == "" || value == null) {
            model.isProfileButtonEnable = false;
            return AppStrings().enterPrice;
          } else if (value.trim().isEmpty) {
            model.isProfileButtonEnable = false;
            return AppStrings().blankSpace;
          } else if (value.toString().length > 5) {
            model.isProfileButtonEnable = false;
            return "Enter valid price";
          }
          return null;
        },
      ),
    );
  }

  Widget uploadedIdProofImageList(
      BuildContext context, GuideUpdateProfileModel model) {
    return Visibility(
      visible: model.idProofUploaded.isNotEmpty ? true : false,
      child: SizedBox(
        height: screenHeight * 0.1,
        width: screenWidth,
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            itemCount: model.idProofUploaded.length,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
                child: Image.network(
                  model.idProofUploaded[index].documentUrl.toString(),
                  fit: BoxFit.fill,
                ),
              );
            }),
      ),
    );
  }

  /// id proof image listing builder
  Widget idProofImageList(BuildContext context, GuideUpdateProfileModel model) {
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
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.width *
                                AppSizes().widgetSize.smallBorderRadius)),
                        child: SizedBox(
                          height: 170,
                          width: 170,
                          child: Image.file(
                            model.idProofFile[index],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () => {
                          model.idProofFile.removeAt(index),
                          model.notifyListeners(),
                          model.counterNotifier.value++
                        },
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child:
                                Image.asset(AppImages().pngImages.closeCircle),
                          ),
                        ),
                      ))
                ],
              );
            }),
      ),
    );
  }

  /// Upload id proof
  Widget uploadIdProofView(GuideUpdateProfileModel model) {
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
      ],
    );
  }

  /// DOTTED BORDER CONTAINER
  Widget dottedContainer(GuideUpdateProfileModel model) {
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
  }

  Widget profileImageEdit(model) {
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
              return showImagePicker(model, "profile");
            },
          );
        },
        child: Center(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                      child: model.profilePicture == null
                          ? ClipOval(
                              child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Image.network(
                                    model.profileImage,
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : ClipOval(
                              child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Image.file(
                                    model.profilePicture!,
                                    fit: BoxFit.cover,
                                  )),
                            )),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 10,
                child: CircleAvatar(
                  radius: 12.0,
                  child: Image.asset(AppImages().pngImages.iceditProfile),
                ),
              )
            ],
          ),
        ));
  }

  // Edit password bottom sheet
  Widget editPasswordBottomSheet(GuideUpdateProfileModel model) {
    return ValueListenableBuilder(
        valueListenable: model.counterNotifier1,
        builder: (context, current, child) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                  ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(
                        screenWidth * AppSizes().widgetSize.horizontalPadding),
                    shrinkWrap: true,
                    children: [
                      TextView.normalText(
                          text: AppStrings().changePassContent,
                          textColor: AppColor.dontHaveTextColor,
                          textSize: AppSizes().fontSize.mediumFontSize,
                          fontFamily: AppFonts.nunitoRegular,
                          context: context),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
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
                          space: AppSizes().widgetSize.normalPadding,
                          context: context),
                      updatePasswordButton(model)
                    ],
                  )
                ],
              ));
        });
  }

  /// passwords
  Widget currentPasswordField(GuideUpdateProfileModel model) {
    return SizedBox(
      child: TextFormField(
        controller: model.currentPasswordController,
        onChanged: onPasswordFieldChange(model),
        obscureText: currentPasswordSuffixVisibility,
        textAlignVertical: TextAlignVertical.center,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return GlobalUtility().validatePassword(value!);
        },
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
          hintText: "Current password",
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
            onPressed: null,
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
        onChanged: onPasswordFieldChange(model),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return GlobalUtility().validatePassword(value!);
        },
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
          hintText: "New password",
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
            onPressed: null,
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

  Widget newPasswordAgainField(GuideUpdateProfileModel model) {
    return SizedBox(
      child: TextFormField(
        controller: model.newPasswordAgainController,
        onChanged: onPasswordFieldChange(model),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return GlobalUtility().validatePassword(value!);
        },
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
            onPressed: null,
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

  Widget updatePasswordButton(GuideUpdateProfileModel model) {
    return model.isBusy == false
        ? CommonButton.commonBoldTextButton(
            text: AppStrings().updatePassword,
            context: context,
            onPressed: () {
              model.notifyListeners();
              model.counterNotifier1.value++;
              if (validate(model)) {
                if (model.updatePasswordButtonEnable) {
                  if (model.newPasswordController.text ==
                      model.newPasswordAgainController.text) {
                    model.guideUpdatePassword(context);
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

  Widget showImagePicker(GuideUpdateProfileModel model, String fromWhere) {
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
  imageFromCamera(GuideUpdateProfileModel model, String fromWhere) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedFile != null) {
      if (fromWhere == "profile") {
        model.profilePicture = File(pickedFile.path);

        ///model.updateProfileImage(context);
      } else if (fromWhere == "idProof") {
        model.idProofFile.add(File(pickedFile.path));
      }
      debugPrint("Id Proof list camera-- ${model.idProofFile.length}");
      model.notifyListeners();
    }
    model.counterNotifier.value++;
    model.notifyListeners();
  }

  /// IMAGE SELECTION WITH Gallery
  imageFromGallery(GuideUpdateProfileModel model, String fromWhere) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      if (fromWhere == "profile") {
        model.profilePicture = File(pickedFile.path);
      } else if (fromWhere == "idProof") {
        model.idProofFile.add(File(pickedFile.path));
      }
    }
    model.counterNotifier.value++;
    model.notifyListeners();
  }

  onTextFieldChange(GuideUpdateProfileModel model) {
    if (model.firstNameController.text != "" &&
        model.contactController.text != "" &&
        model.pincodeController.text != "" &&
        model.priceController.text != "") {
      model.isProfileButtonEnable = true;
    } else {
      model.isProfileButtonEnable = false;
    }
  }

  onPasswordFieldChange(model) {
    if (model.currentPasswordController != "" &&
        model.newPasswordController != "" &&
        model.newPasswordAgainController != "") {
      if (model.newPasswordAgainController.text != "" &&
          model.newPasswordController.text != "" &&
          model.newPasswordController.text ==
              model.newPasswordAgainController.text) {
        model.updatePasswordButtonEnable = true;
        model.counterNotifier1.value++;
      } else {
        model.updatePasswordButtonEnable = false;
        model.counterNotifier1.value++;
      }
    } else {
      model.updatePasswordButtonEnable = false;
      model.counterNotifier1.value++;
    }
    model.notifyListeners();
  }

  bool validate(GuideUpdateProfileModel model) {
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
