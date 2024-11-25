import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class RangeDateSelector extends StatefulWidget {
   RangeDateSelector({Key? key,dynamic travellerMyBookingsModel,dynamic guideMyBookingsModel}) : super(key: key){
    travellerMyBookingsModelInstance = travellerMyBookingsModel;
    guideModel = guideMyBookingsModel;
   }
   dynamic? travellerMyBookingsModelInstance;
   dynamic guideModel;
  @override
  State<RangeDateSelector> createState() => _RangeDateSelectorState();
}

class _RangeDateSelectorState extends State<RangeDateSelector> {
  var selectedStartDate =DateTime.now().subtract(const Duration(days: 4));
  var selectedEndDate = DateTime.now().add(const Duration(days: 3));
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width *
          AppSizes().widgetSize.horizontalPadding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 50,),
            TextView.normalText(
                text: "Date",
                context: context,
                fontFamily: AppFonts.nunitoBold,
                textSize: AppSizes().fontSize.normalFontSize,
                textColor: AppColor.textColorBlack),
            GestureDetector(
              onTap: (){
                if(widget.travellerMyBookingsModelInstance!=null){
                widget.travellerMyBookingsModelInstance.getMyBookings(context, 1, "",[],"yes","","","");}
                else{
                  widget.guideModel.getMyBookings(context, 1, "",[0],"","","","");
                }
                Navigator.pop(context);
              },
              child: TextView.normalText(
                  text: "Clear Filter",
                  context: context,
                  fontFamily: AppFonts.nunitoBold,
                  textSize: AppSizes().fontSize.normalFontSize,
                  textColor: AppColor.appthemeColor),
            ),
          ],
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        Divider(
          color: AppColor.hintTextColor,
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        datePicker(),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        CommonButton.commonThemeColorButton(
            context: context, onPressed: () { 
              String startDate = DateFormat('yyyy-MM-dd').format(selectedStartDate);
              String endDate = DateFormat('yyyy-MM-dd').format(selectedEndDate);
              if(selectedStartDate!=null && selectedEndDate!=null){
              debugPrint("checkkkmodeeelleel${startDate}---$endDate");
              if(widget.travellerMyBookingsModelInstance!=null){
              widget.travellerMyBookingsModelInstance.getMyBookings(context, 1, "",[],"yes",startDate,endDate,"");
              }else{
               widget.guideModel.getMyBookings(context, 1, "",[0],"",startDate,endDate,"");
              }
              Navigator.pop(context);
              }else{
                debugPrint("checkkkmodeeelleel${startDate}---$endDate");
              }
              }, text: AppStrings().saveText)
      ],
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
   debugPrint("argsargsargsargsargs${args.value}");
   selectedStartDate = args.value.startDate;
   selectedEndDate = args.value.endDate;
    debugPrint("argsargsargsargsargs${selectedStartDate}--${selectedEndDate}");

  }

  Widget datePicker() {
    return SfDateRangePicker(
      yearCellStyle: DateRangePickerYearCellStyle(
          textStyle: TextStyle(
              color: AppColor.lightBlack,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.simpleFontSize,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.nunitoBold)),
      viewSpacing: 50,

      headerStyle: DateRangePickerHeaderStyle(textAlign: TextAlign.center),
      todayHighlightColor: Colors.transparent,

      monthCellStyle: DateRangePickerMonthCellStyle(
        weekendTextStyle: TextStyle(
            color: AppColor.textbuttonColor,
            fontSize: MediaQuery.of(context).size.height *
                AppSizes().fontSize.simpleFontSize,
            fontFamily: AppFonts.nunitoMedium),
      ),

      monthViewSettings: DateRangePickerMonthViewSettings(
        showTrailingAndLeadingDates: true,
        dayFormat: "EEE",
        viewHeaderHeight: 50.0,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(textStyle: TextStyle(
            color: AppColor.dateTextColor,
            fontSize: MediaQuery.of(context).size.height *
                AppSizes().fontSize.normalFontSize,
            fontFamily: AppFonts.nunitoSemiBold),)
      ),
      showActionButtons: false,
      showNavigationArrow: false,
      headerHeight: 30,
      onSelectionChanged: _onSelectionChanged,
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
    );
  }
}
