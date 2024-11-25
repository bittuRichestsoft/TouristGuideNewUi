// ignore_for_file: non_constant_identifier_names

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view/all_bottomsheet/range_selector_datesheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app_constants/app_images.dart';
import 'package:Siesta/view_models/myBookingsModel.dart';
import 'package:stacked/stacked.dart';

class ItineraryPage extends StatefulWidget {
  ItineraryPage({Key? key, required var fromWhere}) : super(key: key) {
    from = fromWhere;
  }

  String from = "";

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  ScrollController scrollController = ScrollController();
  int pageCount = 1;
  bool? isSvgImg;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<TravellerMyBookingsModel>.reactive(
        viewModelBuilder: () =>
            TravellerMyBookingsModel(context, "yes", 0, 0.0),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (!model.isBusy) {
                pageCount = pageCount + 1;
                model.getMyBookings(
                    context, pageCount, "", [], "yes", "", "", "");
              }
            } else {}
          });

          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: widget.from == "drawer"
                ? AppBar(
                    systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: AppColor.appthemeColor),
                    centerTitle: true,
                    backgroundColor: AppColor.appthemeColor,
                    leading: IconButton(
                      icon: Icon(Icons.clear, color: AppColor.whiteColor),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.travellerHomePage);
                      },
                    ),
                    title: TextView.headingWhiteText(
                        text: AppStrings().itineraryText, context: context),
                  )
                : null,
            body: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                    alignment: Alignment.center,
                    height: screenHeight * 0.16,
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth *
                            AppSizes().widgetSize.horizontalPadding),
                    color: AppColor.whiteColor,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          searchField(model),
                          TextView.normalText(
                              text: AppStrings().recentItinerary,
                              context: context,
                              fontFamily: AppFonts.nunitoSemiBold,
                              textSize: AppSizes().fontSize.normalFontSize,
                              textColor: AppColor.textfieldColor),
                        ])),
                model.isSearchRunnig == true
                    ? SizedBox(
                        width: screenWidth * 0.1,
                        child: Center(
                          child: Text(AppStrings().pleaseWait),
                        ),
                      )
                    : const SizedBox(),
                Container(
                    height: model.isBusy
                        ? screenHeight * 0.68
                        : screenHeight * 0.73,
                    color: AppColor.whiteColor,
                    child: itineraryList(model)),
                model.isBusy
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: SizedBox(
                          width: screenWidth * 0.1,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: AppColor.blackColor),
                          ),
                        ))
                    : const SizedBox.shrink()
              ],
            ),
          );
        });
  }

  Widget searchField(model) {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        onChanged: (value) {
          if (value != "") {
            model.getMyBookings(context, 1, value, [], "yes", "", "", "");
          } else {
            debugPrint("call Search Field  ---$value");

            model.getMyBookings(context, 1, "", [], "yes", "", "", "");
          }
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoMedium,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.searchFieldDecoWithSuffixWithLeftBorder(
            context, "Search by destination", () {
          GlobalUtility.showBottomSheet(
              context,
              RangeDateSelector(
                  travellerMyBookingsModel: model, guideMyBookingsModel: null));
        }),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget itineraryList(model) {
    return RefreshIndicator(
        onRefresh: model.pullRefresh,
        child: ListView.separated(
          itemCount: model.travellerMybookingList!.length,
          shrinkWrap: true,
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(
              screenWidth * AppSizes().widgetSize.horizontalPaddings),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: itineraryItemView(index, model),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: AppColor.disableColor);
          },
        ));
  }

  Widget itineraryItemView(int index, TravellerMyBookingsModel model) {
    checkImgType(index, model);
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 1000),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isSvgImg == false
                    ? guideImage(model.travellerMybookingList.length > 0
                        ? model.travellerMybookingList[index].user!.userDetail!
                            .profilePicture
                        : "")
                    : guideImageSvg(
                        model.travellerMybookingList[index].user!.userDetail !=
                                null
                            ? model.travellerMybookingList[index].user!
                                .userDetail!.profilePicture
                            : ""),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      width: screenWidth * 0.4,
                      child: TextView.normalText(
                          text: model.travellerMybookingList.length > 0
                              ? model.travellerMybookingList[index].user!.name
                              : "",
                          context: context,
                          fontFamily: AppFonts.nunitoBold,
                          textSize: AppSizes().fontSize.normalFontSize,
                          textColor: AppColor.blackColor),
                    ),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.xsmallPadding,
                        context: context),
                    /*  Container(
                        color: Colors.transparent,
                        width: screenWidth * 0.4,
                        child: TextView.normalTextHeight(
                            text: model.travellerMybookingList.length > 0
                                ? model
                                    .travellerMybookingList[index].user!.email
                                : "",
                            context: context,
                            fontFamily: AppFonts.nunitoSemiBold,
                            textSize: AppSizes().fontSize.mediumFontSize,
                            textColor: AppColor.dontHaveTextColor)),*/
                    TextView.normalTextHeight(
                        text: (model.travellerMybookingList.length > 0
                            ? model.travellerMybookingList[index].bookingStart
                            : ""),
                        context: context,
                        fontFamily: AppFonts.nunitoSemiBold,
                        textSize: AppSizes().fontSize.smallTextSize,
                        textColor: AppColor.hintTextColor.withOpacity(0.6)),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton.icon(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.topCenter),
                    onPressed: null,
                    icon: Image.asset(
                      AppImages().pngImages.icLoc,
                      width: 15,
                      height: 15,
                      fit: BoxFit.fill,
                    ),
                    label: Container(
                      color: Colors.transparent,
                      width: screenWidth * 0.2,
                      child: Text(
                        model.travellerMybookingList.length > 0 &&
                                model.travellerMybookingList[index].country !=
                                    null
                            ? "${GlobalUtility().firstLetterCapital(model.travellerMybookingList[index].state.toString())} ${model.travellerMybookingList[index].city!.length != 0 ? GlobalUtility().firstLetterCapital(model.travellerMybookingList[index].city.toString()) : ""}"
                            : "",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: screenHeight *
                                AppSizes().fontSize.smallTextSize,
                            fontFamily: AppFonts.nunitoSemiBold,
                            color: AppColor.textfieldColor,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
                viewItineraryButton(model, index)
              ],
            )
          ],
        )),
      ),
    );
  }

  Widget guideImage(img) {
    return Container(
      width: screenWidth * 0.1,
      height: screenWidth * 0.1,
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

  Widget guideImageSvg(img) {
    return Container(
      width: screenWidth * 0.1,
      height: screenWidth * 0.1,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        shape: BoxShape.circle,
      ),
      child: img != null && img != ""
          ? SvgPicture.network(img)
          : Image.asset(AppImages().pngImages.icProfilePlaceholder),
    );
  }

  Widget viewItineraryButton(model, ind) {
    return SizedBox(
      width: screenWidth * 0.32,
      height: screenHeight * 0.035,
      child: CommonButton.commonButtonRoundedItinerary(
          context: context,
          text: AppStrings().viewItinerary,
          onPressed: () {
            var booking_Id = model.travellerMybookingList.length > 0
                ? model.travellerMybookingList[ind].id
                : "";
            Navigator.pushNamed(context, AppRoutes.itineraryDetail,
                arguments: {"bookingId": booking_Id});
          },
          textColor: AppColor.appthemeColor,
          backColor: AppColor.buttonDisableColor),
    );
  }

  void checkImgType(int index, model) {
    if (model.travellerMybookingList![index].user!.userDetail != null) {
      String imgUrl = model
          .travellerMybookingList![index].user!.userDetail!.profilePicture
          .toString();
      String isSvg = ".svg";
      if (imgUrl.contains(isSvg)) {
        isSvgImg = true;
      } else {
        isSvgImg = false;
      }
    }
  }
}
