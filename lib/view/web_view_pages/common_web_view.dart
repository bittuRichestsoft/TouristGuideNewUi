// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:Siesta/view/signIn/login_page.dart';
import 'package:Siesta/view/touristGuideView/home/guide_home_page.dart';
import 'package:Siesta/view/travellerView/home/traveller_homepage.dart';
import 'package:Siesta/view/wait_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class CommonWebViewPage extends StatefulWidget {
  CommonWebViewPage({Key? key, Object? from}) : super(key: key) {
    Map map = from as Map;
    fromWhere = map["from"];
    role = map["role"];
  }

  String? fromWhere;
  String? role;
  @override
  State<CommonWebViewPage> createState() => _CommonWebViewPageState();
}

class _CommonWebViewPageState extends State<CommonWebViewPage> {
  String url = Api.aboutUs;

  String? roleUser;
  bool isLoading = true;

  void roleName() async {
    String userRole = await PreferenceUtil().getRoleName();
    debugPrint("ROLE --userRole == $userRole --- ${widget.role}");
    roleUser = userRole;
  }

  @override
  void initState() {
    super.initState();

    roleName();
    debugPrint("ROLE --init == $roleUser");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          debugPrint("ROLE -- ${widget.role}");
          if (widget.fromWhere == "login") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage()),
              (route) => false,
            );
          } else if (widget.fromWhere == "wait") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const WaitListScreen()),
              (route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => widget.role == 'GUIDE'
                    ? TouristGuideHomePage(
                        bottomTab: 0,
                        fromWhere: "",
                      )
                    : TravellerHomePage(bottomTab: 0),
              ),
              (route) => false,
            );
          }
          return true;
        },
        child: Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              leading: IconButton(
                icon: Icon(Icons.clear, color: AppColor.whiteColor),
                onPressed: () {
                  if (widget.fromWhere == "login") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const LoginPage()),
                      (route) => false,
                    );
                  } else if (widget.fromWhere == "wait") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const WaitListScreen()),
                      (route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            widget.role == 'GUIDE'
                                ? TouristGuideHomePage(
                                    bottomTab: 0,
                                    fromWhere: "",
                                  )
                                : TravellerHomePage(bottomTab: 0),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
              title: TextView.headingWhiteText(
                  text: AppStrings().aboutUs, context: context),
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
                  : const SizedBox()
            ])));
  }
}
