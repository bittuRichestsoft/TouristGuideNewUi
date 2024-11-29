import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../app_constants/app_color.dart';
import '../app_constants/app_fonts.dart';
import '../app_constants/app_sizes.dart';
import '../common_widgets/vertical_size_box.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      this.textEditingController,
      this.onChange,
      this.isFilled,
      this.hintText,
      this.keyboardType,
      this.validator,
      this.headingText,
      this.minLines,
      this.maxLines,
      this.suffixIconPath,
      this.suffixWidget,
      this.readOnly,
      this.onTap,
      this.borderRadius,
      this.maxLength,
      this.inputFormatter,
      this.prefixWidget});
  final TextEditingController? textEditingController;
  final Function(String)? onChange;
  final Function()? onTap;
  final bool? isFilled;
  final String? hintText;
  final TextInputType? keyboardType;
  final String Function(String?)? validator;
  final String? headingText;
  final int? minLines;
  final int? maxLines;
  final double? borderRadius;
  final String? suffixIconPath;
  final bool? readOnly;
  final Widget? suffixWidget; // preference to it
  final Widget? prefixWidget;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatter;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headingText != null)
          TextView.mediumText(
            context: context,
            text: widget.headingText,
            textColor: AppColor.greyColor,
            textSize: 0.018,
            textAlign: TextAlign.start,
          ),
        if (widget.headingText != null)
          UiSpacer.verticalSpace(space: 0.01, context: context),
        TextFormField(
          readOnly: widget.readOnly ?? false,
          controller: widget.textEditingController,
          onChanged: widget.onChange,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.start,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          maxLength: widget.maxLength,
          style: TextStyle(
              color: AppColor.lightBlack,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.simpleFontSize),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixWidget,
            suffixIcon: widget.suffixWidget != null
                ? widget.suffixWidget
                : widget.suffixIconPath != null
                    ? Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: SvgPicture.asset(
                          widget.suffixIconPath!,
                          width: 20,
                          height: 20,
                          color: AppColor.greyColor,
                        ),
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
            filled: widget.isFilled,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.textfieldborderColor),
                borderRadius: BorderRadius.all(Radius.circular(
                    widget.borderRadius ??
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
          ),
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.next,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          inputFormatters: widget.inputFormatter,
        ),
      ],
    );
  }
}
