import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/view/create_password/create_password.dart';
import 'package:Siesta/view/notification_screen/notification_page.dart';
import 'package:Siesta/view/signIn/forgot_password_page.dart';
import 'package:Siesta/view/signIn/login_page.dart';
import 'package:Siesta/view/signUp/registration_page.dart';
import 'package:Siesta/view/touristGuideView/bookingHistory/booking_history_detail.dart';
import 'package:Siesta/view/touristGuideView/create_tourist_profile/create_profile_page.dart';
import 'package:Siesta/view/touristGuideView/guide_transaction_history/guidetransactions_history_screen.dart';
import 'package:Siesta/view/touristGuideView/guide_transaction_history/withdraw_request_screen.dart';
import 'package:Siesta/view/touristGuideView/home/guide_home_page.dart';
import 'package:Siesta/view/touristGuideView/tourist_profile_view/banking_detail.dart';
import 'package:Siesta/view/touristGuideView/tourist_profile_view/gallery_page.dart';
import 'package:Siesta/view/touristGuideView/tourist_profile_view/general_detail_page.dart';
import 'package:Siesta/view/touristGuideView/tourist_profile_view/review_page.dart';
import 'package:Siesta/view/travellerView/about_us/about_us_page.dart';
import 'package:Siesta/view/travellerView/bookTrip/book_your_trip_page.dart';
import 'package:Siesta/view/travellerView/create_profile/create_traveller_profile.dart';
import 'package:Siesta/view/travellerView/find_guide/guide_detail_page.dart';
import 'package:Siesta/view/travellerView/find_tourist_guide/find_tourist_guide_screen.dart';
import 'package:Siesta/view/travellerView/home/traveller_homepage.dart';
import 'package:Siesta/view/travellerView/itinerary/itinerary_detail_page.dart';
import 'package:Siesta/view/travellerView/message_screen/message_chat_page.dart';
import 'package:Siesta/view/travellerView/transactions/transaction_history_traveller.dart';
import 'package:Siesta/view/web_view_pages/common_web_view.dart';
import 'package:flutter/material.dart';

import '../view/travellerView/itinerary/itineary_page.dart';
import '../view/travellerView/profile/profile_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.loginPage:
      return MaterialPageRoute(builder: (context) => const LoginPage());

    case AppRoutes.signUpPage:
      return MaterialPageRoute(builder: (context) => const SignUpPage());

    case AppRoutes.forgotPassword:
      return MaterialPageRoute(
          builder: (context) => const ForgotPasswordPage());

    case AppRoutes.createPassword:
      return MaterialPageRoute(builder: (context) => const CreateNewPassword());

    case AppRoutes.createTravelerProfile:
      return MaterialPageRoute(
          builder: (context) => const CreateTravellerProfile());

    case AppRoutes.findguideDetail:
      return MaterialPageRoute(
          builder: (context) => FindGuideDetail(idMap: settings.arguments));

    case AppRoutes.bookTripNow:
      return MaterialPageRoute(
          builder: (context) => BookTripPage(guideId: settings.arguments));

    case AppRoutes.travellerHomePage:
      return MaterialPageRoute(
          builder: (context) => TravellerHomePage(bottomTab: 0));

    case AppRoutes.itineraryDetail:
      return MaterialPageRoute(
          builder: (context) =>
              ItineraryDetailPage(bookingId: settings.arguments));

    case AppRoutes.travellerHomePageTab2:
      return MaterialPageRoute(
          builder: (context) => TravellerHomePage(bottomTab: 1));

    case AppRoutes.travellerHomePageTab3:
      return MaterialPageRoute(
          builder: (context) => TravellerHomePage(bottomTab: 2));

    case AppRoutes.travellerHomePageTab4:
      return MaterialPageRoute(
          builder: (context) => TravellerHomePage(bottomTab: 3));

    case AppRoutes.travellerHomeMessagePage:
      return MaterialPageRoute(
          builder: (context) => TravellerHomePage(
                bottomTab: 2,
                from: "chat_with_guide",
              ));

    case AppRoutes.transactionHistory:
      /*  return MaterialPageRoute(
          builder: (context) => TransactionHistoryPage(fromWhere: "traveller")); */
      return MaterialPageRoute(
          builder: (context) => const TransactionHistoryTravelerPage());

    case AppRoutes.transactionHistoryGuide:
      return MaterialPageRoute(
          builder: (context) =>
              GuideTransactionHistoryPage(fromWhere: "guide"));

    case AppRoutes.profilePage:
      return MaterialPageRoute(builder: (context) => const ProfilePage());

    case AppRoutes.itineraryPage:
      return MaterialPageRoute(
          builder: (context) => ItineraryPage(
                fromWhere: settings.arguments,
              ));

    case AppRoutes.withdrawRequestGuide:
      return MaterialPageRoute(
          builder: (context) => const WithdrawGuideRequestPage());

    case AppRoutes.notificationPage:
      return MaterialPageRoute(builder: (context) => const NotificationPage());

    case AppRoutes.galleryPage:
      return MaterialPageRoute(builder: (context) => const GalleryPage());

    case AppRoutes.touristGuideHome:
      return MaterialPageRoute(
          builder: (context) => TouristGuideHomePage(
                bottomTab: 0,
                fromWhere: "",
              ));

    case AppRoutes.touristGuideHome1:
      return MaterialPageRoute(
          builder: (context) => TouristGuideHomePage(
                bottomTab: 1,
                fromWhere: "",
              ));

    case AppRoutes.touristGuideHome2:
      return MaterialPageRoute(
          builder: (context) => TouristGuideHomePage(
                bottomTab: 2,
                fromWhere: "",
              ));

    case AppRoutes.touristGuideMessageHomePage:
      return MaterialPageRoute(
          builder: (context) => TouristGuideHomePage(
                bottomTab: 2,
                fromWhere: "message_guide",
              ));

    case AppRoutes.aboutUsPage:
      return MaterialPageRoute(builder: (context) => const AboutUsScreen());

    case AppRoutes.createTouristProfile:
      return MaterialPageRoute(
          builder: (context) => const CreateTouristProfileScreen());

    case AppRoutes.messageChatPage:
      return MaterialPageRoute(
          builder: (context) =>
              MessageChatScreen(threadId: settings.arguments));

    case AppRoutes.bookingHistoryDetail:
      return MaterialPageRoute(
          builder: (context) =>
              BookingHistoryDetail(bookingId: settings.arguments));
    case AppRoutes.reviewListPage:
      return MaterialPageRoute(builder: (context) => const ReviewPage());

    case AppRoutes.touristBankingDetails:
      return MaterialPageRoute(
          builder: (context) => const TouristBankingDetails());

    case AppRoutes.commonWebViewPage:
      return MaterialPageRoute(
          builder: (context) => CommonWebViewPage(from: settings.arguments));

    case AppRoutes.findTouristGuide:
      return MaterialPageRoute(builder: (context) => FindTouristGuideScreen());

    case AppRoutes.generalDetailPage:
      return MaterialPageRoute(builder: (context) => GeneralDetailPage());

    default:
      return MaterialPageRoute(builder: (context) => const LoginPage());
  }
}
