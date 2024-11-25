import 'package:Siesta/app_constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CommonLoaderDialog extends StatelessWidget {
  const CommonLoaderDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Container(
        color: Colors.transparent,
        child: LoadingAnimationWidget.inkDrop(color: AppColor.appthemeColor,
            size:MediaQuery.of(context).size.width*0.1)
      ),
    );
  }
}
