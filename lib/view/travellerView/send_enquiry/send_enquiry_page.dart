import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Siesta/view_models/traveller_find_guide.view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:intl/intl.dart';

class SendEnquiryScreen extends StatefulWidget {
  const SendEnquiryScreen({Key? key}) : super(key: key);

  @override
  State<SendEnquiryScreen> createState() => _SendEnquiryScreenState();
}

class _SendEnquiryScreenState extends State<SendEnquiryScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isContactFilled = false;

  bool destinationText = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<TravellerFindGuideModel>.reactive(
        viewModelBuilder: () => TravellerFindGuideModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          if (model.isBusy) {
            model.setBusy(false);
          }
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
              centerTitle: true,
              backgroundColor: AppColor.appthemeColor,
              elevation: 0,
              title: TextView.headingWhiteText(
                  context: context, text: AppStrings().findGuide),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColor.whiteColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal:
                        screenWidth * AppSizes().widgetSize.horizontalPadding,
                    vertical:
                        screenWidth * AppSizes().widgetSize.horizontalPadding),
                children: [detailFields(model)]),
          );
        });
  }

  /// FIELDS
  Widget detailFields(model) {
    return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        nameFields(model),
        UiSpacer.verticalSpace(space: 0.02, context: context),
        emailField(model),
        UiSpacer.verticalSpace(space: 0.009, context: context),
        phoneNumberField(model),
        UiSpacer.verticalSpace(space: 0.015, context: context),
        TextView.normalText(
            context: context,
            text: AppStrings().selectDate,
            textColor: AppColor.lightBlack,
            textSize: AppSizes().fontSize.simpleFontSize,
            fontFamily: AppFonts.nunitoSemiBold),
        const SizedBox(
          height: 5,
        ),
        dateFields(model),
        UiSpacer.verticalSpace(space: 0.007, context: context),
        TextView.normalText(
            context: context,
            text: AppStrings().destination,
            textColor: AppColor.lightBlack,
            textSize: AppSizes().fontSize.simpleFontSize,
            fontFamily: AppFonts.nunitoSemiBold),
        const SizedBox(
          height: 5,
        ),
        destinationView(model),
        UiSpacer.verticalSpace(space: 0.06, context: context),
        model.isBusy == false
            ? CommonButton.commonBoldTextButton(
                context: context,
                isButtonEnable: model.isSubmitButtonEnable,
                text: AppStrings().send,
                onPressed: () {
                  if (model.isSubmitButtonEnable) {
                    DateTime dt1 =
                        DateTime.parse(model.fromDateController.text);
                    DateTime dt2 = DateTime.parse(model.toDateController.text);

                    if (dt1.compareTo(dt2) == 0 || dt1.compareTo(dt2) < 0) {
                      model.sendEnquiry(context);
                    } else {
                      GlobalUtility.showToast(context,
                          "Form Date Should be greater than to date!!");
                    }
                  }
                })
            : SizedBox(
                width: screenWidth * 0.1,
                child: Center(
                  child:
                      CircularProgressIndicator(color: AppColor.appthemeColor),
                ),
              )
      ],
    );
  }

  Widget nameFields(TravellerFindGuideModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: screenWidth * 0.43,
          child: TextFormField(
            controller: model.firstNameController,
            readOnly: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == "" || value == null) {
                model.isSubmitButtonEnable = false;
                model.notifyListeners();
                return AppStrings().enterFirstString;
              } else if (value.trim().isEmpty) {
                model.isSubmitButtonEnable = false;
                model.notifyListeners();
                return AppStrings().blankSpace;
              } else if (value.toString().length < 2) {
                model.isSubmitButtonEnable = false;
                model.notifyListeners();
                return AppStrings().nameErrorString;
              }
              return null;
            },
            onChanged: onTextFieldValueChanged(model),
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            decoration: TextFieldDecoration.textFieldDecoration(
                context, 'First name', AppImages().svgImages.icName, ""),
            enableInteractiveSelection: true,
            textInputAction: TextInputAction.next,
          ),
        ),
        // last Name field
        SizedBox(
          // height: screenHeight * AppSizes().widgetSize.textFieldheight,
          width: screenWidth * 0.43,
          child: TextFormField(
            controller: model.lastNameController,
            readOnly: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.trim().isEmpty) {
                return AppStrings().blankSpace;
              }
              return null;
            },
            onChanged: onTextFieldValueChanged(model),
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            decoration: TextFieldDecoration.textFieldDecoration(
                context, 'Last name', AppImages().svgImages.icName, ""),
            enableInteractiveSelection: true,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  /// Contact number
  Widget phoneNumberField(model) {
    return SizedBox(
      // height: screenHeight * AppSizes().widgetSize.textFieldheight,
      width: screenWidth,
      child: TextFormField(
        controller: model.mobileNumberController,
        onChanged: onTextFieldValueChanged(model),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == "" || value == null) {
            model.isSubmitButtonEnable = false;
            model.notifyListeners();
            return AppStrings().enterPhoneNumber;
          } else if (value.trim().isEmpty) {
            model.isSubmitButtonEnable = false;
            model.notifyListeners();
            return AppStrings().blankSpace;
          } else if (value.toString().length < 10) {
            model.isSubmitButtonEnable = false;
            model.notifyListeners();
            return AppStrings().phoneErrorString;
          } else if (GlobalUtility().validateContact(value)) {
            model.isSubmitButtonEnable = false;
            model.notifyListeners();
            return AppStrings().EnterValidMobile;
          }

          return null;
        },
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: InputDecoration(
          hintText: "Contact Number",
          prefixIcon: InkWell(
              onTap: () {
                showCountryPicker(
                  useSafeArea: false,
                  showPhoneCode: false,
                  context: context,
                  countryListTheme: CountryListThemeData(
                    flagSize: 25,
                    backgroundColor: Colors.white,
                    textStyle: TextStyle(
                        fontSize: AppSizes().fontSize.simpleFontSize,
                        color: AppColor.textColorLightBlack),
                    bottomSheetHeight: 500,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    inputDecoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  onSelect: (Country country) {
                    // setState(() {
                    model.countryName = country.name;
                    model.notifyListeners();
                    // });
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 15, right: 10),
                child: Text(model.countryName == "" ? "US" : model.countryName),
              )),
          hintStyle: TextStyle(
              color: AppColor.hintTextColor,
              fontFamily: AppFonts.nunitoRegular,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.simpleFontSize),
          contentPadding: const EdgeInsets.only(top: 20, bottom: 2),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fieldBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.width *
                      AppSizes().widgetSize.smallBorderRadius))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldEnableColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.fieldBorderColor),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorBorderColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorBorderColor),
          ),
        ),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  /// email field

  Widget emailField(model) {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        controller: model.emailController,
        readOnly: true,
        validator: (value) {
          if (value == "" || value == null) {
            model.isSubmitButtonEnable = false;
            model.notifyListeners();
            return AppStrings().enterEmail;
          } else if (GlobalUtility().validateEmail(value.toString()) == false) {
            model.isSubmitButtonEnable = false;
            model.notifyListeners();
            return AppStrings().emailErrorString;
          }
          return null;
        },
        onChanged: onTextFieldValueChanged(model),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.textFieldDecoration(context,
            AppStrings().enterEmail, AppImages().svgImages.icEmail, ""),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  /// Date field
  Widget dateFields(model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: screenHeight * AppSizes().widgetSize.textFieldheight,
          width: screenWidth * 0.42,
          child: TextFormField(
            controller: model.fromDateController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null) {
                model.isSubmitButtonEnable = false;
                model.notifyListeners();
                return 'Please enter from date';
              }
              return null;
            },
            onTap: () {
              // Below line stops keyboard from appearing
              FocusScope.of(context).requestFocus(FocusNode());
              _selectDate(context, model, 1);
            },
            onChanged: (value) {},
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            decoration: TextFieldDecoration.textFieldDecorationWithSuffix(
                context, 'From', AppImages().svgImages.icCalendar),
            enableInteractiveSelection: true,
            textInputAction: TextInputAction.next,
          ),
        ),

        // last Name field
        SizedBox(
          height: screenHeight * AppSizes().widgetSize.textFieldheight,
          width: screenWidth * 0.43,
          child: TextFormField(
            controller: model.toDateController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null) {
                model.isSubmitButtonEnable = false;
                model.notifyListeners();
                return 'Please enter to date';
              }
              return null;
            },
            onTap: () {
              // Below line stops keyboard from appearing
              FocusScope.of(context).requestFocus(FocusNode());
              _selectDate(context, model, 2);
            },
            onChanged: (value) {},
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            decoration: TextFieldDecoration.textFieldDecorationWithSuffix(
                context, 'To', AppImages().svgImages.icCalendar),
            enableInteractiveSelection: true,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  /// destination
  Widget destinationView(model) {
    return TextFormField(
      // onChanged: (value) {
      //   setState(() {
      //     if (value.replaceAll("  ", "") == "") {
      //       destinationText = false;
      //     } else {
      //       destinationText = true;
      //     }
      //   });
      // },
      controller: model.destinationController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == "" || value == null) {
          model.isSubmitButtonEnable = false;
          model.notifyListeners();
          return AppStrings().enterLocation;
        } else if (value.trim().isEmpty) {
          model.isSubmitButtonEnable = false;
          model.notifyListeners();
          return AppStrings().blankSpace;
        }
        return null;
      },
      onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: InputDecoration(
        hintText: AppStrings().destinationContent,
        hintStyle: TextStyle(
            color: AppColor.hintTextColor,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: MediaQuery.of(context).size.height *
                AppSizes().fontSize.simpleFontSize),
        contentPadding: const EdgeInsets.only(top: 10, bottom: 0, left: 5),
        fillColor: AppColor.textfieldFilledColor,
        filled: destinationText,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.textfieldborderColor),
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius))),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.textfieldborderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.textfieldborderColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.textfieldborderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.textfieldborderColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.textfieldborderColor),
        ),
      ),
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      maxLines: 1,
    );
  }

  onTextFieldValueChanged(TravellerFindGuideModel model) {
    if (model.mobileNumberController.text.isNotEmpty &&
        model.destinationController.text.isNotEmpty &&
        model.fromDateController.text.isNotEmpty &&
        model.toDateController.text.isNotEmpty) {
      model.isSubmitButtonEnable = true;
    } else {
      model.isSubmitButtonEnable = false;
    }
    model.notifyListeners();
  }

  _selectDate(BuildContext context, model, typeDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      // 1 == from date
      // 2 == to date
      if (typeDate == 1) {
        debugPrint(formattedDate);
        model.fromDateController.text = formattedDate;
        model.notifyListeners();
      } else {
        model.toDateController.text = formattedDate;
        model.notifyListeners();
      }
    }
  }
}
