import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:readmore/readmore.dart';
import '../../../app_constants/app_images.dart';
import 'package:Siesta/view_models/traveller_find_guide.view_model.dart';
import 'package:stacked/stacked.dart';

class FindGuidePage extends StatefulWidget {
  const FindGuidePage({Key? key}) : super(key: key);

  @override
  State<FindGuidePage> createState() => _FindGuidePageState();
}

class _FindGuidePageState extends State<FindGuidePage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool? isSvgImg;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<TravellerFindGuideModel>.reactive(
        viewModelBuilder: () => TravellerFindGuideModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              backgroundColor: AppColor.whiteColor,
              elevation: 0,
              leadingWidth: 0,
              leading: const SizedBox(),
              toolbarHeight: 90,
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
                          height: screenHeight * 0.024,
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings().pleaseWait,
                            style: TextStyle(
                                fontSize: screenHeight * 0.013,
                                fontFamily: AppFonts.nunitoSemiBold,
                                color: AppColor.fieldEnableColor),
                          ),
                        )
                      : SizedBox(
                          height: screenHeight * 0.024,
                        ),
                ],
              ),
            ),
            body: model.travellerGuideList!.isNotEmpty
                ? Container(
                    height: model.isBusy
                        ? screenHeight * 0.70
                        : screenHeight * 0.75,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth *
                            AppSizes().widgetSize.horizontalPadding),
                    color: Colors.transparent,
                    child: ListView.builder(
                        controller: model.scrollController,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: model.travellerGuideList?.length,
                        padding: const EdgeInsets.only(
                            bottom: kBottomNavigationBarHeight),
                        itemBuilder: (context, index) {
                          return itemView(index, model);
                        }))
                : emptyItemView(),
          );
        });
  }

  Widget itemView(int index, TravellerFindGuideModel model) {
    checkImgType(index, model);
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 200),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
            child: GestureDetector(
          onTap: () {
            var guideId =
                model.travellerGuideList![index].user!.userDetail != null
                    ? model.travellerGuideList![index].userId.toString()
                    : "";
            openGuideDetailPage(guideId);
          },
          child: SizedBox(
            width: screenWidth,
            height: screenHeight * 0.19,
            child: Card(
              margin: EdgeInsets.symmetric(
                  vertical:
                      screenHeight * AppSizes().widgetSize.smallPadding09),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: AppColor.textfieldborderColor, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(
                      screenWidth * AppSizes().widgetSize.mediumBorderRadius))),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isSvgImg == false
                            ? guideImage(model.travellerGuideList![index].user!
                                        .userDetail !=
                                    null
                                ? model.travellerGuideList![index].user!
                                    .userDetail!.profilePicture
                                : "")
                            : guideImageSvg(model.travellerGuideList![index]
                                        .user!.userDetail !=
                                    null
                                ? model.travellerGuideList![index].user!
                                    .userDetail!.profilePicture
                                : ""),
                        UiSpacer.verticalSpace(
                            space: AppSizes().widgetSize.smallPadding,
                            context: context),
                        model.travellerGuideList?[index].avgRatings != "0"
                            ? Row(
                                children: [
                                  RatingBar.builder(
                                    wrapAlignment: WrapAlignment.start,
                                    initialRating: 1,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    ignoreGestures: true,
                                    unratedColor: AppColor.disableColor,
                                    itemCount: 1,
                                    itemSize: 20.0,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: AppColor.ratingbarColor,
                                    ),
                                    onRatingUpdate: (double value) {},
                                  ),
                                  TextView.semiBoldText(
                                      textColor: AppColor.textfieldColor,
                                      context: context,
                                      text: model.travellerGuideList?[index]
                                          .avgRatings),
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                    SizedBox(
                      width: screenWidth * 0.05,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: TextView.normalText(
                                    text: model.travellerGuideList![index].user!
                                                .userDetail !=
                                            null
                                        ? ("${model.travellerGuideList![index].user!.name} ${model.travellerGuideList![index].user!.lastName ?? ""}")
                                        : "",
                                    context: context,
                                    fontFamily: AppFonts.nunitoBold,
                                    textSize:
                                        AppSizes().fontSize.normalFontSize,
                                    textColor: AppColor.appthemeColor),
                              ),
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: model.travellerGuideList?[index].user
                                                    ?.userDetail !=
                                                null &&
                                            model.travellerGuideList?[index]
                                                    .user?.userDetail?.price !=
                                                null
                                        ? "\$${model.travellerGuideList?[index].user?.userDetail?.price}"
                                        : "",
                                    style: TextStyle(
                                        fontFamily: AppFonts.nunitoSemiBold,
                                        color: AppColor.lightBlack,
                                        fontSize: screenHeight *
                                            AppSizes()
                                                .fontSize
                                                .xsimpleFontSize),
                                  ),
                                  TextSpan(
                                      text: "/hr",
                                      style: TextStyle(
                                          fontFamily: AppFonts.nunitoRegular,
                                          color: AppColor.hintTextColor,
                                          fontSize: screenHeight *
                                              AppSizes()
                                                  .fontSize
                                                  .xsimpleFontSize)),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.6,
                              height: screenHeight * 0.1,
                              child: ReadMoreText(
                                model.travellerGuideList![index].user!
                                            .userDetail !=
                                        null
                                    ? model.travellerGuideList![index].user!
                                        .userDetail!.bio
                                        .toString()
                                    : "",
                                trimMode: TrimMode.Line,
                                trimLines: 4,
                                callback: null,
                                textAlign: TextAlign.justify,
                                trimCollapsedText: 'read more',
                                trimExpandedText: 'read less',
                                moreStyle: TextStyle(
                                    fontSize: screenHeight *
                                        AppSizes().fontSize.mediumFontSize,
                                    fontFamily: AppFonts.nunitoRegular,
                                    color: AppColor.appthemeColor),
                                style: TextStyle(
                                    fontSize: screenHeight *
                                        AppSizes().fontSize.mediumFontSize,
                                    fontFamily: AppFonts.nunitoRegular,
                                    color: AppColor.lightBlack),
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.6,
                              height: screenHeight * 0.1,
                              color: Colors.transparent,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget guideImage(img) {
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

  Widget guideImageSvg(img) {
    return CircleAvatar(
      radius: screenWidth * 0.1,
      backgroundImage: NetworkImage(img),
    );
  }

  void checkImgType(int index, TravellerFindGuideModel model) {
    if (model.travellerGuideList![index].user!.userDetail != null) {
      String imgUrl = model
          .travellerGuideList![index].user!.userDetail!.profilePicture
          .toString();
      String isSvg = ".svg";
      if (imgUrl.contains(isSvg)) {
        isSvgImg = true;
      } else {
        isSvgImg = false;
      }
    }
  }

  Widget searchField(TravellerFindGuideModel model) {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        onChanged: (value) {
          if (value != "") {
            model.isSearch(context, value);
          } else {
            model.pageCount = model.pageCount + 1;
            model.gettouristGuide(context, 1);
          }
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.searchFieldDecoration(
            context, AppStrings().fingGuideSearch),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      ),
    );
  }

  openGuideDetailPage(guideId) {
    Navigator.pushNamed(context, AppRoutes.findguideDetail,
        arguments: {"guideId": guideId});
  }

  Widget emptyItemView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: screenHeight * 0.18,
          width: screenWidth,
          alignment: Alignment.center,
          child: Image.asset(AppImages().pngImages.ivEmptySearch),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "Find the incredible tour guides with siesta by searching country, state, city or zipcode.",
            /*AppStrings().noResultFound,*/
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize,
                fontFamily: AppFonts.nunitoSemiBold,
                color: AppColor.dontHaveTextColor),
          ),
        ),
        // UiSpacer.verticalSpace(
        //     space: AppSizes().widgetSize.normalPadding, context: context),
        // TextView.normalText(
        //     context: context,
        //     text: AppStrings().searchAgain,
        //     textColor: AppColor.dontHaveTextColor,
        //     textSize: AppSizes().fontSize.mediumFontSize,
        //     fontFamily: AppFonts.nunitoMedium),
        // UiSpacer.verticalSpace(
        //     space: AppSizes().widgetSize.largePadding, context: context),
        // SizedBox(
        //   width: screenWidth * 0.45,
        //   child: CommonButton.commonThemeColorButton(
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => const SendEnquiryScreen()));
        //       },
        //       text: AppStrings().findGuide,
        //       context: context),
        // )
      ],
    );
  }
}
