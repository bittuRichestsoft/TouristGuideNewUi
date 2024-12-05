import 'dart:convert';

import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/main.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoogleMapServices {
  String kPLACES_API_KEY = "AIzaSyCdB1v7t7lh_1MkaTotwt-Ynlu7D0mJXmo";

  Future<List<dynamic>> getSuggestions(String input) async {
    List<dynamic> placesList;

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY';

    if (await GlobalUtility.isConnected()) {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        placesList = jsonDecode(response.body.toString())['predictions'];
        debugPrint(jsonEncode(placesList));
        return placesList;
      } else {
        return [];
        // throw Exception("error in fetching the google locations data");
      }
    } else {
      GlobalUtility.showToast(
          navigatorKey.currentContext!, AppStrings().INTERNET);
      return [];
    }
  }

  /*Future<Map<String, dynamic>> getLatLongFromAddress(String address) async {
    try {
      String encodedAddress = Uri.encodeQueryComponent(address);
      String baseURL = 'https://maps.googleapis.com/maps/api/geocode/json';
      String request = '$baseURL?address=$encodedAddress&key=$kPLACES_API_KEY';

      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        Map<String, dynamic> geocodingData =
            jsonDecode(response.body.toString());
        debugPrint(jsonEncode(geocodingData));
        return geocodingData;
      } else {
        throw Exception(
            "Failed to fetch geocoding data. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching geocoding data: $error");
      return {};
    }
  }

  Future<Map<String, double>?> fetchLatLongFromAddress(String address) async {
    try {
      Map<String, dynamic> geocodingData = await getLatLongFromAddress(address);
      if (geocodingData.isNotEmpty) {
        double latitude =
            geocodingData['results'][0]['geometry']['location']['lat'];
        double longitude =
            geocodingData['results'][0]['geometry']['location']['lng'];

        Map<String, double> latlngMap = {
          'latitude': latitude,
          'longitude': longitude
        };
        // print("Latitude: $latitude, Longitude: $longitude");
        return latlngMap;
      }
      Map<String, double> temp = {};
      return null;
    } catch (e) {
      debugPrint("error in latlong: $e");
      return null;
    }
  }*/
  Future<Map<String, dynamic>> getLatLongFromAddress(String address) async {
    try {
      String encodedAddress = Uri.encodeQueryComponent(address);
      String baseURL = 'https://maps.googleapis.com/maps/api/geocode/json';
      String request = '$baseURL?address=$encodedAddress&key=$kPLACES_API_KEY';

      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        Map<String, dynamic> geocodingData =
            jsonDecode(response.body.toString());
        debugPrint(jsonEncode(geocodingData));

        // Initialize variables for country, state, and city
        String country = '';
        String state = '';
        String city = '';

        // Parse the address components to assign the values
        List<dynamic> addressComponents =
            geocodingData['results'][0]['address_components'];

        for (var component in addressComponents) {
          var types = component['types'];

          if (types.contains('country')) {
            country = component['long_name'];
          } else if (types.contains('administrative_area_level_1')) {
            state = component['long_name'];
          } else if (types.contains('administrative_area_level_3') ||
              types.contains('postal_town')) {
            city = component['long_name'];
          }
        }

        // If no state is found, assign the country as the state
        if (state.isEmpty) {
          state = country;
        }

        // If no city is found, assign the state as the city
        if (city.isEmpty) {
          city = state;
        }

        // Return the results along with the extracted country, state, and city
        return {
          'country': country,
          'state': state,
          'city': city,
          'latitude': geocodingData['results'][0]['geometry']['location']
              ['lat'],
          'longitude': geocodingData['results'][0]['geometry']['location']
              ['lng'],
          'formatted_address': geocodingData['results'][0]['formatted_address']
        };
      } else {
        throw Exception(
            "Failed to fetch geocoding data. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching geocoding data: $error");
      return {};
    }
  }
}
