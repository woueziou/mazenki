import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class LocationService {
  Future<LatLng> currentLatLng() async {
    if (await canIUseLocation()) {
      var location = await Geolocator.getCurrentPosition();
      return LatLng(location.latitude, location.longitude);
    }
    return const LatLng(6.1319, 1.2225);
  }

  late LocationSettings locationSettings;
  Future<bool> canIUseLocation() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      var permissionStatus = await Geolocator.checkPermission();
      if (permissionStatus == LocationPermission.deniedForever) {
        return false;
      } else {
        permissionStatus = await Geolocator.requestPermission();
        // if (
        return permissionStatus != LocationPermission.denied;
        // )
        // {

        //   Geolocator.getCurrentPosition().then((value) => _fastPostion = value);
        // }
      }
    }
    return false;
  }
}
