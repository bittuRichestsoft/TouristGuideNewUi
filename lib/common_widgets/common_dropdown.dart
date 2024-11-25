import 'package:flutter/material.dart';

import '../app_constants/app_color.dart';
import '../app_constants/app_fonts.dart';

class CustomDropDown extends StatefulWidget {
  final String? title;
  final dynamic dropDownValue;
  final List<dynamic>? itemList;
  final void Function(dynamic)? onChanged;
  final VoidCallback? onTap;
  final bool? isUnderLine;
  const CustomDropDown(
      {this.title,
      this.onChanged,
      this.dropDownValue,
      this.itemList,
      this.isUnderLine,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;
    return DropdownButtonFormField<dynamic>(
      dropdownColor: Colors.white,
      onTap: widget.onTap,
      icon: const Icon(Icons.arrow_drop_down),
      hint: Text(
        widget.title!,
        style: TextStyle(
          fontFamily: AppFonts.nunitoMedium,
          fontSize: screenHeight * 0.017,
          color: AppColor.disableColor,
        ),
      ),
      value: widget.dropDownValue,
      decoration: widget.isUnderLine == true
          ? InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColor.disableTextColor.withOpacity(0.3),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 8,
                bottom: 15,
              ),
            )
          : const InputDecoration(border: InputBorder.none),
      onChanged: widget.onChanged,
      items: widget.itemList!.map<DropdownMenuItem<dynamic>>((dynamic value) {
        return DropdownMenuItem<dynamic>(
            value: value,
            child: Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColor.blackColor,
              ),
            ));
      }).toList(),
    );
  }
}
