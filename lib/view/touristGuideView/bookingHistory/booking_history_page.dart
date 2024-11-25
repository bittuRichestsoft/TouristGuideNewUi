// ignore_for_file: prefer_is_empty, prefer_const_constructors, unnecessary_null_comparison

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/view_models/guide_models/guideReceivedBookingModel.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  ScrollController scrollController = ScrollController();
  int pageCount = 1;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<GuideReceivedBookingModel>.reactive(
        viewModelBuilder: () =>
            GuideReceivedBookingModel(context, "bookingHistory"),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (!model.isBusy) {
                pageCount = pageCount + 1;
                if (model.filterselectedValue == 1) {
                  // all bookings
                  model.getMyBookings(
                      context,
                      pageCount,
                      "",
                      [1, 2, 3, 4, 5, 6, 7, 8, 9],
                      "",
                      "",
                      "",
                      "&completed_booking=[0,1]");
                } else if (model.filterselectedValue == 2) {
                  // ongoing bookings
                  model.getMyBookings(context, pageCount, "", [2, 4, 6, 8], "",
                      "", "", "&completed_booking=[0]");
                } else if (model.filterselectedValue == 3) {
                  // completed bookings
                  model.getMyBookings(context, pageCount, "", [4], "", "", "",
                      "&completed_booking=[1]");
                } else {
                  // cancelled bookings
                  model.getMyBookings(context, pageCount, "", [1, 3, 5, 7, 9],
                      "", "", "", "&completed_booking=[0]");
                }
              }
            }
          });
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal:
                    screenWidth * AppSizes().widgetSize.horizontalPadding),
            children: [
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.normalPadding, context: context),
              searchField(model),
              model.isSearchRunnig == true
                  ? Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.3),
                      child: Text(
                        AppStrings().pleaseWait,
                        style: TextStyle(
                            height: 3,
                            fontFamily: AppFonts.nunitoSemiBold,
                            color: AppColor.fieldEnableColor),
                      ),
                    )
                  : const SizedBox(),
              Column(
                children: [
                  model.isEmtyViewForBooking == true
                      ? Container(
                          height: screenHeight * 0.65,
                          width: screenWidth,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages().pngImages.ivEmptySearch,
                                width: screenWidth * 0.6,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextView.normalText(
                                  context: context,
                                  text: AppStrings().noDataFound,
                                  textColor: AppColor.appthemeColor,
                                  textSize: AppSizes().fontSize.headingTextSize,
                                  fontFamily: AppFonts.nunitoSemiBold),
                            ],
                          ),
                        )
                      : Container(
                          height: screenHeight * 0.73,
                          color: AppColor.whiteColor,
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: RefreshIndicator(
                            onRefresh: model.pullRefresh,
                            child: ListView.builder(
                                controller: scrollController,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    model.guideReceivedBookingList.length,
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight *
                                        AppSizes().widgetSize.normalPadding),
                                itemBuilder: (context, index) {
                                  return historyItemView(index, model);
                                }),
                          )),
                ],
              ),
            ],
          );
        });
  }

  Widget searchField(model) {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        onChanged: (value) {
          if (value != "") {
            model.getMyBookings(
                context, 1, value, [1, 2, 3, 4, 5, 6, 7, 8, 9], "", "", "", "");
          } else {
            model.getMyBookings(
                context, 1, "", [1, 2, 3, 4, 5, 6, 7, 8, 9], "", "", "");
          }
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          hintText: AppStrings().fingGuideSearch,
          prefixIcon: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: AppColor.appthemeColor,
              )),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.simpleFontSize),
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 0,
          ),
          suffixIcon: SizedBox(
            height: 25,
            width: 50,
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 2,
                  color: Colors.grey.shade200,
                ),
                PopupMenuButton<int>(
                  initialValue: model.filterselectedValue,
                  position: PopupMenuPosition.over,
                  icon: Icon(
                    Icons.filter_list,
                    color: AppColor.appthemeColor,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: RadioListTile<int>(
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(vertical: -4, horizontal: -4),
                        title: TextView.normalText(
                            text: "All",
                            context: context,
                            fontFamily: AppFonts.nunitoMedium,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            textColor: AppColor.lightBlack),
                        value: 1,
                        groupValue: model.filterselectedValue,
                        onChanged: (int? value) {
                          model.filterselectedValue = value;
                          model.notifyListeners();
                          model.getMyBookingsFilter(value);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: RadioListTile<int>(
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(vertical: -4, horizontal: -4),
                        title: TextView.normalText(
                            text: "OnGoing",
                            context: context,
                            fontFamily: AppFonts.nunitoMedium,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            textColor: AppColor.lightBlack),
                        value: 2,
                        groupValue: model.filterselectedValue,
                        onChanged: (int? value) {
                          model.filterselectedValue = value;
                          model.notifyListeners();
                          model.getMyBookingsFilter(value);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: RadioListTile<int>(
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(vertical: -4, horizontal: -4),
                        title: TextView.normalText(
                            text: "Completed",
                            context: context,
                            fontFamily: AppFonts.nunitoMedium,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            textColor: AppColor.lightBlack),
                        value: 3,
                        groupValue: model.filterselectedValue,
                        onChanged: (int? value) {
                          model.filterselectedValue = value;
                          model.notifyListeners();
                          model.getMyBookingsFilter(value);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: RadioListTile<int>(
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(vertical: -4, horizontal: -4),
                        title: TextView.normalText(
                            text: "Cancelled",
                            context: context,
                            fontFamily: AppFonts.nunitoMedium,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            textColor: AppColor.lightBlack),
                        value: 4,
                        groupValue: model.filterselectedValue,
                        onChanged: (int? value) {
                          model.filterselectedValue = value;
                          model.notifyListeners();
                          model.getMyBookingsFilter(value);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                  offset: const Offset(0, 35),
                  color: Colors.white,
                  elevation: 2,
                  onSelected: (value) {},
                ),
              ],
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.largeBorderRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldEnableColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.largeBorderRadius))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.largeBorderRadius))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.largeBorderRadius))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.largeBorderRadius))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.largeBorderRadius))),
        ),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget historyItemView(int index, GuideReceivedBookingModel model) {
    return GestureDetector(
        onTap: () {
          var bookingId = model.guideReceivedBookingList.length > 0
              ? model.guideReceivedBookingList[index].id
              : "";
          Navigator.pushNamed(context, AppRoutes.bookingHistoryDetail,
              arguments: {"bookingId": bookingId});
        },
        child: Card(
            color: AppColor.whiteColor,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    screenWidth * AppSizes().widgetSize.mediumBorderRadius))),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.disableColor,
                      blurRadius: 3.0, // soften the shadow
                      spreadRadius: 1.0, //extend the shadow
                    )
                  ],
                  color: AppColor.whiteColor),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenWidth * 0.02),
                      leading: profileImage(
                          model.guideReceivedBookingList[index].travellerDetails != null &&
                                  model.guideReceivedBookingList.length > 0
                              ? model.guideReceivedBookingList[index]
                                          .travellerDetails!.userDetail !=
                                      null
                                  ? model
                                      .guideReceivedBookingList[index]
                                      .travellerDetails!
                                      .userDetail!
                                      .profilePicture
                                  : ""
                              : ""),
                      title: Transform.translate(
                        offset: Offset(-8, 0),
                        child: TextView.normalText(
                            textColor: AppColor.appthemeColor,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            fontFamily: AppFonts.nunitoBold,
                            text: model.guideReceivedBookingList.length > 0
                                ? GlobalUtility().firstLetterCapital(
                                    "${model.guideReceivedBookingList[index].firstName} ${model.guideReceivedBookingList[index].lastName}")
                                : "",
                            context: context),
                      ),
                      isThreeLine: false,
                      trailing: (model.guideReceivedBookingList[index].isCompleted == 0 &&
                              model.guideReceivedBookingList[index].finalPaid ==
                                  0 &&
                              model.guideReceivedBookingList[index].initialPaid !=
                                  0)
                          ? buttonContainer(AppColor.completedStatusBGColor,
                              "ongoing", AppColor.pendingColor)
                          : (model.guideReceivedBookingList[index].isCompleted == 0 &&
                                  model.guideReceivedBookingList[index].finalPaid != 0 &&
                                  model.guideReceivedBookingList[index].initialPaid != 0 &&
                                  model.guideReceivedBookingList[index].status == 4)
                              ? buttonContainer(AppColor.completedStatusBGColor, "ongoing", AppColor.pendingColor)
                              : (model.guideReceivedBookingList[index].status == 1 || model.guideReceivedBookingList[index].status == 3 || model.guideReceivedBookingList[index].status == 5 || model.guideReceivedBookingList[index].status == 7 || model.guideReceivedBookingList[index].status == 9)
                                  ? buttonContainer(AppColor.shadowButton, "Cancelled", AppColor.errorBorderColor)
                                  : (model.guideReceivedBookingList[index].status == 4 && model.guideReceivedBookingList[index].isCompleted == 0)
                                      ? buttonContainer(AppColor.completedStatusBGColor, "ongoing", AppColor.completedStatusColor)
                                      : (model.guideReceivedBookingList[index].status == 0 || model.guideReceivedBookingList[index].status == 2 || model.guideReceivedBookingList[index].status == 6 || model.guideReceivedBookingList[index].status == 8)
                                          ? buttonContainer(AppColor.completedStatusBGColor, "ongoing", AppColor.completedStatusColor)
                                          : buttonContainer(AppColor.completedStatusBGColor, "Completed", AppColor.completedStatusColor)),
                  Divider(
                    color: AppColor.textfieldborderColor,
                    height: 2,
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    horizontalTitleGap: 0,
                    leading: Container(
                      height: screenHeight * 0.035,
                      width: screenHeight * 0.035,
                      decoration: BoxDecoration(
                          color: AppColor.shadowLocation,
                          shape: BoxShape.circle),
                      child: Icon(Icons.location_on_outlined,
                          color: AppColor.appthemeColor, size: 18),
                    ),
                    title: Transform.translate(
                        offset: Offset(-8, 0),
                        child: TextView.normalText(
                            textColor: AppColor.textfieldColor,
                            textSize: AppSizes().fontSize.mediumFontSize,
                            fontFamily: AppFonts.nunitoMedium,
                            text: model.guideReceivedBookingList.length > 0 &&
                                    model.guideReceivedBookingList[index]
                                            .country !=
                                        null
                                ? " ${GlobalUtility().firstLetterCapital(model.guideReceivedBookingList[index].country.toString())} ${GlobalUtility().firstLetterCapital(model.guideReceivedBookingList[index].state.toString())} ${model.guideReceivedBookingList[index].city!.length != 0 ? GlobalUtility().firstLetterCapital(model.guideReceivedBookingList[index].city.toString()) : ""}"
                                : "",
                            context: context)),
                    isThreeLine: false,
                    trailing: TextView.normalText(
                        textColor: AppColor.textfieldColor,
                        textSize: AppSizes().fontSize.mediumFontSize,
                        fontFamily: AppFonts.nunitoMedium,
                        text:
                            "${model.guideReceivedBookingList.length > 0 ? model.guideReceivedBookingList[index].bookingStart : ""} - ${model.guideReceivedBookingList.length > 0 ? model.guideReceivedBookingList[index].bookingEnd : ""}",
                        context: context),
                  ),
                  UiSpacer.verticalSpace(
                      space: AppSizes().widgetSize.smallPadding,
                      context: context),
                ],
              ),
            )));
  }

  //image view
  Widget profileImage(img) {
    return Container(
      width: screenWidth * 0.15,
      height: screenWidth * 0.15,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          shape: BoxShape.circle,
          image: img != null && img != ""
              ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(img))
              : DecorationImage(
                  image:
                      AssetImage(AppImages().pngImages.icProfilePlaceholder))),
    );
  }

  Widget buttonContainer(Color bgColor, String text, Color textColor) {
    return Container(
      height: screenHeight * 0.04,
      width: screenWidth * 0.35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: bgColor),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: textColor,
            fontFamily: AppFonts.nunitoMedium,
            fontSize: screenHeight * AppSizes().fontSize.xsimpleFontSize,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
