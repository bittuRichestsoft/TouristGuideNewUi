import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

import '../../main.dart';

class CreatePostModel extends BaseViewModel implements Initialisable {
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
  bool accessibility = false;

  List<ActivitiesModel> activitiesList = [
    ActivitiesModel(id: 1, title: "Bar"),
    ActivitiesModel(id: 2, title: "Restaurant"),
    ActivitiesModel(id: 3, title: "Cycling"),
    ActivitiesModel(id: 4, title: "Travelling"),
    ActivitiesModel(id: 5, title: "Sightseeing"),
  ];
  List<DocumentsModel> documentsList = [];

  @override
  void initialise() {}

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
  DocumentsModel(
      {this.id = 0, required this.documentPath, required this.isLocal});
}
