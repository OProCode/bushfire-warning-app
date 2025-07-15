import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../firebase_options.dart';
import 'package:bushfire_warning_app/src/connector/local_storage_connector.dart';

class FcmNotifications {
  late Future init;
  late Box firewatchBox;

  FcmNotifications() {
    init = initialize();
  }

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // generate instances for firebase messaging service and shared preferences

    //get user token and set it to a strings list shared preference.
    // the token should be both the key and the value
  }

  Future<void> checkNotificationPermission(BuildContext context) async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging newFCMInstance = FirebaseMessaging.instance;
      LocalStorage newLocalStorageInstance = LocalStorage();

      NotificationSettings userSettings =
          await newFCMInstance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (context.mounted) {
        if (userSettings.authorizationStatus ==
            AuthorizationStatus.authorized) {
          String? nullableToken = await newFCMInstance.getToken();
          if (nullableToken != null) {
            String token = nullableToken.toString();
            newLocalStorageInstance.storeFcmToken(token);
            newLocalStorageInstance.getFcmToken().then((value){
              print(value);
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            'Notifications are disabled for this device. To see notifications from this app, please enable them in'
            'your device settings',
            softWrap: true,
          )));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Firebase serviced used before initialize completed or firebase initialization failed.',
          softWrap: true,
        )));
      }
    }
  }

  //
}
