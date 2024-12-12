import 'dart:async';
import 'dart:ui';

import 'package:Siesta/app_constants/app_images.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

enum CustomTabValue { list, map }

class FindExperienceViewModel extends BaseViewModel implements Initialisable {
  var tabVal = CustomTabValue.list;

  // RangeValues priceRange = RangeValues(100, 300);
  SfRangeValues priceRange = SfRangeValues(3000.0, 5000.0);
  DateRangePickerController dateController = DateRangePickerController();

  DateTime? startDate;
  DateTime? endDate;

  bool showMapOverlayTile = false;

  List<String> activitiesList = [
    "Hiking",
    "Backpacking",
    "Sightseeing",
    "adventure"
  ];

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  Set<Marker> markers = {};

  @override
  void initialise() {
    _addCustomMarker();
  }

  void onTapTab(var value) {
    if (value == CustomTabValue.list) {
      tabVal = CustomTabValue.list;
    } else {
      tabVal = CustomTabValue.map;
      _addCustomMarker();
    }
    notifyListeners();
  }

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<void> _addCustomMarker() async {
    final Uint8List resizedMarkerIcon = await _resizeImage(
      AppImages().pngImages.icCustomMainMarker,
      90, // Desired width
      90, // Desired height
    );

    final BitmapDescriptor customIcon =
        BitmapDescriptor.fromBytes(resizedMarkerIcon);

    markers.add(
      Marker(
        markerId: MarkerId('customMarker'),
        position: LatLng(37.42796133580664, -122.085749655962),
        icon: customIcon,
        infoWindow: InfoWindow.noText,
        onTap: () {
          showMapOverlayTile = true;
          notifyListeners();
        },
      ),
    );
    notifyListeners();
  }

  Future<Uint8List> _resizeImage(
      String assetPath, int width, int height) async {
    final ByteData imageData = await rootBundle.load(assetPath);
    final Codec codec = await instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    final FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? resizedData =
        await frameInfo.image.toByteData(format: ImageByteFormat.png);

    return resizedData!.buffer.asUint8List();
  }
}
