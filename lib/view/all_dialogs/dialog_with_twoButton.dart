// ignore_for_file: must_be_immutable

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:Siesta/view_models/myBookingsModel.dart';
import 'package:stacked/stacked.dart';

class DialogWithTwoButton extends StatefulWidget {
  DialogWithTwoButton({
    Key? key,
    required String headingText,
    required String subContent,
    required String okayText,
    required String cancelText,
    required String from,
    String? bookIdForCancelTrip,
  }) : super(key: key) {
    titleText = headingText;
    contentText = subContent;
    okayButtonText = okayText;
    cancelButtonText = cancelText;
    fromWhere = from;
    booking_id = bookIdForCancelTrip.toString();
  }

  String titleText = "";
  String contentText = "";
  String okayButtonText = "";
  String cancelButtonText = "";
  String fromWhere = "";
  String booking_id = "";

  @override
  State<DialogWithTwoButton> createState() => _DialogWithTwoButtonState();
}

class _DialogWithTwoButtonState extends State<DialogWithTwoButton> {
  double width = 0.0, height = 0.0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<TravellerMyBookingsModel>.reactive(
        viewModelBuilder: () =>
            TravellerMyBookingsModel(context, "noNeedToCallApi", 0, 0.0),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Dialog(
            alignment: Alignment.center,
            backgroundColor: AppColor.whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.mediumBorderRadius))),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.horizontalPadding),
              children: [
                Text(
                  widget.titleText,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.headingTextSize,
                      fontFamily: AppFonts.nunitoSemiBold,
                      color: AppColor.appthemeColor,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding,
                    context: context),
                Text(
                  widget.contentText,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.simpleFontSize,
                      fontFamily: AppFonts.nunitoRegular,
                      color: AppColor.dontHaveTextColor,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding,
                    context: context),
                buttonRow(model)
              ],
            ),
          );
        });
  }

  Widget buttonRow(TravellerMyBookingsModel model) {
    return SizedBox(
      width: width,
      height: height * AppSizes().widgetSize.buttonHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.3,
            child: CommonButton.commonNormalButton(
                context: context,
                text: widget.cancelButtonText,
                onPressed: () {
                  if (widget.fromWhere == "cancelTrip") {
                    // handle cancel trip
                    model.travellerCancelTrip(context, widget.booking_id);
                  } else {
                    Navigator.pop(context);
                  }
                },
                textColor: AppColor.textbuttonColor,
                backColor: AppColor.marginBorderColor),
          ),
          SizedBox(
            width: width * 0.3,
            child: CommonButton.commonNormalButton(
                context: context,
                text: widget.okayButtonText,
                onPressed: () {
                  if (widget.fromWhere == "logout" ||
                      widget.fromWhere == 'guide_logout') {
                    model.logout(context, widget.fromWhere);
                  } else {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.travellerHomePageTab2);
                  }
                },
                textColor: AppColor.whiteColor,
                backColor: AppColor.appthemeColor),
          ),
        ],
      ),
    );
  }
}
