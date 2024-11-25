import 'package:Siesta/app_constants/app_color.dart';
import 'package:flutter/material.dart';

class CommonProgressLoader {
  commonLoader(BuildContext context) => showDialog(
      barrierDismissible: false,
      useSafeArea: false,
      context: context,
      builder: (ctx) => SizedBox(
          width: 20,
          height: 20,
          child: Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.appthemeColor),
          ))));
}
