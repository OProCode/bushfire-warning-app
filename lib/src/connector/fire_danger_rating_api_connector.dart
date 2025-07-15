import 'dart:convert';
import 'package:bushfire_warning_app/src/connector/local_storage_connector.dart';
import 'package:bushfire_warning_app/src/models/fire_danger_rating.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FireDangerRatingAPI {
  late final String serverBaseAddress;

  late final String accessToken;
  late final String userEmail;

  static late bool isLoggedIn = false;

  late Future init;

  FireDangerRatingAPI() {
    init = fetchServerAddress();
  }

  Future<void> fetchServerAddress() async {
    serverBaseAddress =
        await LocalStorage().getServerAddress() ?? "http://localhost";
    return;
  }

  // Login a user
  Future<bool> login(String email, String password) async {
    await init;
    final String? token = await fetchAccessToken(email, password);
    if (token == null) {
      isLoggedIn = false;
      return false;
    }
    accessToken = token;
    userEmail = email;
    isLoggedIn = true; // TODO: isLoggedIn returns to false after code excecution.
    return true;
  }

  // Logout a user
  Future<void> logout() async {
    await init;
    try {
      await get("$serverBaseAddress/api/logout", false);
      isLoggedIn = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Create a new user account
  Future<bool> createAccount(String name, String email, String password,
      String confirmPassword, String suburb) async {
    await init;
    final dynamic responseData = await post(
      "$serverBaseAddress/api/register",
      jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
        "suburb": suburb,
      }),
      false,
    );

    // Check if the API response indicates success
    if (responseData.containsKey("data")) {
      // Account created successfully
      return true;
    } else {
      // Failed to create account
      return false;
    }
  }

  // Update a users primary and/or secondary (favourite) locations
  void updateUserLocations() async {}

  // Get primary and secondary user locations
  void getUserLocations() async {}

  // Get user location fire danger ratings (primary + secondary)
  void fetchUserLocationFireDangerRatings() async {}

  Future<FireDangerRating?> fetchFireDangerRatingForSuburb(
      String suburb) async {
    await init;
    final Map? responseData = await post(
        "$serverBaseAddress/api/fire-danger-ratings",
        jsonEncode({"suburb": suburb.toUpperCase()}),
        false);
    if (responseData == null || responseData.containsKey("error")) {
      return null;
    }
    Map<String, dynamic> ratings = responseData["fire_danger_ratings"];
    FireDangerRating fireDangerRating = FireDangerRating(
        issuedAt: ratings[ratings.keys.first]["issued_at"],
        ratings: ratings,
        weather: responseData["weather_forecast"]);
    LocalStorage().storeFireDangerRating(suburb, fireDangerRating);
    return fireDangerRating;
  }

  // Get all districts fire danger ratings
  Future<Map?> fetchAllDistrictFireDangerRatings() async {
    await init;
    final dynamic responseData =
        await get("$serverBaseAddress/api/all/fire-danger-ratings", false);
    if (responseData == null) {
      return null;
    }
    return responseData as Map;
  }

  // Fetch bearer token from the API
  Future<String?> fetchAccessToken(String email, String password) async {
    await init;
    final dynamic responseData = await post(
        "$serverBaseAddress/api/login",
        jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
        }),
        false);
    if (responseData == null) {
      return null;
    }
    return responseData["data"]["token"] as String;
  }

  Map<String, String> getHeaders(bool isProtectedRoute) {
    if (isProtectedRoute) {
      return {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    };
  }

  Future<dynamic> post(
      String endpointUrl, Object body, bool isProtectedRoute) async {
    await init;
    try {
      final response = await http.post(
        Uri.parse(endpointUrl),
        headers: getHeaders(isProtectedRoute),
        body: body,
      );
      final bodyJson = jsonDecode(response.body);
      return bodyJson;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> get(String endpointUrl, bool isProtectedRoute) async {
    await init;
    try {
      final response = await http.get(Uri.parse(endpointUrl),
          headers: getHeaders(isProtectedRoute));
      final bodyJson = jsonDecode(response.body);
      return bodyJson;
    } catch (e) {
      return null;
    }
  }
}
