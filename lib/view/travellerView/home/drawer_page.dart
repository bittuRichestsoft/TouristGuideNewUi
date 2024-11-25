import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:Siesta/view/all_dialogs/dialog_with_twoButton.dart';
import 'package:Siesta/view_models/updateTravellerProfileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  List<String> titleString = [
    AppStrings().findGuide,
    AppStrings().bookings,
    AppStrings().messages,
    AppStrings().transactionHistory,
    AppStrings().itineraries,
    AppStrings().profile,
    AppStrings().notification,
    AppStrings().aboutUs,
    AppStrings().logout,
    // AppStrings().deleteAcc
    "Find Traveller Guides",
  ];
  List<String> iconPath = [
    AppImages().pngImages.icSearch,
    AppImages().pngImages.icBookings,
    AppImages().pngImages.icMessage,
    AppImages().pngImages.icTransaction,
    AppImages().pngImages.icitinary,
    AppImages().pngImages.icProfile,
    AppImages().pngImages.icNotification,
    AppImages().pngImages.icAbout,
    AppImages().pngImages.icLogout,
    //  AppImages().pngImages.icDelete,
    AppImages().pngImages.icSearch,
  ];
  String email = "";
  String username = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
  }

  asyncMethod() async {
    String val1 = await PreferenceUtil().getEmail();
    String val2 = await PreferenceUtil().getFirstName();
    String val3 = await PreferenceUtil().getProgileImage();
    setState(() {
      email = val1;
      username = val2;
      profileImage = val3;
    });
    debugPrint(email);
    debugPrint(profileImage);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<UpdateTravellerProfileViewModel>.reactive(
        viewModelBuilder: () => UpdateTravellerProfileViewModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              profileContainer(model.profileImage, model),
              menuContainer(model)
            ],
          );
        });
  }

  Widget profileContainer(img, model) {
    return Container(
      width: screenWidth * 0.8,
      height: MediaQuery.of(context).size.height * 0.3,
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
            profilePic(img),
            UiSpacer.verticalSpace(
                space: AppSizes().widgetSize.smallPadding, context: context),
            TextView.headingWhiteText(text: model.username, context: context),
            /*UiSpacer.verticalSpace(space: 0.01, context: context),
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
      height: screenHeight * 0.7,
      child: ListView.separated(
        padding:
            EdgeInsets.all(screenWidth * AppSizes().widgetSize.largePadding),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 13, right: 13),
            child: Divider(
              color: AppColor.textfieldborderColor,
            )),
        itemCount: titleString.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.pop(context);
              onTapListTile(index);
            },
            trailing: titleString[index] == AppStrings().notification
                ? notificationSwitch(model)
                : const SizedBox(),
            minVerticalPadding: 0.0,
            horizontalTitleGap: 20.0,
            minLeadingWidth: 20,
            visualDensity: const VisualDensity(vertical: -2),
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

  Widget notificationSwitch(UpdateTravellerProfileViewModel model) {
    return Transform.scale(
      scale: 0.9,
      child: CupertinoSwitch(
        activeColor: AppColor.switchColor,
        trackColor: AppColor.disableColor,
        thumbColor: Colors.white,
        value: model.isEnableNotification,
        onChanged: (value) =>
            setState(() => {model.travellerNotificationOnOff(context, value)}),
      ),
    );
  }

  onTapListTile(int index) async {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.travellerHomePage);
        break;

      case 1:
        Navigator.pushNamed(context, AppRoutes.travellerHomePageTab2);
        break;

      case 2:
        Navigator.pushNamed(context, AppRoutes.travellerHomePageTab3);
        break;

      case 3:
        Navigator.pushNamed(context, AppRoutes.transactionHistory);
        break;

      case 4:
        Navigator.pushNamed(context, AppRoutes.itineraryPage,
            arguments: "drawer");
        break;

      case 5:
        Navigator.pushReplacementNamed(context, AppRoutes.profilePage);
        break;

      case 6:
        Navigator.pushNamed(context, AppRoutes.notificationPage);
        break;

      case 7:
        Map map = {"from": "drawer", "role": "TRAVELLER"};
        Navigator.pushNamed(context, AppRoutes.commonWebViewPage,
            arguments: map);
        break;

      case 8:
        GlobalUtility.showDialogFunction(
            context,
            DialogWithTwoButton(
                from: "logout",
                cancelText: AppStrings().logoutNo,
                headingText: AppStrings().logout,
                okayText: AppStrings().logoutYes,
                subContent: AppStrings().logoutHeading));
        break;
      case 9:
        Navigator.pushNamed(
          context,
          AppRoutes.findTouristGuide,
        );
        break;

      /* case 9:
        GlobalUtility.showDialogFunction(
            context,
            DialogDeleteAccount(
                from: "delete",
                cancelText: AppStrings().logoutNo,
                headingText: AppStrings().deleteAcc,
                okayText: AppStrings().logoutYes,
                subContent: AppStrings().deleteHeading));
        break;*/
    }
  }
}
