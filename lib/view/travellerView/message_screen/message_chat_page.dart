// ignore_for_file: prefer_is_empty, must_be_immutable, non_constant_identifier_names, depend_on_referenced_packages, unrelated_type_equality_checks

import 'dart:async';
import 'dart:io';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/view_models/travellerMessageModel.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import '../../../utility/globalUtility.dart';
import 'package:file/local.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'dart:io' as io;

class MessageChatScreen extends StatefulWidget {
  MessageChatScreen(
      {Key? key, Object? threadId, LocalFileSystem? localFileSystem})
      : super(key: key) {
    localFileSystem = const LocalFileSystem();
    Map map = threadId as Map;
    thread_Id = map["threadId"];
  }
  LocalFileSystem? localFileSystem;

  String? thread_Id;
  @override
  State<MessageChatScreen> createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  ScrollController scrollController = ScrollController();
  int pageCount = 1;

  bool? isMsgRecordStart;
  bool? hasVoiceMsg;

  Duration _duration = const Duration();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    initRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<TravellerMessageModel>.reactive(
        viewModelBuilder: () =>
            TravellerMessageModel(context, widget.thread_Id),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (!model.isBusy) {
                pageCount = pageCount + 1;
                model.getmessages(context, pageCount, widget.thread_Id);
              }
            } else {}
          });
          return Scaffold(
              backgroundColor: AppColor.whiteColor,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: AppColor.appthemeColor),
                centerTitle: true,
                backgroundColor: AppColor.appthemeColor,
                elevation: 0,
                title: TextView.headingWhiteText(
                    context: context, text: AppStrings().messages),
                leading: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppColor.whiteColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              body: Stack(
                children: [
                  model.isBusy == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: AppColor.appthemeColor),
                        )
                      : messageView(model),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: screenHeight * 0.04,
                            right: screenHeight * 0.02),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth *
                                      AppSizes().widgetSize.horizontalPadding,
                                  vertical: screenHeight *
                                      AppSizes().widgetSize.mediumPadding),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.center,
                              backgroundColor: AppColor.whiteColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth *
                                          AppSizes()
                                              .widgetSize
                                              .largeBorderRadius)))),
                          onPressed: () async {
                            await initRecord();
                            isMsgRecordStart = null;
                            hasVoiceMsg = null;
                            model.audioFile = null;
                            model.audioFileCompose = null;
                            model.counterNotifier.value++;
                            model.notifyListeners();

                            writeMsgBottomSheet(model);
                            /*  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TestAudio(widget.thread_Id!)));*/
                          },
                          icon: Icon(
                            Icons.undo,
                            color: AppColor.appthemeColor,
                          ),
                          label: TextView.normalText(
                              text: "Reply",
                              context: context,
                              fontFamily: AppFonts.nunitoSemiBold,
                              textSize: AppSizes().fontSize.normalFontSize,
                              textColor: AppColor.appthemeColor),
                        )),
                  )
                ],
              ));
        });
  }

  Widget messageView(TravellerMessageModel model) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.1),
      child: ListView.builder(
          key: _listKey,
          itemCount: model.messageList?.length,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.03, horizontal: screenWidth * 0.05),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    model.userId.toString() !=
                            model.messageList![index].senderUserId.toString()
                        ? profileImage(model.getMessagesResponse != null &&
                                model.getMessagesResponse!.data!
                                        .receiverMessageDetails!.userDetail !=
                                    null
                            ? model
                                .getMessagesResponse!
                                .data!
                                .receiverMessageDetails!
                                .userDetail!
                                .profilePicture
                            : "")
                        : profileImage(model.profileImage),
                    Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.5,
                                  child: Text(
                                    model.userId.toString() !=
                                            model.messageList![index]
                                                .senderUserId
                                                .toString()
                                        ? model.getMessagesResponse != null
                                            ? model.getMessagesResponse!.data!
                                                .receiverMessageDetails!.name!
                                            : ""
                                        : model.username,
                                    style: TextStyle(
                                      fontSize: screenHeight *
                                          AppSizes().fontSize.simpleFontSize,
                                      color: AppColor.blackColor,
                                      fontFamily: AppFonts.nunitoBold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "  ${model.getMessagesResponse != null ? Jiffy.parse(model.messageList![index].createdAt.toString()).yMMMd : ""}",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: screenHeight *
                                        AppSizes().fontSize.mediumFontSize,
                                    color: AppColor.dontHaveTextColor,
                                    fontFamily: AppFonts.nunitoRegular,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.7,
                              child: Text(
                                "To :- ${model.userId.toString() != model.messageList![index].receiverUserId.toString() ? model.getMessagesResponse != null ? model.getMessagesResponse!.data!.receiverMessageDetails!.name : "" : model.username}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 2,
                                  fontSize: screenHeight *
                                      AppSizes().fontSize.mediumFontSize,
                                  color: AppColor.dontHaveTextColor,
                                  fontFamily: AppFonts.nunitoRegular,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                model.messageList![index].messageType == 0
                    ? Padding(
                        padding:
                            EdgeInsets.only(top: screenHeight * 0.01, left: 5),
                        child: Text(
                          model.messageList!.length > 0
                              ? model.messageList![index].messageText!
                              : "",
                          style: TextStyle(
                              fontSize: screenHeight *
                                  AppSizes().fontSize.simpleFontSize,
                              fontFamily: AppFonts.nunitoLight,
                              color: AppColor.dontHaveTextColor,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.only(top: screenHeight * 0.01, left: 5),
                        child: voiceMsgView(model,
                            model.messageList![index].messageText!, index)),
                Divider(
                  color: AppColor.disableColor.withOpacity(0.3),
                ),
              ],
            );
          }),
    );
  }

  //image view
  Widget profileImage(img) {
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

  void writeMsgBottomSheet(TravellerMessageModel model) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  children: [
                    Center(
                      child: TextView.headingTextWithAlign(
                          context: context,
                          text: "Reply",
                          alignmentTxt: TextAlign.center),
                    ),
                    UiSpacer.verticalSpace(
                        space: AppSizes().widgetSize.normalPadding,
                        context: context),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);

                                isMsgRecordStart = null;
                                hasVoiceMsg = null;
                                model.audioFile = null;
                                model.audioFileCompose = null;
                                model.counterNotifier.value++;
                                model.notifyListeners();
                              },
                              child: TextView.normalText(
                                  context: context,
                                  text: "Close",
                                  textColor: AppColor.textColorBlack,
                                  textSize:
                                      AppSizes().fontSize.simpleFontSize)),
                          GestureDetector(
                              onTap: () => {
                                    if (model.replyMessageController.text != "")
                                      {
                                        if (GlobalUtility()
                                            .containsPhoneNumberOrEmail(model
                                                .replyMessageController.text))
                                          {
                                            GlobalUtility.showToast(context,
                                                "Sharing contact details are restricted")
                                          }
                                        else if (GlobalUtility()
                                            .containsPhoneNumberOrEmail(model
                                                .replyMessageController.text))
                                          {
                                            GlobalUtility.showToast(context,
                                                "Sharing contact details are restricted and prohibited.")
                                          }
                                        else
                                          {
                                            model.sendReplyMessage(
                                                context, widget.thread_Id)
                                          }
                                      }
                                    else if (model.audioFile != null)
                                      {
                                        model.sendReplyVoiceMessage(
                                            context, widget.thread_Id)
                                      }
                                    else
                                      {
                                        GlobalUtility.showToast(context,
                                            "Send text or voice message.")
                                      }
                                  },
                              child: model.isBusy == false
                                  ? TextView.normalText(
                                      context: context,
                                      text: AppStrings().send,
                                      textColor: AppColor.appthemeColor,
                                      textSize:
                                          AppSizes().fontSize.simpleFontSize)
                                  : SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            color: AppColor.appthemeColor),
                                      ),
                                    )),
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
            }));
  }

  Widget composeMessagesFields(TravellerMessageModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        hasVoiceMsg == null && isMsgRecordStart == null
            ? SizedBox(
                height: screenHeight * AppSizes().widgetSize.largeBorderRadius,
                width: screenWidth * 0.7,
                child: TextFormField(
                  controller: model.replyMessageController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppColor.lightBlack,
                      fontFamily: AppFonts.nunitoRegular,
                      fontSize:
                          screenHeight * AppSizes().fontSize.simpleFontSize),
                  decoration: InputDecoration(
                      hintText: 'Type here ...',
                      hintStyle: TextStyle(
                          color: AppColor.hintTextColor,
                          fontFamily: AppFonts.nunitoRegular,
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.simpleFontSize),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero),
                ),
              )
            : voiceFileView(model),
        voiceRecorderStartButton(model)
      ],
    );
  }

  voiceRecorderStartButton(TravellerMessageModel model) {
    return Bounceable(
        curve: Curves.bounceInOut,
        reverseCurve: Curves.easeInCubic,
        scaleFactor: 0.7,
        onTap: () {
          isMsgRecordStart == null
              ? recordVoice(model)
              : isMsgRecordStart == true
                  ? stopVoice(model)
                  : debugPrint("FALSE ---- ");
        },
        child: Container(
          width: isMsgRecordStart == null || isMsgRecordStart == true ? 35 : 0,
          height: 35,
          margin: const EdgeInsets.only(right: 5, top: 5),
          decoration: BoxDecoration(
              border: Border.all(
                  color: isMsgRecordStart == null || isMsgRecordStart == true
                      ? AppColor.blackColor
                      : Colors.transparent),
              shape: BoxShape.circle),
          child: isMsgRecordStart == null
              ? const Icon(Icons.keyboard_voice)
              : isMsgRecordStart == true
                  ? const Icon(Icons.stop)
                  : const SizedBox(),
        ));
  }

  voiceFileView(TravellerMessageModel model) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: screenHeight * 0.015),
      height: screenHeight * 0.1,
      width: isMsgRecordStart == null || isMsgRecordStart == true
          ? screenWidth * 0.75
          : screenWidth * 0.85,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      decoration: BoxDecoration(
          color: AppColor.disableColor,
          borderRadius: BorderRadius.circular(40)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cancelMsgButton(model),
          isMsgRecordStart != false || hasVoiceMsg != true
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: BlinkText(
                    'Recording...',
                    style: TextStyle(
                        color: AppColor.appthemeColor,
                        fontFamily: AppFonts.nunitoSemiBold,
                        fontSize: MediaQuery.of(context).size.height *
                            AppSizes().fontSize.normalFontSize),
                    endColor: AppColor.fieldEnableColor,
                  ),
                )
              : currentAudioTile(model.audioFile!.path.toString(), "current")
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
          await initRecord();
          isMsgRecordStart = null;
          hasVoiceMsg = null;
          if (model.audioFile != null) {
            model.audioFile = null;
          }
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

  /// PLAYER FOR URL MSG -----
  Widget voiceMsgView(TravellerMessageModel model, String path, int index) {
    debugPrint(
        "voiceMsgView path=$path <> index=$index  <<>>   audioUrlManagerList![index]=${model.audioUrlManagerList! /*[index].toString()*/}");

    return ValueListenableBuilder(
        valueListenable: model.msgUrlNotifier,
        builder: (BuildContext context, value, Widget? child) {
          return Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.9,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            decoration: BoxDecoration(
                color: AppColor.fieldBorderColor,
                boxShadow: const [
                  BoxShadow(color: Colors.white, blurRadius: 2)
                ],
                borderRadius: BorderRadius.circular(40)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                model.audioUrlManagerList!.isNotEmpty
                    ? urlAudioTile(path)
                    : const SizedBox(),
                /* const Icon(Icons.volume_up_rounded)*/
              ],
            ),
          );
        });
  }

  /// RECORD VOICE MESSAGE -----
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  io.Directory? appDocDirectory;
  initRecord() async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/siesta_voice_note_';

        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        customPath = appDocDirectory!.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        _recorder =
            AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;

        var current = await _recorder?.current(channel: 0);

        _current = current;
        _currentStatus = current!.status!;
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
      isMsgRecordStart = true;
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

  resume(TravellerMessageModel model) async {
    await _recorder?.resume();

    model.counterNotifier.value++;
    model.notifyListeners();
  }

  pause(TravellerMessageModel model) async {
    await _recorder?.pause();
    model.counterNotifier.value++;
    model.notifyListeners();
  }

  stopVoice(TravellerMessageModel model) async {
    var result = await _recorder?.stop();
    widget.localFileSystem = const LocalFileSystem();
    File file = widget.localFileSystem!.file(result?.path);
    _current = result;
    _currentStatus = _current!.status!;
    hasVoiceMsg = true;
    isMsgRecordStart = false;

    model.audioFile = file;
    _duration = _current!.duration!;
    debugPrint(
        "MessageChatPage -- ${model.audioFile!.path} \n_duration --- $_duration");
    model.counterNotifier.value++;
    model.notifyListeners();
  }

  /// PLAYER CURRENT AUDIO
  Widget currentAudioTile(String path, String type) {
    final player = AudioPlayer();
    Source source =
        type == "current" ? DeviceFileSource(path) : UrlSource(path);
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
      progressValue.value =
          position.value.inMilliseconds / _duration.value.inMilliseconds;
      debugPrint("Audio Position: $progressValue");
    });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ValueListenableBuilder(
                valueListenable: progressValue,
                builder: (context, value, child) {
                  return SizedBox(
                      width: screenWidth * 0.55,
                      child: Column(
                        children: [
                          Slider(
                            value: progressValue.value,
                            onChanged: (value) {
                              player.seek(calculatePercentageDuration(
                                  value, _duration.value));
                              if (value.isNaN) {
                                debugPrint(
                                    "MessageChatPage value is not a number: $value");
                              } else {
                                debugPrint(
                                    "MessageChatPage value is a number1: $value");

                                progressValue.value = value;
                              }
                            },
                            activeColor: AppColor.appthemeColor,
                            inactiveColor: Colors.grey,
                          ),
                          /*Transform.translate(
                              offset: const Offset(0, -10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    durationToString(position.value),
                                    textAlign: TextAlign.end,
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: _duration,
                                      builder: (context, value, child) {
                                        debugPrint(
                                            "Total--- ${_duration.value} == Position ${progressValue.value}");
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
                              ))*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                durationToString(position.value),
                                textAlign: TextAlign.end,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: _duration,
                                  builder: (context, value, child) {
                                    debugPrint(
                                        "749 Total--- ${_duration.value} == Position ${progressValue.value}");
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
                          )
                        ],
                      ));
                }),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: isAudioPlaying,
          builder: (context, value, child) {
            return IconButton(
                onPressed: () async {
                  if (value == false) {
                    try {
                      await player.play(source /*, isLocal: false*/);
                    } catch (e) {
                      /*  GlobalUtility.showToast(
                          context, "PlayAudio excep:- ${e.toString()}");*/
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

  Widget urlAudioTile(String path) {
    final player = AudioPlayer();
    Source? source;
    debugPrint("urlAudioTile path=$path");
    source = UrlSource(path);
    player.setSource(source);
    /* if (io.Platform.isAndroid) {
      source = UrlSource(path);
      player.setSource(source);
    }
    else if (io.Platform.isIOS) {
      var file = File(path);

      Uint8List bytes = file.readAsBytesSync();

      var buffer = bytes.buffer;

      var unit8 = buffer.asUint8List(32, bytes.lengthInBytes - 32);

      var tmpFile = "${appDocDirectory!.path}/tmp.mp3";
      var writeFile = File(tmpFile).writeAsBytesSync(unit8);
      source = DeviceFileSource(tmpFile);
      player.play(source);
    }
*/
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
        debugPrint("messageChatPage Audio Position Not a number: $proTempVal");
      } else {
        progressValue.value = proTempVal;
        debugPrint("messageChatPage Audio Position is a number: $proTempVal");
      }
    });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: isAudioPlaying,
          builder: (context, value, child) {
            return IconButton(
                onPressed: () async {
                  if (value == false) {
                    try {
                      await player.play(source!);
                    } catch (e) {
                      /* GlobalUtility.showToast(
                          context, "Msg list player excep:- ${e.toString()}");*/
                      debugPrint("Plyer Issue-- $e");
                    }
                  } else {
                    await player.pause();
                  }
                },
                icon: Icon(value == true ? Icons.pause : Icons.play_arrow));
          },
        ),
        ValueListenableBuilder(
            valueListenable: progressValue,
            builder: (context, value, child) {
              return SizedBox(
                  width: screenWidth * 0.55,
                  child: Column(
                    children: [
                      Slider(
                        value: progressValue.value,
                        onChanged: (value) {
                          player.seek(calculatePercentageDuration(
                              value, _duration.value));
                          if (value.isNaN) {
                            debugPrint(
                                "MessageChatPage value is not a number: $value");
                          } else {
                            debugPrint(
                                "MessageChatPage value is a number1: $value");

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
                                    debugPrint(
                                        "868 Total--- ${_duration} == Position ${progressValue.value}");
                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        durationToString(_duration.value),
                                        textAlign: TextAlign.end,
                                      ),
                                    );
                                  }),
                            ],
                          ))
                    ],
                  ));
            }),
      ],
    );
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

  String durationToString(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    isMsgRecordStart = null;
    hasVoiceMsg = null;
    if (_recorder != null) {
      _recorder!.stop();
    }
    super.dispose();
  }
}
