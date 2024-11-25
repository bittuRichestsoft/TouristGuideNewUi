import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/view/notification_screen/notification_page.dart';
import 'package:Siesta/view/touristGuideView/bookingHistory/booking_history_page.dart';
import 'package:Siesta/view/touristGuideView/guide_bookings/guide_bookings_page.dart';
import 'package:Siesta/view/touristGuideView/home/guide_drawer_page.dart';
import 'package:Siesta/view/touristGuideView/tourist_profile_view/tourist_profile_page.dart';
import 'package:Siesta/view/touristGuideView/tourist_profile_view/tourist_profile_page_new.dart';
import 'package:Siesta/view/travellerView/message_screen/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utility/preference_util.dart';

// ignore: must_be_immutable
class TouristGuideHomePage extends StatefulWidget {
  TouristGuideHomePage(
      {Key? key, required int bottomTab, required String fromWhere})
      : super(key: key) {
    tabIndex = bottomTab;
    from = fromWhere;
    setWidgetOptions();
  }
  int tabIndex = 0;
  @override
  State<TouristGuideHomePage> createState() => _TravellerHomePageState();
}

String from = "";
List<Widget> _widgetOptions = [];

setWidgetOptions() {
  if (from == "message_guide") {
    _widgetOptions.clear();
    _widgetOptions = [
      const GuideBookingsPage(),
      const BookingHistoryScreen(),
      MessagePage(fromWhere: "message_guide"),
      const TouristProfilePage(),
    ];
  } else {
    _widgetOptions.clear();
    _widgetOptions = [
      const GuideBookingsPage(),
      const BookingHistoryScreen(),
      MessagePage(fromWhere: ""),
      // const TouristProfilePage(),
      TouristProfilePageNew()
    ];
  }
}

class _TravellerHomePageState extends State<TouristGuideHomePage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  int selectedTab = 0;
  String titleText = AppStrings().home;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getWaitingStatus();

    setState(() {
      selectedTab = widget.tabIndex;
      if (selectedTab == 0) {
        titleText = AppStrings().home;
      } else if (selectedTab == 1) {
        titleText = AppStrings().bookingsHistory;
      } else if (selectedTab == 2) {
        titleText = AppStrings().messages;
      } else if (selectedTab == 3) {
        titleText = AppStrings().profile;
      }
    });
  }

  bool? isWaiting;
  getWaitingStatus() async {
    await PreferenceUtil().getWaitingStatus();

    debugPrint(
        "WAITING STATUS ---- ${await PreferenceUtil().getWaitingStatus()}");
    isWaiting = PreferenceUtil().getWaitingStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () async {
          if (selectedTab == 0) {
            return true;
          } else {
            setState(() {
              selectedTab = 0;
            });
            return false;
          }
        },
        child: Scaffold(
            backgroundColor: AppColor.whiteColor,
            key: _scaffoldKey,
            appBar: AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              elevation: 0,
              title:
                  TextView.headingWhiteText(context: context, text: titleText),
              leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: AppColor.whiteColor,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  }),
              actions: [
                IconButton(
                    icon: Image.asset(
                      AppImages().pngImages.icNotification,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationPage()));
                    }),
              ],
            ),
            bottomNavigationBar: bottombar(),
            drawer: Drawer(
              elevation: 4,
              width: screenWidth * 0.8,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(screenWidth * 0.15)),
              ),
              child: const GuideDrawerPage(),
            ),
            body: _widgetOptions[selectedTab]));
  }

  BottomNavigationBar bottombar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedFontSize:
          screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
      iconSize: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
      elevation: 4,
      backgroundColor: AppColor.whiteColor,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image.asset(
            selectedTab == 0
                ? AppImages().pngImages.icGuideBookings
                : AppImages().pngImages.icUnselectedBookings,
            width: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            height: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            fit: BoxFit.fill,
          ),
          label: AppStrings().bookings,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            selectedTab == 1
                ? AppImages().pngImages.icSelectedGuideHistory
                : AppImages().pngImages.icGuideHistory,
            width: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            height: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            fit: BoxFit.fill,
          ),
          label: AppStrings().history,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            selectedTab == 2
                ? AppImages().pngImages.messageFilled
                : AppImages().pngImages.unSelectedMesssage,
            width: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            height: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            fit: BoxFit.fill,
          ),
          label: AppStrings().messages,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            selectedTab == 3
                ? AppImages().pngImages.icSelectedProfile
                : AppImages().pngImages.icProfile,
            width: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            height: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            fit: BoxFit.fill,
          ),
          label: AppStrings().profile,
        ),
      ],
      selectedIconTheme: IconThemeData(color: AppColor.appthemeColor),
      unselectedIconTheme: IconThemeData(color: AppColor.hintTextColor),
      selectedLabelStyle: TextStyle(
          color: AppColor.appthemeColor,
          fontSize: screenHeight * AppSizes().fontSize.mediumFontSize,
          fontFamily: AppFonts.nunitoSemiBold),
      unselectedLabelStyle: TextStyle(
          color: AppColor.hintTextColor,
          fontSize: screenHeight * AppSizes().fontSize.mediumFontSize,
          fontFamily: AppFonts.nunitoSemiBold),
      unselectedItemColor: AppColor.hintTextColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: AppColor.appthemeColor,
      currentIndex: selectedTab,
      onTap: (index) {
        from = "";
        setWidgetOptions();
        setState(() {
          selectedTab = index;
          if (selectedTab == 0) {
            titleText = AppStrings().home;
          } else if (selectedTab == 1) {
            titleText = AppStrings().bookingsHistory;
          } else if (selectedTab == 2) {
            titleText = AppStrings().messages;
          } else if (selectedTab == 3) {
            titleText = AppStrings().profile;
          }
        });
      },
    );
  }
}
