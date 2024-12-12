// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_requests/auth.request.dart';
import '../app_constants/app_fonts.dart';
import '../app_constants/app_routes.dart';
import '../response_pojo/waiting_list_content_pojo.dart';
import '../utility/globalUtility.dart';
import 'all_dialogs/dialog_with_twoButton.dart';

class WaitListScreen extends StatefulWidget {
  const WaitListScreen({super.key});

  @override
  State<WaitListScreen> createState() => _WaitListScreenState();
}

class _WaitListScreenState extends State<WaitListScreen> {
  var screenHeight;
  var screenWidth;

  Value? waitingData;

  @override
  void initState() {
    waitingListContent();
    super.initState();
  }

  String description = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    description = waitingData != null
        ? "<div style='text-align: center;'>${waitingData!.description!}</div>"
        : "";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColor.appthemeColor,
        title: TextView.headingWhiteText(
            text: AppStrings().waitList, context: context),
      ),
      body: waitingData != null
          ? ListView(
              children: [
                UiSpacer.verticalSpace(context: context, space: 0.04),
                Center(
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Image.asset(
                      AppImages().pngImages.icAppLogo,
                      height: screenHeight * 0.08,
                      // width: screenWidth * 0.4,
                    ),
                  ),
                ),
                UiSpacer.verticalSpace(context: context, space: 0.05),
                Center(
                  child: SvgPicture.asset(
                    AppImages().svgImages.ivWaitList,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColor.hintTextColor.withOpacity(0.3))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextView.largeHeadingText(
                          context: context, text: waitingData!.title),
                      UiSpacer.verticalSpace(context: context, space: 0.02),
                      Container(
                        alignment: Alignment.center,
                        child: Center(
                          child: HtmlWidget(
                              textStyle: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    AppSizes().fontSize.simpleFontSize,
                                fontFamily: AppFonts.nunitoRegular,
                                color: AppColor.dontHaveTextColor,
                              ),
                              description),
                        ),
                      ),
                      UiSpacer.verticalSpace(context: context, space: 0.01),
                      InkWell(
                        onTap: () {
                          openEmail(waitingData!.email.toString());
                        },
                        child: TextView.subHeadingText(
                            context: context,
                            text: waitingData!.email.toString(),
                            color: AppColor.dontHaveTextColor),
                      ),
                      UiSpacer.verticalSpace(context: context, space: 0.02),
                      Container(
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                        decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            shape: BoxShape.circle,
                            image:
                                waitingData!.bannerImage!.uploadImageUrl != null
                                    ? DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(waitingData!
                                            .bannerImage!.uploadImageUrl
                                            .toString()))
                                    : DecorationImage(
                                        image: AssetImage(
                                            AppImages().pngImages.ivGroupImg))),
                      ),
                      UiSpacer.verticalSpace(context: context, space: 0.01),
                    ],
                  ),
                ),
                UiSpacer.verticalSpace(context: context, space: 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Map map = {"from": "wait"};
                        Navigator.pushNamed(
                            context, AppRoutes.commonWebViewPage,
                            arguments: map);
                      },
                      child: Text(
                        AppStrings().aboutUs,
                        style: TextStyle(
                            fontSize: screenHeight *
                                AppSizes().fontSize.simpleFontSize,
                            fontFamily: AppFonts.nunitoBold,
                            color: AppColor.textBlack,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        GlobalUtility.showDialogFunction(
                            context,
                            DialogWithTwoButton(
                                from: "logout",
                                cancelText: AppStrings().logoutNo,
                                headingText: AppStrings().logout,
                                okayText: AppStrings().logoutYes,
                                subContent: AppStrings().logoutHeading));
                      },
                      child: Text(
                        AppStrings().logout,
                        style: TextStyle(
                            fontSize: screenHeight *
                                AppSizes().fontSize.simpleFontSize,
                            fontFamily: AppFonts.nunitoBold,
                            color: AppColor.textBlack,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(width: 20)
                  ],
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  Future<void> openEmail(String email) async {
    if (email == null || email.isEmpty) {
      throw 'Email address is null or empty';
    }
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    debugPrint('EMAIL --- $emailUri');
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  void waitingListContent() async {
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await AuthRequest().waitingListContentApi();
      debugPrint("WAITING LIST CONTENT API ==>> ${apiResponse.body}");
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];

      if (status == 200) {
        WaitingListContent waitingListContent =
            waitingListContentFromJson(apiResponse.body);
        waitingData = waitingListContent.data!.value;
        debugPrint("waitingListData---- ${waitingData!.title}");
      } else if (status == 400) {
        GlobalUtility.showToast(context, message);
      } else if (status == 401) {
        GlobalUtility().handleSessionExpire(context);
      }
      setState(() {});
    } else {
      GlobalUtility.showToast(context, AppStrings().INTERNET);
    }
  }
}
