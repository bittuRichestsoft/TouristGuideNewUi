// ignore_for_file: must_be_immutable, library_private_types_in_public_api, no_logic_in_create_state, depend_on_referenced_packages
import 'package:Siesta/api_requests/api.dart';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  String url = Api.termsAndConditions;
  bool isLoading = true;

  @override
  void initState() {
    debugPrint("TermsCondition url $url");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          leadingWidth: 0,
          elevation: 0,
          leading: const SizedBox(),
          title: Text(
            "Terms & Conditions",
            style: TextStyle(
                color: AppColor.appthemeColor,
                fontSize: MediaQuery.of(context).size.height *
                    AppSizes().fontSize.largeTextSize,
                fontFamily: AppFonts.nunitoBold),
          ),
          centerTitle: false,
          backgroundColor: AppColor.whiteColor,
          actions: [
            Padding(
              padding: EdgeInsets.only(
                  right: height * AppSizes().widgetSize.verticalPadding),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.clear,
                  color: AppColor.blackColor,
                ),
              ),
            )
          ],
        ),
        body: Stack(children: [
          WebViewPlus(
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
        ]));
  }
}
