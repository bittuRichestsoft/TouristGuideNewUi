import 'package:flutter/material.dart';

class UiSpacer {
  static Widget verticalSpace({double space = 0, BuildContext? context}) =>
      SizedBox(height: MediaQuery.of(context!).size.height * space);

  static Widget verticalSpaceBox({double space = 0}) => SizedBox(height: space);

  static Widget horizontalSpace({double space = 0, BuildContext? context}) =>
      SizedBox(width: MediaQuery.of(context!).size.width * space);

  static Widget emptySpace() => SizedBox.shrink();
}
