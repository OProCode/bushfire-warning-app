
import'dart:math';
import 'suburbs.dart';

double haversine(double lat1, double long1, double lat2, double long2) {
  var R = 6371; 
  var dlat = deg2rad(lat2-lat1);
  var dlong = deg2rad(long2-long1);
  var a = sin(dlat/2) * sin(dlat/2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dlong/2) * sin(dlong/2); 
  var c = 2 * atan2(sqrt(a), sqrt(1-a)); 
  var d = R * c;
  return d;
}

double deg2rad(double deg) {
  return deg * (pi/180);
}

String closestSuburb(double latitude, double longitude) {
  String closestSuburbName = "";
  double closestSuburbDistance = double.maxFinite;
  allSuburbs.forEach((key, value) {    
    double distance = haversine(latitude, longitude, value["latitude"], value["longitude"]);
    if (distance < closestSuburbDistance) {
      closestSuburbDistance = distance;
      closestSuburbName = key;
    }
  }); 
  return closestSuburbName;
}

List<String> postcodeToSuburbs(postcode) {
  List<String> foundSuburbs = [];
  allSuburbs.forEach((String key, value) {
    if (value["postcodes"].contains(postcode.toString())) {
      foundSuburbs.add(key);
    }
  });
  return foundSuburbs;
}

String suburbToPostcode(String suburb) {
  final Map? foundSuburb = allSuburbs[suburb.toUpperCase()];
  if (foundSuburb != null && foundSuburb["postcodes"].length > 0) {
    int lowestPostcode = int.parse(foundSuburb["postcodes"][0]);
    foundSuburb["postcodes"].forEach((postcode) {
      if (int.parse(postcode) < lowestPostcode) {
        lowestPostcode = postcode;
      }
    });
    return lowestPostcode.toString();
  } else {
    return "0000";
  }
}

Map<String, double>? suburbToCoordinates(String suburb) {
  final Map? foundSuburb = allSuburbs[suburb.toUpperCase()];
  if (foundSuburb == null) {
    return null;
  }
  return {
    "latitude": foundSuburb["latitude"],
    "longitude": foundSuburb["longitude"]
  };
}

String decimalDirectionToCompassBearing(double decimalDirection) {
  if (decimalDirection > 360) {
    return "";
  }
  return ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"][(decimalDirection/45).round()];
}