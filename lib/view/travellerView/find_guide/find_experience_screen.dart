import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/custom_widgets/custom_traveller_experience_tile.dart';
import 'package:Siesta/utility/globalUtility.dart';
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
import '../../../app_constants/app_routes.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../common_widgets/common_button.dart';
import '../../../common_widgets/vertical_size_box.dart';
import '../../../custom_widgets/common_widgets.dart';
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
          return GestureDetector(
            onTap: () {
              model.isPlaceListShow = false;
              model.notifyListeners();
            },
            child: Scaffold(
              backgroundColor: AppColor.whiteColor,
              body: model.hasError
                  ? CommonWidgets()
                      .inAppErrorWidget(model.modelError.toString(), () {
                      model.initialise();
                    }, context: context)
                  : model.initialised == false
                      ? CommonWidgets().inPageLoader()
                      : Column(
                          children: [
                            // filter view
                            filterView(model),

                            // tab view
                            tabBarView(model),
                            UiSpacer.verticalSpace(
                                context: context, space: 0.02),

                            // listing or map
                            model.status == Status.loading
                                ? Expanded(
                                    child: CommonWidgets().inPageLoader())
                                : model.status == Status.error
                                    ? Expanded(
                                        child: CommonWidgets().inAppErrorWidget(
                                            context: context,
                                            model.errorMsg, () {
                                          model.pageNo = 1;
                                          model.getSearchExperienceAPI();
                                        }),
                                      )
                                    : model.tabVal == CustomTabValue.list
                                        ? Expanded(child: listView(model))
                                        : Expanded(child: mapView(model)),
                          ],
                        ),
            ),
          );
        });
  }

  Widget filterView(FindExperienceViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiSpacer.verticalSpace(context: context, space: 0.02),
          // search field & filter view
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // width: screenWidth * 0.7,
                child: CustomTextField(
                  textEditingController: model.locationTEC,
                  hintText: "Search by location",
                  borderRadius: 50,
                  maxLines: 1,
                  suffixWidget: Icon(
                    Icons.search,
                    color: AppColor.blackColor,
                  ),
                  onTap: () {
                    if (model.locationTEC.text.isNotEmpty) {
                      model.isPlaceListShow = true;
                      model.notifyListeners();
                    }
                  },
                  onChange: (value) async {
                    model.longitude = null;
                    model.latitude = null;

                    await model.searchLocation(value);
                  },
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
                    onTap: () async {
                      Map<String, dynamic> mapData =
                          await model.onClickSuggestion(index);
                      model.locationTEC.text = mapData["location"] ?? "";
                      model.latitude = mapData["latitude"];
                      model.longitude = mapData["longitude"];

                      model.getSearchExperienceAPI();
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

          // Tags
          SizedBox(
            height: screenHeight * 0.05,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: model.activitiesList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (model.activitiesList[index].isSelect == true) {
                      model.activitiesList[index].isSelect = false;
                    } else {
                      model.activitiesList[index].isSelect = true;
                    }
                    model.pageNo = 1;
                    model.getSearchExperienceAPI();
                  },
                  child: activityChip(model.activitiesList[index].title,
                      model.activitiesList[index].isSelect),
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

  Widget activityChip(String name, bool isSelect) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.03,
        horizontal: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: isSelect ? AppColor.appthemeColor : AppColor.whiteColor,
          border: Border.all(
            color: isSelect == true
                ? AppColor.appthemeColor
                : AppColor.greyColor500.withOpacity(0.2),
          )),
      child: TextView.mediumText(
        context: context,
        text: name,
        textSize: 0.016,
        textAlign: TextAlign.center,
        textColor: isSelect ? AppColor.whiteColor : AppColor.greyColor600,
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
            child: GestureDetector(
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
            child: GestureDetector(
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
    return model.experienceList.isEmpty
        ? Center(
            child: FittedBox(
                fit: BoxFit.fitHeight,
                child: CommonWidgets().emptyStateWidget(context: context)))
        : ListView.separated(
            shrinkWrap: true,
            controller: model.scrollController,
            itemCount: model.experienceList.length,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CustomTravellerExperienceTile(
                id: (model.experienceList[index].id ?? "0").toString(),
                heroImage: model.experienceList[index].heroImage ?? "",
                title: model.experienceList[index].title ?? "",
                avgRating: model.experienceList[index].user!.avgRating ?? "0",
                price: (model.experienceList[index].price ?? "0").toString(),
                duration: model.experienceList[index].duration ?? "",
              );
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
            initialCameraPosition: model.initialCameraPosition(),
            markers: model.markers.toSet(),
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
              model.currentDetail = null;
              model.selectedMarkerId = null;
              model.updateMarkers(model.experienceList);
              model.notifyListeners();
            },
          ),
          if (model.showMapOverlayTile == true)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.postDetailPage,
                    arguments: {
                      "postId": (model.currentDetail?.id ?? 0).toString(),
                      "type": "experience",
                      "otherPersonProfile": true
                    },
                  );
                },
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
                            imgUrl: model.currentDetail?.heroImage ?? "",
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
                              text: model.currentDetail?.title ?? "",
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              textColor: AppColor.greyColor600,
                              textSize: 0.018,
                            ),
                            UiSpacer.verticalSpace(
                                context: context, space: 0.01),
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
                                  text: "\$${model.currentDetail?.price ?? 0}",
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
                                      text: double.parse(model.currentDetail
                                                  ?.user?.avgRating ??
                                              "0.0")
                                          .toStringAsFixed(1),
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
                                    text: model.currentDetail?.duration ?? "",
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
              ),
            )
        ],
      ),
    );
  }

  void showFilterSheet(FindExperienceViewModel model) {
    SfRangeValues tempPriceRange = model.priceRange;
    var tempFromPriceTEC =
        TextEditingController(text: tempPriceRange.start.toString());
    var tempToPriceTEC =
        TextEditingController(text: tempPriceRange.end.toString());
    var tempLocationTEC = TextEditingController(text: model.locationTEC.text);
    DateTime? startDate = model.startDate;
    DateTime? endDate = model.endDate;

    var tempDateTEC = TextEditingController();
    double tempRatingValue = model.ratingValue;
    double? tempLatitude = model.latitude;
    double? tempLongitude = model.longitude;

    List<ActivitiesModel> tempActivityList =
        model.activitiesList.map((activity) => activity.copy()).toList();

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
                          min: 0,
                          max: 10000,
                          values: tempPriceRange,
                          enableTooltip: true,
                          stepSize: 1,
                          onChanged: (SfRangeValues values) {
                            setModelState(() {
                              tempPriceRange = values;
                              tempFromPriceTEC.text =
                                  double.parse(tempPriceRange.start.toString())
                                      .toStringAsFixed(0);
                              tempToPriceTEC.text =
                                  double.parse(tempPriceRange.end.toString())
                                      .toStringAsFixed(0);
                            });
                          },
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),

                        // min and max text field
                        CustomTextField(
                          textEditingController: tempFromPriceTEC,
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
                          onChange: (val) {
                            if (double.parse(val) >= 10000) {
                              tempPriceRange =
                                  SfRangeValues(10000, tempPriceRange.end);
                            } else {
                              tempPriceRange = SfRangeValues(
                                  double.parse(val), tempPriceRange.end);
                            }
                            setModelState(() {});
                          },
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),

                        CustomTextField(
                          textEditingController: tempToPriceTEC,
                          borderRadius: 10,
                          isFilled: true,
                          fillColor: Color(0xffF3F8FF),
                          headingText: "To",
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
                          onChange: (val) {
                            if (double.parse(val) >= 10000) {
                              tempPriceRange =
                                  SfRangeValues(tempPriceRange.start, 10000);
                            } else {
                              tempPriceRange = SfRangeValues(
                                  tempPriceRange.start, double.parse(val));
                            }
                            setModelState(() {});
                          },
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
                              initialRating: tempRatingValue,
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
                                Icons.star_rounded,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                tempRatingValue = rating;
                                setModelState(() {});
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
                          textEditingController: tempLocationTEC,
                          headingText: "Location",
                          hintText: "Enter destination",
                          onTap: () {
                            if (tempLocationTEC.text.isNotEmpty) {
                              model.isPlaceListShow = true;
                              model.notifyListeners();
                            }
                          },
                          onChange: (value) async {
                            tempLatitude = null;
                            tempLongitude = null;
                            await model.searchLocation(value);
                            setModelState(() {});
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
                                  onTap: () async {
                                    Map<String, dynamic> mapData =
                                        await model.onClickSuggestion(index);
                                    tempLocationTEC.text =
                                        mapData["location"] ?? "";
                                    tempLatitude = mapData["latitude"];
                                    tempLongitude = mapData["longitude"];

                                    setModelState(() {});
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.04,
                                        vertical: 6),
                                    child: TextView.mediumText(
                                      context: context,
                                      text: model.placeList[index]
                                          ["description"],
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

                        // date text field
                        /* CustomTextField(
                          textEditingController: tempDateTEC,
                          headingText: "Date",
                          hintText: "Add date",
                          readOnly: true,
                          onTap: () async {
                            //
                            var mapData = await onClickCalender(
                                model, startDate, endDate);
                            if (mapData != null) {
                              startDate = mapData["startDate"];
                              endDate = mapData["endDate"];
                              tempDateTEC.text =
                                  "${CommonDateTimeFormats.dateFormat1((mapData["startDate"] ?? DateTime.now()).toString())} - ${CommonDateTimeFormats.dateFormat1((mapData["endDate"] ?? DateTime.now()).toString())}";
                              setModelState(() {});
                            }
                          },
                        ),
                        UiSpacer.verticalSpace(context: context, space: 0.02),*/

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
                          itemCount: tempActivityList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: tempActivityList[index].isSelect,
                                    onChanged: (value) {
                                      if (tempActivityList[index].isSelect ==
                                          true) {
                                        tempActivityList[index].isSelect =
                                            false;
                                      } else {
                                        tempActivityList[index].isSelect = true;
                                      }
                                      setModelState(() {});
                                    },
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
                                  text: tempActivityList[index].title,
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
                                  tempPriceRange = SfRangeValues(0, 5000);
                                  tempFromPriceTEC.text = "0";
                                  tempToPriceTEC.text = "5000";
                                  tempLocationTEC.clear();
                                  tempDateTEC.clear();
                                  tempRatingValue = 0;
                                  tempLatitude = null;
                                  tempLongitude = null;
                                  startDate = null;
                                  endDate = null;
                                  tempActivityList = tempActivityList.map((e) {
                                    e.isSelect = false;
                                    return e;
                                  }).toList();
                                  setModelState(() {});
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
                                  model.priceRange = tempPriceRange;
                                  model.locationTEC.text = tempLocationTEC.text;

                                  model.ratingValue = tempRatingValue;
                                  model.latitude = tempLatitude;
                                  model.longitude = tempLongitude;
                                  model.startDate = startDate;
                                  model.endDate = endDate;
                                  model.activitiesList = tempActivityList;

                                  model.pageNo = 1;

                                  model.getSearchExperienceAPI();
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

  Future<Map<String, dynamic>?> onClickCalender(FindExperienceViewModel model,
      DateTime? startDate, DateTime? endDate) async {
    DateTime? tempStartDate;
    DateTime? tempEndDate;
    var mapData = await showDialog(
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
                    tempStartDate = args.value.startDate;
                    tempEndDate = args.value.endDate;
                  },
                  toggleDaySelection: false,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(startDate, endDate),
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
                        if (tempStartDate == null || tempEndDate == null) {
                          GlobalUtility.showToast(context,
                              "Please select both start date and end date");
                        } else {
                          startDate = tempStartDate;
                          endDate = tempEndDate;
                          Navigator.pop(context, {
                            "startDate": tempStartDate,
                            "endDate": tempEndDate
                          });
                        }
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
    return mapData;
  }
}
