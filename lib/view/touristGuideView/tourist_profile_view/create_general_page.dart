import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/custom_widgets/custom_textfield.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_fonts.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../app_constants/app_strings.dart';
import '../../../common_widgets/common_textview.dart';

class CreateGeneralPage extends StatefulWidget {
  const CreateGeneralPage({super.key, required this.argData});
  final Map<String, dynamic> argData;

  @override
  State<CreateGeneralPage> createState() => _CreateGeneralPageState();
}

class _CreateGeneralPageState extends State<CreateGeneralPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  List<ActivitiesModel> activitiesList = [
    ActivitiesModel(id: 1, title: "Bar"),
    ActivitiesModel(id: 2, title: "Restaurant"),
    ActivitiesModel(id: 3, title: "Cycling"),
    ActivitiesModel(id: 4, title: "Travelling"),
    ActivitiesModel(id: 5, title: "Sightseeing"),
  ];
  String? selectedValue;

  String screenType = "create";

  @override
  void initState() {
    screenType = widget.argData["screenType"] ?? "create";
    super.initState();
  }

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
          title: screenType == "create"
              ? TextView.headingWhiteText(
                  text: widget.argData["type"] == "gallery"
                      ? AppStrings.createGallery
                      : widget.argData["type"] == "experience"
                          ? AppStrings.createExperience
                          : AppStrings.createGeneral,
                  context: context)
              : TextView.headingWhiteText(
                  text: widget.argData["type"] == "gallery"
                      ? AppStrings.createGallery
                      : widget.argData["type"] == "experience"
                          ? AppStrings.createExperience
                          : AppStrings.createGeneral,
                  context: context),
        ),

        // save button
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(screenWidth * 0.04),
          child: CommonButton.commonBoldTextButton(
            context: context,
            text: "Save",
            onPressed: () {},
            // isButtonEnable: true,
          ),
        ),

        // body
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(screenWidth * 0.04),
          children: [
            // title text field
            CustomTextField(hintText: "Enter title", headingText: "Title"),
            UiSpacer.verticalSpace(context: context, space: 0.02),

            if (widget.argData["type"] == "general" ||
                widget.argData["type"] == "experience")
              selectActivitiesDropdown(),
            if (widget.argData["type"] == "general" ||
                widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            CustomTextField(
              hintText: "Enter location",
              headingText: "Location",
              suffixIconPath: AppImages().svgImages.icLocation,
            ),
            UiSpacer.verticalSpace(context: context, space: 0.02),

            if (widget.argData["type"] == "general" ||
                widget.argData["type"] == "experience")
              priceView(),
            if (widget.argData["type"] == "general" ||
                widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            // detailed schedule
            if (widget.argData["type"] == "experience")
              CustomTextField(
                hintText: "Enter schedule of the trip",
                headingText: "Detailed Schedule",
              ),
            if (widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            // Transport Type
            if (widget.argData["type"] == "experience")
              CustomTextField(
                hintText: "Enter transport type",
                headingText: "Transport Type",
                suffixIconPath: AppImages().svgImages.icCar,
              ),
            if (widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            // Accessibility
            if (widget.argData["type"] == "experience")
              CustomTextField(
                hintText: "Select accessibility",
                headingText: "Accessibility",
                suffixWidget: Switch(
                  value: true,
                  activeColor: AppColor.appthemeColor,
                  onChanged: (value) {},
                ),
              ),
            if (widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            // Maximum People
            if (widget.argData["type"] == "experience")
              CustomTextField(
                hintText: "Enter max no. of people",
                headingText: "Maximum People",
                keyboardType: TextInputType.number,
              ),
            if (widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            // Minimum People
            if (widget.argData["type"] == "experience")
              CustomTextField(
                hintText: "Enter min no. of people",
                headingText: "Minimum People",
                keyboardType: TextInputType.number,
              ),
            if (widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            // Starting Time
            if (widget.argData["type"] == "experience")
              CustomTextField(
                hintText: "Select starting time",
                headingText: "Starting Time",
                readOnly: true,
                onTap: () {
                  // code for time picker
                },
              ),
            if (widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            // Duration
            if (widget.argData["type"] == "experience")
              CustomTextField(
                hintText: "Enter duration",
                headingText: "Duration",
              ),
            if (widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            // Meeting Point
            if (widget.argData["type"] == "experience")
              CustomTextField(
                hintText: "Enter meeting point",
                headingText: "Meeting Point",
              ),
            if (widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            // Drop-off Point
            if (widget.argData["type"] == "experience")
              CustomTextField(
                hintText: "Enter drop-off point",
                headingText: "Drop-off Point",
              ),
            if (widget.argData["type"] == "experience")
              UiSpacer.verticalSpace(context: context, space: 0.02),

            CustomTextField(
              hintText: "Enter description",
              headingText: "Description",
              minLines: 1,
              maxLines: 7,
            ),
            UiSpacer.verticalSpace(context: context, space: 0.02),

            // Upload Images view
            uploadImagesView(),
          ],
        ));
  }

  Widget priceView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.mediumText(
          context: context,
          text: "Price (Per Person)",
          textColor: AppColor.greyColor,
          textSize: 0.018,
          textAlign: TextAlign.start,
        ),
        UiSpacer.verticalSpace(space: 0.005, context: context),
        TextView.mediumText(
          context: context,
          text: "(Siesta will deduct 16% commission)",
          textColor: AppColor.greyColor500,
          textSize: 0.014,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        CustomTextField(
          hintText: "Enter price",
          suffixIconPath: AppImages().svgImages.icDollar,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget selectActivitiesDropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.mediumText(
          context: context,
          text: "Activities",
          textColor: AppColor.greyColor,
          textSize: 0.018,
          textAlign: TextAlign.start,
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
            value: activitiesList.isEmpty
                ? null
                : activitiesList.last.id.toString(),
            onChanged: (value) {
              selectedValue = value;
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
            items: activitiesList.map((item) {
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
            selectedItemBuilder: (context) {
              return activitiesList.map(
                (item) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      activitiesList
                          .where((activity) =>
                              activity.isSelect) // Filter selected activities
                          .map((activity) => activity.title) // Extract titles
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
            },
          ),
        ),
      ],
    );
  }

  Widget uploadImagesView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Image
        Wrap(
          children: [
            TextView.mediumText(
              context: context,
              text: "Add Picture",
              textColor: AppColor.greyColor,
              textSize: 0.018,
              textAlign: TextAlign.start,
            ),
            SizedBox(width: 5),
            TextView.mediumText(
              context: context,
              text: "(File size must not exceed 50 MB)",
              textColor: AppColor.greyColor,
              textSize: 0.016,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        Container(
          width: double.infinity,
          height: screenHeight * 0.3,
          decoration: DottedDecoration(
            shape: Shape.box,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppImages().svgImages.icUploadImage),
              UiSpacer.verticalSpace(space: 0.02, context: context),
              TextView.mediumText(
                context: context,
                text: "Click here to upload",
                textColor: AppColor.greyColor,
                textSize: 0.018,
              )
            ],
          ),
        ),

        UiSpacer.verticalSpace(space: 0.02, context: context),

        // Additional Images

        Wrap(
          children: [
            TextView.mediumText(
              context: context,
              text: "Add Additional Images or Videos",
              textColor: AppColor.greyColor,
              textSize: 0.018,
              textAlign: TextAlign.start,
            ),
            SizedBox(width: 5),
            TextView.mediumText(
              context: context,
              text: "(File size must not exceed 50 MB)",
              textColor: AppColor.greyColor,
              textSize: 0.016,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        UiSpacer.verticalSpace(space: 0.01, context: context),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: screenWidth * 0.04,
            alignment: WrapAlignment.start,
            children: [1, 2, 3, 4].asMap().entries.map((e) {
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
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColor.greyColor500.withOpacity(0.4),
                        child: Icon(
                          CupertinoIcons.trash,
                          color: AppColor.whiteColor,
                          size: 15,
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

class ActivitiesModel {
  String title;
  int id;
  bool isSelect;
  ActivitiesModel(
      {required this.id, required this.title, this.isSelect = false});
}
