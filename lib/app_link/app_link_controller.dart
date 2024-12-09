import 'dart:async';

import 'package:Siesta/main.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../app_constants/app_routes.dart';

class AppLinkController {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  // void dispose() {
  //   _linkSubscription?.cancel();
  // }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    final uri = await _appLinks.getInitialAppLink();
    if (uri != null) {
      handleDeepLink(uri);
    }

    // Handle links when app is open
    _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink URL: $uri');
      // Print individual query parameters

      debugPrint("Path segments :${uri.pathSegments}");
      handleDeepLink(uri);
    });

    debugPrint("App link controller initialized");
  }

  Future<void> handleDeepLink(Uri uri) async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (uri.pathSegments.contains("guide_detailed_page")) {
        String guideID = uri.pathSegments[uri.pathSegments.length - 1];
        if (isPositiveInteger(guideID) == true) {
          Navigator.pushNamed(context, AppRoutes.previewProfilePage,
              arguments: {
                "userId": guideID,
              });
        }
      } else {
        // GlobalUtility.showToast(context,  "Invalid URL");
      }
    } catch (e) {
      debugPrint("Error in handling deep link: $e");
    }
  }

  bool isPositiveInteger(String s) {
    if (s.isEmpty) {
      return false;
    }
    int? value = int.tryParse(s);
    return value != null && value > 0;
  }
}
