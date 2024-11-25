// ignore_for_file: must_be_immutable

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';
import 'package:Siesta/view_models/myBookingsModel.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:stacked/stacked.dart';

import '../../utility/globalUtility.dart';

class DialogDeleteAccount extends StatefulWidget {
  DialogDeleteAccount({
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
  State<DialogDeleteAccount> createState() => _DialogDeleteAccountState();
}

class _DialogDeleteAccountState extends State<DialogDeleteAccount> {
  double width = 0.0, height = 0.0;

  TextEditingController reasonTEC = TextEditingController();

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
                  Navigator.pop(context);
                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return fieldDialog(model, context);
                    },
                    animationType: DialogTransitionType.slideFromBottom,
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 800),
                  );
                  /* if (widget.fromWhere == "delete" ||
                      widget.fromWhere == 'delete_logout') {
                    model.deleteAccApi(
                        context, widget.fromWhere, reasonTEC.text);
                  }*/
                },
                textColor: AppColor.whiteColor,
                backColor: AppColor.appthemeColor),
          ),
        ],
      ),
    );
  }

  fieldDialog(TravellerMyBookingsModel model, BuildContext context) {
    return Dialog(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        shrinkWrap: true,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.clear),
            ),
          ),
          Text(
            "Please enter reason for delete account.",
            softWrap: true,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.simpleFontSize,
                fontFamily: AppFonts.nunitoMedium,
                color: AppColor.blackColor,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: reasonTEC,
            maxLines: 4,
            maxLength: 200,
            decoration: InputDecoration(
              counterText: "",
              hintText: "Enter reason",
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
                  borderSide: BorderSide(color: AppColor.fieldBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.fieldBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.errorBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.errorBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: width,
            child: CommonButton.commonNormalButton(
                context: context,
                text: "submit",
                onPressed: () {
                  if (widget.fromWhere == "delete" ||
                      widget.fromWhere == 'guide_delete') {
                    if (reasonTEC.text.replaceAll(" ", "") != "") {
                      model.deleteAccApi(
                          context, widget.fromWhere, reasonTEC.text);
                    } else {
                      GlobalUtility.showToastShort(
                          context, "Please enter reason");
                    }
                  }
                },
                textColor: AppColor.whiteColor,
                backColor: AppColor.appthemeColor),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
