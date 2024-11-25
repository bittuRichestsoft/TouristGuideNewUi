import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonButton {
  static Widget commonBoldTextButton(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          bool? isButtonEnable}) =>
      SizedBox(
        height: MediaQuery.of(context!).size.height *
            AppSizes().widgetSize.buttonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              elevation: 0,
              backgroundColor: isButtonEnable == true && isButtonEnable != null
                  ? AppColor.appthemeColor
                  : AppColor.buttonDisableColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
          child: Text(
            text.toString(),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.simpleFontSize,
                color: isButtonEnable == true && isButtonEnable != null
                    ? AppColor.whiteColor
                    : AppColor.appthemeColor,
                fontFamily: AppFonts.nunitoSemiBold),
          ),
        ),
      );

  static Widget commonSendButton(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          bool? isButtonEnable}) =>
      SizedBox(
        height: MediaQuery.of(context!).size.height *
            AppSizes().widgetSize.buttonHeight,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              elevation: 0,
              backgroundColor: isButtonEnable == true && isButtonEnable != null
                  ? AppColor.appthemeColor
                  : AppColor.buttonDisableColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
          child: Text(
            text.toString(),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.simpleFontSize,
                color: isButtonEnable == true && isButtonEnable != null
                    ? AppColor.whiteColor
                    : AppColor.appthemeColor,
                fontFamily: AppFonts.nunitoSemiBold),
          ),
        ),
      );

  static Widget commonThemeColorButton(
          {String? text, BuildContext? context, VoidCallback? onPressed}) =>
      SizedBox(
        height: MediaQuery.of(context!).size.height *
            AppSizes().widgetSize.buttonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColor.appthemeColor,
              splashFactory: NoSplash.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
          child: Text(
            text.toString(),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.normalFontSize,
                color: AppColor.whiteColor,
                fontFamily: AppFonts.nunitoSemiBold),
          ),
        ),
      );

  static Widget commonNormalButton(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          Color? backColor,
          Color? textColor}) =>
      SizedBox(
        width: MediaQuery.of(context!).size.width * 0.8,
        height: MediaQuery.of(context).size.height *
            AppSizes().widgetSize.roundBorderRadius,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: backColor,
              splashFactory: NoSplash.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
          child: Text(
            text.toString(),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.normalFontSize,
                color: textColor,
                fontFamily: AppFonts.nunitoSemiBold),
          ),
        ),
      );
  static Widget commonNormalButtonsmallHeight(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          Color? backColor,
          Color? textColor}) =>
      SizedBox(
        width: MediaQuery.of(context!).size.width * 0.8,
        height: MediaQuery.of(context).size.height *
            AppSizes().widgetSize.mediumbuttonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: backColor,
              splashFactory: NoSplash.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.smallBorderRadius))),
          child: Text(
            text.toString(),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.normalFontSize,
                color: textColor,
                fontFamily: AppFonts.nunitoSemiBold),
          ),
        ),
      );

  static Widget commonButtonRounded(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          Color? backColor,
          Color? textColor}) =>
      SizedBox(
        height: MediaQuery.of(context!).size.height *
            AppSizes().widgetSize.buttonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              primary: backColor,
              elevation: 0,
              backgroundColor: backColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.largeBorderRadius))),
          child: Text(
            text.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.termsFontSize,
                color: textColor,
                fontFamily: AppFonts.nunitoSemiBold),
          ),
        ),
      );

  static Widget commonButtonRoundedItinerary(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          Color? backColor,
          Color? textColor}) =>
      Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context!).size.width * 0.8,
        height: MediaQuery.of(context).size.height *
            AppSizes().widgetSize.buttonHeight,
        decoration: BoxDecoration(
            color: backColor,
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.largeBorderRadius)),
        child: GestureDetector(
          onTap: onPressed,
          child: Text(
            text.toString(),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.termsFontSize,
                color: textColor,
                fontFamily: AppFonts.nunitoBold),
          ),
        ),
      );

  static Widget commonButtonRoundedsmallBorderRadius(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          Color? backColor,
          Color? textColor}) =>
      SizedBox(
        width: MediaQuery.of(context!).size.width * 0.8,
        height: MediaQuery.of(context).size.height *
            AppSizes().widgetSize.mediumbuttonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              elevation: 0,
              backgroundColor: backColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          AppSizes().widgetSize.roundBorderRadiuSmall))),
          child: Text(
            text.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.xsimpleFontSize,
                color: textColor,
                fontFamily: AppFonts.nunitoMedium),
          ),
        ),
      );

  static Widget commonButtonWithIconText(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          String? iconPath,
          Color? color}) =>
      SizedBox(
        height: MediaQuery.of(context!).size.height *
            AppSizes().widgetSize.buttonHeight,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                alignment: Alignment.center,
                elevation: 0,
                backgroundColor: color ?? AppColor.appthemeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width *
                            AppSizes().widgetSize.smallBorderRadius))),
            child: TextButton.icon(
              onPressed: onPressed,
              icon: Image.asset(
                iconPath!,
                width: AppSizes().widgetSize.iconWidth,
                height: AppSizes().widgetSize.iconHeight,
                color: AppColor.whiteColor,
              ),
              label: Text(
                text.toString(),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height *
                        AppSizes().fontSize.normalFontSize,
                    color: AppColor.whiteColor,
                    fontFamily: AppFonts.nunitoSemiBold),
              ),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center),
            )),
      );

  static Widget commonOutlineButtonWithIconText(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          String? iconPath,
          Color? color}) =>
      SizedBox(
        height: MediaQuery.of(context!).size.height *
            AppSizes().widgetSize.buttonHeight,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                alignment: Alignment.center,
                elevation: 0,
                backgroundColor: color ?? AppColor.whiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width *
                            AppSizes().widgetSize.smallBorderRadius),
                    side: BorderSide(color: AppColor.hintTextColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath!,
                  color: AppColor.hintTextColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.normalFontSize,
                      color: AppColor.hintTextColor,
                      fontFamily: AppFonts.nunitoSemiBold),
                )
              ],
            )),
      );

  static Widget commonOutlineButtonWithTextIcon(
          {String? text,
          BuildContext? context,
          VoidCallback? onPressed,
          String? iconPath,
          Color? color,
          double? borderRadius}) =>
      SizedBox(
        height: MediaQuery.of(context!).size.height *
            AppSizes().widgetSize.buttonHeight,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                alignment: Alignment.center,
                elevation: 0,
                backgroundColor: color ?? AppColor.whiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ??
                        MediaQuery.of(context).size.width *
                            AppSizes().widgetSize.smallBorderRadius),
                    side: BorderSide(color: AppColor.hintTextColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.normalFontSize,
                      color: AppColor.greyColor,
                      fontFamily: AppFonts.nunitoSemiBold),
                ),
                SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  iconPath!,
                  color: AppColor.greyColor,
                ),
              ],
            )),
      );
}
