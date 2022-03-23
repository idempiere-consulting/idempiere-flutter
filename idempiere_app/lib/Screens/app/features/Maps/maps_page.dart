import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class MobileMapsScreen extends StatefulWidget {
  const MobileMapsScreen({Key? key}) : super(key: key);

  @override
  _MobileMapsScreenState createState() => _MobileMapsScreenState();
}

class _MobileMapsScreenState extends State<MobileMapsScreen> {
  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  bool _isShowLocMarker = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(0, 0),
            zoom: 1,
            maxZoom: 19,
            // Stop centering the location marker on the map if user interacted with the map.
            onPositionChanged: (MapPosition position, bool hasGesture) {
              if (hasGesture) {
                setState(
                  () => _centerOnLocationUpdate = CenterOnLocationUpdate.never,
                );
              }
            },
          ),
          children: [
            TileLayerWidget(
              options: TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                maxZoom: 19,
              ),
            ),
            if (_isShowLocMarker)
              LocationMarkerLayerWidget(
                plugin: LocationMarkerPlugin(
                  centerCurrentLocationStream:
                      _centerCurrentLocationStreamController.stream,
                  centerOnLocationUpdate: _centerOnLocationUpdate,
                ),
              ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 80,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () => setState(() {
                  _isShowLocMarker = false;
                  _centerCurrentLocationStreamController.close();
                }),
                child: const Icon(
                  Icons.gps_off,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  // Automatically center the location marker on the map when location updated until user interact with the map.
                  setState(() {
                    if (!_isShowLocMarker) {
                      _centerCurrentLocationStreamController =
                          StreamController<double>();
                    }
                    _centerOnLocationUpdate = CenterOnLocationUpdate.once;
                    _isShowLocMarker = true;
                  });
                  // Center the location marker on the map and zoom the map to level 18.
                  _centerCurrentLocationStreamController.add(18);
                },
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
