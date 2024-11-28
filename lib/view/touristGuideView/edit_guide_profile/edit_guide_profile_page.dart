import 'package:Siesta/custom_widgets/custom_textfield.dart';
import 'package:Siesta/view_models/guide_profile_model/edit_guide_profile_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_fonts.dart';
import '../../../app_constants/app_images.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../app_constants/app_strings.dart';
import '../../../common_widgets/common_imageview.dart';
import '../../../common_widgets/common_textview.dart';
import '../../../common_widgets/vertical_size_box.dart';
import '../../../utility/globalUtility.dart';

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

    return Scaffold(
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
            text: AppStrings.editProfile, context: context),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Cover and profile photo
          profileImageView(AppImages().dummyImage),
          UiSpacer.verticalSpace(
              space: AppSizes().widgetSize.normalPadding, context: context),

          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name view
                nameView(),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding,
                    context: context),

                // Host since view
                hostSinceView(),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding,
                    context: context),

                pronounView(),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding,
                    context: context),

                describeYourself(),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding,
                    context: context),

                // countryCityField(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget profileImageView(img) {
    return Container(
      height: screenHeight * 0.44,
      child: Stack(
        children: [
          Container(
            height: screenHeight * 0.4,
            width: screenWidth,
            child: CommonImageView.rectangleNetworkImage(imgUrl: img),
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
                          image: img != null && img != ""
                              ? DecorationImage(
                                  fit: BoxFit.fill, image: NetworkImage(img))
                              : DecorationImage(
                                  image: AssetImage(AppImages()
                                      .pngImages
                                      .icProfilePlaceholder)))),
                  Positioned(
                      right: 5,
                      bottom: 5,
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
                          )))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// NAME VIEW
  Widget nameView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // first name
        CustomTextField(
          hintText: "First name",
          headingText: "First Name",
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.normalPadding, context: context),

        // last name
        CustomTextField(
          hintText: "Last name",
          headingText: "Last Name",
        ),
      ],
    );
  }

  /// HOST SINCE
  Widget hostSinceView() {
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
                controller: TextEditingController(text: "1"),
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
                            // model.decreaseHostValue("year");
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
                            // model.increaseHostValue("year");
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
                controller: TextEditingController(text: "1"),
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
                            // model.decreaseHostValue("month");
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
                            // model.increaseHostValue("month");
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

  String? selectedPronounValue;
  List<String> pronounsList = ["He/Him", "She/Her"];

  /// PRONOUNS
  Widget pronounView() {
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
            value: selectedPronounValue,
            onChanged: (value) {
              selectedPronounValue = value;
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
                child: Text(pronounsList[0]),
                value: pronounsList[0],
              ),
              DropdownMenuItem(
                child: Text(pronounsList[1]),
                value: pronounsList[1],
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

  ///describe yourself
  Widget describeYourself() {
    return CustomTextField(
      headingText: "Bio",
      hintText: "Enter your bio",
      minLines: 5,
      maxLines: 5,
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
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          builder: (cxt) {
                            return Padding(
                                padding:
                                    EdgeInsets.only(top: screenHeight * 0.03),
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
                                    },
                                    title: Text(model.countryList[index]),
                                  ),
                                )));
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
                      title: Text(model.countryNameController.text == ""
                          ? "Select Country"
                          : model.countryNameController.text),
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
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            builder: (cxt) {
                              return Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight * 0.03),
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
                                        if (model.stateNameController.text !=
                                            model.stateList[index]) {
                                          model.stateNameController.text =
                                              model.stateList[index];
                                          model.cityNameController.clear();
                                        }
                                        Navigator.pop(cxt);
                                      },
                                      title: Text(model.stateList[index]),
                                    ),
                                  )));
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
                      title: Text(model.stateNameController.text == ""
                          ? "Select State"
                          : model.stateNameController.text),
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
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: model.cityList.length,
                                    itemBuilder: (context, index) => ListTile(
                                      onTap: () {
                                        model.cityNameController.text =
                                            model.cityList[index];
                                        Navigator.pop(cxt);
                                      },
                                      title: Text(model.cityList[index]),
                                    ),
                                  )));
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
                      title: Text(model.cityNameController.text == ""
                          ? "Select City"
                          : model.cityNameController.text),
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
}
