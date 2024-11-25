// ignore_for_file: must_be_immutable, use_build_context_synchronously, non_constant_identifier_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/view_models/guide_models/guideReceivedBookingModel.dart';
import 'package:flutter/material.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class CreateItineraryPage extends StatefulWidget {
  CreateItineraryPage(
      {Key? key,
      dynamic guideReceievedBookingModel,
      selIndex,
      dynamic guideBookinghistoryModel})
      : super(key: key) {
    guideReceievedBooking_Model = guideReceievedBookingModel;
    guideBookinghistory_Model = guideBookinghistoryModel;
    itemSelected = selIndex;
  }
  dynamic guideReceievedBooking_Model;
  dynamic guideBookinghistory_Model;
  int? itemSelected;
  @override
  State<CreateItineraryPage> createState() => _CreateItineraryPageState();
}

class _CreateItineraryPageState extends State<CreateItineraryPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  bool isItinararyFilled = false,
      isNameFilled = true,
      isEmailFilled = true,
      isAmountFilled = true;

  String? htmlEditorInitalValue = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Key _k1 = GlobalKey();
  final Key _k2 = GlobalKey();
  final Key _k3 = GlobalKey();
  @override
  void initState() {
    super.initState();

    if (widget.itemSelected != -1 &&
        widget.guideReceievedBooking_Model != null) {
      widget.guideReceievedBooking_Model.nameController.text = widget
          .guideReceievedBooking_Model
          .guideReceivedBookingList[widget.itemSelected]
          .firstName;
      widget.guideReceievedBooking_Model.emailController.text = widget
          .guideReceievedBooking_Model
          .guideReceivedBookingList[widget.itemSelected]
          .email;
      if (widget.guideReceievedBooking_Model
              .guideReceivedBookingList[widget.itemSelected].itinerary !=
          null) {
        String itineraryContent = "";
        if (widget
            .guideReceievedBooking_Model
            .guideReceivedBookingList[widget.itemSelected]
            .itinerary
            .descriptions
            .toString()
            .contains("\n\n")) {
          itineraryContent = widget
              .guideReceievedBooking_Model
              .guideReceivedBookingList[widget.itemSelected]
              .itinerary
              .descriptions
              .toString()
              .replaceAll("\n\n", "<br></br>");
        } else {
          itineraryContent = widget
              .guideReceievedBooking_Model
              .guideReceivedBookingList[widget.itemSelected]
              .itinerary
              .descriptions
              .toString()
              .replaceAll(" -", "<br></br>");
        }
        htmlEditorInitalValue = itineraryContent;
      }
    } else {
      if (widget.guideBookinghistory_Model != null) {
        widget.guideBookinghistory_Model.nameController.text = widget
            .guideBookinghistory_Model!
            .guideItineraryDetailResponse!
            .data
            .firstName;
        widget.guideBookinghistory_Model.emailController.text = widget
            .guideBookinghistory_Model!
            .guideItineraryDetailResponse!
            .data
            .email;

        if (widget.guideBookinghistory_Model!.guideItineraryDetailResponse!
                .data!.itinerary !=
            null) {
          widget.guideBookinghistory_Model.advanceAmount.text = widget
              .guideBookinghistory_Model!
              .guideItineraryDetailResponse!
              .data!
              .itinerary!
              .price;
          widget.guideBookinghistory_Model.finalPayment.text = widget
              .guideBookinghistory_Model!
              .guideItineraryDetailResponse!
              .data!
              .itinerary!
              .finalPrice;

          String itineraryDescription = "";
          if (widget.guideBookinghistory_Model!.guideItineraryDetailResponse!
              .data!.itinerary!.descriptions
              .toString()
              .contains("\n\n")) {
            itineraryDescription = widget.guideBookinghistory_Model!
                .guideItineraryDetailResponse!.data!.itinerary!.descriptions
                .toString()
                .replaceAll("\n\n", "<br></br>");
          } else {
            itineraryDescription = widget.guideBookinghistory_Model!
                .guideItineraryDetailResponse!.data!.itinerary!.descriptions
                .toString()
                .replaceAll(" -", "<br></br>");
          }
          htmlEditorInitalValue = itineraryDescription;
        }
      }

      if (widget.guideReceievedBooking_Model != null) {
        if (widget.guideReceievedBooking_Model
                .guideReceivedBookingList[widget.itemSelected].itinerary !=
            null) {
          String itineraryDescription = widget
              .guideReceievedBooking_Model
              .guideReceivedBookingList[widget.itemSelected]
              .itinerary
              .description
              .replaceAll(" -", "<br></br>");
          htmlEditorInitalValue = itineraryDescription;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Container(
        height: screenHeight * 0.9,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: screenHeight * 0.035),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            )),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leadingWidth: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(5)),
                ),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.largeTextSize,
                    textColor: AppColor.lightBlack,
                    text: widget.itemSelected != -1
                        ? "Review Itinerary"
                        : AppStrings().edititineraryText),
                Divider(
                  color: AppColor.hintTextColor,
                ),
              ],
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal:
                      screenWidth * AppSizes().widgetSize.horizontalPadding),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    textColor: AppColor.lightBlack,
                    text: "First Name"),
                nameField(widget.itemSelected == -1
                    ? widget.guideBookinghistory_Model
                    : widget.guideReceievedBooking_Model),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    textColor: AppColor.lightBlack,
                    text: AppStrings().advanceAmountText),
                advanceAmountField(widget.itemSelected != -1
                    ? widget.guideReceievedBooking_Model
                    : widget.guideBookinghistory_Model),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.mediumPadding,
                    context: context),
                noteText(),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    textColor: AppColor.lightBlack,
                    text: "Final Payment"),
                finalAmountField(widget.itemSelected != -1
                    ? widget.guideReceievedBooking_Model
                    : widget.guideBookinghistory_Model),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.mediumPadding,
                    context: context),
                noteFinalText(widget.itemSelected != -1
                    ? widget
                        .guideReceievedBooking_Model
                        .guideReceivedBookingList[widget.itemSelected]
                        .bookingStart
                    : ""),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),
                TextView.normalText(
                    context: context,
                    fontFamily: AppFonts.nunitoSemiBold,
                    textSize: AppSizes().fontSize.simpleFontSize,
                    textColor: AppColor.lightBlack,
                    text: AppStrings().createItinerary),
                ckEditor(widget.itemSelected != -1
                    ? widget.guideReceievedBooking_Model
                    : widget.guideBookinghistory_Model),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.normalPadding,
                    context: context),
                UiSpacer.verticalSpace(
                    space: AppSizes().widgetSize.smallPadding,
                    context: context),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03, vertical: screenWidth * 0.06),
            child: createButton(widget.itemSelected != -1
                ? widget.guideReceievedBooking_Model
                : widget.guideBookinghistory_Model),
          ),
        ));
  }

  Widget noteText() {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(children: [
        TextSpan(
            text: AppStrings().note,
            style: TextStyle(
                fontFamily: AppFonts.nunitoRegular,
                color: AppColor.blackColor,
                fontSize: screenHeight * AppSizes().fontSize.mediumFontSize)),
        TextSpan(
            text: AppStrings().notePrepayment,
            style: TextStyle(
                fontFamily: AppFonts.nunitoSemiBold,
                color: AppColor.hintTextColor,
                fontSize: screenHeight * AppSizes().fontSize.mediumFontSize)),
      ]),
    );
  }

  Widget noteFinalText(String date) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(children: [
        TextSpan(
            text: AppStrings().note,
            style: TextStyle(
                fontFamily: AppFonts.nunitoRegular,
                color: AppColor.blackColor,
                fontSize: screenHeight * AppSizes().fontSize.mediumFontSize)),
        TextSpan(
            text:
                " Final amount will need to be processed by $date or 30 days after advance payment(whichever comes first)",
            style: TextStyle(
                fontFamily: AppFonts.nunitoSemiBold,
                color: AppColor.hintTextColor,
                fontSize: screenHeight * AppSizes().fontSize.mediumFontSize)),
      ]),
    );
  }

  Widget emailField(model) {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        controller: model.emailController,
        onChanged: onTextFieldValueChanged(model),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.textFieldFilledDecoration(context,
            "Email Address", AppImages().svgImages.icEmail, isEmailFilled),
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enableInteractiveSelection: false,
        readOnly: true,
        validator: (value) {
          if (GlobalUtility().validateEmail(value.toString()) == false) {
            model.issubmitButtonEnable = false;
            model.counterNotifier.notifyListeners();
            model.counterNotifier.value++;
            return AppStrings().emailErrorString;
          } else if (value == "" || value == null) {
            model.issubmitButtonEnable = false;
            model.counterNotifier.notifyListeners();
            model.counterNotifier.value++;
            return null;
          }
          return null;
        },
      ),
    );
  }

  Widget nameField(model) {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        controller: model.nameController,
        onChanged: onTextFieldValueChanged(model),
        validator: (value) {
          if (value == null) {
            model.issubmitButtonEnable = false;
            model.notifyListeners();
            model.counterNotifier.value++;
            return 'Please enter first name';
          }
          return null;
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.textFieldFilledDecoration(
            context, "Name", AppImages().svgImages.icName, isNameFilled),
        enableInteractiveSelection: false,
        readOnly: true,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget advanceAmountField(model) {
    return TextFormField(
      key: _k1,
      controller: model.advanceAmount,
      onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      maxLength: 7,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.simpletextFieldDecoration(
          context, "Enter advance amount you want", isAmountFilled),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == "" || value == null) {
          model.issubmitButtonEnable = false;
          model.counterNotifier.notifyListeners();

          model.counterNotifier.value++;

          return AppStrings().enterPrice;
        } else if (value.trim().isEmpty) {
          model.issubmitButtonEnable = false;
          model.counterNotifier.notifyListeners();

          model.counterNotifier.value++;
          return AppStrings().blankSpace;
        } else if (GlobalUtility().validatePinPrice(value)) {
          model.issubmitButtonEnable = false;
          model.counterNotifier.notifyListeners();

          model.counterNotifier.value++;
          return AppStrings().enterValidPrice;
        }

        return null;
      },
    );
  }

  Widget finalAmountField(model) {
    return TextFormField(
      key: _k2,
      controller: model.finalPayment,
      onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      maxLength: 7,
      textAlign: TextAlign.start,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.simpletextFieldDecoration(
          context, "Enter final amount you want", isAmountFilled),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
    );
  }

  Widget itineraryField(model) {
    return TextFormField(
      key: _k3,
      controller: model.createItinerary,
      onChanged: onTextFieldValueChanged(model),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: AppColor.lightBlack,
          fontFamily: AppFonts.nunitoRegular,
          fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
      decoration: TextFieldDecoration.simpletextFieldDecoration(
          context, AppStrings().typeSomething, isItinararyFilled),
      keyboardType: TextInputType.text,
      maxLines: 10,
      validator: (value) {
        if (value == null) {
          model.issubmitButtonEnable = false;
          model.counterNotifier.notifyListeners();

          model.counterNotifier.value++;
          return 'Enter itinerary detail';
        }
        return null;
      },
    );
  }

  Widget createButton(model) {
    return model.isBusy == false
        ? CommonButton.commonBoldTextButton(
            context: context,
            text: "Send",
            onPressed: () async {
              String? ckEditorText = await model.htmlEditorController.getText();
              model.createItinerary.text = ckEditorText.toString();
              if (validate(model)) {
                if (model.issubmitButtonEnable!) {
                  if (ckEditorText != "") {
                    if (widget.itemSelected != -1 &&
                        widget.guideReceievedBooking_Model != null) {
                      model.guideCreateItinerary(
                        context,
                        widget.guideReceievedBooking_Model
                            .guideReceivedBookingList[widget.itemSelected].id,
                      );
                    } else {
                      model.guideEditItinerary(
                          context,
                          widget.guideBookinghistory_Model!
                              .guideItineraryDetailResponse!.data.id);
                    }
                  } else {
                    GlobalUtility.showToast(
                        context, "Itinerary detail required");
                  }
                }
              }
            },
            isButtonEnable: model.issubmitButtonEnable)
        : SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Center(
              child: CircularProgressIndicator(color: AppColor.appthemeColor),
            ),
          );
  }

  Widget ckEditor(model) {
    return Container(
      height: screenHeight * 0.35,
      color: Colors.transparent,
      child: HtmlEditor(
        controller: model.htmlEditorController,
        htmlEditorOptions: HtmlEditorOptions(
          hint: 'Type something',
          autoAdjustHeight: true,
          shouldEnsureVisible: true,
          initialText: htmlEditorInitalValue!.replaceAll("\n", "<br></br>"),
        ),
        htmlToolbarOptions: HtmlToolbarOptions(
          textStyle: TextStyle(
              height: 1.5,
              fontFamily: AppFonts.nunitoSemiBold,
              color: AppColor.blackColor,
              fontSize: screenHeight * AppSizes().fontSize.mediumFontSize),
          toolbarPosition: ToolbarPosition.aboveEditor, //by default
          toolbarType: ToolbarType.nativeScrollable,
          toolbarItemHeight: screenHeight * 0.03,
          onButtonPressed:
              (ButtonType type, bool? status, Function? updateStatus) {
            return true;
          },
          onDropdownChanged: (DropdownType type, dynamic changed,
              Function(dynamic)? updateSelectedItem) {
            return true;
          },
          mediaLinkInsertInterceptor: (String url, InsertFileType type) {
            debugPrint(url);
            return true;
          },
        ),
        otherOptions: const OtherOptions(height: 400),
        callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
          debugPrint('html before change is $currentHtml');
        }, onChangeContent: (String? changed) {
          debugPrint('content changed to $changed');
        }, onChangeCodeview: (String? changed) {
          debugPrint('code changed to $changed');
        }, onChangeSelection: (EditorSettings settings) {
          debugPrint('parent element is ${settings.parentElement}');
          debugPrint('font name is ${settings.fontName}');
        }, onImageUploadError:
            (FileUpload? file, String? base64Str, UploadError error) {
          debugPrint(base64Str ?? '');
          if (file != null) {
            debugPrint(file.name);
            debugPrint(file.type);
          }
        }, onKeyDown: (int? keyCode) {
          debugPrint('$keyCode key downed');
          debugPrint(
              'current character count: ${model.htmlEditorController.characterCount}');
        }, onKeyUp: (int? keyCode) {
          debugPrint('$keyCode key released');
        }, onMouseDown: () {
          debugPrint('mouse downed');
        }, onMouseUp: () {
          debugPrint('mouse released');
        }, onNavigationRequestMobile: (String url) {
          debugPrint(url);
          return NavigationActionPolicy.ALLOW;
        }, onPaste: () {
          debugPrint('pasted into editor');
        }, onScroll: () {
          debugPrint('editor scrolled');
        }),
        plugins: [
          SummernoteAtMention(
              getSuggestionsMobile: (String value) {
                var mentions = <String>['test1', 'test2', 'test3'];
                return mentions
                    .where((element) => element.contains(value))
                    .toList();
              },
              mentionsWeb: ['test1', 'test2', 'test3'],
              onSelect: (String value) {
                debugPrint(value);
              }),
        ],
      ),
    );
  }

  onTextFieldValueChanged(model) {
    if (model.nameController.text.isNotEmpty &&
        model.emailController.text.isNotEmpty &&
        model.advanceAmount.text.isNotEmpty &&
        (widget.itemSelected == -1
            ? model.guideItineraryDetailResponse!.data.itinerary!.finalPrice !=
                null
            : model.finalPayment.text.isNotEmpty) &&
        (model.htmlEditorController != "" &&
            model.htmlEditorController != null)) {
      model.issubmitButtonEnable = true;
      model.counterNotifier.notifyListeners();
      model.counterNotifier.value++;
    } else {
      model.issubmitButtonEnable = false;
      model.counterNotifier.notifyListeners();
      model.counterNotifier.value++;
    }
  }

  bool validate(model) {
    String name = model.nameController.text;
    String advanceAmountTxt = model.advanceAmount.text;
    String createItineraryTxt = model.createItinerary.text;
    String finalPay = model.finalPayment.text;

    if (name == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterName);
      return false;
    } else if (advanceAmountTxt.replaceAll(" ", "") == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterAdvanceAmount);
      return false;
    } else if (createItineraryTxt.replaceAll(" ", "") == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterCreateItinerary);
      return false;
    } else if (finalPay.replaceAll(" ", "") == "") {
      GlobalUtility.showToastBottom(context, "Please enter final payment");
      return false;
    }
    return true;
  }
}
