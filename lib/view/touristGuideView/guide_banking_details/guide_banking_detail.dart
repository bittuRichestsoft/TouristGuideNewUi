import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/custom_widgets/common_widgets.dart';
import 'package:Siesta/custom_widgets/custom_textfield.dart';
import 'package:Siesta/view_models/guide_models/guide_banking_detail_model/guide_banking_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class GuideBankingDetails extends StatefulWidget {
  const GuideBankingDetails({Key? key}) : super(key: key);

  @override
  State<GuideBankingDetails> createState() => _GuideBankingDetailsState();
}

class _GuideBankingDetailsState extends State<GuideBankingDetails> {
  double screenWidth = 0.0, screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<GuideBankingDetailModel>.reactive(
        viewModelBuilder: () => GuideBankingDetailModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,

            // App bar
            appBar: AppBar(
              backgroundColor: AppColor.appthemeColor,
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              leading: IconButton(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                color: AppColor.whiteColor,
              ),
              title: TextView.headingWhiteText(
                  text: AppStrings().bankingDetails, context: context),
            ),

            // body
            body: model.hasError
                ? CommonWidgets().inAppErrorWidget(model.modelError.toString(),
                    () {
                    model.initialise();
                  }, context: context)
                : model.initialised == false
                    ? CommonWidgets().inPageLoader()
                    : ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                AppSizes().widgetSize.horizontalPadding,
                            vertical: screenHeight *
                                AppSizes().widgetSize.verticalPadding),
                        children: [
                          Row(
                            children: [
                              Text(
                                "Note:-  ",
                                style: TextStyle(
                                    color: AppColor.blackColor,
                                    fontFamily: AppFonts.nunitoRegular,
                                    fontSize: screenHeight *
                                        AppSizes().fontSize.simpleFontSize),
                              ),
                              Text(
                                AppStrings.bankNote,
                                style: TextStyle(
                                    color: AppColor.hintTextColor,
                                    fontFamily: AppFonts.nunitoRegular,
                                    fontSize: screenHeight *
                                        AppSizes().fontSize.simpleFontSize),
                              ),
                            ],
                          ),
                          UiSpacer.verticalSpace(space: 0.02, context: context),

                          // Account holder name text field
                          CustomTextField(
                            textEditingController: model.accountHolderNameTEC,
                            hintText: AppStrings().enterAccountHolderName,
                            headingText: AppStrings.accountHolderName,
                          ),
                          UiSpacer.verticalSpace(space: 0.02, context: context),

                          // Account number text field
                          CustomTextField(
                            textEditingController: model.accountNumberTEC,
                            hintText: AppStrings().enterCardNumber,
                            headingText: AppStrings.accountNumber,
                            keyboardType: TextInputType.number,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          UiSpacer.verticalSpace(space: 0.02, context: context),

                          // bank name text field
                          CustomTextField(
                            textEditingController: model.bankNameTEC,
                            hintText: AppStrings().enterBankName,
                            headingText: AppStrings.bankName,
                          ),
                          UiSpacer.verticalSpace(space: 0.02, context: context),

                          // routing number text field
                          CustomTextField(
                            textEditingController: model.ifscTEC,
                            hintText: AppStrings().enterIfscCode,
                            headingText: AppStrings.routingNumber,
                          ),
                        ],
                      ),

            bottomNavigationBar:
                model.initialised ? submitButton(model) : SizedBox(),
          );
        });
  }

  Widget submitButton(GuideBankingDetailModel model) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.06,
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, vertical: screenWidth * 0.04),
      child: CommonButton.commonNormalButton(
          context: context,
          text: "Submit",
          onPressed: () {
            if (model.validate(context)) {
              model.guideUpdateAccountAPI(context);
            }
          }),
    );
  }
}
