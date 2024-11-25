import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_constants/shared_preferences.dart';

class PreferenceUtil {
  setUserData(
      String firstName,
      String lastName,
      int id,
      String email,
      String roleName,
      String phone,
      String profileImgUrl1,
      String pinCode,
      String availability,
      bool isProfileComplete,
      String emailT) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.firstName, firstName);
    prefs.setString(SharedPreferenceValues.lastName, lastName);
    prefs.setString(SharedPreferenceValues.id, id.toString());
    prefs.setString(SharedPreferenceValues.email, email);
    prefs.setString(SharedPreferenceValues.roleName, roleName);
    prefs.setString(SharedPreferenceValues.phone, phone);
    prefs.setString(SharedPreferenceValues.profileImgUrl, profileImgUrl1);
    prefs.setString(SharedPreferenceValues.pinCode, pinCode);
    prefs.setString(SharedPreferenceValues.availability, availability);
    prefs.setBool(
        SharedPreferenceValues.isTravellerProfileComplete, isProfileComplete);
    prefs.setString(SharedPreferenceValues.travelerEmail, availability);
  }

  updateUserData(
    String firstName,
    String lastName,
    String phone,
    String profileImgUrl1,
    String travelerCountry,
    String travelerState,
    String travelerCity,
    String email,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.firstName, firstName);
    prefs.setString(SharedPreferenceValues.lastName, lastName);
    prefs.setString(SharedPreferenceValues.phone, phone);
    prefs.setString(SharedPreferenceValues.travelerEmail, email);
    prefs.setString(SharedPreferenceValues.profileImgUrl, profileImgUrl1);
    prefs.setString(SharedPreferenceValues.travelerCountry, travelerCountry);
    prefs.setString(SharedPreferenceValues.travelerState, travelerState);
    prefs.setString(SharedPreferenceValues.travelerCity, travelerCity);
  }

  updateUserDataGuide(
    String firstName,
    String lastName,
    String phone,
    String profileImgUrl1,
    String pinCode,
    String price,
    String guideCountry,
    String guideState,
    String guideCity,
    String guideBio,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.firstName, firstName);
    prefs.setString(SharedPreferenceValues.lastName, lastName);
    prefs.setString(SharedPreferenceValues.phone, phone);
    prefs.setString(SharedPreferenceValues.profileImgUrl, profileImgUrl1);
    prefs.setString(SharedPreferenceValues.pinCode, pinCode);
    prefs.setString(SharedPreferenceValues.guideCountry, guideCountry);
    prefs.setString(SharedPreferenceValues.guideState, guideState);
    prefs.setString(SharedPreferenceValues.guideCity, guideCity);
    prefs.setString(SharedPreferenceValues.guideBio, guideBio);
  }

  getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firstNameValue = prefs.getString(SharedPreferenceValues.firstName);
    return firstNameValue;
  }

  getcountryCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countryCode = prefs.getString(SharedPreferenceValues.countryCode);
    return countryCode;
  }

  setCountryCode(String countryCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.countryCode, countryCode);
  }

  setWaitingStatus(bool waitingStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SharedPreferenceValues.waitingStatus, waitingStatus);
  }

  getWaitingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? waitingStatus = prefs.getBool(SharedPreferenceValues.waitingStatus);
    return waitingStatus;
  }

  getPinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pinCode = prefs.getString(SharedPreferenceValues.pinCode);
    return pinCode;
  }

  getphone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString(SharedPreferenceValues.phone);
    return phone;
  }

  getProgileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileImgUrl =
        prefs.getString(SharedPreferenceValues.profileImgUrl);
    return profileImgUrl;
  }

  userType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString("userType");
    return userType;
  }

  getRoleType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString(SharedPreferenceValues.roleName);
    return userType;
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userType");
    prefs.remove(SharedPreferenceValues.firstName);
    prefs.remove(SharedPreferenceValues.lastName);
    prefs.remove(SharedPreferenceValues.id);
    prefs.remove(SharedPreferenceValues.email);
    prefs.remove(SharedPreferenceValues.roleName);
    prefs.remove(SharedPreferenceValues.phone);
    prefs.remove(SharedPreferenceValues.profileImgUrl);
    prefs.remove(SharedPreferenceValues.pinCode);
    prefs.remove(SharedPreferenceValues.token);
    prefs.remove(SharedPreferenceValues.idProof);
  }

  getLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastNameValue = prefs.getString(SharedPreferenceValues.lastName);
    return lastNameValue;
  }

  getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idValue = prefs.getString(SharedPreferenceValues.id);
    return idValue;
  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailValue = prefs.getString(SharedPreferenceValues.email);
    return emailValue;
  }

  getRoleName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleNameValue = prefs.getString(SharedPreferenceValues.roleName);
    return roleNameValue;
  }

  setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.token, token);
  }

  setTravelerEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.travelerEmail, email);
  }

  setIdProof(String idProof) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.idProof, idProof);
  }

  getIdProof() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idProof = prefs.getString(SharedPreferenceValues.idProof);
    return idProof;
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenValue = prefs.getString(SharedPreferenceValues.token);
    return tokenValue;
  }

  getTravellerProfileStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isTravellerProfileComplete =
        prefs.getBool(SharedPreferenceValues.isTravellerProfileComplete);
    return isTravellerProfileComplete;
  }

  getGuideAvailability() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? availability = prefs.getString(SharedPreferenceValues.availability);
    return availability;
  }

  setGuideAvailability(String availability) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.availability, availability);
  }

  getGuideNotigicationSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notification = prefs.getString(SharedPreferenceValues.notification);
    return notification;
  }

  getTravellerCountrySetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? country = prefs.getString(SharedPreferenceValues.travelerCountry);
    return country;
  }

  getTravellerStateSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? state = prefs.getString(SharedPreferenceValues.travelerState);
    return state;
  }

  getTravellerCitySetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? city = prefs.getString(SharedPreferenceValues.travelerCity);
    return city;
  }

  setTravelerLocationDetails(
    String country,
    String state,
    String city,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.travelerCountry, country);
    prefs.setString(SharedPreferenceValues.travelerState, state);
    prefs.setString(SharedPreferenceValues.travelerCity, city);
  }

  setGuideNotificationSetting(String notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.notification, notification);
  }

  // MESSAGE GUIDE
  setGuideSendMessageUserId(String guideUserId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPreferenceValues.guideId, guideUserId);
  }

  setGuideSendMessageUserName(String guideUserName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPreferenceValues.guideName, guideUserName);
  }

  // MESSAGE GUIDE
  setTravellerSendMessageUserId(String guideUserId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPreferenceValues.travellerId, guideUserId);
  }

  setTravellerSendMessageUserName(String guideUserName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPreferenceValues.travellerName, guideUserName);
  }

  setGuideLocationDetails(String country, String state, String city) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPreferenceValues.guideCountry, country);
    pref.setString(SharedPreferenceValues.guideState, state);
    pref.setString(SharedPreferenceValues.guideCity, city);
  }

  setGuideBio(String bio) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPreferenceValues.guideBio, bio);
  }

  getGuideBio() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? guideBio = pref.getString(SharedPreferenceValues.guideBio);
    return guideBio;
  }

  getGuideCountryDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? country = pref.getString(SharedPreferenceValues.guideCountry);
    return country;
  }

  getGuideStateDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? guideState = pref.getString(SharedPreferenceValues.guideState);
    return guideState;
  }

  getGuideCityDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? guideCity = pref.getString(SharedPreferenceValues.guideCity);
    return guideCity;
  }

  getGuideSendMessageUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(SharedPreferenceValues.guideId);
    return userId;
  }

  getGuideSendMessageUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString(SharedPreferenceValues.guideName);
    return userName;
  }

  getTravellerSendMessageUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(SharedPreferenceValues.travellerId);
    return userId;
  }

  getTravellerSendMessageUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString(SharedPreferenceValues.travellerName);
    return userName;
  }
}
