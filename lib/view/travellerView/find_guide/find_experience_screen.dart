import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/custom_widgets/custom_traveller_experience_tile.dart';
import 'package:Siesta/view_models/traveller_models/find_experience_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_fonts.dart';
import '../../../app_constants/app_images.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../common_widgets/common_button.dart';
import '../../../common_widgets/vertical_size_box.dart';
import '../../../custom_widgets/custom_textfield.dart';

class FindExperienceScreen extends StatefulWidget {
  const FindExperienceScreen({super.key});

  @override
  State<FindExperienceScreen> createState() => _FindExperienceScreenState();
}

class _FindExperienceScreenState extends State<FindExperienceScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => FindExperienceViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: Column(
              children: [
                // filter view
                filterView(model),

                // tab view
                tabBarView(model),
                UiSpacer.verticalSpace(context: context, space: 0.02),

                // Google Map
                model.tabVal == CustomTabValue.list
                    ? Expanded(child: listView(model))
                    : Expanded(child: mapView(model)),
              ],
            ),
          );
        });
  }

  Widget filterView(FindExperienceViewModel model) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // search field & filter view
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // width: screenWidth * 0.7,
                child: CustomTextField(
                  hintText: "Search by",
                  borderRadius: 50,
                  suffixWidget: Icon(
                    Icons.search,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(AppImages().svgImages.icFilter),
                onPressed: () {
                  showFilterSheet(model);
                },
              )
            ],
          ),
          UiSpacer.verticalSpace(context: context, space: 0.02),

          // Tags
          SizedBox(
            height: screenHeight * 0.045,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.01,
                    horizontal: screenWidth * 0.03,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColor.appthemeColor,
                  ),
                  child: TextView.mediumText(
                    context: context,
                    text: "Hiking",
                    textSize: 0.016,
                    textAlign: TextAlign.center,
                    textColor: AppColor.whiteColor,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return UiSpacer.horizontalSpace(context: context, space: 0.02);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBarView(FindExperienceViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Row(
        children: [
          // List
          Expanded(
            child: InkWell(
              onTap: () {
                model.onTapTab(CustomTabValue.list);
              },
              child: Container(
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: model.tabVal == CustomTabValue.list
                          ? AppColor.appthemeColor
                          : AppColor.greyColor500,
                      width: model.tabVal == CustomTabValue.map ? 1 : 0.5,
                    ),
                  ),
                ),
                child: Center(
                  child: TextView.mediumText(
                    context: context,
                    text: "List",
                    textColor: model.tabVal == CustomTabValue.list
                        ? AppColor.appthemeColor
                        : AppColor.greyColor500,
                  ),
                ),
              ),
            ),
          ),

          // Map
          Expanded(
            child: InkWell(
              onTap: () {
                model.onTapTab(CustomTabValue.map);
              },
              child: Container(
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: model.tabVal == CustomTabValue.map
                          ? AppColor.appthemeColor
                          : AppColor.greyColor500,
                      width: model.tabVal == CustomTabValue.map ? 1 : 0.5,
                    ),
                  ),
                ),
                child: Center(
                  child: TextView.mediumText(
                    context: context,
                    text: "Map",
                    textColor: model.tabVal == CustomTabValue.map
                        ? AppColor.appthemeColor
                        : AppColor.greyColor500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listView(FindExperienceViewModel model) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 5,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      // physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const CustomTravellerExperienceTile();
      },
      separatorBuilder: (context, index) {
        return UiSpacer.verticalSpace(context: context, space: 0.03);
      },
    );
  }

  Widget mapView(FindExperienceViewModel model) {
    return SizedBox(
      // height: screenHeight * 0.75,
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: model.initialCameraPosition,
            markers: model.markers,
            onMapCreated: (GoogleMapController controller) {
              model.mapController.complete(controller);
            },
            compassEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            buildingsEnabled: false,
            trafficEnabled: false,
            indoorViewEnabled: false,
            onTap: (argument) {
              model.showMapOverlayTile = false;
              model.notifyListeners();
            },
          ),
          if (model.showMapOverlayTile == true)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.all(screenWidth * 0.05),
                width: screenWidth,
                height: screenHeight * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.whiteColor,
                ),
                child: Row(
                  children: [
                    // image
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: SizedBox(
                        height: screenHeight,
                        width: screenWidth * 0.28,
                        child: CommonImageView.rectangleNetworkImage(
                          imgUrl: AppImages().dummyImage,
                        ),
                      ),
                    ),
                    UiSpacer.horizontalSpace(context: context, space: 0.04),

                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView.mediumText(
                            context: context,
                            text: AppStrings().dummyText,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            textColor: AppColor.greyColor600,
                            textSize: 0.018,
                          ),
                          UiSpacer.verticalSpace(context: context, space: 0.01),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextView.mediumText(
                                context: context,
                                text: "Price: ",
                                fontWeight: FontWeight.w400,
                                textColor: AppColor.greyColor500,
                                textSize: 0.016,
                              ),
                              TextView.mediumText(
                                context: context,
                                text: "\$1000",
                                fontWeight: FontWeight.w500,
                                textColor: AppColor.greyColor600,
                                textSize: 0.017,
                              ),
                              UiSpacer.horizontalSpace(
                                  context: context, space: 0.02),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppColor.greyColor600,
                                    size: 20,
                                  ),
                                  TextView.mediumText(
                                    context: context,
                                    text: "4.9",
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w400,
                                    textColor: AppColor.greyColor600,
                                    maxLines: 2,
                                    textSize: 0.016,
                                  )
                                ],
                              ),
                              UiSpacer.horizontalSpace(
                                  context: context, space: 0.02),
                              Container(
                                height: 5,
                                width: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.greyColor,
                                ),
                              ),
                              UiSpacer.horizontalSpace(
                                  context: context, space: 0.02),
                              Expanded(
                                child: TextView.mediumText(
                                  context: context,
                                  text: "5 days",
                                  textAlign: TextAlign.left,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColor.greyColor600,
                                  maxLines: 1,
                                  textSize: 0.016,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  void showFilterSheet(FindExperienceViewModel model) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.8,
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModelState) {
          return Padding(
            padding: EdgeInsets.only(
              top: screenWidth * 0.04,
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView.headingText(
                      context: context,
                      text: "Filters",
                      color: AppColor.greyColor600,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                    )
                  ],
                ),
                Divider(
                  color: AppColor.greyColor500,
                ),
                UiSpacer.verticalSpace(context: context, space: 0.01),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price range text
                        TextView.headingText(
                          context: context,
                          text: "Price Range",
                          color: AppColor.greyColor600,
                          fontSize: screenHeight * 0.022,
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.01),

                        // price desc text
                        Row(
                          children: [
                            TextView.mediumText(
                              context: context,
                              text: "The average experience price is",
                              fontWeight: FontWeight.w400,
                              textColor: AppColor.greyColor500,
                              textSize: 0.016,
                            ),
                            TextView.mediumText(
                              context: context,
                              text: "  \$1000",
                              fontWeight: FontWeight.w500,
                              textColor: AppColor.greyColor,
                              textSize: 0.018,
                            ),
                          ],
                        ),

                        // range slider
                        SfRangeSlider(
                          min: 0.0,
                          max: 10000.0,
                          values: model.priceRange,
                          enableTooltip: true,
                          stepSize: 1,
                          onChanged: (SfRangeValues values) {
                            setModelState(() {
                              model.priceRange = values;
                            });
                          },
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),

                        // min and max text field
                        CustomTextField(
                          borderRadius: 10,
                          isFilled: true,
                          fillColor: Color(0xffF3F8FF),
                          headingText: "From",
                          prefixWidget: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffDAE8FC),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              CupertinoIcons.money_dollar,
                              color: AppColor.greyColor600,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),

                        CustomTextField(
                          borderRadius: 10,
                          isFilled: true,
                          fillColor: Color(0xffF3F8FF),
                          headingText: "From",
                          prefixWidget: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffDAE8FC),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              CupertinoIcons.money_dollar,
                              color: AppColor.greyColor600,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),
                        Divider(
                          color: AppColor.greyColor500,
                        ),

                        // Rating and review
                        TextView.headingText(
                          context: context,
                          text: "Rating",
                          color: AppColor.greyColor600,
                          fontSize: screenHeight * 0.022,
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.01),
                        TextView.mediumText(
                          context: context,
                          text:
                              "Enter your rating to check different experiences accordingly.",
                          fontWeight: FontWeight.w400,
                          textColor: AppColor.greyColor500,
                          textSize: 0.016,
                          textAlign: TextAlign.left,
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextView.mediumText(
                              context: context,
                              text: "Set your rating",
                              fontWeight: FontWeight.w400,
                              textColor: AppColor.greyColor500,
                              textSize: 0.018,
                              textAlign: TextAlign.left,
                            ),
                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              glow: false,
                              itemSize: screenHeight * 0.04,
                              unratedColor: AppColor.greyColor500,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            )
                          ],
                        ),

                        Divider(
                          color: AppColor.greyColor500,
                        ),

                        // search by
                        TextView.headingText(
                          context: context,
                          text: "Search By",
                          color: AppColor.greyColor600,
                          fontSize: screenHeight * 0.022,
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.01),
                        TextView.mediumText(
                          context: context,
                          text: "Check out for different experiences",
                          fontWeight: FontWeight.w400,
                          textColor: AppColor.greyColor500,
                          textSize: 0.016,
                          textAlign: TextAlign.left,
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.01),

                        // search destination text field
                        CustomTextField(
                          headingText: "Location",
                          hintText: "Enter destination",
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),

                        // date text field
                        CustomTextField(
                          headingText: "Date",
                          hintText: "Add date",
                          readOnly: true,
                          onTap: () {
                            //
                            onClickCalender(model);
                          },
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),

                        // activities
                        Divider(
                          color: AppColor.greyColor500,
                        ),

                        // search by
                        TextView.headingText(
                          context: context,
                          text: "Activities",
                          color: AppColor.greyColor600,
                          fontSize: screenHeight * 0.022,
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),

                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: model.activitiesList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: index % 2 == 0 ? true : false,
                                    onChanged: (value) {},
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    side: BorderSide(width: 0.5),
                                  ),
                                ),
                                UiSpacer.horizontalSpace(
                                    context: context, space: 0.04),
                                TextView.mediumText(
                                  context: context,
                                  text: model.activitiesList[index],
                                  textColor: AppColor.greyColor500,
                                  textSize: 0.016,
                                )
                              ],
                            );
                          },
                          separatorBuilder: (context, index) =>
                              UiSpacer.verticalSpace(
                                  context: context, space: 0.02),
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),

                        Row(
                          children: [
                            Expanded(
                              child:
                                  CommonButton.commonOutlineButtonWithIconText(
                                context: context,
                                text: "Clear",
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            UiSpacer.horizontalSpace(
                                context: context, space: 0.04),
                            Expanded(
                              child: CommonButton.commonNormalButton(
                                context: context,
                                text: "Save",
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                UiSpacer.verticalSpace(context: context, space: 0.02),
              ],
            ),
          );
        });
      },
    );
  }

  void onClickCalender(FindExperienceViewModel model) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: screenHeight * 0.4,
                child: SfDateRangePicker(
                  yearCellStyle: DateRangePickerYearCellStyle(
                      textStyle: TextStyle(
                          color: AppColor.lightBlack,
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.simpleFontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.nunitoBold)),
                  viewSpacing: 50,
                  headerStyle:
                      DateRangePickerHeaderStyle(textAlign: TextAlign.center),
                  todayHighlightColor: Colors.transparent,
                  showActionButtons: false,
                  showNavigationArrow: false,
                  headerHeight: 30,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    model.startDate = args.value.startDate;
                    model.endDate = args.value.endDate;

                    debugPrint(
                        "Date selected :- ${model.startDate} - ${model.endDate}");
                  },
                  toggleDaySelection: false,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                      DateTime.now().subtract(const Duration(days: 4)),
                      DateTime.now().add(const Duration(days: 3))),
                  selectionTextStyle: TextStyle(
                      color: AppColor.textColorBlack,
                      fontFamily: AppFonts.nunitoMedium,
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.simpleFontSize),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonButton.commonOutlineButtonWithIconText(
                      context: context,
                      text: "Cancel",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  UiSpacer.horizontalSpace(context: context, space: 0.04),
                  Expanded(
                    child: CommonButton.commonNormalButton(
                      context: context,
                      text: "Save",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
