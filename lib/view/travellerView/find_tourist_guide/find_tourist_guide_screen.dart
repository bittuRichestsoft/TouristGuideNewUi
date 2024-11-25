import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_fonts.dart';
import '../../../app_constants/app_sizes.dart';
import '../../../app_constants/textfield_decoration.dart';
import '../../../common_widgets/common_textview.dart';
import '../../../common_widgets/vertical_size_box.dart';

class FindTouristGuideScreen extends StatefulWidget {
  const FindTouristGuideScreen({super.key});

  @override
  State<FindTouristGuideScreen> createState() => _FindTouristGuideScreenState();
}

class _FindTouristGuideScreenState extends State<FindTouristGuideScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Google Map
            SizedBox(
              height: screenHeight * 0.75,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(
                  screenWidth * AppSizes().widgetSize.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText("Search By"),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),

                  // Location View
                  titleText("Location"),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.smallPadding,
                      context: context),
                  TextFormField(
                    // controller: model.fromDateController,
                    enabled: false,
                    onChanged: (val) {},
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppColor.lightBlack,
                        fontFamily: AppFonts.nunitoRegular,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize),
                    decoration: TextFieldDecoration.simpletextFieldDecoration(
                        context, 'Enter location', false),
                    enableInteractiveSelection: true,
                    textInputAction: TextInputAction.next,
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),

                  // Price range
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      titleText("Price Range"),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.close,
                                color: AppColor.blackColor,
                                size: 20,
                              ),
                              TextView.normalText(
                                text: " Clear all",
                                context: context,
                                fontFamily: AppFonts.nunitoMedium,
                                textColor: AppColor.blackColor,
                                textSize: AppSizes().fontSize.xsimpleFontSize,
                              )
                            ],
                          ))
                    ],
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.smallPadding,
                      context: context),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            subTitleText("Minimum"),
                            UiSpacer.verticalSpace(
                                space: 0.01, context: context),
                            TextFormField(
                              // controller: model.fromDateController,
                              enabled: false,
                              onChanged: (val) {},
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter the minimum value';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColor.lightBlack,
                                  fontFamily: AppFonts.nunitoRegular,
                                  fontSize: screenHeight *
                                      AppSizes().fontSize.simpleFontSize),
                              decoration:
                                  TextFieldDecoration.simpletextFieldDecoration(
                                      context, '\$0', false),
                              enableInteractiveSelection: true,
                              textInputAction: TextInputAction.next,
                            )
                          ],
                        ),
                      ),
                      UiSpacer.horizontalSpace(
                          space: AppSizes().widgetSize.horizontalPadding,
                          context: context),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            subTitleText("Maximum"),
                            UiSpacer.verticalSpace(
                                space: 0.01, context: context),
                            TextFormField(
                              // controller: model.fromDateController,
                              enabled: false,
                              onChanged: (val) {},
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter the maximum value';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColor.lightBlack,
                                  fontFamily: AppFonts.nunitoRegular,
                                  fontSize: screenHeight *
                                      AppSizes().fontSize.simpleFontSize),
                              decoration:
                                  TextFieldDecoration.simpletextFieldDecoration(
                                      context, '\$1000', false),
                              enableInteractiveSelection: true,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),

                  // Activities
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      titleText("Activities"),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.close,
                                color: AppColor.blackColor,
                                size: 20,
                              ),
                              TextView.normalText(
                                text: " Clear all",
                                context: context,
                                fontFamily: AppFonts.nunitoMedium,
                                textColor: AppColor.blackColor,
                                textSize: AppSizes().fontSize.xsimpleFontSize,
                              )
                            ],
                          ))
                    ],
                  ),
                  // UiSpacer.verticalSpace(
                  //     space: AppSizes().widgetSize.smallPadding,
                  //     context: context),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      commonCheckBoxContent(title: "Hiking"),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      commonCheckBoxContent(title: "Sightseeing"),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      commonCheckBoxContent(title: "Backpacking"),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      commonCheckBoxContent(title: "Adventure"),
                    ],
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.normalPadding,
                      context: context),

                  // Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      titleText("Rating"),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.close,
                                color: AppColor.blackColor,
                                size: 20,
                              ),
                              TextView.normalText(
                                text: " Clear all",
                                context: context,
                                fontFamily: AppFonts.nunitoMedium,
                                textColor: AppColor.blackColor,
                                textSize: AppSizes().fontSize.xsimpleFontSize,
                              )
                            ],
                          ))
                    ],
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      commonCheckBoxStars(starCount: 1),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      commonCheckBoxStars(starCount: 2),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      commonCheckBoxStars(starCount: 3),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      commonCheckBoxStars(starCount: 4),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      commonCheckBoxStars(starCount: 5),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  commonCheckBoxContent({required String title}) {
    return Row(
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: Checkbox(
            value: false,
            onChanged: (v) {},
            side: BorderSide(color: AppColor.hintTextColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 10),
        subTitleText(title),
      ],
    );
  }

  commonCheckBoxStars({required int starCount}) {
    return Row(
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: Checkbox(
            value: false,
            onChanged: (v) {},
            side: BorderSide(color: AppColor.hintTextColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 10),
        RatingBar.builder(
          wrapAlignment: WrapAlignment.start,
          initialRating: starCount.toDouble(),
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,
          unratedColor: AppColor.disableColor,
          itemCount: starCount,
          itemSize: 25.0,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: AppColor.ratingbarColor,
          ),
          onRatingUpdate: (double value) {},
        )
      ],
    );
  }

  Widget headingText(String text) {
    return TextView.normalText(
      text: text,
      context: context,
      fontFamily: AppFonts.nunitoSemiBold,
      textColor: AppColor.textColorBlack,
      textSize: AppSizes().fontSize.largeTextSize,
    );
  }

  Widget titleText(String text) {
    return TextView.normalText(
      text: text,
      context: context,
      fontFamily: AppFonts.nunitoSemiBold,
      textColor: AppColor.textColorBlack,
      textSize: AppSizes().fontSize.headingTextSize,
    );
  }

  Widget subTitleText(String text) {
    return TextView.normalText(
      text: text,
      context: context,
      fontFamily: AppFonts.nunitoRegular,
      textColor: AppColor.textColorBlack,
      textSize: AppSizes().fontSize.subHeadingTextSize,
    );
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
