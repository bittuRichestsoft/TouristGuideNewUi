import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:flutter/material.dart';

class TextView {
  static Widget headingText(
          {String? text,
          BuildContext? context,
          Color? color,
          double? fontSize,
          int? maxLines,
          TextAlign? textAlign}) =>
      Text(
        text!,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize ??
              MediaQuery.of(context!).size.height *
                  AppSizes().fontSize.largeTextSize,
          fontFamily: AppFonts.nunitoBold,
          color: color ?? AppColor.appthemeColor,
        ),
        textAlign: textAlign ?? TextAlign.center,
      );

  static Widget largeHeadingText(
          {String? text, BuildContext? context, Color? color}) =>
      Text(
        text!,
        style: TextStyle(
            fontSize: MediaQuery.of(context!).size.height *
                AppSizes().fontSize.largeTextSize,
            fontFamily: AppFonts.nunitoBlack,
            color: color ?? AppColor.appthemeColor),
        textAlign: TextAlign.center,
      );

  static Widget subHeadingText(
          {String? text, BuildContext? context, Color? color}) =>
      Text(
        text!,
        style: TextStyle(
            fontSize: MediaQuery.of(context!).size.height *
                AppSizes().fontSize.simpleFontSize,
            fontFamily: AppFonts.nunitoRegular,
            color: color ?? AppColor.lightBlack),
        textAlign: TextAlign.center,
      );

  static Widget semiBoldText(
          {String? text, BuildContext? context, Color? textColor}) =>
      Text(
        text!,
        style: TextStyle(
            fontSize: MediaQuery.of(context!).size.height *
                AppSizes().fontSize.normalFontSize,
            fontFamily: AppFonts.nunitoSemiBold,
            color: textColor),
      );

  static Widget headingWhiteText(
          {String? text, BuildContext? context, Color? textColor}) =>
      Text(
        text!,
        style: TextStyle(
            fontSize: MediaQuery.of(context!).size.height *
                AppSizes().fontSize.largeTextSize,
            fontFamily: AppFonts.nunitoBold,
            color: textColor ?? AppColor.whiteColor,
            fontWeight: FontWeight.w700),
      );

  static Widget normalText(
          {String? text,
          BuildContext? context,
          String? fontFamily,
          double? textSize,
          Color? textColor}) =>
      Text(
        text!,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        softWrap: true,
        style: TextStyle(
            fontSize: MediaQuery.of(context!).size.height * textSize!,
            fontFamily: fontFamily,
            color: textColor,
            fontWeight: FontWeight.w500),
      );

  static Widget normalTextOver(
          {String? text,
          BuildContext? context,
          String? fontFamily,
          double? textSize,
          Color? textColor}) =>
      Text(
        text!,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: true,
        style: TextStyle(
            fontSize: MediaQuery.of(context!).size.height * textSize!,
            fontFamily: fontFamily,
            color: textColor,
            fontWeight: FontWeight.w500),
      );
  static Widget normalTextHeight(
          {String? text,
          BuildContext? context,
          String? fontFamily,
          double? textSize,
          Color? textColor}) =>
      Text(
        text!,
        style: TextStyle(
            fontSize: MediaQuery.of(context!).size.height * textSize!,
            height: 1.6,
            fontFamily: fontFamily,
            color: textColor,
            fontWeight: FontWeight.w500),
      );

  static Widget headingTextWithAlign(
          {String? text, BuildContext? context, TextAlign? alignmentTxt}) =>
      Text(
        text!,
        style: TextStyle(
            fontSize: MediaQuery.of(context!).size.height *
                AppSizes().fontSize.largeTextSize,
            fontFamily: AppFonts.nunitoBold,
            color: AppColor.appthemeColor),
        textAlign: alignmentTxt,
      );

  static Widget mediumText(
          {String? text,
          BuildContext? context,
          String? fontFamily,
          double? textSize,
          TextAlign? textAlign,
          Color? textColor,
          FontWeight? fontWeight,
          int? maxLines}) =>
      Text(
        text!,
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: textSize == null
                ? MediaQuery.of(context!).size.height * 0.02
                : MediaQuery.of(context!).size.height * textSize!,
            fontFamily: fontFamily,
            color: textColor,
            fontWeight: fontWeight ?? FontWeight.w500),
      );
}
