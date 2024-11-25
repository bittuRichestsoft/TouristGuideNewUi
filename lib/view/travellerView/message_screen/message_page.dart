// ignore_for_file: prefer_is_empty, use_build_context_synchronously, must_be_immutable, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/response_pojo/travellerMessagePojo.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/view_models/travellerMessageModel.dart';
import 'package:Siesta/common_widgets/common_imageview.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'dart:io' as io;
import 'package:file/local.dart';

class MessagePage extends StatefulWidget {
  MessagePage(
      {Key? key, required String fromWhere, LocalFileSystem? localFileSystem})
      : super(key: key) {
    from = fromWhere;
  }

  String from = "";
  @override
  State<MessagePage> createState() => _MessagePageState();
}

LocalFileSystem? localFileSystem;

class _MessagePageState extends State<MessagePage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  ScrollController scrollController = ScrollController();
  int pageCount = 1;
  TextEditingController searchController = TextEditingController();
  TextEditingController guideSendMessageTEC = TextEditingController();
  bool firstTime = true;

  @override
  void initState() {
    TravellerMessageModel model = TravellerMessageModel(context, null);
    initRecord(model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<TravellerMessageModel>.reactive(
        viewModelBuilder: () => TravellerMessageModel(context, null),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (!model.isBusy) {
                pageCount = pageCount + 1;
                model.getInboxUserList(context, pageCount, model.inboxType, "");
              }
            } else {}
          });

          if (widget.from == "message_guide") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
              if (firstTime) {
                await PreferenceUtil().getGuideSendMessageUserId();
                await PreferenceUtil().getGuideSendMessageUserName();
                model.subjectController.clear();
                model.composeMessageController.clear();
                String userID =
                    await PreferenceUtil().getGuideSendMessageUserId();
                model.dropDownValue = userID.toString();
                guideSendMessageTEC.text =
                    await PreferenceUtil().getGuideSendMessageUserName();
                model.isBusy == false;
                model.isMsgRecordStartCompose = false;
                model.notifyListeners();

                writeMsgBottomSheet(model, context);
                firstTime = false;
              }
            });
          }

          if (widget.from == "chat_with_guide") {
            if (firstTime) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
                await PreferenceUtil().getTravellerSendMessageUserId();
                await PreferenceUtil().getTravellerSendMessageUserName();
                model.subjectController.clear();
                model.composeMessageController.clear();
                String userID =
                    await PreferenceUtil().getTravellerSendMessageUserId();
                model.dropDownValue = userID.toString();
                guideSendMessageTEC.text =
                    await PreferenceUtil().getTravellerSendMessageUserName();
                model.isBusy == false;
                model.isMsgRecordStartCompose = false;
                model.audioFileCompose = null;
                model.notifyListeners();
                writeMsgBottomSheet(model, context);
                firstTime = false;
              });
            }
          }

          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: const SizedBox(),
              leadingWidth: 0,
              backgroundColor: AppColor.whiteColor,
              toolbarHeight: 125,
              elevation: 0,
              title: searchAndSentView(model),
            ),
            body: model.isEmtyViewShow == true
                ? emptyItemView(model)
                : Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      model.isBusy
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: AppColor.appthemeColor),
                            )
                          : Container(
                              height: screenHeight -
                                  ((screenHeight * 0.18) +
                                      kBottomNavigationBarHeight +
                                      kToolbarHeight),
                              color: AppColor.whiteColor,
                              child: RefreshIndicator(
                                  onRefresh: model.pullRefresh,
                                  child: ListView.separated(
                                    controller: scrollController,
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: model.inboxUserList.length,
                                    padding: EdgeInsets.only(
                                        left: screenWidth *
                                            AppSizes()
                                                .widgetSize
                                                .horizontalPadding,
                                        right: screenWidth *
                                            AppSizes()
                                                .widgetSize
                                                .horizontalPadding,
                                        bottom: kBottomNavigationBarHeight),
                                    itemBuilder: (context, index) {
                                      return model.inboxUserList[index]
                                                  .lastMessageUserDetails !=
                                              null
                                          ? itemView(index, model)
                                          : const SizedBox();
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: AppColor.textfieldborderColor,
                                    ),
                                  )),
                            ),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 20,
                          child: composeMsgView(model)),
                    ],
                  ),
          );
        });
  }

  Widget emptyItemView(model) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          height: screenHeight * 0.5,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text(
            AppStrings().noResultFound,
            style: TextStyle(
                fontSize: screenHeight * AppSizes().fontSize.largeTextSize,
                fontFamily: AppFonts.nunitoSemiBold,
                color: AppColor.lightBlack),
          ),
        ),
        composeMsgView(model)
      ],
    );
  }

  // Search and sent view
  Widget searchAndSentView(TravellerMessageModel model) {
    return Container(
      height: screenHeight * 0.18,
      width: screenWidth,
      color: AppColor.whiteColor,
      margin: EdgeInsets.only(top: screenHeight * 0.04),
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * AppSizes().widgetSize.normalPadding),
      child: Column(
        children: [
          searchField(model),
          DropdownButton<String>(
            isExpanded: true,
            value: model.dropDownValueInbox, //selected
            icon: CommonImageView.largeSvgImageView(
                imagePath: AppImages().svgImages.arrowDown),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: AppColor.errorBorderColor),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (String? newValue) {
              model.dropDownValueInbox = newValue;
              model.counterNotifier.value++;
              model.notifyListeners();
              if (newValue == 'Inbox') {
                model.inboxType = '1';
                model.inboxUserList = [];
                model.getInboxUserList(context, 1, "1", "");
              } else {
                model.inboxType = '2';
                model.inboxUserList = [];
                model.getInboxUserList(context, 1, "2", "");
              }
            },
            items: <String>['Inbox', 'Sent']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toString(),
                    style: TextStyle(
                        color: AppColor.textfieldColor,
                        fontFamily: AppFonts.nunitoSemiBold,
                        fontSize:
                            screenHeight * AppSizes().fontSize.simpleFontSize)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // search field
  Widget searchField(TravellerMessageModel model) {
    return SizedBox(
      height: screenHeight * AppSizes().widgetSize.textFieldheight,
      child: TextFormField(
        controller: searchController,
        onChanged: (value) {
          if (value != "") {
            if (model.dropDownValueInbox == "Inbox") {
              model.getInboxUserList(context, 1, "1", value);
            } else {
              model.getInboxUserList(context, 1, "2", value);
            }
          } else {
            if (model.dropDownValueInbox == "Inbox") {
              model.getInboxUserList(context, 1, "1", "");
            } else {
              model.getInboxUserList(context, 1, "2", "");
            }
          }
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.searchFieldDecoration(
            context, AppStrings().searchWithDot),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget itemView(int index, TravellerMessageModel model) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direction) {
          var id = model.inboxUserList[index].id;
          var ar = [];
          ar.add(id);
          model.deleteComposeMessage(context, ar);
        },
        child: AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 1000),
          child: SlideAnimation(
            verticalOffset: 20.0,
            child: FadeInAnimation(
                child: SizedBox(
                    width: screenWidth,
                    child: ListTile(
                        onTap: () async {
                          model.thread_id = model.inboxUserList.length > 0
                              ? (model.inboxUserList[index].id).toString()
                              : "";
                          model.notifyListeners();
                          model.counterNotifier.value++;
                          Navigator.pushNamed(
                              context, AppRoutes.messageChatPage, arguments: {
                            "threadId":
                                (model.inboxUserList[index].id).toString()
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: profileImage(model.inboxUserList.length > 0 &&
                                model.inboxUserList[index]
                                        .lastMessageUserDetails!.userDetail !=
                                    null
                            ? model.inboxUserList[index].lastMessageUserDetails!
                                .userDetail!.profilePicture
                            : ""),
                        title: TextView.normalText(
                            textColor: AppColor.textfieldColor,
                            textSize: AppSizes().fontSize.simpleFontSize,
                            fontFamily: AppFonts.nunitoBold,
                            text: model.inboxUserList.length > 0 &&
                                    model.inboxUserList[index]
                                            .lastMessageUserDetails !=
                                        null
                                ? "${model.inboxUserList[index].lastMessageUserDetails!.name} "
                                : "",
                            context: context),
                        isThreeLine: false,
                        subtitle: TextView.normalText(
                            textColor: AppColor.dontHaveTextColor,
                            textSize: AppSizes().fontSize.mediumFontSize,
                            fontFamily: AppFonts.nunitoRegular,
                            text: model.inboxUserList.length > 0
                                ? model.inboxUserList[index].messageType == 0
                                    ? model.inboxUserList[index].subjectText
                                    : "Voice Note"
                                : "",
                            /*"${model.inboxUserList[index].subjectText}"*/
                            context: context),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextView.normalText(
                                textColor: AppColor.hintTextColor,
                                textSize: AppSizes().fontSize.mediumFontSize,
                                fontFamily: AppFonts.nunitoRegular,
                                text: model.inboxUserList.length > 0
                                    ? Jiffy.parse(model
                                            .inboxUserList[index].updatedAt
                                            .toString())
                                        .yMMMd
                                    : "",
                                context: context),
                          ],
                        )))),
          ),
        ));
  }

  //image view
  Widget profileImage(img) {
    return Container(
      width: screenWidth * 0.15,
      height: screenWidth * 0.15,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(color: AppColor.hintTextColor, width: 1),
          shape: BoxShape.circle,
          image: img != null && img != ""
              ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(img))
              : DecorationImage(
                  image:
                      AssetImage(AppImages().pngImages.icProfilePlaceholder))),
    );
  }

  //Compose view
  Widget composeMsgView(model) {
    return GestureDetector(
      onTap: () {
        model.subjectController.clear();
        model.composeMessageController.clear();
        //model.isMsgRecordStartCompose = null;
        writeMsgBottomSheet(model, context);
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          height: screenHeight * 0.06,
          width: screenWidth * 0.3,
          margin: EdgeInsets.only(
              right: screenWidth * 0.02, top: screenHeight * 0.02),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages().pngImages.icEdit,
                width: AppSizes().widgetSize.iconWidth,
              ),
              TextView.normalText(
                  context: context,
                  text: AppStrings().compose,
                  fontFamily: AppFonts.nunitoSemiBold,
                  textSize: AppSizes().fontSize.normalFontSize,
                  textColor: AppColor.appthemeColor),
            ],
          ),
        ),
      ),
    );
  }

  void writeMsgBottomSheet(
      TravellerMessageModel model, BuildContext context) async {
    model.audioFileCompose = null;
    model.isMsgRecordStartCompose = null;
    model.hasVoiceMsgCompose = null;
    await initRecord(model);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(
              screenWidth * AppSizes().widgetSize.mediumBorderRadius),
          topLeft: Radius.circular(
              screenWidth * AppSizes().widgetSize.mediumBorderRadius),
        )),
        builder: (context) => ValueListenableBuilder(
            valueListenable: model.counterNotifier,
            builder: (context, current, child) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(
                      screenWidth * AppSizes().widgetSize.horizontalPadding),
                  children: [
                    Center(
                      child: Container(
                        height: 5,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding,
                        context: context),
                    Center(
                      child: TextView.normalText(
                          context: context,
                          text: AppStrings().newMessage,
                          textColor: AppColor.textColorBlack,
                          textSize: AppSizes().fontSize.normalFontSize),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              model.audioFileCompose = null;
                              model.isMsgRecordStartCompose = null;
                              model.hasVoiceMsgCompose = null;

                              model.counterNotifier.value++;
                              model.notifyListeners();

                              Navigator.pop(context);
                            },
                            child: TextView.normalText(
                                context: context,
                                text: "Close",
                                textColor: AppColor.textColorBlack,
                                textSize: AppSizes().fontSize.simpleFontSize),
                          ),
                          GestureDetector(
                              onTap: () => {
                                    if (model.audioFileCompose != null)
                                      {
                                        if (model.subjectController.text !=
                                                "" &&
                                            /* model.composeMessageController
                                                    .text !=
                                                "" &&*/
                                            model.dropDownValue != null)
                                          {
                                            if (GlobalUtility()
                                                .containsPhoneNumberOrEmail(
                                                    model.subjectController
                                                        .text))
                                              {
                                                GlobalUtility.showToast(context,
                                                    "Sharing contact details are restricted")
                                              }
                                            else
                                              {
                                                if (GlobalUtility()
                                                    .containsPhoneNumberOrEmail(
                                                        model
                                                            .composeMessageController
                                                            .text))
                                                  {
                                                    GlobalUtility.showToast(
                                                        context,
                                                        "Sharing contact details are restricted")
                                                  }
                                                else
                                                  {
                                                    model.counterNotifier
                                                        .value++,
                                                    model.sendComposedMessage(
                                                      context,
                                                    ),
                                                    /*GlobalUtility.showToast(
                                                        context,
                                                        "Api calling 2")*/
                                                  }
                                              }
                                          }
                                        else
                                          {
                                            if (model.dropDownValue == null)
                                              {
                                                GlobalUtility.showToast(
                                                    context, "To required")
                                              }
                                            else if (model
                                                    .subjectController.text ==
                                                "")
                                              {
                                                GlobalUtility.showToast(
                                                    context, "Subject Required")
                                              }
                                            else
                                              {
                                                GlobalUtility.showToast(context,
                                                    "Compose message Required")
                                              }
                                          }
                                      }
                                    else
                                      {
                                        if (model.subjectController.text !=
                                                "" &&
                                            model.composeMessageController
                                                    .text !=
                                                "" &&
                                            model.dropDownValue != null)
                                          {
                                            if (GlobalUtility()
                                                .containsPhoneNumberOrEmail(
                                                    model.subjectController
                                                        .text))
                                              {
                                                GlobalUtility.showToast(context,
                                                    "Sharing contact details are restricted")
                                              }
                                            else
                                              {
                                                if (GlobalUtility()
                                                    .containsPhoneNumberOrEmail(
                                                        model
                                                            .composeMessageController
                                                            .text))
                                                  {
                                                    GlobalUtility.showToast(
                                                        context,
                                                        "Sharing contact details are restricted")
                                                  }
                                                else
                                                  {
                                                    model.counterNotifier
                                                        .value++,
                                                    model.sendComposedMessage(
                                                        context),
                                                    /*  GlobalUtility.showToast(
                                                        context, "Api calling ")*/
                                                  }
                                              }
                                          }
                                        else
                                          {
                                            if (model.dropDownValue == null)
                                              {
                                                GlobalUtility.showToast(
                                                    context, "To required")
                                              }
                                            else if (model.subjectController.text ==
                                                "")
                                              {
                                                GlobalUtility.showToast(
                                                    context, "Subject Required")
                                              }
                                            else if (model
                                                    .composeMessageController
                                                    .text ==
                                                "")
                                              {
                                                GlobalUtility.showToast(context,
                                                    "Compose message Required")
                                              }
                                            else
                                              {
                                                GlobalUtility.showToast(
                                                    context, "To Required")
                                              }
                                          }
                                      }
                                  },
                              child: TextView.normalText(
                                  context: context,
                                  text: AppStrings().send,
                                  textColor: AppColor.appthemeColor,
                                  textSize:
                                      AppSizes().fontSize.simpleFontSize)),
                        ],
                      ),
                    ),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding,
                        context: context),
                    Container(
                      height: 1,
                      width: screenWidth,
                      color: AppColor.disableColor,
                    ),
                    composeMessagesFields(model)
                  ],
                ),
              );
              // }
            }));
  }

  Widget composeMessagesFields(TravellerMessageModel model) {
    debugPrint(
        "composeMessagesFields VALEUEE  isMsgRecordStartCompose=${model.isMsgRecordStartCompose}  hasVoiceMsgCompose=${model.hasVoiceMsgCompose} ");
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        SizedBox(
          height: screenHeight * AppSizes().widgetSize.mediumbuttonHeight,
          child: widget.from != "message_guide"
              ? DropdownButton<String>(
                  isExpanded: true,
                  value: model.dropDownValue, //selected
                  icon: CommonImageView.largeSvgImageView(
                      imagePath: AppImages().svgImages.arrowDown),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: AppColor.completedStatusColor),
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    model.dropDownValue = newValue;
                    model.counterNotifier.value++;
                    model.notifyListeners();
                  },
                  hint: Text("To",
                      style: TextStyle(
                          color: AppColor.lightBlack,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: screenHeight *
                              AppSizes().fontSize.simpleFontSize)),
                  items: model.userList!
                      .map<DropdownMenuItem<String>>((Datum value) {
                    return DropdownMenuItem<String>(
                      value: value.participantId.toString(),
                      child: Text(
                        value.name,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                )
              : widget.from != "chat_with_guide"
                  ? DropdownButton<String>(
                      isExpanded: true,
                      value: model.dropDownValue, //selected
                      icon: CommonImageView.largeSvgImageView(
                          imagePath: AppImages().svgImages.arrowDown),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: AppColor.completedStatusColor),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        model.dropDownValue = newValue;
                        model.counterNotifier.value++;
                        model.notifyListeners();
                      },
                      hint: Text("To",
                          style: TextStyle(
                              color: AppColor.lightBlack,
                              fontFamily: AppFonts.nunitoRegular,
                              fontSize: screenHeight *
                                  AppSizes().fontSize.simpleFontSize)),
                      items: model.userList!
                          .map<DropdownMenuItem<String>>((Datum value) {
                        return DropdownMenuItem<String>(
                          value: value.participantId.toString(),
                          child: Text(
                            value.name,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    )
                  : SizedBox(
                      width: screenWidth,
                      height: screenHeight * 0.06,
                      child: TextField(
                        controller: guideSendMessageTEC,
                        readOnly: true,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
        ),
        Divider(
          color: AppColor.hintTextColor,
        ),

        SizedBox(
          height: screenHeight * AppSizes().widgetSize.textFieldheight,
          child: TextFormField(
            onChanged: (value) {
              onChangeTextField(model);
            },
            controller: model.subjectController,
            textAlignVertical: TextAlignVertical.center,
            maxLines: 2,
            minLines: 1,
            textAlign: TextAlign.start,
            maxLength: 120,
            style: TextStyle(
                color: AppColor.lightBlack,
                fontFamily: AppFonts.nunitoRegular,
                fontSize: screenHeight * AppSizes().fontSize.simpleFontSize),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              counterText: "",
              hintText: 'Subject',
              hintStyle: TextStyle(
                  color: AppColor.hintTextColor,
                  fontFamily: AppFonts.nunitoRegular,
                  fontSize: MediaQuery.of(context).size.height *
                      AppSizes().fontSize.simpleFontSize),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.textfieldborderColor)),
            ),
          ),
        ),

        // compose field
        SizedBox(
          //    height: screenHeight * AppSizes().widgetSize.largeBorderRadius,
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /* (model.isMsgRecordStartCompose != false ||
                          model.hasVoiceMsgCompose != null) ||
                      model.audioFileCompose != null*/

              (model.isMsgRecordStartCompose == true ||
                      model.audioFileCompose != null)
                  ? Center(child: voiceFileView(model))
                  : SizedBox(
                      height: screenHeight *
                          AppSizes().widgetSize.largeBorderRadius,
                      width: screenWidth * 0.7,
                      child: TextFormField(
                        onChanged: (value) {
                          onChangeTextField(model);
                        },
                        minLines: 1,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        controller: model.composeMessageController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppColor.lightBlack,
                            fontFamily: AppFonts.nunitoRegular,
                            fontSize: screenHeight *
                                AppSizes().fontSize.simpleFontSize),
                        decoration: InputDecoration(
                            hintText: 'Compose message',
                            hintStyle: TextStyle(
                                color: AppColor.hintTextColor,
                                fontFamily: AppFonts.nunitoRegular,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppSizes().fontSize.simpleFontSize),
                            border: InputBorder.none),
                      ),
                    ),
              voiceRecorderStartButton(model)
            ],
          ),
        )
      ],
    );
  }

  // RECORD ---
  voiceRecorderStartButton(TravellerMessageModel model) {
    return Bounceable(
        curve: Curves.bounceInOut,
        reverseCurve: Curves.easeInCubic,
        scaleFactor: 0.7,
        onTap: () {
          model.isMsgRecordStartCompose == null
              ? recordVoice(model)
              : model.isMsgRecordStartCompose == true
                  ? stopVoice(model)
                  : debugPrint("FALSE ---- ");

          debugPrint(
              "changed model.isMsgRecordStartCompose=${model.isMsgRecordStartCompose}  isAudioFileCompose=${model.audioFileCompose != null}");
        },
        child: Container(
          width: model.isMsgRecordStartCompose == null ||
                  model.isMsgRecordStartCompose == true
              ? 35
              : 0,
          height: 35,
          margin: const EdgeInsets.only(right: 5, top: 5),
          decoration: BoxDecoration(
              border: Border.all(
                  color: model.isMsgRecordStartCompose == null ||
                          model.isMsgRecordStartCompose == true
                      ? AppColor.blackColor
                      : Colors.transparent),
              shape: BoxShape.circle),
          child: model.isMsgRecordStartCompose == null
              ? const Icon(Icons.keyboard_voice)
              : model.isMsgRecordStartCompose == true
                  ? const Icon(Icons.stop)
                  : const SizedBox(),
        ));
  }

  voiceFileView(TravellerMessageModel model) {
    debugPrint(
        "STart Value --- ${model.isMsgRecordStartCompose} -- ${model.hasVoiceMsgCompose}");
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: screenHeight * 0.015),
      height: screenHeight * 0.1,
      width: model.isMsgRecordStartCompose == null ||
              model.isMsgRecordStartCompose == true
          ? screenWidth * 0.7
          : screenWidth * 0.75,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      decoration: BoxDecoration(
          color: AppColor.fieldBorderColor,
          borderRadius: BorderRadius.circular(40)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cancelMsgButton(model),
          SizedBox(
            width: screenWidth * 0.04,
          ),
          /* model.isMsgRecordStartCompose != false ||
                  model.hasVoiceMsgCompose != true*/
          model.audioFileCompose == null

              /* isMsgRecordStart != false || hasVoiceMsg != true*/

              ? BlinkText(
                  'Recording...',
                  style: TextStyle(
                      color: AppColor.appthemeColor,
                      fontFamily: AppFonts.nunitoSemiBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppSizes().fontSize.normalFontSize),
                  endColor: AppColor.fieldEnableColor,
                )
              : currentAudioPlayer(model.audioFileCompose!.path.toString())
        ],
      ),
    );
  }

  Widget cancelMsgButton(TravellerMessageModel model) {
    return Bounceable(
        curve: Curves.bounceInOut,
        reverseCurve: Curves.easeInCubic,
        scaleFactor: 0.7,
        onTap: () async {
          debugPrint(
              "VALEUEE--- ${model.isMsgRecordStartCompose} === ${model.hasVoiceMsgCompose} ====");

          await initRecord(model);
          model.audioFileCompose = null;
          model.audioFile = null;
          model.isMsgRecordStartCompose = null;
          model.hasVoiceMsgCompose = null;
          model.counterNotifier.value++;
          model.notifyListeners();
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.textbuttonColor),
              shape: BoxShape.circle),
          child: Icon(
            Icons.clear,
            color: AppColor.textbuttonColor,
          ),
        ));
  }

  /// RECORD
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  initRecord(TravellerMessageModel model) async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/siesta_voice_note_';
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();
/*        _recorder =
            AnotherAudioRecorder(customPath, audioFormat: AudioFormat.AAC);*/
        _recorder = AnotherAudioRecorder(customPath + ".wav",
            audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;

        var current = await _recorder?.current(channel: 0);
        _current = current;
        _currentStatus = current!.status!;
        model.isMsgRecordStartCompose = null;

        debugPrint("_currentStatus -- $_currentStatus");
      } else {
        return const SnackBar(content: Text("You must accept permissions"));
      }
    } catch (e) {
      debugPrint("exc-- $e");
    }
  }

  recordVoice(TravellerMessageModel model) async {
    try {
      await _recorder?.start();
      model.isMsgRecordStartCompose = true;
      var recording = await _recorder?.current(channel: 0);
      _current = recording;
      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        var current = await _recorder?.current(channel: 0);
        _current = current;
        _currentStatus = _current!.status!;
      });
      model.counterNotifier.value++;
      model.notifyListeners();
    } catch (e) {
      debugPrint("exc-- $e");
    }
  }

  stopVoice(TravellerMessageModel model) async {
    var result = await _recorder?.stop();
    localFileSystem = const LocalFileSystem();
    File file = localFileSystem!.file(result?.path);
    _current = result;
    _currentStatus = _current!.status!;
    model.isMsgRecordStartCompose = false;
    model.audioFileCompose = file;
    model.counterNotifier.value++;

    model.notifyListeners();
  }

  /// PLAYER
  Widget currentAudioPlayer(String path) {
    final player = AudioPlayer();
    Source source = DeviceFileSource(path);

    player.setSource(source);
    ValueNotifier<bool> isAudioPlaying = ValueNotifier<bool>(false);
    ValueNotifier<Duration> _duration =
        ValueNotifier<Duration>(const Duration());
    ValueNotifier<Duration> position =
        ValueNotifier<Duration>(const Duration());
    ValueNotifier<double> progressValue = ValueNotifier<double>(0);

    player.onPlayerStateChanged.listen((PlayerState state) {
      isAudioPlaying.value = (state == PlayerState.playing);
    });

    player.onDurationChanged.listen((Duration duration) {
      _duration.value = duration;
      debugPrint("Audio Duration: $_duration");
    });

    player.onPositionChanged.listen((Duration newPosition) {
      position.value = newPosition;

      double proTempVal =
          position.value.inMilliseconds / _duration.value.inMilliseconds;
      if (proTempVal.isNaN) {
        debugPrint("messagePage Audio Position Not a number: $proTempVal");
      } else {
        progressValue.value = proTempVal;
        debugPrint("messagePage Audio Position is a number: $proTempVal");
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder(
            valueListenable: progressValue,
            builder: (context, value, child) {
              return SizedBox(
                  width: screenWidth * 0.4,
                  child: Column(
                    children: [
                      Slider(
                        value: progressValue.value,
                        onChanged: (value) {
                          player.seek(calculatePercentageDuration(
                              value, _duration.value));
                          if (value.isNaN) {
                            debugPrint("value is not a number1: $value");
                          } else {
                            debugPrint("value is a number1: $value");

                            progressValue.value = value;
                          }
                        },
                        activeColor: AppColor.appthemeColor,
                        inactiveColor: Colors.grey,
                      ),
                      Transform.translate(
                          offset: const Offset(0, -10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                durationToString(position.value),
                                textAlign: TextAlign.end,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: _duration,
                                  builder: (context, value, child) {
                                    String totalDuration =
                                        "${_duration.value.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_duration.value.inSeconds.remainder(60).toString().padLeft(2, '0')}";
                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        totalDuration,
                                        textAlign: TextAlign.end,
                                      ),
                                    );
                                  }),
                            ],
                          ))
                    ],
                  ));
            }),
        ValueListenableBuilder(
          valueListenable: isAudioPlaying,
          builder: (context, value, child) {
            return IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  if (value == false) {
                    try {
                      await player.play(source);
                    } catch (e) {
                      debugPrint("Plyer Issue-- $e");
                    }
                  } else {
                    await player.pause();
                  }
                },
                icon: Icon(value == true ? Icons.pause : Icons.play_arrow));
          },
        ),
      ],
    );
  }

  String durationToString(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Duration calculatePercentageDuration(
      double percentage, Duration totalDuration) {
    if (percentage < 0 ||
        percentage > 1 ||
        totalDuration == null ||
        totalDuration <= Duration.zero) {
      return Duration.zero;
    }

    int totalInSeconds = totalDuration.inSeconds;
    int percentageInSeconds = (totalInSeconds * percentage).round();

    return Duration(seconds: percentageInSeconds);
  }

  onChangeTextField(model) {
    if (model.subjectController != "" &&
        model.composeMessageController != "") {}
  }
}
