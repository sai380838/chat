import 'dart:async';
import 'package:chat/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LiveMapPage extends StatefulWidget {
  const LiveMapPage({super.key});

  @override
  State<LiveMapPage> createState() => _LiveMapPageState();
}

class _LiveMapPageState extends State<LiveMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentLatLng;
  Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
    LocationService.locationStream().listen((position) {
      setState(() {
        _currentLatLng = LatLng(position.latitude, position.longitude);
        _polygons = _createRectangle(_currentLatLng!);
      });
    });
  }

  Future<void> _initLocation() async {
    final pos = await LocationService.getCurrentLocation();
    _currentLatLng = LatLng(pos.latitude, pos.longitude);
    _polygons = _createRectangle(_currentLatLng!);
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_currentLatLng!, 15));
    setState(() {});
  }

  Set<Polygon> _createRectangle(LatLng center) {
    const offset = 0.009; // approx 1km in degrees (~111km/degree)
    final p1 = LatLng(center.latitude - offset, center.longitude - offset);
    final p2 = LatLng(center.latitude - offset, center.longitude + offset);
    final p3 = LatLng(center.latitude + offset, center.longitude + offset);
    final p4 = LatLng(center.latitude + offset, center.longitude - offset);

    return {
      Polygon(
        polygonId: const PolygonId('2km_area'),
        points: [p1, p2, p3, p4],
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeWidth: 2,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Map")),
      body: _currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLatLng!,
                zoom: 15,
              ),
              polygons: _polygons,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) => _controller.complete(controller),
            ),
    );
  }
}
