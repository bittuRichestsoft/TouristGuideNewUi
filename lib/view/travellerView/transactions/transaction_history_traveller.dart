import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/view/travellerView/transactions/withdraw_request_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/view_models/travellerTransactionHistoryModal.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class TransactionHistoryTravelerPage extends StatefulWidget {
  const TransactionHistoryTravelerPage({super.key});

  @override
  State<TransactionHistoryTravelerPage> createState() =>
      _TransactionHistoryTravelerPageState();
}

class _TransactionHistoryTravelerPageState
    extends State<TransactionHistoryTravelerPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  ScrollController scrollController = ScrollController();
  int pageCount = 1;

  @override
  void initState() {
    debugPrint("Transaction history traveller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<TravellerTransactionHistoryModel>.reactive(
        viewModelBuilder: () => TravellerTransactionHistoryModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (!model.isBusy) {
                pageCount = pageCount + 1;
                model.gettravellerhistory(context, pageCount,
                    model.searchController.text, model.filterValue);
              }
            } else {}
          });
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              elevation: 0,
              title: TextView.headingWhiteText(
                  context: context, text: "Transaction History"),
              leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColor.whiteColor,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.travellerHomePage);
                  }),
            ),
            body: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                searchAndFilterView(model),
                Container(
                  height: screenHeight * 0.75,
                  color: AppColor.whiteColor,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model.travellerTransactionHistoryResponse != null
                        ? model.travellerTransactionHistoryResponse!.data!.rows
                            .length
                        : 0,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth *
                            AppSizes().widgetSize.horizontalPadding),
                    itemBuilder: (context, index) {
                      return paymentItemView(index, model);
                    },
                    separatorBuilder: (context, index) => Divider(
                      color: AppColor.textfieldborderColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // Search and sent view
  Widget searchAndFilterView(TravellerTransactionHistoryModel model) {
    return Container(
      color: AppColor.whiteColor,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * AppSizes().widgetSize.horizontalPaddings),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: screenWidth * AppSizes().widgetSize.horizontalPadding,
          ),
          searchField(model),
          Padding(
              padding: const EdgeInsets.only(left: 5, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent payments",
                    style: TextStyle(
                        color: AppColor.textfieldColor,
                        fontFamily: AppFonts.nunitoSemiBold,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize),
                  ),
                  TextView.headingWhiteText(context: context, text: ""),
                ],
              ))
        ],
      ),
    );
  }

  // search field
  Widget searchField(TravellerTransactionHistoryModel model) {
    return SizedBox(
      width: screenWidth,
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        onChanged: (value) {
          model.gettravellerhistory(context, 1, value, model.filterValue);
        },
        controller: model.searchController,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          hintText: AppStrings().searchNameAndId,
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
              children: [
                Container(
                  height: 20,
                  width: 2,
                  color: Colors.grey.shade200,
                ),
                PopupMenuButton<int>(
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
                          model.filterselectedValue = value!;
                          model.filterValue = "ALL";
                          model.gettravellerhistory(context, 1,
                              model.searchController.text, model.filterValue);
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
                            text: "Completed",
                            context: context,
                            fontFamily: AppFonts.nunitoMedium,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            textColor: AppColor.lightBlack),
                        value: 2,
                        groupValue: model.filterselectedValue,
                        onChanged: (int? value) {
                          debugPrint("filter $value");
                          model.filterValue = "SUCCESS";
                          model.filterselectedValue = value!;
                          model.gettravellerhistory(context, 1,
                              model.searchController.text, model.filterValue);
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
                            text: "Failed",
                            context: context,
                            fontFamily: AppFonts.nunitoMedium,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            textColor: AppColor.lightBlack),
                        value: 3,
                        groupValue: model.filterselectedValue,
                        onChanged: (int? value) {
                          model.filterselectedValue = value!;
                          model.filterValue = "FAIL";
                          debugPrint("filter $value");
                          model.gettravellerhistory(context, 1,
                              model.searchController.text, model.filterValue);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                  offset: const Offset(0, 33),
                  color: Colors.white,
                  elevation: 2,
                  onSelected: (value) {
                    debugPrint("values select:-- $value");
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

  Widget paymentItemView(int index, TravellerTransactionHistoryModel model) {
    return SizedBox(
        width: screenWidth,
        child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: TextView.normalText(
                textColor: AppColor.textfieldColor,
                textSize: AppSizes().fontSize.simpleFontSize,
                fontFamily: AppFonts.nunitoBold,
                text:
                    ("${model.travellerTransactionHistoryResponse!.data!.rows[index].bookingDetails!.user.name} ${model.travellerTransactionHistoryResponse!.data!.rows[index].bookingDetails!.user.lastName}")
                        .toString(),
                context: context),
            isThreeLine: true,
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView.normalText(
                    textColor: AppColor.blackColor,
                    textSize: AppSizes().fontSize.mediumFontSize,
                    fontFamily: AppFonts.nunitoRegular,
                    text:
                        "Booking id:- ${model.travellerTransactionHistoryResponse!.data!.rows[index].bookingId.toString()}",
                    context: context),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                TextView.normalText(
                    textColor: AppColor.blackColor,
                    textSize: AppSizes().fontSize.mediumFontSize,
                    fontFamily: AppFonts.nunitoRegular,
                    //text: "14375212345632",
                    text: model.travellerTransactionHistoryResponse!.data!
                        .rows[index].transactionId
                        .toString(),
                    context: context),
                SizedBox(
                  height: screenHeight * 0.008,
                ),
                TextView.normalText(
                    textColor: AppColor.dontHaveTextColor,
                    textSize: AppSizes().fontSize.mediumFontSize,
                    fontFamily: AppFonts.nunitoRegular,
                    text: DateFormat('dd MMM yyyy – kk:mm a').format(
                        DateTime.parse(model
                            .travellerTransactionHistoryResponse!
                            .data!
                            .rows[index]
                            .createdAt
                            .toString())),
                    context: context)
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [viewBtn(index, model)],
            )));
  }

  Widget viewBtn(int index, TravellerTransactionHistoryModel model) {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          AppSizes().widgetSize.smallbuttonHeight,
      width: screenWidth / 4.3,
      child: ElevatedButton(
        onPressed: () {
          GlobalUtility.showDialogFunction(
              context,
              WithdrawRequestDialog(
                  data: model
                      .travellerTransactionHistoryResponse!.data!.rows[index]));
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColor.appthemeColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width *
                        AppSizes().widgetSize.roundBorderRadius))),
        child: Text(
          AppStrings().viewText,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.mediumFontSize,
              color: AppColor.whiteColor,
              fontFamily: AppFonts.nunitoSemiBold),
        ),
      ),
    );
  }

  Widget profileImage() {
    return Container(
      width: screenWidth * 0.15,
      height: screenWidth * 0.15,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(color: AppColor.hintTextColor, width: 1),
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage(AppImages().pngImages.icProfilePlaceholder))),
    );
  }
}
