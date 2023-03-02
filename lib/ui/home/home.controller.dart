import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mazenki/app/built_assets/assets.gen.dart';
import 'package:mazenki/core/data/models/place.dart';
import 'package:mazenki/core/services/location.service.dart';
import 'package:mazenki/core/vendors/get.it.dart';
import 'package:mazenki/helpers/ui/components/base.controller.dart';
import 'package:mazenki/ui/home/widget/marker.dart';

class HomeController extends BaseController {
  late MapboxMapController _mapController;
  bool isGeoFenceMode = false;
  var markerStates = <MarkerState>[];
  var markers = <Marker>[];
  onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    showMyLocation();
    _mapController.addListener(() {
      if (_mapController.isCameraMoving) {
        updateMarkerPosition();
      }
    });
  }

  var selectesPlaces = <LatLng>[];
  Future<void> showMyLocation() async {
    var currentLocation = await locator.get<LocationService>().currentLatLng();
    await _mapController.animateCamera(CameraUpdate.zoomIn());
    await _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 15));
  }

  void toggleGeofenceMode() {
    isGeoFenceMode = !isGeoFenceMode;
    notifyListeners();
  }

  void addPointToList(LatLng coord) {
    selectesPlaces.add(coord);
    // _mapController.to
    // _mapController.ad
    notifyListeners();
  }

  void removePoint(LatLng coord) {
    selectesPlaces.removeWhere((element) =>
        element.latitude == coord.latitude &&
        element.longitude == coord.longitude);
    notifyListeners();
  }

  void addMarker(Point point, LatLng coordinate, Widget markerWidget) {
    markers.add(Marker(
        id: point.toString(),
        intialPosition: point,
        coordinate: coordinate,
        addMarkerState: addMarkerState,
        child: markerWidget));
    notifyListeners();
  }

  void removeMarker({required String markerId}) {
    markerStates.removeWhere((element) => element.id == markerId);
    markers.removeWhere((element) => element.id == markerId);
    notifyListeners();
  }

  void addMarkerState(MarkerState state) {
    markerStates.add(state);
  }

  void updateMarkerPosition() {
    final coordinates = <LatLng>[];
    for (var item in markerStates) {
      coordinates.add(item.getCoordinate());
    }

    _mapController.toScreenLocationBatch(coordinates).then((points) {
      markerStates.asMap().forEach((key, value) {
        markerStates[key].updatePosition(points[key]);
        // notifyListeners();
      });
    });
  }

  void fillArea() {
    final coordinates = <LatLng>[];
    for (var item in markerStates) {
      coordinates.add(item.getCoordinate());
    }
    var geometry = [coordinates];
    _mapController.addFill(
      FillOptions(geometry: geometry, fillColor: "#6750A4", fillOpacity: 0.5),
    );
  }
}
