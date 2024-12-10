// ignore: duplicate_ignore
// ignore_for_file: prefer_typing_uninitialized_variables, avoid_types_as_parameter_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/app_service/router_service.dart' as router;
import 'package:Siesta/response_pojo/waiting_list_pojo.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:Siesta/utility/preference_util.dart';
import 'package:Siesta/view/signIn/login_page.dart';
import 'package:Siesta/view/touristGuideView/home/guide_home_page.dart';
import 'package:Siesta/view/travellerView/home/traveller_homepage.dart';
import 'package:Siesta/view/wait_list_screen.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_requests/auth.request.dart';
import 'app_constants/app_strings.dart';

late SharedPreferences prefs;

void main() async {
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_live_51NfO9PBlvO0WTpWYWqjdukAI1W0Vt5RpM7V7BL8C2cw3kUKrLTd1hGpRogfEbHzVFR2F7jo4elmHJu3zEWRb8L9L007m6lCOQr";
  //TEST PAYMNET KEY
  /* Stripe.publishableKey =
      "pk_test_51MdtWnSADnr105tVIjklDqQsMWqcMnclJyVU9SeWBQoG2UZHIhbIYui2PyxWqcId4xFEr2YiLDnasNj9KDXVhyii00fcLPtWoM";
 */
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  await Stripe.instance.applySettings();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColor.appthemeColor,
  ));
  try {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      debugPrint("onMessage-- ${message?.data}");
      if (message != null) {
        checkNotification(message, "onMessage");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        setNavigationOnNotification(message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint("Error on main: $e");
  }
  prefs = await SharedPreferences.getInstance();

  debugPrint(
      "Access Token: ${prefs.getString(SharedPreferenceValues.token) ?? ""}");

  getTokenData();
}

var role;
var token;
var isTravellerProfileComplete;

getTokenData() async {
  role = await PreferenceUtil().getRoleName();
  token = await PreferenceUtil().getToken();
  isTravellerProfileComplete =
      await PreferenceUtil().getTravellerProfileStatus();

  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  var role;
  var token;

  @override
  void initState() {
    super.initState();

    _asyncMethod();
  }

  _asyncMethod() async {
    /* FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
              debugPrint(
                  'getInitial Message getInitialMessage getInitialMessage');
            },
          ),
        );*/

    if (await PreferenceUtil().getToken() != null) {
      String val2 = await PreferenceUtil().getToken();
      String val1 = await PreferenceUtil().getRoleName();
      String val3 = await PreferenceUtil().getEmail();
      String val4 = await PreferenceUtil().getId();

      setState(() {
        role = val1;
        token = val2;
        email = val3;
        id = val4;
      });
      debugPrint("ROLE => $role");
      if (token != null && role == "TRAVELLER") {
        waitingStatusApi();
      }
      debugPrint("USER WAITING LIST API ==>>  $email --- $id ---$token");
    }
  }

  String? email;
  String? id;
  bool? isWaitingS;

  void waitingStatusApi() async {
    if (await GlobalUtility.isConnected()) {
      Map map = {"id": id, "email": email};
      Response apiResponse = await AuthRequest().userWaitingStatusApi(map);
      debugPrint("USER WAITING LIST API ==>> ${apiResponse.body}");
      Map jsonData = jsonDecode(apiResponse.body);
      var status = jsonData['statusCode'];
      var message = jsonData['message'];
      if (status == 200) {
        WaitingStatusRes waitingStatusRes =
            waitingStatusResFromJson(apiResponse.body);
        bool status = waitingStatusRes.data!.waitingList!;
        isWaitingS = status;
        debugPrint("USER WAITING S==>> $status === $isWaitingS");

        PreferenceUtil().setWaitingStatus(status);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: token == null
          ? const LoginPage()
          : isWaitingS == null && role == 'TRAVELLER'
              ? Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : isWaitingS == true && role == 'TRAVELLER'
                  ? const WaitListScreen()
                  : role == 'GUIDE'
                      ? TouristGuideHomePage(
                          bottomTab: 0,
                          fromWhere: "",
                        )
                      : TravellerHomePage(bottomTab: 0),
      onGenerateRoute: router.generateRoute,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  debugPrint("checkNotification check Notification checkNotification");
  if (message != null) {
    cancelNotification(1);
    checkNotification(message, "background");
  }
  return;
}

cancelNotification(int notifiTypeId) async {
  final fln = FlutterLocalNotificationsPlugin();
  await fln.cancelAll();
}

setNavigationOnNotification(RemoteMessage message) async {
  if (message.data["typeMode"] == "CHAT_MESSAGE") {
    if (role.toString().toLowerCase() == 'GUIDE'.toLowerCase()) {
      navigatorKey.currentState!.pushNamed(AppRoutes.touristGuideHome2);
    } else {
      navigatorKey.currentState!.pushNamed(AppRoutes.travellerHomePageTab3);
    }
  } else if (message.data["typeMode"] == "BOOKING") {
    navigatorKey.currentState!.pushNamed(AppRoutes.travellerHomePageTab4);
  } else if (message.data["typeMode"] == "PAYMENT") {
    if (role.toString().toLowerCase() == 'GUIDE'.toLowerCase()) {
      navigatorKey.currentState!.pushNamed(AppRoutes.transactionHistoryGuide);
    } else {
      navigatorKey.currentState!.pushNamed(AppRoutes.transactionHistory);
    }
  } else if (message.data["typeMode"] == "RECIEVED_BOOKING") {
    navigatorKey.currentState!.pushNamed(AppRoutes.touristGuideHome);
  } else if (message.data["typeMode"] == "BOOKING_HISTORY") {
    navigatorKey.currentState!.pushNamed(AppRoutes.touristGuideHome1);
  }
}

checkNotification(RemoteMessage message, String from) {
  showNotification(message);
}

void showNotification(Message) async {
  role = await PreferenceUtil().getRoleName();
  debugPrint("ON TAP NOTIFICATION ---- $role");
  String notificationIcon = "@mipmap/ic_launcher";
  String? title;
  String? body;
  title = Message.notification!.title.toString();
  body = Message.notification!.body.toString();
  FlutterLocalNotificationsPlugin fltNotification =
      FlutterLocalNotificationsPlugin();
  var androidInit = AndroidInitializationSettings(notificationIcon);
  var iosInit = const DarwinInitializationSettings();
  var initSetting = InitializationSettings(android: androidInit, iOS: iosInit);
  fltNotification.initialize(initSetting,
      onDidReceiveNotificationResponse: (payload) async {
    debugPrint("onSelectNotificationonSelectNotification>>>");
    if (Message.data["typeMode"] == "CHAT_MESSAGE") {
      if (role.toString().toLowerCase() == 'GUIDE'.toString().toLowerCase()) {
        navigatorKey.currentState!.pushNamed(AppRoutes.touristGuideHome2);
      } else {
        navigatorKey.currentState!.pushNamed(AppRoutes.travellerHomePageTab3);
      }
    } else if (Message.data["typeMode"] == "BOOKING") {
      navigatorKey.currentState!.pushNamed(AppRoutes.travellerHomePageTab4);
    } else if (Message.data["typeMode"] == "PAYMENT") {
      if (role.toString().toLowerCase() == 'GUIDE'.toString().toLowerCase()) {
        navigatorKey.currentState!.pushNamed(AppRoutes.transactionHistoryGuide);
      } else {
        navigatorKey.currentState!.pushNamed(AppRoutes.transactionHistory);
      }
    } else if (Message.data["typeMode"] == "RECIEVED_BOOKING") {
      navigatorKey.currentState!.pushNamed(AppRoutes.touristGuideHome);
    } else if (Message.data["typeMode"] == "BOOKING_HISTORY") {
      navigatorKey.currentState!.pushNamed(AppRoutes.touristGuideHome1);
    }
  });

  var androidDetails = AndroidNotificationDetails(
    "1",
    'channelName',
    channelDescription: 'channel Description',
    importance: Importance.high,
    priority: Priority.high,
    largeIcon: DrawableResourceAndroidBitmap(notificationIcon),
    icon: notificationIcon,
    enableLights: true,
    enableVibration: true,
    visibility: NotificationVisibility.public,
  );

  var iosDetails = const DarwinNotificationDetails(
      sound: '', presentAlert: true, presentBadge: true, presentSound: true);

  var generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);
  await fltNotification.show(0, title, body, generalNotificationDetails,
      payload: 'Notification');
}
