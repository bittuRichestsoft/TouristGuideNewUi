import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/all_dialogs/dialog_with_twoButton.dart';
import 'package:flutter/material.dart';

class DialogWithTextButton extends StatefulWidget {
   DialogWithTextButton({Key? key,String? bId,}) : super(key: key){
     bookingId = bId.toString();
   }
  String bookingId = "";
  @override
  State<DialogWithTextButton> createState() => _DialogWithTextButtonState();
}

class _DialogWithTextButtonState extends State<DialogWithTextButton> {
  @override
  Widget build(BuildContext context) {
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
          Icon(
            Icons.info_outline,
            color: AppColor.appthemeColor,
          ),
          UiSpacer.verticalSpace(
              space: AppSizes().widgetSize.normalPadding, context: context),

          Text(AppStrings().cancelTripContent,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * AppSizes().fontSize.simpleFontSize,
                fontFamily: AppFonts.nunitoRegular,
                color: AppColor.dontHaveTextColor,fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),

          UiSpacer.verticalSpace(
              space: AppSizes().widgetSize.normalPadding, context: context),

          CommonButton.commonThemeColorButton(
              context: context, text: AppStrings().Okay, onPressed: () {
                Navigator.pop(context);
                GlobalUtility.showDialogFunction(context, DialogWithTwoButton(from: "cancelTrip",
                cancelText: AppStrings().cancelText,headingText: AppStrings().cancelTripSubContent,okayText:
                  AppStrings().keepText,subContent: AppStrings().cancelTripContent,bookIdForCancelTrip:widget.bookingId));
          }),
        ],
      ),
    );
  }
}
