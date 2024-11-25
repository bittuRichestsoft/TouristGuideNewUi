import 'dart:convert';
import 'dart:io';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/response_pojo/travellerMessagePojo.dart';
import 'package:Siesta/response_pojo/inboxUserListPojo.dart';
import 'package:Siesta/response_pojo/getMessageThreadPojo.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import '../api_requests/travellerMessageRequest.dart';
import '../app_constants/app_strings.dart';
import '../view/all_dialogs/api_success_dialog.dart';

class TravellerMessageModel extends BaseViewModel implements Initialisable {
  TravellerMessageModel(ctx, thread) {
    if (thread != null) {
      getmessages(ctx, pageNo, thread);
      isMsgRecordStartCompose = false;
      hasVoiceMsgCompose = false;
    }
  }
  final TravellerMessageRequest _travellerMessageRequest =
      TravellerMessageRequest();
  BuildContext? viewContext;
  TextEditingController searchController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController composeMessageController = TextEditingController();
  TextEditingController replyMessageController = TextEditingController();
  TravellerMessageUserResponse? travellerMessageUserResponse;
  InboxUserListResponse? inboxUserListResponse;
  GetMessagesResponse? getMessagesResponse;
  List<TextEditingController> messageController = [];

  List<Datum>? userList = [];
  List<Message>? messageList = [];
  List<InboxMessage> inboxUserList = [];

  int pageNo = 1;
  int lastPage = 1;
  String? dropDownValue;
  String? dropDownValueInbox = 'Inbox';
  dynamic counterNotifier = ValueNotifier<int>(0);
  String inboxType = "1";
  String? thread_id;
  bool isEmtyViewShow = false;
  bool isSearchRunnig = false;
  String username = "";
  String profileImage = "";
  String userId = "";
  File? audioFile;
  File? audioFileCompose;
  List<String>? audioUrlManagerList = [];
  bool? isMsgRecordStartCompose;
  bool? hasVoiceMsgCompose;
  ValueNotifier<bool> msgUrlNotifier = ValueNotifier(false);

  @override
  void dispose() {
    audioFile = null;
    audioFileCompose = null;
    isMsgRecordStartCompose = null;
    hasVoiceMsgCompose = null;

    super.dispose();
  }

  @override
  void initialise() async {
    _asyncMethod();
    requestPermission();
    getEligibleForMessageUserList(viewContext, pageNo);
    getInboxUserList(viewContext, pageNo, inboxType, "");
  }

  Future<void> requestPermission() async {
    var statusMicrophone = await Permission.microphone.request();
    debugPrint("Microphone permission status: $statusMicrophone");

    var statusStorage = await Permission.storage.request();
    debugPrint("Storage permission status: $statusStorage");

    if (statusMicrophone.isGranted) {
      debugPrint("Microphone permission granted");
    } else {
      debugPrint("Microphone permission denied");
    }

    if (statusStorage.isGranted) {
      debugPrint("Storage permission granted");
    } else {
      debugPrint("Storage permission denied");
    }
  }

  _asyncMethod() async {
    String val1 = await PreferenceUtil().getId();
    String val2 = await PreferenceUtil().getFirstName();
    String val3 = await PreferenceUtil().getProgileImage();

    username = val2;
    profileImage = val3;
    userId = val1;
    notifyListeners();
  }

  Future<void> pullRefresh() async {
    debugPrint("_pullRefresh_pullRefresh");
    inboxUserList = [];
    getInboxUserList(viewContext, 1, inboxType, "");
  }

  void getEligibleForMessageUserList(viewContext, int pageNo) async {
    if (pageNo <= lastPage) {
      setBusy(true);
      notifyListeners();
      if (await GlobalUtility.isConnected()) {
        Response apiResponse =
            await _travellerMessageRequest.eligibleMessageUser(
                pageNo: pageNo.toString(), number_of_rows: "10");

        debugPrint("EligibleForMessage response ---- ${apiResponse.body}");

        Map jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];

        if (status == 200) {
          setBusy(false);
          notifyListeners();
          travellerMessageUserResponse =
              travellerMessageUserResponseFromJson(apiResponse.body);
          userList = travellerMessageUserResponse!.data;
        } else if (status == 400) {
          setBusy(false);
          notifyListeners();
        } else if (status == 401) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
          GlobalUtility().handleSessionExpire(viewContext);
        }
      } else {
        GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
      }
    }
  }

  void getInboxUserList(
      viewContext, int pageNo, String inboxType, search_text) async {
    if (pageNo <= lastPage) {
      setBusy(true);
      isEmtyViewShow = false;
      if (search_text != "") {
        isSearchRunnig = true;
      }
      notifyListeners();
      if (await GlobalUtility.isConnected()) {
        Response apiResponse = await _travellerMessageRequest.inboxUser(
            pageNo: pageNo.toString(),
            number_of_rows: "10",
            inboxType: inboxType,
            search_text: search_text);
        Map jsonData = jsonDecode(apiResponse.body);
        debugPrint("API RESPONSE FOR GET INBOX LIST --- ${apiResponse.body}");
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        isSearchRunnig = false;
        notifyListeners();
        if (status == 200) {
          setBusy(false);
          notifyListeners();
          inboxUserListResponse =
              inboxUserListResponseFromJson(apiResponse.body);
          if (inboxUserListResponse!.data!.rows!.isNotEmpty) {
            isEmtyViewShow = false;
            notifyListeners();
            if (pageNo == 1) {
              lastPage = (inboxUserListResponse!.data!.counts! / 10).round();
              lastPage = lastPage + 1;
              inboxUserList = [];
              inboxUserList = inboxUserListResponse!.data!.rows!;
            } else {
              inboxUserList = [
                ...inboxUserList,
                ...inboxUserListResponse!.data!.rows!
              ];
            }
          } else {
            if (inboxUserListResponse!.data!.counts == 0) {
              isEmtyViewShow = true;
              inboxUserList = [];
              notifyListeners();
            }
          }
        } else if (status == 400) {
          setBusy(false);
          isEmtyViewShow = false;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 401) {
          setBusy(false);
          isEmtyViewShow = false;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
          GlobalUtility().handleSessionExpire(viewContext);
        }
      } else {
        GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
      }
    }
  }

  void getmessages(viewContext, int pageNo, thread_id) async {
    if (pageNo <= lastPage) {
      setBusy(true);
      notifyListeners();
      if (await GlobalUtility.isConnected()) {
        Response apiResponse = await _travellerMessageRequest.messageThread(
            pageNo: pageNo.toString(),
            number_of_rows: "10",
            threadId: thread_id.toString());
        debugPrint("GET REPLY MESSAGE RESPONSE ----  ${apiResponse.body}");
        Map jsonData = jsonDecode(apiResponse.body);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        if (status == 200) {
          setBusy(false);
          notifyListeners();
          getMessagesResponse = getMessagesResponseFromJson(apiResponse.body);
          notifyListeners();
          if (pageNo == 1) {
            audioUrlManagerList!.clear();
            lastPage =
                (getMessagesResponse!.data!.totalMessageCount! / 10).round();
            lastPage = lastPage + 1;
            messageList = [];
            messageController = [];
            messageList = getMessagesResponse!.data!.messages;
            for (int i = 0; i < messageList!.length; i++) {
              getMessagesResponse!.data!.messages![i].messageType == 0
                  ? messageController.add(
                      TextEditingController(text: messageList![i].messageText))
                  : audioUrlManagerList!
                      .add(messageList![i].messageText.toString());
            }
          } else {
            messageList = [
              ...messageList!,
              ...getMessagesResponse!.data!.messages!
            ];
            messageController = [];
            for (int i = 0; i < messageList!.length; i++) {
              messageController.add(
                  TextEditingController(text: messageList![i].messageText));
              getMessagesResponse!.data!.messages![i].messageType == 0
                  ? messageController.add(
                      TextEditingController(text: messageList![i].messageText))
                  : audioUrlManagerList!
                      .add(messageList![i].messageText.toString());
            }
          }
        } else if (status == 400) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 401) {
          setBusy(false);
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
          GlobalUtility().handleSessionExpire(viewContext);
        }
      } else {
        GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
      }
    }
  }

  void sendComposedMessage(viewContext) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoader(viewContext);
      if ((audioFileCompose != null && audioFileCompose!.path.isNotEmpty) ||
          audioFileCompose != null) {
        composeMessageController.clear();
      }

      StreamedResponse apiResponse =
          await _travellerMessageRequest.sendComposedMessage(
              context: viewContext,
              receiver_user_id: (dropDownValue).toString(),
              subject: subjectController.text,
              message_text: composeMessageController.text,
              audioFile: audioFileCompose);

      apiResponse.stream.transform(utf8.decoder).listen((value) {
        debugPrint("VOICE MESSAGE API RESPONSE :-- $value");

        Map jsonData = jsonDecode(value);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        Map checkData = jsonData['data'];
        Navigator.pop(viewContext);
        if (status == 200 && checkData.isEmpty == false) {
          Navigator.pop(viewContext);
          GlobalUtility.showToast(viewContext, message);
          isMsgRecordStartCompose = null;
          hasVoiceMsgCompose = null;

          if (audioFileCompose != null) {
            audioFileCompose = null;
          }
          counterNotifier.value++;
          counterNotifier.notifyListeners();
          notifyListeners();
        } else if (status == 400) {
          setBusy(false);
          counterNotifier.value++;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 401) {
          setBusy(false);
          counterNotifier.value++;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
          GlobalUtility().handleSessionExpire(viewContext);
        } else if (status == 200 && checkData.isEmpty == true) {
          setBusy(false);
          Navigator.pop(viewContext);
          isMsgRecordStartCompose = null;
          hasVoiceMsgCompose = null;

          if (audioFileCompose != null) {
            audioFileCompose = null;
          }
          counterNotifier.value++;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        }
      });
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void sendReplyMessage(viewContext, threadId) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoader(viewContext);

      Response apiResponse = await _travellerMessageRequest.sendReply(
          context: viewContext,
          thread_id: threadId,
          message_text: replyMessageController.text);
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      Map checkData = jsonData['data'];
      if (status == 200 && checkData.isEmpty == false) {
        getInboxUserList(viewContext, 1, "1", "");
        GlobalUtility().closeLoader(viewContext);
        Navigator.pop(viewContext);
        replyMessageController.text = "";
        getmessages(viewContext, 1, threadId);
        notifyListeners();
        counterNotifier.value++;
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 400) {
        GlobalUtility().closeLoader(viewContext);

        counterNotifier.value++;
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        GlobalUtility().closeLoader(viewContext);

        counterNotifier.value++;
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      } else if (status == 200 && checkData.isEmpty == true) {
        GlobalUtility().closeLoader(viewContext);

        replyMessageController.text = "";
        getmessages(viewContext, 1, threadId);
        Navigator.pop(viewContext);
        counterNotifier.value++;
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void sendReplyVoiceMessage(viewContext, threadId) async {
    if (await GlobalUtility.isConnected()) {
      GlobalUtility().showLoader(viewContext);
      final apiResponse = await _travellerMessageRequest.sendVoiceReply(
          context: viewContext,
          audioFile: audioFile,
          thread_id: threadId.toString());

      GlobalUtility().closeLoader(viewContext);

      apiResponse.stream.transform(utf8.decoder).listen((value) {
        debugPrint("REPLAY VOICE MESSAGE API RESPONSE :-- $value");
        Map jsonData = jsonDecode(value);
        var status = jsonData['statusCode'];
        var message = jsonData['message'];
        Map checkData = jsonData['data'];
        if (status == 200 && checkData.isEmpty == false) {
          getInboxUserList(viewContext, 1, "1", "");
          setBusy(false);
          Navigator.pop(viewContext);
          replyMessageController.text = "";
          audioFile = null;
          audioFileCompose = null;

          getmessages(viewContext, 1, threadId);
          notifyListeners();
          counterNotifier.value++;
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 400) {
          setBusy(false);
          counterNotifier.value++;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        } else if (status == 401) {
          setBusy(false);
          counterNotifier.value++;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
          GlobalUtility().handleSessionExpire(viewContext);
        } else if (status == 200 && checkData.isEmpty == true) {
          setBusy(false);
          replyMessageController.text = "";
          getmessages(viewContext, 1, threadId);
          Navigator.pop(viewContext);
          counterNotifier.value++;
          notifyListeners();
          GlobalUtility.showToast(viewContext, message);
        }
      });
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  void deleteComposeMessage(viewContext, threadIds) async {
    setBusy(true);
    notifyListeners();
    if (await GlobalUtility.isConnected()) {
      Response apiResponse = await _travellerMessageRequest.deleteMessage(
        context: viewContext,
        thread_ids: threadIds,
      );
      debugPrint('deleteComposeMessage${apiResponse.body}');
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (status == 200) {
        setBusy(false);
        if (dropDownValueInbox == 'Inbox') {
          getInboxUserList(viewContext, 1, '1', "");
        } else {
          getInboxUserList(viewContext, 1, "2", "");
        }
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 400) {
        setBusy(false);
        counterNotifier.value++;
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
      } else if (status == 401) {
        setBusy(false);
        counterNotifier.value++;
        notifyListeners();
        GlobalUtility.showToast(viewContext, message);
        GlobalUtility().handleSessionExpire(viewContext);
      }
    } else {
      GlobalUtility.showToast(viewContext, AppStrings().INTERNET);
    }
  }

  successDialog(String from, BuildContext context, String message) {
    GlobalUtility.showDialogFunction(
        context,
        ApiSuccessDialog(
            imagepath: AppImages().pngImages.ivRegisterVerified,
            titletext: message,
            buttonheading: AppStrings().Okay,
            isPng: true,
            fromWhere: from));
  }
}
