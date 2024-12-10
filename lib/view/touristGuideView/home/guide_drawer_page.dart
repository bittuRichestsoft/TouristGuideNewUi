import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../view_models/guide_drawer_model/guide_drawer_model.dart';

class GuideDrawerPage extends StatefulWidget {
  const GuideDrawerPage({Key? key}) : super(key: key);

  @override
  State<GuideDrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<GuideDrawerPage> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<GuideDrawerModel>.reactive(
        viewModelBuilder: () => GuideDrawerModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Column(
            children: [
              profileContainer(model),
              Expanded(child: menuContainer(model)),
            ],
          );
        });
  }

  Widget profileContainer(GuideDrawerModel model) {
    return Container(
      width: screenWidth * 0.8,
      height: MediaQuery.of(context).size.height * 0.28,
      decoration: BoxDecoration(
          color: AppColor.appthemeColor,
          borderRadius: BorderRadius.only(
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width * 0.15))),
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.verticalPadding, context: context),
            profilePic(model.profileImageUrl ?? ""),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.smallPadding, context: context),
            TextView.headingWhiteText(
                text: model.guideName ?? "", context: context),
            /*  UiSpacer.verticalSpace(space: 0.01, context: context),
            Text(
              model.email,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height *
                      AppSizes().fontSize.simpleFontSize,
                  fontFamily: AppFonts.nunitoRegular,
                  color: AppColor.whiteColor),
              textAlign: TextAlign.center,
            )*/
          ],
        ),
      ),
    );
  }

  Widget menuContainer(GuideDrawerModel model) {
    return Container(
      color: AppColor.whiteColor,
      width: screenWidth * 0.85,
      // height: screenHeight * 0.75,
      child: ListView.separated(
        padding:
            EdgeInsets.all(screenWidth * AppSizes().widgetSize.normalPadding18),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(
          color: AppColor.textfieldborderColor,
        ),
        itemCount: model.titleString.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              model.onTapListTile(context, index);
            },
            trailing: model.titleString[index] == AppStrings().notification
                ? notificationSwitch(model)
                : model.titleString[index] == AppStrings().availability
                    ? availbilitySwitch(model)
                    : const SizedBox(),
            minVerticalPadding: 0.0,
            horizontalTitleGap: 20.0,
            minLeadingWidth: 20,
            visualDensity: const VisualDensity(vertical: -3),
            title: TextView.semiBoldText(
                text: model.titleString[index].toString(),
                context: context,
                textColor: AppColor.textfieldColor),
            leading: Image.asset(
              model.iconPath[index],
              width: AppSizes().widgetSize.iconWidth,
              height: AppSizes().widgetSize.iconHeight,
              color: AppColor.appthemeColor,
            ),
          );
        },
      ),
    );
  }

  Widget profilePic(img) {
    return Container(
      width: screenWidth * AppSizes().widgetSize.profilePicWidth,
      height: screenWidth * AppSizes().widgetSize.profilePicHeight,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(color: AppColor.whiteColor, width: 2),
          shape: BoxShape.circle,
          image: img != null && img != ""
              ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(img))
              : DecorationImage(
                  image:
                      AssetImage(AppImages().pngImages.icProfilePlaceholder))),
    );
  }

  Widget notificationSwitch(GuideDrawerModel model) {
    return CupertinoSwitch(
      activeColor: Colors.green,
      trackColor: AppColor.disableColor,
      thumbColor: Colors.white,
      value: model.isEnableNotification,
      onChanged: (value) => {model.guideNotificationOnOff(context, value)},
    );
  }

  Widget availbilitySwitch(GuideDrawerModel model) {
    return CupertinoSwitch(
        activeColor: Colors.green,
        trackColor: AppColor.disableColor,
        thumbColor: Colors.white,
        value: model.isEnableAvailability,
        onChanged: (value) =>
            // setState(() => {
            // model.isEnableAvailbility = value;
            // model.notifyListeners();
            model.guideAvailability(context, value)

        // }),
        );
  }
}
