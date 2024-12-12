import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/view/notification_screen/notification_page.dart';
import 'package:Siesta/view/travellerView/bookings/booking_page.dart';
import 'package:Siesta/view/travellerView/home/drawer_page.dart';
import 'package:Siesta/view/travellerView/message_screen/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../find_guide/find_experience_screen.dart';
import '../find_guide/find_guide_page.dart';
import '../itinerary/itineary_page.dart';

// ignore: must_be_immutable
class TravellerHomePage extends StatefulWidget {
  TravellerHomePage({Key? key, required int bottomTab, String? from})
      : super(key: key) {
    tabIndex = bottomTab;
    if (from != null) {
      fromWhere = from;
      setWidgetOptions();
    }
  }

  int tabIndex = 0;

  @override
  State<TravellerHomePage> createState() => _TravellerHomePageState();
}

String fromWhere = "";
List<Widget> _widgetOptions = <Widget>[
  // const FindGuidePage(),
  const FindExperienceScreen(),
  const BookingPage(),
  MessagePage(fromWhere: fromWhere),
  ItineraryPage(fromWhere: ""),
];
setWidgetOptions() {
  if (fromWhere == "chat_with_guide") {
    _widgetOptions.clear();
    _widgetOptions = [
      // const FindGuidePage(),
      const FindExperienceScreen(),
      const BookingPage(),
      MessagePage(fromWhere: fromWhere),
      ItineraryPage(fromWhere: ""),
    ];
  } else {
    _widgetOptions.clear();
    _widgetOptions = [
      // const FindGuidePage(),
      const FindExperienceScreen(),
      const BookingPage(),
      MessagePage(fromWhere: ""),
      ItineraryPage(fromWhere: ""),
    ];
  }
}

class _TravellerHomePageState extends State<TravellerHomePage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  int selectedTab = 0;
  String titleText = AppStrings().home;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedTab = widget.tabIndex;
      if (selectedTab == 0) {
        titleText = AppStrings().findExperience;
      } else if (selectedTab == 1) {
        titleText = AppStrings().mybookings;
      } else if (selectedTab == 2) {
        titleText = AppStrings().messages;
      } else if (selectedTab == 3) {
        titleText = AppStrings().itineraryText;
      }
    });
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
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
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
            bottomNavigationBar: bottomBar(),
            drawer: Drawer(
              elevation: 4,
              width: screenWidth * 0.8,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(screenWidth * 0.15)),
              ),
              child: const DrawerPage(),
            ),
            body: _widgetOptions[selectedTab]));
  }

  BottomNavigationBar bottomBar() {
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
                ? AppImages().pngImages.icFilledsearch
                : AppImages().pngImages.unSelectedSearch,
            width: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            height: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            fit: BoxFit.fill,
          ),
          // label: AppStrings().findGuide,
          label: AppStrings().findExperience,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            selectedTab == 1
                ? AppImages().pngImages.icbookingFilled
                : AppImages().pngImages.unSelectedBookings,
            width: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            height: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            fit: BoxFit.fill,
          ),
          label: AppStrings().mybookings,
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
                ? AppImages().pngImages.icitinary
                : AppImages().pngImages.icItineraryUnselected,
            width: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            height: screenWidth * AppSizes().widgetSize.bottomBarIconHeight,
            fit: BoxFit.fill,
          ),
          label: AppStrings().itineraryText,
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
        fromWhere = "";
        setWidgetOptions();
        setState(() {
          selectedTab = index;
          if (selectedTab == 0) {
            titleText = AppStrings().home;
          } else if (selectedTab == 1) {
            titleText = AppStrings().mybookings;
          } else if (selectedTab == 2) {
            titleText = AppStrings().messages;
          } else if (selectedTab == 3) {
            titleText = AppStrings().itineraryText;
          }
        });
      },
    );
  }
}
