import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class FireDangerMap extends StatefulWidget {

  final MapController mapController;

  const FireDangerMap({super.key, required this.mapController});

  @override
  State<FireDangerMap> createState() => _FireDangerMapState();
}

class _FireDangerMapState extends State<FireDangerMap> {
  
  void _zoomIn() {
    widget.mapController.zoomIn();
  }

  void _zoomOut() {
    widget.mapController.zoomOut();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [        
        Column(
          children: [
            SizedBox(
              height: 140,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 230,
              child: OSMFlutter(
                controller: widget.mapController,
                osmOption: OSMOption(
                  userTrackingOption: const UserTrackingOption(
                    enableTracking: false,
                    unFollowUser: false,
                  ),
                  zoomOption: const ZoomOption(
                    initZoom: 12,
                    minZoomLevel: 3,
                    maxZoomLevel: 19,
                    stepZoom: 1.0,
                  ),
                  userLocationMarker: UserLocationMaker(
                    personMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.location_history_rounded,
                        color: Colors.red,
                        size: 48,
                      ),
                    ),
                    directionArrowMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.double_arrow,
                        size: 48,
                      ),
                    ),
                  ),
                  roadConfiguration: const RoadOption(
                    roadColor: Colors.yellowAccent,
                  ),
                  markerOption: MarkerOption(
                      defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 56,
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 50,
          right: 15,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: _zoomIn,
                mini: true,
                child: const Icon(Icons.zoom_in),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                elevation: 10,
                onPressed: _zoomOut,
                mini: true,
                child: const Icon(Icons.zoom_out),
              ),
            ],
          ),
        ),
      ],
    );
  }
}