import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';

import '../../app_constants/app_routes.dart';

class EditPackageSheet extends StatefulWidget {
  EditPackageSheet({Key? key, dynamic travellerItineraryDetailModel})
      : super(key: key) {
    traveller_Itinerary_DetailModel = travellerItineraryDetailModel;
  }
  dynamic traveller_Itinerary_DetailModel;
  @override
  State<EditPackageSheet> createState() => _EditPackageSheetState();
}

class _EditPackageSheetState extends State<EditPackageSheet> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      // padding: EdgeInsets.all(MediaQuery.of(context).size.width *
      //     AppSizes().widgetSize.normalPadding),
      children: [
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.normalPadding, context: context),
        Center(
          child: Container(
            height: 4,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(5)),
          ),
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.normalPadding, context: context),
        Center(
            child: TextView.normalText(
                context: context,
                text: AppStrings().rejectItineraryText,
                textColor: AppColor.textColorBlack,
                textSize: AppSizes().fontSize.headingTextSize,
                fontFamily: AppFonts.nunitoSemiBold)),
        Divider(
          color: AppColor.disableColor,
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.normalPadding, context: context),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: TextView.normalText(
              context: context,
              text: AppStrings().cancelReasonsheet,
              textColor: AppColor.dontHaveTextColor,
              textSize: AppSizes().fontSize.simpleFontSize,
              fontFamily: AppFonts.nunitoRegular),
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.normalPadding, context: context),
        packageListView(),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.normalPadding, context: context),
        buttonRow(),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.normalPadding, context: context),
      ],
    );
  }

  List<String> packageList = [
    'Going But Not Booking On Siesta',
    'Not Going, Cancel My Plan',
    'Not Satisfied With The Current Itinerary'
  ];
  int selectedPackage = 0;

  Widget packageListView() {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: packageList.length,
        itemBuilder: (context, index) {
          return RadioListTile<int>(
            title: TextView.normalText(
                text: packageList[index],
                context: context,
                fontFamily: AppFonts.nunitoSemiBold,
                textSize: AppSizes().fontSize.simpleFontSize,
                textColor: AppColor.textfieldColor),
            value: index,
            groupValue: selectedPackage,
            onChanged: (int? value) {
              setState(() {
                debugPrint(value.toString());
                selectedPackage = value!;
              });
            },
          );
        });
  }

  Widget buttonRow() {
    return Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: CommonButton.commonNormalButton(
                context: context,
                textColor: AppColor.textbuttonColor,
                text: AppStrings().notNowText,
                onPressed: () {
                  Navigator.pop(context);
                },
                backColor: AppColor.marginBorderColor,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: CommonButton.commonNormalButton(
                context: context,
                textColor: AppColor.whiteColor,
                text: AppStrings().sent,
                onPressed: () {
                  debugPrint("REJECT INTI=== ${packageList[selectedPackage]}");
                  widget.traveller_Itinerary_DetailModel
                      .travellerRejectItinerary(
                          context, packageList[selectedPackage]);
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.travellerHomePageTab4);
                },
                backColor: AppColor.appthemeColor,
              ),
            ),
          ],
        ));
  }
}
