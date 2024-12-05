import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Siesta/response_pojo/get_post_detail_response.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:stacked/stacked.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../app_constants/app_strings.dart';
import '../../app_service/google_map_service.dart';
import '../../main.dart';
import '../../response_pojo/get_activities_pojo.dart';

class CreatePostModel extends BaseViewModel implements Initialisable {
  final String type;
  final Map<String, dynamic>? argData;
  CreatePostModel({this.argData, required this.type});

  var titleTEC = TextEditingController();
  var locationTEC = TextEditingController();
  var priceTEC = TextEditingController();
  var scheduleTEC = TextEditingController();
  var transportTypeTEC = TextEditingController();
  var maximumPeopleTEC = TextEditingController();
  var minimumPeopleTEC = TextEditingController();
  var startingTimeTEC = TextEditingController();
  var durationTEC = TextEditingController();
  var meetingPointTEC = TextEditingController();
  var dropOffPointTEC = TextEditingController();
  var descriptionTEC = TextEditingController();

  double? latitude;
  double? longitude;
  String? heroImageLocal;
  String? heroImageUrl;
  bool accessibility = false;
  String? startingTimeValue;

  String? country;
  String? state;
  String? city;

  List<ActivitiesModel> activitiesList = [];
  List<DocumentsModel> documentsList = [];

  List<dynamic> placeList = [];
  bool isPlaceListShow = false;
  PostDetails? postDetail; // for general and experience data

  @override
  void initialise() {
    getActivitiesAPI().then((value) {
      if (argData!["screenType"] == "edit") {
        if (argData!["type"] == "experience") {
          postDetail = argData!["postDetails"];
          getInitialExperienceData();
        } else if (argData!["type"] == "general") {}
      }
    });

    /*// get Activities
    if (argData!["type"] != "gallery") getActivitiesAPI();*/
  }

  // get initial data
  void getInitialExperienceData() {
    titleTEC.text = postDetail!.title ?? "";
    locationTEC.text = postDetail!.location ?? "";
    priceTEC.text = (postDetail!.price ?? 0).toString();
    scheduleTEC.text = postDetail!.schedule ?? "";
    transportTypeTEC.text = postDetail!.transportType ?? "";
    accessibility = postDetail!.accessibility ?? false;
    maximumPeopleTEC.text = (postDetail!.maxPeople ?? 0).toString();
    minimumPeopleTEC.text = (postDetail!.minPeople ?? 0).toString();
    // change time
    startingTimeTEC.text = postDetail!.startingTime ?? "";
    durationTEC.text = postDetail!.duration ?? "";
    meetingPointTEC.text = postDetail!.meetingPoint ?? "";
    dropOffPointTEC.text = postDetail!.dropOffPoint ?? "";
    descriptionTEC.text = postDetail!.description ?? "";

    heroImageUrl = postDetail!.heroImage;

    documentsList = postDetail!.postImages!
        .map((e) => DocumentsModel(
            documentPath: e.url!,
            id: e.id!,
            documentType: e.mediaType ?? "image",
            isLocal: false))
        .toList();

    if (postDetail!.postsActivities != null) {
      List<int> selectedIds = postDetail!.postsActivities!
          .map((item) => item.activity!.id!)
          .toList();

      // Update isSelect for activities in activityList
      for (var activity in activitiesList) {
        activity.isSelect = selectedIds.contains(activity.id);
      }
      debugPrint(
          "Activity selected IDs : ${postDetail!.postsActivities!.length}");
    }

    notifyListeners();
  }

  bool validateExperience() {
    BuildContext context = navigatorKey.currentContext!;

    List<ActivitiesModel> activityList =
        activitiesList.where((element) => element.isSelect == true).toList();

    if (titleTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the title");
      return false;
    } else if (activityList.isEmpty) {
      GlobalUtility.showToast(context, "Please select the activity");
      return false;
    } else if (locationTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the location");
      return false;
    } else if (latitude == null || longitude == null) {
      GlobalUtility.showToast(
          context, "Please select the location from suggestions");
      return false;
    } else if (priceTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the price");
      return false;
    } else if (scheduleTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the detailed schedule");
      return false;
    } else if (transportTypeTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the transport type");
      return false;
    } else if (maximumPeopleTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the maximum people");
      return false;
    } else if (minimumPeopleTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the minimum people");
      return false;
    } else if (startingTimeTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the starting time");
      return false;
    } else if (durationTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the duration");
      return false;
    } else if (meetingPointTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the meeting point");
      return false;
    } else if (dropOffPointTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the drop-off point");
      return false;
    } else if (descriptionTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the description");
      return false;
    } else if (heroImageLocal == null) {
      GlobalUtility.showToast(context, "Please upload the hero image");
      return false;
    }

    return true;
  }

  bool validateGeneral() {
    BuildContext context = navigatorKey.currentContext!;

    List<ActivitiesModel> activityList =
        activitiesList.where((element) => element.isSelect == true).toList();

    if (titleTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the title");
      return false;
    } else if (activityList.isEmpty) {
      GlobalUtility.showToast(context, "Please select the activity");
      return false;
    } else if (locationTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the location");
      return false;
    } else if (latitude == null || longitude == null) {
      GlobalUtility.showToast(
          context, "Please select the location from suggestions");
      return false;
    } else if (priceTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the price");
      return false;
    } else if (descriptionTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the description");
      return false;
    } else if (heroImageLocal == null) {
      GlobalUtility.showToast(context, "Please upload the hero image");
      return false;
    }

    return true;
  }

  bool validateGallery() {
    BuildContext context = navigatorKey.currentContext!;

    if (titleTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the title");
      return false;
    } else if (locationTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the location");
      return false;
    } else if (latitude == null || longitude == null) {
      GlobalUtility.showToast(
          context, "Please select the location from suggestions");
      return false;
    } else if (descriptionTEC.text.trim().isEmpty) {
      GlobalUtility.showToast(context, "Please enter the description");
      return false;
    } else if (heroImageLocal == null) {
      GlobalUtility.showToast(context, "Please upload the hero image");
      return false;
    }

    return true;
  }

  void hideLocationContainer() {
    isPlaceListShow = false;
    notifyListeners();
  }

  void clearSearchTextField() {
    locationTEC.clear();
    placeList.clear();
    isPlaceListShow = false;
    notifyListeners();
  }

  Future<void> searchLocation(String value) async {
    if (value.isEmpty) {
      placeList.clear();
      isPlaceListShow = false;
    } else {
      isPlaceListShow = true;
      placeList.clear();
      placeList = await GoogleMapServices().getSuggestions(value);
    }
    notifyListeners();
  }

  Future<void> onClickSuggestion(int index) async {
    locationTEC.text = placeList[index]["description"];
    isPlaceListShow = false;

    Map<String, dynamic> latLngData = await GoogleMapServices()
        .getLatLongFromAddress(placeList[index]["description"]);

    latitude = latLngData['latitude']!;
    longitude = latLngData['longitude']!;
    country = latLngData["country"] ?? "";
    state = latLngData["state"] ?? "";
    city = latLngData["city"] ?? "";

    debugPrint(
        "Location lat long is: $latitude $longitude $country $state $city");
    notifyListeners();
  }

  // Create Experience API
  Future<void> createExperienceAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    GlobalUtility().showLoaderDialog(context);
    try {
      if (await GlobalUtility.isConnected()) {
        List<int> selectedActivitiesId =
            activitiesList.where((e) => e.isSelect).map((e) => e.id).toList();

        Map<String, String> map = {
          "title": titleTEC.text.trim(),
          "location": locationTEC.text.trim(),
          "latitude": (latitude ?? 0.0).toString(),
          "longitude": (longitude ?? 0.0).toString(),
          "price": priceTEC.text.trim(),
          "schedule": scheduleTEC.text.trim(),
          "transport_type": transportTypeTEC.text,
          "accessibility": accessibility.toString(),
          "max_people": maximumPeopleTEC.text.trim(),
          "min_people": minimumPeopleTEC.text.trim(),
          "starting_time": startingTimeValue ?? "",
          "duration": durationTEC.text.trim(),
          "meeting_point": meetingPointTEC.text.trim(),
          "drop_off_point": dropOffPointTEC.text.trim(),
          "description": descriptionTEC.text.trim(),
          "post_type": "EXPERIENCE",
          "country": country ?? "USA",
          "state": state ?? "Arizona",
          "city": city ?? "Arizona"
        };

        for (int i = 0; i < selectedActivitiesId.length; i++) {
          map['activities[$i]'] = selectedActivitiesId[i].toString();
        }

        List<http.MultipartFile> field = [];

        if (heroImageLocal != null) {
          field.add(http.MultipartFile.fromBytes(
              'hero_image', File(heroImageLocal!).readAsBytesSync(),
              filename: File(heroImageLocal!).path.split("/").last,
              contentType: MediaType('image', '*')));
        }

        for (int i = 0; i < documentsList.length; i++) {
          if (documentsList[i].isLocal == true) {
            field.add(http.MultipartFile.fromBytes(
                'media', File(documentsList[i].documentPath).readAsBytesSync(),
                filename:
                    File(documentsList[i].documentPath).path.split("/").last,
                contentType: MediaType(documentsList[i].documentType, '*')));
          }
        }

        final response = await ApiRequest().postMultipartRequest(
            map, Api.createPost, field) /*.timeout(Duration(seconds: 20))*/;

        var apiResponse = await response.stream.bytesToString();
        debugPrint("API Response : ${apiResponse}");

        var jsonData = jsonDecode(apiResponse);
        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          GlobalUtility.showToast(context, message);
          Navigator.pop(context, "back");
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(context);
    }
  }

  // Create General API
  Future<void> createGeneralAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    GlobalUtility().showLoaderDialog(context);
    try {
      if (await GlobalUtility.isConnected()) {
        List<int> selectedActivitiesId =
            activitiesList.where((e) => e.isSelect).map((e) => e.id).toList();

        Map<String, String> map = {
          "title": titleTEC.text.trim(),
          "location": locationTEC.text.trim(),
          "latitude": (latitude ?? 0.0).toString(),
          "longitude": (longitude ?? 0.0).toString(),
          "price": priceTEC.text.trim(),
          "description": descriptionTEC.text.trim(),
          "post_type": "GENERAL",
          "country": country ?? "USA",
          "state": state ?? "Arizona",
          "city": city ?? "Arizona"
        };

        for (int i = 0; i < selectedActivitiesId.length; i++) {
          map['activities[$i]'] = selectedActivitiesId[i].toString();
        }

        List<http.MultipartFile> field = [];

        if (heroImageLocal != null) {
          field.add(http.MultipartFile.fromBytes(
              'hero_image', File(heroImageLocal!).readAsBytesSync(),
              filename: File(heroImageLocal!).path.split("/").last,
              contentType: MediaType('image', '*')));
        }

        for (int i = 0; i < documentsList.length; i++) {
          if (documentsList[i].isLocal == true) {
            field.add(http.MultipartFile.fromBytes(
                'media', File(documentsList[i].documentPath).readAsBytesSync(),
                filename:
                    File(documentsList[i].documentPath).path.split("/").last,
                contentType: MediaType(documentsList[i].documentType, '*')));
          }
        }

        final response = await ApiRequest().postMultipartRequest(
            map, Api.createPost, field) /*.timeout(Duration(seconds: 20))*/;

        var apiResponse = await response.stream.bytesToString();
        debugPrint("API Response : ${apiResponse}");

        var jsonData = jsonDecode(apiResponse);
        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          GlobalUtility.showToast(context, message);
          Navigator.pop(context, "back");
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(context);
    }
  }

  // Create Gallery API
  Future<void> createGalleryAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    GlobalUtility().showLoaderDialog(context);
    try {
      if (await GlobalUtility.isConnected()) {
        Map<String, String> map = {
          "title": titleTEC.text.trim(),
          "location": locationTEC.text.trim(),
          "latitude": (latitude ?? 0.0).toString(),
          "longitude": (longitude ?? 0.0).toString(),
          "description": descriptionTEC.text.trim(),
        };

        List<http.MultipartFile> field = [];

        if (heroImageLocal != null) {
          field.add(http.MultipartFile.fromBytes(
              'hero_image', File(heroImageLocal!).readAsBytesSync(),
              filename: File(heroImageLocal!).path.split("/").last,
              contentType: MediaType('image', '*')));
        }

        for (int i = 0; i < documentsList.length; i++) {
          if (documentsList[i].isLocal == true) {
            field.add(http.MultipartFile.fromBytes(
                'media', File(documentsList[i].documentPath).readAsBytesSync(),
                filename:
                    File(documentsList[i].documentPath).path.split("/").last,
                contentType: MediaType(documentsList[i].documentType, '*')));
          }
        }

        final response = await ApiRequest().postMultipartRequest(
            map, Api.createGallery, field) /*.timeout(Duration(seconds: 20))*/;

        var apiResponse = await response.stream.bytesToString();
        debugPrint("API Response : ${apiResponse}");

        var jsonData = jsonDecode(apiResponse);
        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          GlobalUtility.showToast(context, message);
          Navigator.pop(context, "back");
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(context);
    }
  }

  Future<void> createExperienceUsingDio() async {
    BuildContext context = navigatorKey.currentContext!;
    GlobalUtility().showLoaderDialog(context);
    try {
      if (await GlobalUtility.isConnected()) {
        List<int> selectedActivitiesId =
            activitiesList.where((e) => e.isSelect).map((e) => e.id).toList();

        Map<String, String> map = {
          "title": titleTEC.text.trim(),
          "location": locationTEC.text.trim(),
          "latitude": (latitude ?? 0.0).toString(),
          "longitude": (longitude ?? 0.0).toString(),
          "price": priceTEC.text.trim(),
          "schedule": scheduleTEC.text.trim(),
          "transport_type": transportTypeTEC.text,
          "accessibility": accessibility.toString(),
          "max_people": maximumPeopleTEC.text.trim(),
          "min_people": minimumPeopleTEC.text.trim(),
          "starting_time": startingTimeValue ?? "",
          "duration": durationTEC.text.trim(),
          "meeting_point": meetingPointTEC.text.trim(),
          "drop_off_point": dropOffPointTEC.text.trim(),
          "description": descriptionTEC.text.trim(),
          "post_type": "EXPERIENCE",
          "country": country ?? "USA",
          "state": state ?? "Arizona",
          "city": city ?? "Arizona"
        };

        for (int i = 0; i < selectedActivitiesId.length; i++) {
          map['activities[$i]'] = selectedActivitiesId[i].toString();
        }

        // Initialize Dio
        Dio dio = Dio();

        // Create FormData for the request
        FormData formData = FormData.fromMap(map);

        // Add Hero Image (if available)
        if (heroImageLocal != null) {
          formData.files.add(MapEntry(
            "hero_image",
            await MultipartFile.fromFile(
              heroImageLocal!,
              filename: File(heroImageLocal!).path.split("/").last,
              contentType:
                  MediaType("image", "jpeg"), // Adjust content type if needed
            ),
          ));
        }

        // Add Media Files (Documents)
        for (int i = 0; i < documentsList.length; i++) {
          if (documentsList[i].isLocal == true) {
            formData.files.add(MapEntry(
              'media',
              await MultipartFile.fromFile(
                documentsList[i].documentPath,
                filename:
                    File(documentsList[i].documentPath).path.split("/").last,
                contentType: MediaType(documentsList[i].documentType, '*'),
              ),
            ));
          }
        }

        // Specify the API URL
        String apiUrl = Api.createPost;

        // Make the POST request using Dio
        Response response = await dio.post(Api.baseUrl + apiUrl, data: formData,
            onSendProgress: (sent, total) {
          if (total != -1) {
            double progress = sent / total;
            debugPrint(
                "Upload progress: ${(progress * 100).toStringAsFixed(2)}%");
          }
        });

        // Handle the API response
        var apiResponse = jsonDecode(response.data);
        int status = apiResponse['statusCode'] ?? 404;
        String message = apiResponse['message'] ?? "";

        if (status == 200) {
          GlobalUtility.showToast(context, message);
          Navigator.pop(context, "back");
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      GlobalUtility().closeLoaderDialog(context);
    }
  }

  Future<void> getActivitiesAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        GlobalUtility().showLoaderDialog(context);
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getActivities)
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        GlobalUtility().closeLoaderDialog(context);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          GetActivitiesPojo getActivitiesPojo =
              getActivitiesPojoFromJson(apiResponse.body);
          activitiesList.clear();

          activitiesList = getActivitiesPojo.data!.rows!.map((e) {
            return ActivitiesModel(id: e.id!, title: e.name ?? "");
          }).toList();
        } else if (status == 400) {
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          GlobalUtility().handleSessionExpire(context);
        }
      } else {
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
    }
  }
}

class ActivitiesModel {
  String title;
  int id;
  bool isSelect;
  ActivitiesModel(
      {required this.id, required this.title, this.isSelect = false});
}

class DocumentsModel {
  int id;
  String documentPath;
  bool isLocal;
  String documentType;
  Uint8List? thumbnailPath;
  DocumentsModel(
      {this.id = 0,
      required this.documentPath,
      required this.isLocal,
      this.documentType = "image",
      this.thumbnailPath});
}
