import 'dart:convert';

class FireDangerRating {

  final String issuedAt;
  final Map<String, dynamic> ratings;
  final Map<String, dynamic> weather;

  FireDangerRating({
    required this.issuedAt,
    required this.ratings,
    required this.weather
  });

  String toJsonString() {
    return jsonEncode({
      "issuedAt": issuedAt,
      "ratings": ratings,
      "weather": weather
    });
  }

  static FireDangerRating fromJsonString(jsonString) {
    Map<String, dynamic> fireDangerRatingMap = jsonDecode(jsonString);
    return FireDangerRating(
      issuedAt: fireDangerRatingMap["issuedAt"], 
      ratings: fireDangerRatingMap["ratings"], 
      weather: fireDangerRatingMap["weather"]
    );
  }

}