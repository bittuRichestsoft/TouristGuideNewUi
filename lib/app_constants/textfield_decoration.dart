import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextFieldDecoration {
  static InputDecoration textFieldDecoration(
      BuildContext context, String hint, String iconPath, String errorText) {
    return InputDecoration(
      hintText: hint,
      counterText: "",
      prefixIcon: IconButton(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        onPressed: null,
        icon: SvgPicture.asset(iconPath),
      ),
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      errorStyle: TextStyle(
          color: AppColor.textbuttonColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.mediumFontSize),
      contentPadding: const EdgeInsets.only(
        top: 10,
        bottom: 0,
      ),
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
    );
  }

  static InputDecoration textFieldDecorationSec(
    BuildContext context,
    String hint,
    String iconPath,
  ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: IconButton(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        onPressed: null,
        icon: SvgPicture.asset(iconPath),
      ),
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      contentPadding: const EdgeInsets.only(
        top: 10,
        bottom: 0,
      ),
      fillColor: AppColor.textfieldFilledColor,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.textfieldborderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.smallBorderRadius))),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
    );
  }

  static InputDecoration textFieldFilledDecoration(
      BuildContext context, String hint, String iconPath, bool isFilled) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: IconButton(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        onPressed: null,
        icon: SvgPicture.asset(iconPath),
      ),
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      contentPadding: const EdgeInsets.only(
        top: 10,
        bottom: 0,
      ),
      fillColor: AppColor.textfieldFilledColor,
      filled: isFilled,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.textfieldborderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.smallBorderRadius))),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
    );
  }

  static InputDecoration textFieldDecorationNew(
      BuildContext context, String hint,
      {String? iconPath, bool isFilled = false}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: iconPath != null
          ? IconButton(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.zero,
              onPressed: null,
              icon: SvgPicture.asset(iconPath),
            )
          : null,
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      contentPadding: const EdgeInsets.only(
        top: 10,
        bottom: 0,
        left: 10,
      ),
      fillColor: AppColor.textfieldFilledColor,
      filled: isFilled,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.textfieldborderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.smallBorderRadius))),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
    );
  }

  static InputDecoration searchFieldDecoration(
      BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: IconButton(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.zero,
          onPressed: null,
          icon: Icon(
            Icons.search,
            color: AppColor.appthemeColor,
          )),
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      contentPadding: const EdgeInsets.only(
        top: 10,
        bottom: 0,
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldEnableColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
    );
  }

  static InputDecoration searchFieldDecoWithSuffixWithLeftBorder(
      BuildContext context, String hint, VoidCallback suffixCallback) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: IconButton(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.zero,
          onPressed: null,
          icon: Icon(
            Icons.search,
            color: AppColor.appthemeColor,
          )),
      suffixIcon: SizedBox(
          height: 25,
          width: 50,
          child: Row(children: [
            Container(
              height: 20,
              width: 2,
              color: Colors.grey.shade200,
            ),
            IconButton(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: suffixCallback,
              icon: Image.asset(
                AppImages().pngImages.icFilter,
                width: AppSizes().widgetSize.iconWidth,
                height: AppSizes().widgetSize.iconHeight,
              ),
              // icon: ,
            ),
          ])),
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      contentPadding: const EdgeInsets.only(
        top: 10,
        bottom: 0,
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldEnableColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
    );
  }

  static InputDecoration searchFieldDecoWithSuffix(
      BuildContext context, String hint, VoidCallback suffixCallback) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: IconButton(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.zero,
          onPressed: null,
          icon: Icon(
            Icons.search,
            color: AppColor.appthemeColor,
          )),
      suffixIcon: IconButton(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: suffixCallback,
        icon: Image.asset(
          AppImages().pngImages.icFilter,
          width: AppSizes().widgetSize.iconWidth,
          height: AppSizes().widgetSize.iconHeight,
        ),
        // icon: ,
      ),
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      contentPadding: const EdgeInsets.only(
        top: 10,
        bottom: 0,
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldEnableColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius))),
    );
  }

  static InputDecoration simpletextFieldDecoration(
      BuildContext context, String hint, bool isFilled) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      contentPadding: const EdgeInsets.only(top: 10, bottom: 0, left: 10),
      fillColor: AppColor.textfieldFilledColor,
      filled: isFilled,
      counterText: "",
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.textfieldborderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.smallBorderRadius))),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textfieldborderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
    );
  }

  static InputDecoration textFieldDecorationWithSuffix(
      BuildContext context, String hint, String iconPath) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: IconButton(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        onPressed: null,
        icon: SvgPicture.asset(iconPath),
      ),
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      contentPadding: const EdgeInsets.only(top: 10, bottom: 0, left: 13),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.fieldBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.smallBorderRadius))),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.fieldEnableColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.fieldBorderColor),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.fieldBorderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
    );
  }

  static InputDecoration textFieldDecorationDollar(
      BuildContext context, String hint, String errorText) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: IconButton(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        onPressed: null,
        icon: Icon(Icons.attach_money,
            color: Colors.black,
            size: MediaQuery.of(context).size.height * 0.025),
      ),
      counterText: "",
      hintStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.simpleFontSize),
      errorStyle: TextStyle(
          color: AppColor.textbuttonColor,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: MediaQuery.of(context).size.height *
              AppSizes().fontSize.mediumFontSize),
      contentPadding: const EdgeInsets.only(top: 15, bottom: 0, left: 0),
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
    );
  }
}
