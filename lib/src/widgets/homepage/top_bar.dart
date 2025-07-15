import 'package:bushfire_warning_app/src/connector/fire_danger_rating_api_connector.dart';
import 'package:bushfire_warning_app/src/connector/local_storage_connector.dart';
import 'package:bushfire_warning_app/src/models/fire_danger_rating.dart';
import 'package:bushfire_warning_app/src/providers/data_provider.dart';
import 'package:bushfire_warning_app/src/utils/format.dart';
import 'package:bushfire_warning_app/src/utils/geo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';


class TopBar extends StatefulWidget {
  const TopBar({super.key});
  
  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                (Theme.of(context).colorScheme.secondary),
                (Theme.of(context).colorScheme.tertiary),
              ]
            )
          ),
          child: Column(
            children: [
              FutureBuilder(future: Provider.of<DataProvider>(context).getCurrentSuburb(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == null) {
                    return const Text("Error, no suburb could be found."); // TODO
                  }
                  return FutureBuilder(future: FireDangerRatingAPI().fetchFireDangerRatingForSuburb((snapshot.data)!), builder: (context, apiSnapshot) {
                    if (apiSnapshot.hasData) {
                      if (apiSnapshot.data == null) {
                        return const Text("Failed to fetch data from API");
                      }
                      return TopBarContent(
                        fireDangerRating: (apiSnapshot.data)!, 
                        suburbName: (snapshot.data)!,
                        isOffline: false,
                      );
                    } else {
                      return FutureBuilder(future: LocalStorage().getFireDangerRatingIfExists((snapshot.data)!), builder: (context, localSnapshot) {
                        if (localSnapshot.hasData) {
                          if (localSnapshot.data == null) {
                            return const Text("No local data, loading from API..");
                          }
                          return TopBarContent(
                            fireDangerRating: (localSnapshot.data)!, 
                            suburbName: (snapshot.data)!,
                            isOffline: true,
                          );
                        } else {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 6,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.amber[400],
                                    color: Colors.red,
                                  ),
                                ),
                                const Icon(Icons.offline_bolt_outlined, color: Colors.white70, size: 32,),
                                const Text("Our data server appears to be offline",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16
                                  ),
                                ),
                                const Text("Please wait or close the app and try again later",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16
                                  ),
                                ),
                              ]
                            ),
                          );
                        }
                      });
                    }
                  });
                } else {
                  return const Text("");
                }
              }),
            ],
          )
        ),
        ClipPath(
          clipper: WaveClipperOne(flip: true, reverse: false),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [(Colors.amber[900])!, Colors.red],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TopBarContent extends StatefulWidget {

  final FireDangerRating fireDangerRating;
  final String suburbName;
  final bool isOffline;
  const TopBarContent({super.key, required this.fireDangerRating, required this.suburbName, required this.isOffline});

  @override
  State<TopBarContent> createState() => _TopBarContentState();
}

class _TopBarContentState extends State<TopBarContent> {

  int dayIndex = 0;

  void onNextTapped() {
    if (dayIndex < 3) {
      setState(() {
        dayIndex += 1;
      });
    }
  }

  void onPrevTapped() {
    if (dayIndex > 0) {
      setState(() {
        dayIndex -= 1;
      });
    }
  }

  Map<String, dynamic> getCurrentDayRating(FireDangerRating fireDangerRating) {
    return {
      "issuedAt": fireDangerRating.issuedAt,
      "rating": fireDangerRating.ratings[fireDangerRating.ratings.keys.toList()[dayIndex]],
      "weather": fireDangerRating.weather[fireDangerRating.ratings.keys.toList()[dayIndex]],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white24))
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Last Issued At: ${getCurrentDayRating(widget.fireDangerRating)["issuedAt"]}",
                  style: const TextStyle(
                    color: Colors.white60
                  ),
                ),
                Row(
                  children: [
                    if (widget.isOffline)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white60,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(width: 8),
                    Icon(
                      widget.isOffline ? Icons.wifi_off_rounded : Icons.wifi_rounded,
                      color: Colors.white60,
                      size: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("${widget.suburbName}, ${suburbToPostcode(widget.suburbName)}, WA, AUSTRALIA",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [                    
                    IconButton(
                      onPressed: dayIndex == 0 ? null : onPrevTapped, 
                      icon: Icon(
                        Icons.arrow_back_ios, 
                        size: 16, 
                        color: dayIndex == 0 ? Colors.amber[800] : Colors.white
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                    Text(formatDate(widget.fireDangerRating.ratings.keys.toList()[dayIndex]),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white
                      ),
                    ),
                    IconButton(
                      onPressed: dayIndex == 3 ? null : onNextTapped, 
                      icon: Icon(
                        Icons.arrow_forward_ios, 
                        size: 16, 
                        color: dayIndex == 3 ?  Colors.amber[800] : Colors.white
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
            child: Row(
              children: [
                if (getCurrentDayRating(widget.fireDangerRating)["rating"]["rating_level"] > 49)
                  Icon(Icons.warning_amber_rounded,
                    size: 36,
                    color: Colors.red[900],
                  ),
                const Icon(Icons.local_fire_department,
                  size: 36,
                  color: Colors.white,
                ),
                Text(getCurrentDayRating(widget.fireDangerRating)["rating"]["rating_level"].toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(width: 8),
                Text(getCurrentDayRating(widget.fireDangerRating)["rating"]["rating_name"].toString().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text("Temp Low",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70
                      ),
                    ),
                    Text("${getCurrentDayRating(widget.fireDangerRating)["weather"]["temp_min"].round().toString()} °C",
                      style: const TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Temp High",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70
                      ),
                    ),
                    Text("${getCurrentDayRating(widget.fireDangerRating)["weather"]["temp_max"].round().toString()} °C",
                      style: const TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Rain",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70
                      ),
                    ),
                    Text("${getCurrentDayRating(widget.fireDangerRating)["weather"]["showers_sum"].round().toString()} mm",
                      style: const TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Wind Speed Max",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70
                      ),
                    ),
                    Text(
                      "${
                          getCurrentDayRating(widget.fireDangerRating)["weather"]["wind_speed_max"].round().toString()
                        } km/h ${
                          decimalDirectionToCompassBearing(getCurrentDayRating(widget.fireDangerRating)["weather"]["wind_direction"])
                        }",
                      style: const TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Wind Gusts Max",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70
                      ),
                    ),
                    Text(
                      "${
                          getCurrentDayRating(widget.fireDangerRating)["weather"]["wind_gusts_max"].round().toString()
                        } km/h ${
                          decimalDirectionToCompassBearing(getCurrentDayRating(widget.fireDangerRating)["weather"]["wind_direction"])
                        }",
                      style: const TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
