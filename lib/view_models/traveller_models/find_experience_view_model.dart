import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:Siesta/response_pojo/get_search_experience_resp.dart'
    as get_exp_resp;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../api_requests/api.dart';
import '../../api_requests/api_request.dart';
import '../../app_constants/app_strings.dart';
import '../../app_service/google_map_service.dart';
import '../../main.dart';
import '../../response_pojo/get_activities_pojo.dart' as get_activity_resp;
import '../../utility/globalUtility.dart';

enum CustomTabValue { list, map }

enum Status { error, loading, initialised }

class FindExperienceViewModel extends BaseViewModel implements Initialisable {
  var tabVal = CustomTabValue.list;

  // RangeValues priceRange = RangeValues(100, 300);
  SfRangeValues priceRange = SfRangeValues(0.0, 5000.0);
  DateRangePickerController dateController = DateRangePickerController();
  var locationTEC = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  double ratingValue = 0;
  double? latitude;
  double? longitude;

  bool showMapOverlayTile = false;

  List<ActivitiesModel> activitiesList = [];

  List<get_exp_resp.Rows> experienceList = [];

  int pageNo = 1;
  int totalExperiencePost = 0;
  late var scrollController;
  bool isLoadMore = false;

  Status _status = Status.loading;
  Status get status => _status;

  String errorMsg = "Some error occurred";

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  List<Marker> markers = [];
  get_exp_resp.Rows? currentDetail;
  int? selectedMarkerId;

  List<dynamic> placeList = [];
  bool isPlaceListShow = false;

  @override
  void initialise() {
    setInitialised(false);
    pageNo = 1;
    scrollController = ScrollController()..addListener(pagination);
    getActivitiesAPI();
    getSearchExperienceAPI();
  }

  void pagination() {
    if ((scrollController.position.maxScrollExtent ==
        scrollController.offset)) {
      if (totalExperiencePost > experienceList.length) {
        isLoadMore = true;
        pageNo++;
        notifyListeners();
        getSearchExperienceAPI();
      }
    }
  }

  void onTapTab(var value) {
    if (value == CustomTabValue.list) {
      tabVal = CustomTabValue.list;
    } else {
      currentDetail = null;
      selectedMarkerId = null;
      showMapOverlayTile = false;
      tabVal = CustomTabValue.map;
      cameraUpdate();
    }
    notifyListeners();
  }

  CameraPosition initialCameraPosition() {
    final LatLng initialPosition = markers.isNotEmpty
        ? markers.first.position
        : LatLng(37.42796133580664, -122.085749655962);
    return CameraPosition(
      target: initialPosition,
      zoom: 14.4746,
    );
  }

  Future<void> _addCustomMarkers(List<get_exp_resp.Rows> expList) async {
    final Uint8List defaultMarkerIcon = await _resizeImage(
      AppImages().pngImages.icDefaultMarker,
      90, // Desired width
      90, // Desired height
    );

    final Uint8List selectedMarkerIcon = await _resizeImage(
      AppImages().pngImages.icCustomMainMarker,
      90, // Desired width
      90, // Desired height
    );

    final BitmapDescriptor defaultIcon =
        BitmapDescriptor.fromBytes(defaultMarkerIcon);
    final BitmapDescriptor selectedIcon =
        BitmapDescriptor.fromBytes(selectedMarkerIcon);

    markers.clear(); // Clear previous markers

    for (var row in expList) {
      // final detail = row; // Create a local copy of the current row

      markers.add(
        Marker(
          markerId: MarkerId(row.id.toString()), // Use a unique ID
          position: LatLng(double.parse((row.latitude ?? 0.0).toString()),
              double.parse((row.longitude ?? 0.0).toString())),
          icon: row.id == selectedMarkerId ? selectedIcon : defaultIcon,
          infoWindow: InfoWindow.noText,
          onTap: () {
            selectedMarkerId = row.id; // Update the selected marker ID
            currentDetail = row; // Update the selected detail
            showMapOverlayTile = true;
            updateMarkers(expList); // Update markers
          },
        ),
      );
    }
    notifyListeners();
  }

  void updateMarkers(List<get_exp_resp.Rows> expList) {
    // Clear and re-add markers to reflect the change in icons
    _addCustomMarkers(expList);
  }

  Future<Uint8List> _resizeImage(
      String assetPath, int width, int height) async {
    final ByteData imageData = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? resizedData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return resizedData!.buffer.asUint8List();
  }

  // get activities API
  Future<void> getActivitiesAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      setInitialised(false);
      if (await GlobalUtility.isConnected()) {
        final apiResponse = await ApiRequest()
            .getWithHeader(Api.getActivities)
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          get_activity_resp.GetActivitiesPojo getActivitiesPojo =
              get_activity_resp.getActivitiesPojoFromJson(apiResponse.body);
          activitiesList.clear();

          activitiesList = getActivitiesPojo.data!.rows!.map((e) {
            return ActivitiesModel(id: e.id!, title: e.name ?? "");
          }).toList();
          setInitialised(true);
        } else if (status == 400) {
          setError(message);
          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          setError(message);
          GlobalUtility().handleSessionExpire(context);
        } else {
          setError(AppStrings.someErrorOccurred);
        }
      } else {
        setError(AppStrings().INTERNET);
        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      setError(AppStrings.someErrorOccurred);
      debugPrint("Get Activities error : $e");
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      setBusy(false);
    }
  }

  // search experience API
  Future<void> getSearchExperienceAPI() async {
    BuildContext context = navigatorKey.currentContext!;
    try {
      if (await GlobalUtility.isConnected()) {
        if (pageNo == 1) {
          _status = Status.loading;
          notifyListeners();
        }

        String? userId = prefs.getString(SharedPreferenceValues.id);
        List<int> selectedActivitiesId =
            activitiesList.where((e) => e.isSelect).map((e) => e.id).toList();

        String userIdFilter = userId != null ? "&user_id=$userId" : "";
        String priceFilter =
            "&min_price=${priceRange.start}&max_price=${priceRange.end}";
        String destinationFilter = locationTEC.text.trim().isNotEmpty
            ? "&destination=${locationTEC.text}"
            : "";
        String ratingFilter = ratingValue != 0 ? "&rating=$ratingValue" : "";

        String activityFilter = selectedActivitiesId.isNotEmpty
            ? "&activity=${selectedActivitiesId.toString()}"
            : "";

        final apiResponse = await ApiRequest()
            .getWithHeader(
                "${Api.searchExperience}?page_no=$pageNo&number_of_rows=10$userIdFilter$priceFilter$destinationFilter$ratingFilter$activityFilter")
            .timeout(Duration(seconds: 20));

        var jsonData = jsonDecode(apiResponse.body);

        int status = jsonData['statusCode'] ?? 404;
        String message = jsonData['message'] ?? "";

        if (status == 200) {
          _status = Status.initialised;
          get_exp_resp.GetSearchExperienceResponse getSearchExperienceResponse =
              get_exp_resp.getSearchExpRespFromJson(apiResponse.body);

          totalExperiencePost =
              getSearchExperienceResponse.data!.details!.count ?? 0;

          if (pageNo == 1) {
            markers.clear();
            experienceList = getSearchExperienceResponse.data!.details!.rows!;
          } else {
            experienceList
                .addAll(getSearchExperienceResponse.data!.details!.rows!);
          }

          // add markers
          _addCustomMarkers(experienceList);

          // update camera
          cameraUpdate();
        } else if (status == 400) {
          _status = Status.error;
          errorMsg = "Some error occurred";

          GlobalUtility.showToast(context, message);
        } else if (status == 401) {
          _status = Status.error;
          errorMsg = "Un authentication";

          GlobalUtility().handleSessionExpire(context);
        } else {
          _status = Status.error;
          errorMsg = "Some error occurred";

          GlobalUtility.showToast(context, message);
        }
      } else {
        _status = Status.error;
        errorMsg = AppStrings().INTERNET;

        GlobalUtility.showToast(context, AppStrings().INTERNET);
      }
    } catch (e) {
      debugPrint("$runtimeType error : $e");
      _status = Status.error;
      errorMsg = AppStrings.someErrorOccurred;
      GlobalUtility.showToast(context, AppStrings.someErrorOccurred);
    } finally {
      notifyListeners();
    }
  }

  void cameraUpdate() {
    // update camera
    if (experienceList.isNotEmpty) {
      mapController.future.then((controller) {
        controller
            .animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                  double.parse((experienceList[0].latitude ?? 0.0).toString()),
                  double.parse(
                      (experienceList[0].longitude ?? 0.0).toString())),
              zoom: 14.0, // Adjust the zoom level as needed
            ),
          ),
        )
            .then((value) {
          notifyListeners();
        });
      });
    }
  }

  /// Location Google Places
  void hideLocationContainer() {
    isPlaceListShow = false;
    notifyListeners();
  }

  Future<void> searchLocation(String value) async {
    if (value.isEmpty) {
      placeList.clear();
      isPlaceListShow = false;
      getSearchExperienceAPI();
    } else {
      isPlaceListShow = true;
      placeList.clear();
      placeList = await GoogleMapServices().getSuggestions(value);
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> onClickSuggestion(int index) async {
    // locationTEC.text = placeList[index]["description"];
    isPlaceListShow = false;

    Map<String, dynamic> latLngData = await GoogleMapServices()
        .getLatLongFromAddress(placeList[index]["description"]);

    // latitude = latLngData['latitude']!;
    // longitude = latLngData['longitude']!;

    Map<String, dynamic> mapData = {
      "location": placeList[index]["description"],
      "latitude": latLngData['latitude']!,
      "longitude": latLngData['longitude']!
    };

    // notifyListeners();
    return mapData;
  }
}

class ActivitiesModel {
  String title;
  int id;
  bool isSelect;
  ActivitiesModel(
      {required this.id, required this.title, this.isSelect = false});

  ActivitiesModel copy() {
    return ActivitiesModel(
      id: this.id,
      isSelect: this.isSelect,
      title: this.title,
    );
  }
}
