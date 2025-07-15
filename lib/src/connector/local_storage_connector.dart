import 'package:bushfire_warning_app/src/models/fire_danger_rating.dart';
import 'package:hive_flutter/adapters.dart';


class LocalStorage {

  late Box firewatchBox;
  late Future init;

  LocalStorage() {
    init = initialiseLocalStorage();
  }

  Future<void> initialiseLocalStorage() async {
    await Hive.initFlutter();
    firewatchBox = await Hive.openBox("firewatch_wa");
    if (firewatchBox.get("serverAddress") == null) {
      firewatchBox.put("serverAddress", "http://localhost");
    }
    return;
  }

  Future<FireDangerRating?> getFireDangerRatingIfExists(String suburbName) async {
    await init;
    String? fireDangerRatingString = firewatchBox.get(suburbName.toUpperCase());
    if (fireDangerRatingString == null) {
      return null;
    }
    return FireDangerRating.fromJsonString(fireDangerRatingString);
  }

  Future<void> storeFireDangerRating(String suburubName, FireDangerRating fireDangerRating) async {
    await init;
    firewatchBox.put(suburubName.toUpperCase(), fireDangerRating.toJsonString());
    return;
  }

  Future<String?> getCurrentSuburb() async {
    await init;
    return firewatchBox.get("currentSuburb");
  }

  Future<void> storeCurrentSuburb(String currentSuburb) async {
    await init;
    firewatchBox.put("currentSuburb", currentSuburb);
    return;
  }

  Future<void> clearLocalStorage() async {
    await init;
    firewatchBox.clear();
    return;
  }

  Future<void> storeServerAddress(String serverAddress) async {
    await init;
    firewatchBox.put("serverAddress", serverAddress);
    return;
  }

  Future<String?> getServerAddress() async {
    await init;
    return firewatchBox.get("serverAddress");
  }

}