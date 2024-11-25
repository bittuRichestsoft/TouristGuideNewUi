// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../utility/globalUtility.dart';
import '../all_dialogs/dialog_with_twoButton.dart';

class WaitingWebViewPage extends StatefulWidget {
  const WaitingWebViewPage({super.key});

  @override
  State<WaitingWebViewPage> createState() => _WaitingWebViewPageState();
}

class _WaitingWebViewPageState extends State<WaitingWebViewPage> {
  String url = Api.waitingList;

  var role;
  bool isLoading = true;

  void roleName() async {
    if (role != null) {
      String userRole = await PreferenceUtil().getRoleName();
      role = userRole;
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("WaitingList URL--- $url");
    roleName();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              title: TextView.headingWhiteText(
                  text: AppStrings().waitList, context: context),
            ),
            body: Stack(children: [
              WebViewPlus(
                gestureNavigationEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (url) {
                  setState(() {
                    isLoading = false;
                  });
                },
                initialUrl: url,
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.appthemeColor,
                      ),
                    )
                  : const SizedBox(),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
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
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.03),
                        decoration: BoxDecoration(
                            color: AppColor.appthemeColor,
                            borderRadius: BorderRadius.circular(30)),
                        height: MediaQuery.of(context).size.height * 0.065,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextView.headingText(
                          color: AppColor.whiteColor,
                          context: context,
                          text: AppStrings().logout,
                        ),
                      ),
                    ),
                  ))
            ])));
  }
}
