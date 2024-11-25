import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/view_models/notificationsModel.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:Siesta/api_requests/api.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  ScrollController scrollController = ScrollController();
  int pageCount = 1;
  @override
  void initState() {
    getRole();
    super.initState();
  }

  String role = "";
  getRole() async {
    role = await PreferenceUtil().getRoleName();
    debugPrint("ROLE ==== $role");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<NotificationModel>.reactive(
        viewModelBuilder: () => NotificationModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (!model.isBusy) {
                pageCount = pageCount + 1;
                if (model.selectedTabIndex == 0) {
                  model.getNotifications(context, pageCount, "All");
                  model.notifyListeners();
                } else if (model.selectedTabIndex == 1) {
                  model.getNotifications(context, pageCount, "booking");
                  model.notifyListeners();
                } else {
                  model.getNotifications(context, pageCount, "payment");
                  model.notifyListeners();
                }
              }
            } else {}
          });
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              elevation: 0,
              title: TextView.headingWhiteText(
                  context: context, text: "Notification"),
              leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColor.whiteColor,
                  ),
                  onPressed: () {
                    if (role == "GUIDE") {
                      Navigator.pushNamedAndRemoveUntil(context,
                          AppRoutes.touristGuideHome, (route) => false);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(context,
                          AppRoutes.travellerHomePage, (route) => false);
                    }
                  }),
              actions: [
                model.isBusy
                    ? SizedBox(
                        width: screenWidth * 0.2,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColor.whiteColor),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            body: DefaultTabController(
              length: role == "GUIDE" ? 3 : 2,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leadingWidth: screenWidth * 0.6,
                  elevation: 0,
                  leading: TabBar(
                    padding: EdgeInsets.zero,
                    indicatorColor: AppColor.appthemeColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.zero,
                    unselectedLabelColor: AppColor.dontHaveTextColor,
                    onTap: (index) {
                      model.selectedTabIndex = index;
                      model.notifyListeners();
                      setState(() {
                        pageCount = 1;
                      });
                      if (index == 0) {
                        model.getNotifications(context, 1, "All");
                        model.notifyListeners();
                      } else if (index == 1) {
                        model.getNotifications(context, 1, "booking");
                        model.notifyListeners();
                      } else {
                        model.getNotifications(context, 1, "payment");
                        model.notifyListeners();
                      }
                    },
                    tabs: role == "GUIDE"
                        ? [
                            Tab(
                              child: TextView.normalText(
                                  context: context,
                                  text: "All",
                                  textColor: AppColor.appthemeColor,
                                  textSize: AppSizes().fontSize.simpleFontSize,
                                  fontFamily: AppFonts.nunitoMedium),
                            ),
                            Tab(
                              child: TextView.normalText(
                                  context: context,
                                  text: AppStrings().bookings,
                                  textColor: AppColor.appthemeColor,
                                  textSize: AppSizes().fontSize.simpleFontSize,
                                  fontFamily: AppFonts.nunitoMedium),
                            ),
                            Tab(
                              child: TextView.normalText(
                                  context: context,
                                  text: AppStrings().payment,
                                  textColor: AppColor.appthemeColor,
                                  textSize: AppSizes().fontSize.simpleFontSize,
                                  fontFamily: AppFonts.nunitoMedium),
                            )
                          ]
                        : [
                            Tab(
                              child: TextView.normalText(
                                  context: context,
                                  text: "All",
                                  textColor: AppColor.appthemeColor,
                                  textSize: AppSizes().fontSize.simpleFontSize,
                                  fontFamily: AppFonts.nunitoMedium),
                            ),
                            Tab(
                              child: TextView.normalText(
                                  context: context,
                                  text: AppStrings().bookings,
                                  textColor: AppColor.appthemeColor,
                                  textSize: AppSizes().fontSize.simpleFontSize,
                                  fontFamily: AppFonts.nunitoMedium),
                            ),
                          ],
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        if (model.notificatiosList.isNotEmpty) {
                          for (var i = 0;
                              i < model.notificatiosList.length;
                              i++) {
                            if (model.notificatiosList[i].status != 3) {
                              model.listToMarkedRead
                                  .add(model.notificatiosList[i].id);
                              model.notifyListeners();
                            }
                          }
                          setState(() {
                            pageCount = 1;
                          });
                          if (model.selectedTabIndex == 0) {
                            model.readNotification(
                                context, model.listToMarkedRead, "All");
                            model.notifyListeners();
                          } else if (model.selectedTabIndex == 1) {
                            model.readNotification(
                                context, model.listToMarkedRead, "booking");
                            model.notifyListeners();
                          } else {
                            model.readNotification(
                                context, model.listToMarkedRead, "payment");
                            model.notifyListeners();
                          }
                          debugPrint(
                              "sjljjlfjsjsf${model.selectedTabIndex}${model.listToMarkedRead.toString()}");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16, left: 0, right: 15, bottom: 0),
                        child: Text(
                          AppStrings().markAllRead,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: AppColor.appthemeColor,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppSizes().fontSize.simpleFontSize,
                              fontFamily: AppFonts.nunitoMedium),
                        ),
                      ),
                    )
                  ],
                ),
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    allListView(model),
                    bookingListView(model),
                    paymentListView(model)
                  ],
                ),
              ),
            ),
          );
        });
  }

  // ALL notification view
  Widget allListView(NotificationModel model) {
    return ListView.builder(
      controller: scrollController,
      itemCount: model.notificatiosList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () async => {
                  if (model.notificatiosList[index].status != 3)
                    {
                      setState(() {
                        pageCount = 1;
                      }),
                      model.readNotification(
                          context, [model.notificatiosList[index].id], "All"),
                    },
                  if (await PreferenceUtil().getRoleName() == Api.guideRoleName)
                    {
                      if (model.notificatiosList[index].description
                          .contains("Booking"))
                        {
                          Navigator.pushNamedAndRemoveUntil(context,
                              AppRoutes.touristGuideHome, (route) => false)
                        }
                    }
                  else
                    {
                      if (model.notificatiosList[index].description
                              .contains("itinerary") ||
                          model.notificatiosList[index].description
                              .contains("booking"))
                        {
                          Navigator.pushNamedAndRemoveUntil(context,
                              AppRoutes.travellerHomePageTab2, (route) => false)
                        }
                    },
                },
            child: ListTile(
              leading: Container(
                  color: Colors.transparent,
                  width: screenWidth * 0.7,
                  child: Text(
                    model.notificatiosList.isNotEmpty
                        ? model.notificatiosList[index].description
                        : "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoSemiBold,
                        color: AppColor.textColorBlack,
                        fontWeight: FontWeight.w500),
                    maxLines: 2,
                  )),
              trailing: TextView.normalText(
                  context: context,
                  text: model.notificatiosList.isNotEmpty
                      ? model.notificatiosList[index].timeAgo
                      : "",
                  textColor: AppColor.dontHaveTextColor,
                  textSize: AppSizes().fontSize.mediumFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
              tileColor: model.notificatiosList[index].status == 0 ||
                      model.notificatiosList[index].status == 1
                  ? AppColor.notificationListColor
                  : Colors.white,
            ));
      },
    );
  }

  // Booking notification view
  Widget bookingListView(NotificationModel model) {
    return ListView.builder(
      controller: scrollController,
      itemCount: model.notificatiosList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () async => {
                  if (model.notificatiosList[index].status != 3)
                    {
                      setState(() {
                        pageCount = 1;
                      }),
                      model.readNotification(context,
                          [model.notificatiosList[index].id], "booking")
                    },
                  if (await PreferenceUtil().getRoleName() == Api.guideRoleName)
                    {
                      if (model.notificatiosList[index].description
                          .contains("Booking"))
                        {
                          Navigator.pushNamedAndRemoveUntil(context,
                              AppRoutes.touristGuideHome, (route) => false)
                        }
                    }
                  else
                    {
                      if (model.notificatiosList[index].description
                              .contains("itinerary") ||
                          model.notificatiosList[index].description
                              .contains("booking"))
                        {
                          Navigator.pushNamedAndRemoveUntil(context,
                              AppRoutes.travellerHomePageTab2, (route) => false)
                        }
                    },
                },
            child: ListTile(
              leading: Container(
                  color: Colors.transparent,
                  width: screenWidth * 0.68,
                  child: Text(
                    model.notificatiosList.isNotEmpty
                        ? model.notificatiosList[index].description
                        : "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoSemiBold,
                        color: AppColor.textColorBlack,
                        fontWeight: FontWeight.w500),
                    maxLines: 2,
                  )),
              trailing: TextView.normalText(
                  context: context,
                  text: model.notificatiosList.isNotEmpty
                      ? model.notificatiosList[index].timeAgo
                      : "",
                  textColor: AppColor.dontHaveTextColor,
                  textSize: AppSizes().fontSize.mediumFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
              tileColor: model.notificatiosList[index].status == 0 ||
                      model.notificatiosList[index].status == 1
                  ? AppColor.notificationListColor
                  : Colors.white,
            ));
      },
    );
  }

  // Payment notification view
  Widget paymentListView(NotificationModel model) {
    return ListView.builder(
      controller: scrollController,
      itemCount: model.notificatiosList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () async => {
                  if (model.notificatiosList[index].status != 3)
                    {
                      setState(() {
                        pageCount = 1;
                      }),
                      model.readNotification(context,
                          [model.notificatiosList[index].id], "payment")
                    },
                },
            child: ListTile(
              leading: Container(
                color: Colors.transparent,
                width: screenWidth * 0.68,
                child: Text(
                  model.notificatiosList.isNotEmpty
                      ? model.notificatiosList[index].description
                      : "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.simpleFontSize,
                      fontFamily: AppFonts.nunitoSemiBold,
                      color: AppColor.textColorBlack,
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                ),
              ),
              trailing: TextView.normalText(
                  context: context,
                  text: model.notificatiosList.isNotEmpty
                      ? model.notificatiosList[index].timeAgo
                      : "",
                  textColor: AppColor.dontHaveTextColor,
                  textSize: AppSizes().fontSize.mediumFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
              tileColor: (model.notificatiosList.isNotEmpty &&
                      (model.notificatiosList[index].status == 0 ||
                          model.notificatiosList[index].status == 1))
                  ? AppColor.notificationListColor
                  : Colors.white,
            ));
      },
    );
  }
}
