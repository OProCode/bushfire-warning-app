import 'package:bushfire_warning_app/src/connector/local_storage_connector.dart';
import 'package:bushfire_warning_app/src/utils/geo.dart';
import 'package:bushfire_warning_app/src/utils/gps.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bushfire_warning_app/src/connector/fire_danger_rating_api_connector.dart';

class DataProvider with ChangeNotifier {
  final LocalStorage localStorage = LocalStorage();
  String? _currentSuburb;

  Future<String> getCurrentSuburb() async {
    if (_currentSuburb != null) {
      return (_currentSuburb)!;
    }
    Position? gpsPosition = await getGPS();
    if (gpsPosition == null) {
      String? localCurrentSuburb = await LocalStorage().getCurrentSuburb();
      if (localCurrentSuburb != null) {
        _currentSuburb = localCurrentSuburb;
        return localCurrentSuburb;
      }
    } else {
      String closestSuburbToGps =
          closestSuburb(gpsPosition.latitude, gpsPosition.longitude);
      _currentSuburb = closestSuburbToGps;
      return closestSuburbToGps;
    }
    return "PERTH";
  }

  void setCurrentSuburb(suburbName) {
    _currentSuburb = suburbName;
    return;
  }

  Future<String> getCurrentPostcode() async {
    if (_currentSuburb != null) {
      return suburbToPostcode((_currentSuburb)!);
    }
    String currentSuburb = await getCurrentSuburb();
    return suburbToPostcode(currentSuburb);
  }

  Future<void> refreshPage() async {
    notifyListeners();
  }
}
