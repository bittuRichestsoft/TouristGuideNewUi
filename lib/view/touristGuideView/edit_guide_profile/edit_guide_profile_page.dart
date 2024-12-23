import 'dart:io';

import 'package:Siesta/custom_widgets/custom_textfield.dart';
import 'package:Siesta/view_models/guide_profile_model/edit_guide_profile_model.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_fonts.dart';
import '../../../app_constants/app_images.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../app_constants/app_strings.dart';
import '../../../common_widgets/common_button.dart';
import '../../../common_widgets/common_imageview.dart';
import '../../../common_widgets/common_textview.dart';
import '../../../common_widgets/vertical_size_box.dart';
import '../../../custom_widgets/common_widgets.dart';
import '../../../utility/globalUtility.dart';
import '../../travellerView/delete_account.dart';

class EditGuideProfilePage extends StatefulWidget {
  const EditGuideProfilePage({super.key});

  @override
  State<EditGuideProfilePage> createState() => _EditGuideProfilePageState();
}

class _EditGuideProfilePageState extends State<EditGuideProfilePage> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder.reactive(
        viewModelBuilder: () => EditGuideProfileModel(),
        // onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, "back");
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: AppColor.appthemeColor),
                centerTitle: true,
                backgroundColor: AppColor.appthemeColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
                  onPressed: () {
                    Navigator.pop(context, "back");
                  },
                ),
                title: TextView.headingWhiteText(
                    text: AppStrings.editProfile, context: context),
              ),

              // body
              body: model.hasError
                  ? CommonWidgets()
                      .inAppErrorWidget(model.modelError.toString(), () {
                      model.initialise();
                    }, context: context)
                  : model.initialised == false
                      ? CommonWidgets().inPageLoader()
                      : ListView(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            // Cover and profile photo
                            profileImageView(model),
                            UiSpacer.verticalSpace(
                                space: AppSizes().widgetSize.normalPadding,
                                context: context),

                            Padding(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // name view
                                  nameView(model),
                                  UiSpacer.verticalSpace(
                                      space:
                                          AppSizes().widgetSize.normalPadding,
                                      context: context),

                                  // phone field
                                  phoneField(model),
                                  UiSpacer.verticalSpace(
                                      space:
                                          AppSizes().widgetSize.normalPadding,
                                      context: context),

                                  // Host since view
                                  hostSinceView(model),
                                  UiSpacer.verticalSpace(
                                      space:
                                          AppSizes().widgetSize.normalPadding,
                                      context: context),

                                  pronounView(model),
                                  UiSpacer.verticalSpace(
                                      space:
                                          AppSizes().widgetSize.normalPadding,
                                      context: context),

                                  describeYourself(model),
                                  UiSpacer.verticalSpace(
                                      space:
                                          AppSizes().widgetSize.normalPadding,
                                      context: context),

                                  // activities
                                  activitiesView(model),
                                  UiSpacer.verticalSpace(
                                      space:
                                          AppSizes().widgetSize.normalPadding,
                                      context: context),

                                  // country state city
                                  countryCityField(model),
                                  UiSpacer.verticalSpace(
                                      space:
                                          AppSizes().widgetSize.normalPadding,
                                      context: context),

                                  // Zipcode
                                  CustomTextField(
                                    textEditingController: model.zipcodeTEC,
                                    headingText: "Zipcode",
                                    hintText: "Enter zipcode",
                                  ),
                                  UiSpacer.verticalSpace(
                                      space:
                                          AppSizes().widgetSize.normalPadding,
                                      context: context),

                                  // upload ID proof
                                  uploadIdProofView(model),
                                  UiSpacer.verticalSpace(
                                      space:
                                          AppSizes().widgetSize.normalPadding,
                                      context: context),

                                  // save button
                                  SizedBox(
                                    height: screenHeight * 0.06,
                                    width: screenWidth,
                                    child: CommonButton.commonBoldTextButton(
                                      context: context,
                                      text: "Save",
                                      isButtonEnable: true,
                                      onPressed: () {
                                        if (model.validate()) {
                                          model.updateGuideProfileAPI();
                                        }
                                      },
                                    ),
                                  ),
                                  UiSpacer.verticalSpace(
                                      context: context, space: 0.02),

                                  // delete account button
                                  SizedBox(
                                    height: screenHeight * 0.06,
                                    width: screenWidth,
                                    child: CommonButton.commonBoldTextButton(
                                      context: context,
                                      text: "Delete Account",
                                      isButtonEnable: true,
                                      onPressed: () {
                                        GlobalUtility.showDialogFunction(
                                            context,
                                            DialogDeleteAccount(
                                                from: "guide_delete",
                                                cancelText:
                                                    AppStrings().logoutNo,
                                                headingText:
                                                    AppStrings().deleteAcc,
                                                okayText:
                                                    AppStrings().logoutYes,
                                                subContent: AppStrings()
                                                    .deleteHeading));
                                      },
                                      bgColor: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
            ),
          );
        });
  }

  Widget profileImageView(EditGuideProfileModel model) {
    return Container(
      height: screenHeight * 0.44,
      child: Stack(
        children: [
          Container(
            height: screenHeight * 0.4,
            width: screenWidth,
            child: model.coverImgLocal != null
                ? Image.file(
                    File(model.coverImgLocal ?? ""),
                    fit: BoxFit.cover,
                  )
                : CommonImageView.rectangleNetworkImage(
                    imgUrl: model.coverImgUrl ?? "",
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CircleAvatar(
              radius: screenWidth * 0.17,
              child: Stack(
                children: [
                  Container(
                    width: screenWidth * 0.35,
                    height: screenWidth * 0.35,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      border: Border.all(
                          color: AppColor.buttonDisableColor, width: 3),
                      shape: BoxShape.circle,
                    ),
                    child: model.profileImgLocal != null
                        ? Image.file(
                            File(model.profileImgLocal ?? ""),
                            fit: BoxFit.cover,
                          )
                        : model.profileImgUrl != null &&
                                model.profileImgUrl != ""
                            ? CommonImageView.roundNetworkImage(
                                imgUrl: model.profileImgUrl,
                              )
                            : Image.asset(
                                AppImages().pngImages.icProfilePlaceholder),
                  ),
                  Positioned(
                      right: screenHeight * 0.015,
                      bottom: screenHeight * 0.015,
                      child: InkWell(
                        onTap: () {
                          CommonImageView.chooseImageDialog(
                              context: context,
                              onTapGallery: () async {
                                Navigator.pop(context);
                                String? pickedFile =
                                    await CommonImageView.pickFromGallery();
                                if (pickedFile != null) {
                                  model.profileImgLocal = pickedFile;
                                  model.notifyListeners();
                                }
                              },
                              onTapCamera: () async {
                                Navigator.pop(context);
                                String? pickedFile =
                                    await CommonImageView.pickFromCamera();
                                if (pickedFile != null) {
                                  model.profileImgLocal = pickedFile;
                                  model.notifyListeners();
                                }
                              });
                        },
                        child: Container(
                            width: screenHeight * 0.04,
                            height: screenHeight * 0.04,
                            decoration: BoxDecoration(
                              color: AppColor.appthemeColor,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                AppImages().svgImages.icCameraOutline,
                              ),
                            )),
                      )),
                ],
              ),
            ),
          ),
          model.coverImgUrl == null
              ? Positioned(
                  top: screenWidth * 0.04,
                  right: screenWidth * 0.04,
                  child: InkWell(
                    onTap: () {
                      CommonImageView.chooseImageDialog(
                          context: context,
                          onTapGallery: () async {
                            Navigator.pop(context);
                            String? pickedFile =
                                await CommonImageView.pickFromGallery();
                            if (pickedFile != null) {
                              model.coverImgLocal = pickedFile;
                              model.updateCoverImageAPI();
                            }
                          },
                          onTapCamera: () async {
                            Navigator.pop(context);
                            String? pickedFile =
                                await CommonImageView.pickFromCamera();
                            if (pickedFile != null) {
                              model.coverImgLocal = pickedFile;
                              model.updateCoverImageAPI();
                            }
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.greyColor500,
                      ),
                      child: TextView.mediumText(
                        context: context,
                        text: "Upload cover photo",
                        textColor: AppColor.whiteColor,
                      ),
                    ),
                  ))
              : Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                      onPressed: () {
                        model.removeCoverImageAPI();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      )),
                ),
        ],
      ),
    );
  }

  /// NAME VIEW
  Widget nameView(EditGuideProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // first name
        CustomTextField(
          textEditingController: model.firstNameTEC,
          hintText: "First name",
          headingText: "First Name",
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.normalPadding, context: context),

        // last name
        CustomTextField(
          textEditingController: model.lastNameTEC,
          hintText: "Last name",
          headingText: "Last Name",
        ),
      ],
    );
  }

  /// HOST SINCE
  Widget hostSinceView(EditGuideProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Host since text
        TextView.mediumText(
          context: context,
          text: "Host Since",
          textColor: AppColor.greyColor,
          textSize: AppSizes().fontSize.simpleFontSize,
        ),
        UiSpacer.verticalSpace(space: 0.01, context: context),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: model.hostSinceYearTEC,
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
                controller: model.hostSinceMonthTEC,
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
      ],
    );
  }

  /// PRONOUNS
  Widget pronounView(EditGuideProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.mediumText(
          context: context,
          text: "Pronouns(optional)",
          textColor: AppColor.greyColor,
          textSize: AppSizes().fontSize.simpleFontSize,
        ),
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
              setState(() {});
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

  /// describe yourself
  Widget describeYourself(EditGuideProfileModel model) {
    return CustomTextField(
      textEditingController: model.bioTEC,
      headingText: "Bio",
      hintText: "Enter your bio",
      minLines: 5,
      maxLines: 5,
    );
  }

  Widget activitiesView(EditGuideProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.mediumText(
          context: context,
          text: "Activities",
          textColor: AppColor.greyColor,
          textSize: AppSizes().fontSize.simpleFontSize,
        ),
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

  Widget countryCityField(EditGuideProfileModel model) {
    return ValueListenableBuilder(
      valueListenable: model.destinationNotifier,
      builder: (context, value, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // country
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView.mediumText(
                  context: context,
                  text: "Country",
                  textColor: AppColor.greyColor,
                  textSize: AppSizes().fontSize.simpleFontSize,
                ),
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
                            return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
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
                                            if (model.countryNameTEC.text !=
                                                tempCountryList[index]) {
                                              model.countryNameTEC.text =
                                                  tempCountryList[index];
                                              model.stateNameTEC.clear();
                                              model.cityNameTEC.clear();
                                            } else {
                                              model.countryNameTEC.text =
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
                        ).whenComplete(() {
                          // onCreateProfileValueChanged(model);
                          // setState(() {});
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
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -3),
                      title: Text(model.countryNameTEC.text == ""
                          ? "Select Country"
                          : model.countryNameTEC.text),
                      titleTextStyle: TextStyle(
                          color: AppColor.lightBlack,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: screenHeight *
                              AppSizes().fontSize.simpleFontSize),
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
                TextView.mediumText(
                  context: context,
                  text: "State",
                  textColor: AppColor.greyColor,
                  textSize: AppSizes().fontSize.simpleFontSize,
                ),
                UiSpacer.verticalSpace(space: 0.01, context: context),
                GestureDetector(
                  onTap: () {
                    if (model.countryNameTEC.text.isEmpty) {
                      GlobalUtility.showToast(context, "Please Select country");
                    } else {
                      model
                          .getLocationApi(
                              viewContext: context,
                              countryId: model.countryNameTEC.text,
                              stateId: "")
                          .then((value) {
                        if (value == true) {
                          List<String> tempStateList = model.stateList;

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (cxt) {
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
                                            tempStateList = model.stateList
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
                                              if (model.stateNameTEC.text !=
                                                  tempStateList[index]) {
                                                model.stateNameTEC.text =
                                                    tempStateList[index];
                                                model.cityNameTEC.clear();
                                              } else {
                                                model.stateNameTEC.text =
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
                          ).whenComplete(() {
                            // onCreateProfileValueChanged(model);
                            // setState(() {});
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
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -3),
                      title: Text(model.stateNameTEC.text == ""
                          ? "Select State"
                          : model.stateNameTEC.text),
                      titleTextStyle: TextStyle(
                          color: AppColor.lightBlack,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: screenHeight *
                              AppSizes().fontSize.simpleFontSize),
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
                TextView.mediumText(
                  context: context,
                  text: "City",
                  textColor: AppColor.greyColor,
                  textSize: AppSizes().fontSize.simpleFontSize,
                ),
                UiSpacer.verticalSpace(space: 0.01, context: context),
                GestureDetector(
                  onTap: () {
                    if (model.countryNameTEC.text.isEmpty) {
                      GlobalUtility.showToast(context, "Please Select country");
                    } else if (model.stateNameTEC.text.isEmpty) {
                      GlobalUtility.showToast(context, "Please Select State");
                    } else {
                      model
                          .getLocationApi(
                              viewContext: context,
                              countryId: model.countryNameTEC.text,
                              stateId: model.stateNameTEC.text)
                          .then((value) {
                        if (value == true) {
                          List<String> tempCityList = model.cityList;

                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            enableDrag: true,
                            builder: (cxt) {
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
                                              model.cityNameTEC.text =
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
                          ).whenComplete(() {
                            // onCreateProfileValueChanged(model);
                            // setState(() {});
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
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -3),

                      // contentPadding: EdgeInsets.zero,
                      title: Text(model.cityNameTEC.text == ""
                          ? "Select City"
                          : model.cityNameTEC.text),
                      titleTextStyle: TextStyle(
                          color: AppColor.lightBlack,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: screenHeight *
                              AppSizes().fontSize.simpleFontSize),
                      trailing: const Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Phone number field
  Widget phoneField(EditGuideProfileModel model) {
    return CustomTextField(
      textEditingController: model.phoneTEC,
      headingText: "Phone Number",
      prefixWidget: Row(
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
                    // model.countryCode = model.countryCode == ""
                    //     ? "+1"
                    //     : '+ ${country.phoneCode}';
                    //
                    // model.countryCodeIso = model.countryCodeIso == ""
                    //     ? "In"
                    //     : '+ ${country.countryCode}';
                    // model.counterNotifier.notifyListeners();
                    // debugPrint(
                    //     "country.phoneCode --- ${country.phoneCode}-- ${country.countryCode}");
                  },
                );
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 8),
                    child: Text(model.countryCode),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child:
                          SvgPicture.asset(AppImages().svgImages.chevronDown)),
                ],
              ),
            ),
          ]),
      hintText: "Enter phone number",
      inputFormatter: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }

  // Upload ID proof
  Widget uploadIdProofView(EditGuideProfileModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.mediumText(
          context: context,
          text: "Upload Id Proof",
          textColor: AppColor.greyColor,
          textSize: AppSizes().fontSize.simpleFontSize,
        ),
        UiSpacer.verticalSpace(context: context, space: 0.01),
        if (model.documentsList.length < 4)
          InkWell(
            onTap: () {
              if (model.documentsList.length < 4) {
                CommonImageView.chooseImageDialog(
                  context: context,
                  onTapGallery: () async {
                    Navigator.pop(context);
                    String? pickedFile =
                        await CommonImageView.pickFromGallery();
                    if (pickedFile != null) {
                      model.documentsList.add(DocumentsModel(
                          documentPath: pickedFile, isLocal: true));
                      model.notifyListeners();
                    }
                  },
                  onTapCamera: () async {
                    Navigator.pop(context);
                    String? pickedFile = await CommonImageView.pickFromCamera();
                    if (pickedFile != null) {
                      model.documentsList.add(DocumentsModel(
                          documentPath: pickedFile, isLocal: true));
                      model.notifyListeners();
                    }
                  },
                );
              } else {
                GlobalUtility.showToast(
                    context, "You can only upload maximum 4 documents");
              }
            },
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: DottedDecoration(
                color: AppColor.greyColor,
                shape: Shape.box,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages().svgImages.icUpload),
                  UiSpacer.horizontalSpace(context: context, space: 0.04),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          TextView.mediumText(
                            context: context,
                            text: "Click to upload",
                            textSize: 0.02,
                            textColor: AppColor.appthemeColor,
                          ),
                          UiSpacer.horizontalSpace(
                              context: context, space: 0.02),
                          TextView.mediumText(
                            context: context,
                            text: "or drag and drop",
                            textSize: 0.018,
                            textColor: AppColor.greyColor500,
                          ),
                        ],
                      ),
                      UiSpacer.verticalSpace(context: context, space: 0.01),
                      TextView.mediumText(
                        context: context,
                        text: "PNG or JPG(max. 800x400px)",
                        textSize: 0.018,
                        textColor: AppColor.greyColor500,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        if (model.documentsList.length < 4)
          UiSpacer.verticalSpace(context: context, space: 0.02),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: screenWidth * 0.04,
            alignment: WrapAlignment.start,
            children: model.documentsList.asMap().entries.map((e) {
              int index = e.key;
              return Container(
                width: screenWidth * 0.2,
                height: screenWidth * 0.2,
                decoration: BoxDecoration(
                  color: AppColor.greyColor500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: AppColor.greyColor),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                          child: e.value.isLocal == false
                              ? CommonImageView.rectangleNetworkImage(
                                  imgUrl: e.value.documentPath)
                              : Image.file(File(e.value.documentPath))),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () {
                          if (e.value.isLocal == true) {
                            model.documentsList.removeAt(index);
                          } else {
                            model.deleteDocumentAPI(
                                index: e.key, documentId: e.value.id);
                          }
                          model.notifyListeners();
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              AppColor.greyColor500.withOpacity(0.4),
                          child: Icon(
                            CupertinoIcons.trash,
                            color: AppColor.whiteColor,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
