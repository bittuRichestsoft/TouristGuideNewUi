import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/all_dialogs/dialog_with_twoButton.dart';
import 'package:Siesta/view_models/guide_models/guideUpdateProfileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GuideDrawerPage extends StatefulWidget {
  const GuideDrawerPage({Key? key}) : super(key: key);

  @override
  State<GuideDrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<GuideDrawerPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isEnableAvailbility = false;
  List<String> titleString = [
    AppStrings().receivedBookings,
    AppStrings().bookingsHistory,
    AppStrings().messages,
    AppStrings().transactions,
    AppStrings().gallery,
    AppStrings().notification,
    AppStrings().availability,
    AppStrings().aboutUs,
    //AppStrings().wallet,
    AppStrings().logout,
    //  AppStrings().deleteAcc
  ];

  List<String> iconPath = [
    AppImages().pngImages.icCalendar,
    AppImages().pngImages.icitinary,
    AppImages().pngImages.icMessage,
    AppImages().pngImages.icTransaction,
    AppImages().pngImages.icGallery,
    AppImages().pngImages.icNotification,
    AppImages().pngImages.icAvailbility,
    // AppImages().pngImages.icWallet,
    AppImages().pngImages.icAbout,
    AppImages().pngImages.icLogout,
    //  AppImages().pngImages.icDelete,
  ];

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<GuideUpdateProfileModel>.reactive(
        viewModelBuilder: () => GuideUpdateProfileModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [profileContainer(model), menuContainer(model)],
          );
        });
  }

  Widget profileContainer(model) {
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
            profilePic(model.profileImage),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.smallPadding, context: context),
            TextView.headingWhiteText(text: model.username, context: context),
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

  Widget menuContainer(model) {
    return Container(
      color: AppColor.whiteColor,
      width: screenWidth * 0.85,
      height: screenHeight * 0.75,
      child: ListView.separated(
        padding:
            EdgeInsets.all(screenWidth * AppSizes().widgetSize.normalPadding18),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(
          color: AppColor.textfieldborderColor,
        ),
        itemCount: titleString.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              onTapListTile(index);
            },
            trailing: titleString[index] == AppStrings().notification
                ? notificationSwitch(model)
                : titleString[index] == AppStrings().availability
                    ? availbilitySwitch(model)
                    : const SizedBox(),
            minVerticalPadding: 0.0,
            horizontalTitleGap: 20.0,
            minLeadingWidth: 20,
            visualDensity: const VisualDensity(vertical: -3),
            title: TextView.semiBoldText(
                text: titleString[index].toString(),
                context: context,
                textColor: AppColor.textfieldColor),
            leading: Image.asset(
              iconPath[index],
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

  Widget notificationSwitch(GuideUpdateProfileModel model) {
    return CupertinoSwitch(
      activeColor: Colors.green,
      trackColor: AppColor.disableColor,
      thumbColor: Colors.white,
      value: model.isEnableNotification,
      onChanged: (value) => {model.guideNotificationOnOff(context, value)},
    );
  }

  Widget availbilitySwitch(GuideUpdateProfileModel model) {
    return CupertinoSwitch(
        activeColor: Colors.green,
        trackColor: AppColor.disableColor,
        thumbColor: Colors.white,
        value: model.isEnableAvailbility,
        onChanged: (value) =>
            // setState(() => {
            // model.isEnableAvailbility = value;
            // model.notifyListeners();
            model.guideAvailability(context, value)

        // }),
        );
  }

  onTapListTile(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.touristGuideHome);
        break;

      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.touristGuideHome1);
        break;

      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.touristGuideHome2);
        break;

      case 3:
        Navigator.pushReplacementNamed(
            context, AppRoutes.transactionHistoryGuide);
        break;

      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.galleryListingPage);
        break;

      case 7:
        Map map = {"from": "drawer", "role": "GUIDE"};
        Navigator.pushReplacementNamed(context, AppRoutes.commonWebViewPage,
            arguments: map);
        break;

      case 8:
        GlobalUtility.showDialogFunction(
            context,
            DialogWithTwoButton(
                from: "guide_logout",
                cancelText: AppStrings().logoutNo,
                headingText: AppStrings().logout,
                okayText: AppStrings().logoutYes,
                subContent: AppStrings().logoutHeading));
        break;

      /*  case 9:
        GlobalUtility.showDialogFunction(
            context,
            DialogDeleteAccount(
                from: "guide_delete",
                cancelText: AppStrings().logoutNo,
                headingText: AppStrings().deleteAcc,
                okayText: AppStrings().logoutYes,
                subContent: AppStrings().deleteHeading));
        break;*/
    }
  }
}
