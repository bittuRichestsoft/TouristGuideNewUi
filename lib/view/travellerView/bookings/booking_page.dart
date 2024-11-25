// ignore_for_file: prefer_if_null_operators

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/travellerView/write_review_page/review_screen.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:Siesta/view_models/myBookingsModel.dart';
import '../../../app_constants/app_strings.dart';
import 'package:stacked/stacked.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  List<String> ratingList = ["1", "2", "3", "4", "5"];
  ScrollController scrollController = ScrollController();
  int pageCount = 1;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<TravellerMyBookingsModel>.reactive(
        viewModelBuilder: () => TravellerMyBookingsModel(context, "no", 0, 0.0),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (!model.isBusy) {
                pageCount = pageCount + 1;
                if (model.filterselectedValue == 1) {
                  // all bookings
                  model.getMyBookings(context, pageCount, "",
                      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "", "", "", "");
                } else if (model.filterselectedValue == 2) {
                  // upcomming bookings
                  model.getMyBookings(
                      context, pageCount, "", [0, 2, 6, 8], "", "", "", "");
                } else if (model.filterselectedValue == 3) {
                  // completed bookings
                  model.getMyBookings(context, pageCount, "", [4], "", "", "",
                      "completed_booking=[1]");
                } else {
                  // cancelled bookings
                  model.getMyBookings(
                      context, pageCount, "", [1, 3, 5, 7, 9], "", "", "", "");
                }
              }
            } else {}
          });
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
                backgroundColor: AppColor.whiteColor,
                elevation: 0,
                toolbarHeight: 80,
                title: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding023,
                        context: context),
                    searchField(model),
                    model.isSearchRunnig == true
                        ? Container(
                            height: screenHeight * 0.022,
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings().pleaseWait,
                              style: TextStyle(
                                  fontSize: screenHeight * 0.014,
                                  fontFamily: AppFonts.nunitoSemiBold,
                                  color: AppColor.fieldEnableColor),
                            ),
                          )
                        : SizedBox(
                            height: screenHeight * 0.022,
                          ),
                  ],
                )),
            body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        screenWidth * AppSizes().widgetSize.horizontalPadding),
                child: SizedBox(
                  height: screenHeight * 0.7,
                  child: model.isEmtyViewForBooking == true
                      ? Container(
                          height: screenHeight * 0.6,
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
                                  text: "No pending bookings",
                                  textColor: AppColor.appthemeColor,
                                  textSize: AppSizes().fontSize.headingTextSize,
                                  fontFamily: AppFonts.nunitoSemiBold),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: model.pullRefresh,
                          child: ListView.builder(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: model.travellerMybookingList.length,
                              padding: const EdgeInsets.only(
                                  bottom: kBottomNavigationBarHeight),
                              itemBuilder: (context, index) {
                                return bookingItemView(index, model);
                              })),
                )),
          );
        });
  }

  Widget searchField(TravellerMyBookingsModel model) {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        onChanged: (value) {
          if (value != "") {
            model.getMyBookings(context, 1, value,
                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "", "", "", "");
          } else {
            model.getMyBookings(
                context, 1, "", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "", "", "", "");
          }
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          hintText: "Search by country, state, city",
          prefixIcon: IconButton(
              padding: EdgeInsets.zero,
              onPressed: null,
              icon: Icon(
                Icons.search,
                color: AppColor.appthemeColor,
                size: 20,
              )),
          suffixIcon: SizedBox(
            height: 25,
            width: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                  width: 2,
                  color: Colors.grey.shade200,
                ),
                PopupMenuButton<int>(
                  initialValue: model.filterselectedValue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  position: PopupMenuPosition.over,
                  icon: Icon(
                    Icons.filter_list,
                    color: AppColor.appthemeColor,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
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
                          pageCount = 1;
                          model.filterselectedValue = value!;
                          model.notifyListeners();
                          model.getMyBookingsFilter(value, pageCount);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      value: 2,
                      child: RadioListTile<int>(
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(vertical: -4, horizontal: -4),
                        title: TextView.normalText(
                            text: "Upcoming",
                            context: context,
                            fontFamily: AppFonts.nunitoMedium,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            textColor: AppColor.lightBlack),
                        value: 2,
                        groupValue: model.filterselectedValue,
                        onChanged: (int? value) {
                          model.filterselectedValue = value!;
                          model.notifyListeners();
                          pageCount = 1;
                          model.getMyBookingsFilter(value, pageCount);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
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
                          model.filterselectedValue = value!;
                          model.notifyListeners();
                          pageCount = 1;
                          model.getMyBookingsFilter(value, pageCount);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
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
                          model.filterselectedValue = value!;
                          pageCount = 1;
                          model.notifyListeners();
                          model.getMyBookingsFilter(value, pageCount);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                  offset: const Offset(0, 35),
                  color: Colors.white,
                  elevation: 2,
                  onSelected: (value) {
                    debugPrint("debugPrint debugPrint${value.toString()}");
                  },
                ),
              ],
            ),
          ),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.xsimpleFontSize),
          contentPadding: const EdgeInsets.only(
            left: 0,
            top: 10,
            bottom: 0,
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
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget bookingItemView(int index, TravellerMyBookingsModel model) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 300),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
            child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * AppSizes().widgetSize.xsmallPadding007),
          child: InkWell(
            onTap: () {
              showAnimatedDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return detailsDialog(index, model);
                },
                animationType: DialogTransitionType.slideFromBottom,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 800),
              );
            },
            child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(screenWidth *
                        AppSizes().widgetSize.mediumBorderRadius))),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.disableColor.withOpacity(0.3),
                          blurRadius: 3.0,
                          spreadRadius: 1.0,
                        )
                      ],
                      color: AppColor.whiteColor),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: [
                      ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          leading: profileImage(
                              // ignore: unnecessary_null_comparison
                              model.travellerMybookingList[index].user!.userDetail != null
                                  ? model.travellerMybookingList[index].user!
                                      .userDetail!.profilePicture
                                  : ""),
                          title: Container(
                            color: Colors.transparent,
                            width: screenWidth * 0.4,
                            child: TextView.normalTextOver(
                                textColor: AppColor.appthemeColor,
                                textSize: AppSizes().fontSize.xsimpleFontSize,
                                fontFamily: AppFonts.nunitoBold,
                                text: GlobalUtility().firstLetterCapital(
                                    "${model.travellerMybookingList[index].user!.name} ${model.travellerMybookingList[index].user!.lastName}"),
                                context: context),
                          ),
                          isThreeLine: false,
                          subtitle: Transform.translate(
                            offset: const Offset(-2, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.star_rate_rounded,
                                  color: AppColor.ratingbarColor,
                                  size: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: TextView.normalText(
                                      textColor: AppColor.blackColor,
                                      textSize:
                                          AppSizes().fontSize.xsimpleFontSize,
                                      fontFamily: AppFonts.nunitoMedium,
                                      text: model.travellerMybookingList[index]
                                          .user!.avgRatings,
                                      context: context),
                                )
                              ],
                            ),
                          ),
                          trailing: (model.travellerMybookingList[index].status == 0 ||
                                  model.travellerMybookingList[index].status ==
                                      2 ||
                                  model.travellerMybookingList[index].status ==
                                      4 ||
                                  model.travellerMybookingList[index].status ==
                                      6 ||
                                  model.travellerMybookingList[index].status ==
                                      8)
                              ? (model.travellerMybookingList[index].status == 4 &&
                                      model.travellerMybookingList[index]
                                              .isCompleted ==
                                          1)
                                  ? buttonContainer(
                                      AppColor.completedStatusBGColor,
                                      AppStrings().completedStatus,
                                      AppColor.completedStatusColor,
                                      model.travellerMybookingList[index]
                                          .touristGuideUserId,
                                      index)
                                  : buttonContainer(
                                      AppColor.buttonDisableColor,
                                      AppStrings().upcomingStatus,
                                      AppColor.appthemeColor,
                                      null,
                                      index)
                              : (model.travellerMybookingList[index].status == 1 ||
                                      model.travellerMybookingList[index].status == 3 ||
                                      model.travellerMybookingList[index].status == 5 ||
                                      model.travellerMybookingList[index].status == 7 ||
                                      model.travellerMybookingList[index].status == 9)
                                  ? buttonContainer(AppColor.cancelbuttonColor, AppStrings().cancelledStatus, AppColor.textbuttonColor, null, index)
                                  : null),
                      Divider(
                        color: AppColor.textfieldborderColor,
                        height: 2,
                      ),
                      ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          horizontalTitleGap: 0,
                          leading: Container(
                            height: screenHeight * 0.034,
                            width: screenHeight * 0.034,
                            decoration: BoxDecoration(
                                color: AppColor.shadowLocation,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: AppColor.appthemeColor,
                              size: 18,
                            ),
                          ),
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Container(
                              padding: const EdgeInsets.only(left: 5),
                              width: screenWidth * 0.4,
                              color: Colors.transparent,
                              alignment: Alignment.centerLeft,
                              child: TextView.normalText(
                                  textColor: AppColor.textfieldColor,
                                  textSize: AppSizes().fontSize.mediumFontSize,
                                  fontFamily: AppFonts.nunitoSemiBold,
                                  text: model.travellerMybookingList[index]
                                              .country !=
                                          null
                                      ? "${GlobalUtility().firstLetterCapital(model.travellerMybookingList[index].country.toString())}, ${GlobalUtility().firstLetterCapital(model.travellerMybookingList[index].state.toString())}, ${model.travellerMybookingList[index].city!.length != 0 ? GlobalUtility().firstLetterCapital(model.travellerMybookingList[index].city.toString()) : ""}"
                                      : "",
                                  context: context),
                            ),
                          ),
                          isThreeLine: false,
                          trailing: TextView.normalText(
                              textColor: AppColor.textfieldColor,
                              textSize: AppSizes().fontSize.mediumFontSize,
                              fontFamily: AppFonts.nunitoSemiBold,
                              text:
                                  "${model.travellerMybookingList[index].bookingStart} - ${model.travellerMybookingList[index].bookingEnd}",
                              context: context)),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      model.travellerMybookingList[index].status == 4
                          ? DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              lineThickness: 1.0,
                              dashLength: 6.0,
                              dashColor: AppColor.textfieldborderColor,
                              dashRadius: 0.0,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                              dashGapRadius: 0.0,
                            )
                          : const SizedBox(),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: (model.travellerMybookingList[index].status ==
                                      4 &&
                                  model.travellerMybookingList[index]
                                          .isCompleted ==
                                      1)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextView.normalText(
                                        textColor: AppColor.appthemeColor,
                                        textSize:
                                            AppSizes().fontSize.simpleFontSize,
                                        fontFamily: AppFonts.nunitoSemiBold,
                                        text: AppStrings().rateText,
                                        context: context),
                                    SizedBox(
                                        width: screenWidth * 0.7,
                                        child: ratingGrid(
                                            model,
                                            index,
                                            model.travellerMybookingList[index]
                                                .touristGuideUserId)),
                                  ],
                                )
                              : (model.travellerMybookingList[index].status ==
                                          0 ||
                                      model.travellerMybookingList[index]
                                              .status ==
                                          2 ||
                                      model.travellerMybookingList[index]
                                              .status ==
                                          4 ||
                                      model.travellerMybookingList[index]
                                              .status ==
                                          6 ||
                                      model.travellerMybookingList[index]
                                              .status ==
                                          8)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            GlobalUtility.showDialogFunction(
                                                context, infoCancelDialog());
                                          },
                                          child: Transform.translate(
                                            offset: const Offset(6, 0),
                                            child: Icon(
                                              Icons.info_outline,
                                              size: 24,
                                              color: AppColor.appthemeColor,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth * 0.8,
                                          padding: const EdgeInsets.all(8.0),
                                          child: CommonButton
                                              .commonNormalButtonsmallHeight(
                                                  textColor:
                                                      AppColor.errorBorderColor,
                                                  text: AppStrings().cancelTrip,
                                                  context: context,
                                                  onPressed: () {
                                                    openCancelDialog(
                                                        model,
                                                        model
                                                            .travellerMybookingList[
                                                                index]
                                                            .id);
                                                  },
                                                  backColor: AppColor
                                                      .cancelbuttonColor),
                                        )
                                      ],
                                    )
                                  : null)
                    ],
                  ),
                )),
          ),
        )),
      ),
    );
  }

  Widget infoCancelDialog() {
    return Dialog(
        insetPadding: EdgeInsets.all(screenWidth * 0.04),
        alignment: Alignment.center,
        backgroundColor: AppColor.whiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.mediumBorderRadius))),
        child: Container(
          width: screenWidth,
          height: screenHeight * 0.22,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.mediumBorderRadius))),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1, vertical: screenHeight * 0.03),
            children: [
              Icon(
                Icons.info_outline,
                size: 24,
                color: AppColor.appthemeColor,
              ),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Text(
                " If you wish to cancel your booking, you must do so within 24 hours",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColor.dontHaveTextColor,
                    fontFamily: AppFonts.nunitoRegular,
                    letterSpacing: 0.1,
                    fontSize: screenHeight * AppSizes().fontSize.simpleFontSize,
                    fontWeight: FontWeight.w500),
              ),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              CommonButton.commonBoldTextButton(
                  text: "Okay",
                  context: context,
                  isButtonEnable: true,
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ));
  }

  openCancelDialog(model, bookingId) {
    cancelTripSheet(model, bookingId);
  }

  //image view
  Widget profileImage(img) {
    return Container(
      height: screenHeight * 0.055,
      width: screenHeight * 0.055,
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

  Widget buttonContainer(Color bgColor, String text, Color textColor,
      touristGuideUserId, seldIndex) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (text == AppStrings().completedStatus) {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ReviewScreen(
          //             touristGuideUserId: tourist_guide_user_id.toString(),
          //             selectedIndex: seldIndex)));
        }
      },
      child: Container(
        height: screenHeight * 0.04,
        width: screenWidth * 0.25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: bgColor),
        child: Text(
          text,
          style: TextStyle(
              color: textColor,
              fontFamily: AppFonts.nunitoMedium,
              fontSize: screenHeight * AppSizes().fontSize.simpleFontSize,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget ratingGrid(model, ind, touristGuideId) {
    return GridView.count(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.8,
        shrinkWrap: true,
        crossAxisCount: 5,
        crossAxisSpacing: screenWidth * 0.02,
        mainAxisSpacing: screenWidth * 0.01,
        children: List.generate(
            model.travellerMybookingList[ind].user.givenRating != null
                ? model.travellerMybookingList[ind].user.givenRating
                : ratingList.length, (index) {
          return GestureDetector(
              onTap: () {
                if (model.travellerMybookingList[ind].user.givenRating !=
                        null &&
                    model.travellerMybookingList[ind].user.givenRating > 0) {
                  // no need to navigate
                } else {
                  debugPrint("RATE VALUE:--- ${ratingList[index]}}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewScreen(
                                touristGuideUserId: model
                                    .travellerMybookingList[ind].id
                                    .toString(),
                                selectedIndex: ind,
                                rating: double.parse(ratingList[index]),
                              )));
                }
              },
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                          screenWidth *
                              AppSizes().widgetSize.smallBorderRadius)),
                      border: Border.all(color: AppColor.textfieldborderColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: TextView.normalText(
                              textColor: AppColor.blackColor,
                              textSize: AppSizes().fontSize.mediumFontSize,
                              fontFamily: AppFonts.nunitoMedium,
                              text: ratingList[index],
                              context: context)),
                      model.travellerMybookingList[ind].user.givenRating != null
                          ? Icon(
                              Icons.star_rate_rounded,
                              color: AppColor.ratingbarColor,
                              size: 20,
                            )
                          : Icon(
                              Icons.star_rate_rounded,
                              color: AppColor.disableColor,
                              size: 20,
                            ),
                    ],
                  )));
        }));
  }

  cancelTripSheet(TravellerMyBookingsModel model, bookingId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        )),
        builder: (context) => ValueListenableBuilder(
            valueListenable: model.counterNotifier1,
            builder: (context, current, child) {
              return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(
                        screenWidth * AppSizes().widgetSize.horizontalPadding),
                    children: [
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      Center(
                        child: Container(
                          height: 4,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding,
                          context: context),
                      Center(
                          child: TextView.normalText(
                              context: context,
                              fontFamily: AppFonts.nunitoSemiBold,
                              textSize: AppSizes().fontSize.headingTextSize,
                              textColor: AppColor.lightBlack,
                              text: AppStrings().cancelTripText)),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.normalPadding,
                          context: context),
                      Container(
                        height: 1.8,
                        width: screenWidth,
                        color: Colors.black12,
                      ),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.smallPadding,
                          context: context),
                      TextView.normalText(
                          text: AppStrings().cancelReasonsheet,
                          textColor: AppColor.dontHaveTextColor,
                          textSize: AppSizes().fontSize.mediumFontSize,
                          fontFamily: AppFonts.nunitoRegular,
                          context: context),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                      reasonForCancel(model),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                      cancelButton(model, bookingId),
                      UiSpacer.verticalSpace(
                          space: AppSizes().widgetSize.mediumPadding,
                          context: context),
                    ],
                  ));
            }));
  }

  Widget reasonForCancel(TravellerMyBookingsModel model) {
    return SizedBox(
      child: TextFormField(
        controller: model.cancelReasonController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onReasonFieldChange(model),
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          hintText: "Please write your reason here...",
          contentPadding: const EdgeInsets.only(
            top: 8,
            bottom: 0,
            left: 10,
          ),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
          // prefixIcon: IconButton(
          //   padding: EdgeInsets.zero,
          //   alignment: Alignment.center,
          //   onPressed: () {},
          //   icon: SvgPicture.asset(AppImages().svgImages.icPassword),
          // ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldEnableColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.errorBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
        ),
      ),
    );
  }

  Widget cancelButton(TravellerMyBookingsModel model, bookingId) {
    return model.isBusy == false
        ? CommonButton.commonBoldTextButton(
            text: AppStrings().cancelTripText,
            context: context,
            onPressed: () {
              model.counterNotifier1.value++;
              if (validate(model)) {
                if (model.isCancelButtonEnable) {
                  if (model.cancelReasonController.text != "" &&
                      model.cancelReasonController.text.trim().isNotEmpty) {
                    model.travellerCancelTrip(context, bookingId.toString());
                  } else {
                    GlobalUtility.showToast(
                        context, "Please write reason for cancel trip!!");
                  }
                }
              }
            },
            isButtonEnable: model.isCancelButtonEnable)
        : SizedBox(
            width: screenWidth * 0.1,
            child: Center(
              child: CircularProgressIndicator(color: AppColor.appthemeColor),
            ),
          );
  }

  onReasonFieldChange(TravellerMyBookingsModel model) {
    if (model.cancelReasonController.text != "") {
      model.isCancelButtonEnable = true;
      model.notifyListeners();
      model.counterNotifier1.value++;
    } else {
      model.isCancelButtonEnable = false;
      model.notifyListeners();
      model.counterNotifier1.value++;
    }
  }

  bool validate(TravellerMyBookingsModel model) {
    String cancelReason = model.cancelReasonController.text;
    if (cancelReason == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterReason);
      return false;
    }
    return true;
  }

  detailsDialog(int index, TravellerMyBookingsModel model) {
    return Dialog(
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextView.normalText(
                context: context,
                text: "Details",
                textColor: AppColor.appthemeColor,
                textSize: AppSizes().fontSize.headingTextSize,
                fontFamily: AppFonts.nunitoSemiBold),
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: AppColor.appthemeColor,
                ))
          ],
        ),
        subtitle: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            TextView.normalText(
                context: context,
                text: "Name",
                textColor: AppColor.blackColor,
                textSize: AppSizes().fontSize.simpleFontSize,
                fontFamily: AppFonts.nunitoBold),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.01),
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.disableColor.withOpacity(0.2)),
              child: TextView.normalText(
                  context: context,
                  text: model.travellerMybookingList[index].user!.name,
                  textColor: AppColor.blackColor,
                  textSize: AppSizes().fontSize.simpleFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView.normalText(
                        context: context,
                        text: "Country",
                        textColor: AppColor.blackColor,
                        textSize: AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoBold),
                    Container(
                      width: screenWidth * 0.32,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01),
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.disableColor.withOpacity(0.2)),
                      child: TextView.normalText(
                          context: context,
                          text: model.travellerMybookingList[index].country,
                          textColor: AppColor.blackColor,
                          textSize: AppSizes().fontSize.simpleFontSize,
                          fontFamily: AppFonts.nunitoSemiBold),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView.normalText(
                        context: context,
                        text: "State",
                        textColor: AppColor.blackColor,
                        textSize: AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoBold),
                    Container(
                      width: screenWidth * 0.32,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01),
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.disableColor.withOpacity(0.2)),
                      child: TextView.normalText(
                          context: context,
                          text: model.travellerMybookingList[index].state,
                          textColor: AppColor.blackColor,
                          textSize: AppSizes().fontSize.simpleFontSize,
                          fontFamily: AppFonts.nunitoSemiBold),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView.normalText(
                    context: context,
                    text: "City",
                    textColor: AppColor.blackColor,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    fontFamily: AppFonts.nunitoBold),
                Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.01),
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColor.disableColor.withOpacity(0.2)),
                    child: Text(
                      model.travellerMybookingList[index].city!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                      style: TextStyle(
                          fontSize:
                              screenHeight * AppSizes().fontSize.simpleFontSize,
                          fontFamily: AppFonts.nunitoSemiBold,
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.w500),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView.normalText(
                        context: context,
                        text: "Type",
                        textColor: AppColor.blackColor,
                        textSize: AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoBold),
                    Container(
                      width: screenWidth * 0.32,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01),
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.disableColor.withOpacity(0.2)),
                      child: TextView.normalText(
                          context: context,
                          text: model.travellerMybookingList[index].familyType,
                          textColor: AppColor.blackColor,
                          textSize: AppSizes().fontSize.simpleFontSize,
                          fontFamily: AppFonts.nunitoSemiBold),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView.normalText(
                        context: context,
                        text: "No of days",
                        textColor: AppColor.blackColor,
                        textSize: AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoBold),
                    Container(
                      width: screenWidth * 0.32,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01),
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.disableColor.withOpacity(0.2)),
                      child: TextView.normalText(
                          context: context,
                          text: model.travellerMybookingList[index].noOfDays,
                          textColor: AppColor.blackColor,
                          textSize: AppSizes().fontSize.simpleFontSize,
                          fontFamily: AppFonts.nunitoSemiBold),
                    ),
                  ],
                ),
              ],
            ),
            TextView.normalText(
                context: context,
                text: "Activities",
                textColor: AppColor.blackColor,
                textSize: AppSizes().fontSize.simpleFontSize,
                fontFamily: AppFonts.nunitoBold),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.01),
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.disableColor.withOpacity(0.2)),
              child: TextView.normalText(
                  context: context,
                  text: model.travellerMybookingList[index].activities,
                  textColor: AppColor.blackColor,
                  textSize: AppSizes().fontSize.simpleFontSize,
                  fontFamily: AppFonts.nunitoSemiBold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView.normalText(
                        context: context,
                        text: "Start date",
                        textColor: AppColor.blackColor,
                        textSize: AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoBold),
                    Container(
                      width: screenWidth * 0.32,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01),
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.disableColor.withOpacity(0.2)),
                      child: TextView.normalText(
                          context: context,
                          text:
                              model.travellerMybookingList[index].bookingStart,
                          textColor: AppColor.blackColor,
                          textSize: AppSizes().fontSize.simpleFontSize,
                          fontFamily: AppFonts.nunitoSemiBold),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView.normalText(
                        context: context,
                        text: "End date",
                        textColor: AppColor.blackColor,
                        textSize: AppSizes().fontSize.simpleFontSize,
                        fontFamily: AppFonts.nunitoBold),
                    Container(
                      width: screenWidth * 0.32,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01),
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.disableColor.withOpacity(0.2)),
                      child: TextView.normalText(
                          context: context,
                          text: model.travellerMybookingList[index].bookingEnd,
                          textColor: AppColor.blackColor,
                          textSize: AppSizes().fontSize.simpleFontSize,
                          fontFamily: AppFonts.nunitoSemiBold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.03,
            )
          ],
        ),
      ),
    );
  }
}
