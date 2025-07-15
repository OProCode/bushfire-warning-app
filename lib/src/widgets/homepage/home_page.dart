import 'package:bushfire_warning_app/src/providers/data_provider.dart';
import 'package:bushfire_warning_app/src/utils/geo.dart';
import 'package:bushfire_warning_app/src/widgets/homepage/map.dart';
import 'package:bushfire_warning_app/src/widgets/homepage/top_bar.dart';
import 'package:bushfire_warning_app/src/notifications/fcm_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
<<<<<<< HEAD
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.currentSuburb});

  final String currentSuburb;
  //
=======
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
>>>>>>> d49718e90294917abd8737ea51a445ad6ec77a77

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
<<<<<<< HEAD
  late Future<FireDangerRating?> data;
  late Future<String> issuedAt;
  late FcmNotifications notificationContext = Get.find<FcmNotifications>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationContext.checkNotificationPermission(context);
    });
    fetchSuburbData();
  }

  Future<void> fetchSuburbData() async {
    final FireDangerRatingAPI fireDangerRatingAPI = FireDangerRatingAPI();
    data = fireDangerRatingAPI
        .fetchFireDangerRatingForSuburb(widget.currentSuburb);
    issuedAt = data.then((value) => (value)!.issuedAt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firewatch WA'),
      ),
      body: Stack(
        children: [
          const FireDangerMap(),
          // HomePageContent(currentSuburb: widget.currentSuburb, issuedAt: issuedAt),
          TopBar(data: data),
        ],
      ),
=======

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(future: Provider.of<DataProvider>(context).getCurrentSuburb(), builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Text("ERROR");
            }
            Map<String, double>? suburbCoordinates = suburbToCoordinates((snapshot.data)!);
            suburbCoordinates ??= suburbToCoordinates("PERTH");
            MapController mapController = MapController(
              initPosition: GeoPoint(latitude: (suburbCoordinates?["latitude"])!, longitude: (suburbCoordinates?["longitude"])!)
            );
            return FireDangerMap(mapController: mapController);
          } else {
            return const Text("LOADING...");
          }
        }),
        const TopBar(),        
      ],
>>>>>>> d49718e90294917abd8737ea51a445ad6ec77a77
    );
  }
}
