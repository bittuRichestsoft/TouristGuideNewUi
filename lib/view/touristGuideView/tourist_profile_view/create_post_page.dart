import 'dart:io';

import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/decimal_formatter.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/custom_widgets/custom_textfield.dart';
import 'package:Siesta/view_models/gallery_general_experience_models/create_post_model.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_fonts.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../app_constants/app_strings.dart';
import '../../../common_widgets/common_textview.dart';
import '../../../utility/globalUtility.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key, required this.argData});
  final Map<String, dynamic> argData;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  double screenWidth = 0.0, screenHeight = 0.0;

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

    return ViewModelBuilder<CreatePostModel>.reactive(
        viewModelBuilder: () => CreatePostModel(
            type: widget.argData["type"], argData: widget.argData),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: AppColor.appthemeColor),
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
                            ? AppStrings.editGallery
                            : widget.argData["type"] == "experience"
                                ? AppStrings.editExperience
                                : AppStrings.editGeneral,
                        context: context),
              ),

              // save button
              bottomNavigationBar: Container(
                margin: EdgeInsets.all(screenWidth * 0.04),
                child: CommonButton.commonBoldTextButton(
                  context: context,
                  text: "Save",
                  onPressed: () async {
                    debugPrint("Latutude : ${model.latitude}");
                    if (widget.argData["type"] == "experience" &&
                        model.validateExperience()) {
                      // debugPrint(
                      //     " ${File(model.documentsList[0].documentPath).readAsBytesSync()}");
                      // model.createExperienceUsingDio();
                      model.createExperienceAPI();
                    } else if (widget.argData["type"] == "general" &&
                        model.validateGeneral()) {
                      model.createGeneralAPI();
                    } else if (widget.argData["type"] == "gallery" &&
                        model.validateGallery()) {
                      model.createGalleryAPI();
                    }
                  },
                  isButtonEnable: true,
                ),
              ),

              // body
              body: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(screenWidth * 0.04),
                children: [
                  // title text field
                  CustomTextField(
                    textEditingController: model.titleTEC,
                    hintText: "Enter title",
                    headingText: "Title",
                  ),
                  UiSpacer.verticalSpace(context: context, space: 0.02),

                  if (widget.argData["type"] == "general" ||
                      widget.argData["type"] == "experience")
                    selectActivitiesDropdown(model),
                  if (widget.argData["type"] == "general" ||
                      widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  CustomTextField(
                    textEditingController: model.locationTEC,
                    hintText: "Enter location",
                    headingText: "Location",
                    suffixIconPath: AppImages().svgImages.icLocation,
                    onTap: () {
                      if (model.locationTEC.text.isNotEmpty) {
                        model.isPlaceListShow = true;
                        model.notifyListeners();
                      }
                    },
                    onChange: (value) async {
                      model.latitude = null;
                      model.longitude = null;
                      await model.searchLocation(value);
                    },
                  ),
                  if (model.isPlaceListShow == true)
                    Container(
                      // height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: model.placeList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              model.onClickSuggestion(index);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04, vertical: 6),
                              child: TextView.mediumText(
                                context: context,
                                text: model.placeList[index]["description"],
                                textAlign: TextAlign.start,
                                textColor: AppColor.greyColor,
                                textSize: 0.016,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey,
                            height: 1,
                            indent: screenWidth * 0.04,
                            endIndent: screenWidth * 0.04,
                          );
                        },
                      ),
                    ),
                  UiSpacer.verticalSpace(context: context, space: 0.02),

                  if (widget.argData["type"] == "general" ||
                      widget.argData["type"] == "experience")
                    priceView(model),

                  // detailed schedule
                  if (widget.argData["type"] == "experience")
                    CustomTextField(
                      textEditingController: model.scheduleTEC,
                      hintText: "Enter schedule of the trip",
                      headingText: "Detailed Schedule",
                    ),
                  if (widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  // Transport Type
                  if (widget.argData["type"] == "experience")
                    CustomTextField(
                      textEditingController: model.transportTypeTEC,
                      hintText: "Enter transport type",
                      headingText: "Transport Type",
                      suffixIconPath: AppImages().svgImages.icCar,
                    ),
                  if (widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  // Accessibility
                  if (widget.argData["type"] == "experience")
                    CustomTextField(
                      readOnly: true,
                      hintText: "Select accessibility",
                      headingText: "Accessibility",
                      suffixWidget: Switch(
                        value: model.accessibility,
                        activeColor: AppColor.appthemeColor,
                        onChanged: (value) {
                          model.accessibility = value;
                          model.notifyListeners();
                        },
                      ),
                    ),
                  if (widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  // Maximum People
                  if (widget.argData["type"] == "experience")
                    CustomTextField(
                      textEditingController: model.maximumPeopleTEC,
                      hintText: "Enter max no. of people",
                      headingText: "Maximum People",
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  if (widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  // Minimum People
                  if (widget.argData["type"] == "experience")
                    CustomTextField(
                      textEditingController: model.minimumPeopleTEC,
                      hintText: "Enter min no. of people",
                      headingText: "Minimum People",
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  if (widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  // Starting Time
                  if (widget.argData["type"] == "experience")
                    CustomTextField(
                      textEditingController: model.startingTimeTEC,
                      hintText: "Select starting time",
                      headingText: "Starting Time",
                      readOnly: true,
                      onTap: () async {
                        // code for time picker
                        TimeOfDay? pickedTime = await showTimePicker(
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

                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final dateTime = DateTime.utc(now.year, now.month,
                              now.day, pickedTime.hour, pickedTime.minute);
                          model.startingTimeValue = dateTime.toIso8601String();

                          final localizations =
                              MaterialLocalizations.of(context);
                          final formattedTimeOfDay =
                              localizations.formatTimeOfDay(pickedTime);
                          model.startingTimeTEC.text = formattedTimeOfDay;
                        }
                      },
                    ),
                  if (widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  // Duration
                  if (widget.argData["type"] == "experience")
                    CustomTextField(
                      textEditingController: model.durationTEC,
                      hintText: "Enter duration",
                      headingText: "Duration",
                    ),
                  if (widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  // Meeting Point
                  if (widget.argData["type"] == "experience")
                    CustomTextField(
                      textEditingController: model.meetingPointTEC,
                      hintText: "Enter meeting point",
                      headingText: "Meeting Point",
                    ),
                  if (widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  // Drop-off Point
                  if (widget.argData["type"] == "experience")
                    CustomTextField(
                      textEditingController: model.dropOffPointTEC,
                      hintText: "Enter drop-off point",
                      headingText: "Drop-off Point",
                    ),
                  if (widget.argData["type"] == "experience")
                    UiSpacer.verticalSpace(context: context, space: 0.02),

                  CustomTextField(
                    textEditingController: model.descriptionTEC,
                    hintText: "Enter description",
                    headingText: "Description",
                    minLines: 1,
                    maxLines: 7,
                  ),
                  UiSpacer.verticalSpace(context: context, space: 0.02),

                  // Upload Images view
                  uploadImagesView(model),
                ],
              ));
        });
  }

  Widget priceView(CreatePostModel model) {
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
          textEditingController: model.priceTEC,
          hintText: "Enter price",
          suffixIconPath: AppImages().svgImages.icDollar,
          keyboardType: TextInputType.number,
          inputFormatter: [
            DecimalTextInputFormatter(decimalRange: 2, integerRange: 7)
          ],
        ),
        UiSpacer.verticalSpace(context: context, space: 0.02),
      ],
    );
  }

  Widget selectActivitiesDropdown(CreatePostModel model) {
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
            value: model.activitiesList.isEmpty
                ? null
                : model.activitiesList.last.id.toString(),
            onChanged: (value) {
              // selectedValue = value;
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
            selectedItemBuilder: (context) {
              return model.activitiesList.map(
                (item) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      model.activitiesList
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

  Widget uploadImagesView(CreatePostModel model) {
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
        InkWell(
          onTap: () {
            CommonImageView.chooseImageDialog(
              context: context,
              onTapGallery: () async {
                Navigator.pop(context);
                String? pickedFile = await CommonImageView.pickFromGallery();
                if (pickedFile != null) {
                  model.heroImageLocal = pickedFile;
                  model.notifyListeners();
                }
              },
              onTapCamera: () async {
                Navigator.pop(context);
                String? pickedFile = await CommonImageView.pickFromCamera();
                if (pickedFile != null) {
                  model.heroImageLocal = pickedFile;
                  model.notifyListeners();
                }
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.3,
              decoration: DottedDecoration(
                shape: Shape.box,
                borderRadius: BorderRadius.circular(10),
              ),
              child: model.heroImageLocal != null
                  ? Image.file(
                      File(model.heroImageLocal ?? ""),
                      fit: BoxFit.cover,
                    ) : model.heroImageUrl != null ? CommonImageView.rectangleNetworkImage(imgUrl: model.heroImageUrl) :
                   Column(
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

        UiSpacer.verticalSpace(context: context, space: 0.02),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: screenWidth * 0.04,
            alignment: WrapAlignment.start,
            children: [
              ...model.documentsList.asMap().entries.map((e) {
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
                                : e.value.documentType == "image"
                                    ? Image.file(
                                        File(e.value.documentPath),
                                        fit: BoxFit.cover,
                                      )
                                    : Stack(
                                        children: [
                                          Image.memory(
                                            e.value.thumbnailPath!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                          Positioned(
                                              top: 5,
                                              left: 5,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2, horizontal: 5),
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColor.appthemeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: TextView.mediumText(
                                                  context: context,
                                                  textColor:
                                                      AppColor.whiteColor,
                                                  text: "Video",
                                                  textSize: 0.012,
                                                ),
                                              ))
                                        ],
                                      )),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () {
                            if (e.value.isLocal == true) {
                              model.documentsList.removeAt(index);
                            } else {
                              /*model.deleteDocumentAPI(
                                index: e.key, documentId: e.value.id);*/
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
              if (model.documentsList.length < 4)
                InkWell(
                  onTap: () async {
                    if (model.documentsList.length < 4) {
                      Map<String, dynamic>? pickedFile =
                          await CommonImageView.pickImageVideoFromGallery();
                      if (pickedFile != null) {
                        model.documentsList.add(DocumentsModel(
                          documentPath: pickedFile["filePath"],
                          documentType: pickedFile["contentType"],
                          thumbnailPath: pickedFile["thumbNailData"],
                          isLocal: true,
                        ));
                        model.notifyListeners();
                      }
                      /*CommonImageView.chooseImageDialog(
                        context: context,
                        onTapGallery: () async {
                          Navigator.pop(context);
                          Map<String, dynamic>? pickedFile =
                              await CommonImageView.pickImageVideoFromGallery();
                          if (pickedFile != null) {
                            model.documentsList.add(DocumentsModel(
                              documentPath: pickedFile["filePath"],
                              documentType: pickedFile["contentType"],
                              thumbnailPath: pickedFile["thumbNailData"],
                              isLocal: true,
                            ));
                            model.notifyListeners();
                          }
                        },
                        onTapCamera: () async {
                          Navigator.pop(context);
                          String? pickedFile =
                              await CommonImageView.pickFromCamera();
                          if (pickedFile != null) {
                            model.documentsList.add(DocumentsModel(
                                documentPath: pickedFile, isLocal: true));
                            model.notifyListeners();
                          }
                        },
                      );*/
                    } else {
                      GlobalUtility.showToast(
                          context, "You can only upload maximum 4 documents");
                    }
                  },
                  child: Container(
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: DottedDecoration(
                      color: AppColor.greyColor,
                      shape: Shape.box,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextView.mediumText(
                      context: context,
                      text: "Click to upload",
                      textSize: 0.014,
                      textAlign: TextAlign.center,
                      textColor: AppColor.appthemeColor,
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
