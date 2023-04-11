import 'dart:collection';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mazenki/core/data/models/place.dart';
import 'package:mazenki/core/services/geofence.service.dart';
import 'package:mazenki/core/services/hive.service.dart';
import 'package:mazenki/core/services/location.service.dart';
import 'package:mazenki/core/vendors/get.it.dart';
import 'package:mazenki/helpers/ui/components/base.controller.dart';
import 'package:mazenki/helpers/utils/navigation.service.dart';
import 'package:mazenki/ui/home/widget/marker.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart' as pG;
import 'package:quick_notify/quick_notify.dart';

class HomeController extends BaseController {
  late MapboxMapController _mapController;
  bool isGeoFenceMode = false;
  var queueSMarkerStates = Queue<MarkerState>();
  var queueMarkers = Queue<Marker>();
  // var markerStates = <MarkerState>[];
  // var markers = <Marker>[];
  onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    showMyLocation();
    locator.getAsync<HiveService>().then(
      (value) {
        value.placeBox.values.map((e) {
          drawFill(geometry: e.fillGeometry, color: "#52B5AC");
        });
      },
    );
    // .then((value) {
    // .map((e) {

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
    _mapController.removeFills(_mapController.fills);
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
    queueMarkers.add(Marker(
        id: point.toString(),
        intialPosition: point,
        coordinate: coordinate,
        addMarkerState: addMarkerState,
        child: markerWidget));
    notifyListeners();
  }

  void removeMarker({required String markerId}) {
    queueSMarkerStates.removeWhere((element) => element.id == markerId);
    queueMarkers.removeWhere((element) => element.id == markerId);
    notifyListeners();
  }

  void addMarkerState(MarkerState state) {
    queueSMarkerStates.add(state);
  }

  void updateMarkerPosition() {
    final coordinates = <LatLng>[];
    for (var item in queueSMarkerStates) {
      coordinates.add(item.getCoordinate());
    }

    _mapController.toScreenLocationBatch(coordinates).then((points) {
      queueMarkers.toList().asMap().forEach((key, value) {
        queueSMarkerStates.toList()[key].updatePosition(points[key]);
        // markerStates[key].updatePosition(points[key]);
        notifyListeners();
      });
    });
  }

  void undoMark() {
    if (queueMarkers.isNotEmpty) {
      queueMarkers.removeLast();
      queueSMarkerStates.removeLast();
      notifyListeners();
    }
  }

  void drawFill({required List<List<LatLng>> geometry, required String color}) {
    _mapController.addFill(
      FillOptions(geometry: geometry, fillColor: color, fillOpacity: 1),
    );
  }

  void fillArea({required BuildContext context}) {
    if (queueSMarkerStates.length < 5) {
      locator.get<NavigationService>().openDialog(
              content: const AlertDialog(
            title: Text("Info"),
            content: Text(
                "Please you must select at least five (5) point to make a fence"),
          ));
      return;
    }
    final coordinates = <LatLng>[];
    for (var item in queueSMarkerStates) {
      coordinates.add(item.getCoordinate());
    }
    var geometry = [coordinates];
    _mapController
        .addFill(
      FillOptions(geometry: geometry, fillColor: "#6750A4", fillOpacity: 1),
    )
        .then((value) {
      saveGeofence(geometry: geometry, name: Faker().address.streetName());
      queueMarkers.clear();
      queueSMarkerStates.clear();
      notifyListeners();
      // _mapController.removeFills(_mapController.fills).then((value) {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(const SnackBar(content: Text("Done")));
      //   queueMarkers.clear();
      //   queueSMarkerStates.clear();
      //   notifyListeners();
      // });
    });
  }

  void saveGeofence(
      {required List<List<LatLng>> geometry, required String name}) {
    var place = Place.fromMap(name: name, geometry: geometry);
    GeoFencService.addNewGeofencing(place: place);
  }

  void initGeoFenceStatus() {
    polyGeofenceService
        .addPolyGeofenceStatusChangeListener(onPolyGeofenceStatusChanged);
    polyGeofenceService.addLocationChangeListener(onLocationChanged);
    polyGeofenceService.addLocationServicesStatusChangeListener(
        onLocationServicesStatusChanged);
    polyGeofenceService.addStreamErrorListener(onError);
    locator.getAsync<HiveService>().then((value) {
      var places = value.placeBox.values.map((e) {
        return pG.PolyGeofence(id: e.id, polygon: e.geometry);
      }).toList();

      polyGeofenceService.start(places).then((value) {
        var navigationService = locator.get<NavigationService>();
        navigationService.showSnackBar(
            message: "${places.length} loaded with success");
        if (kDebugMode) {
          print("Geofence service started with success");
        }
      }).catchError(onError);
    });
    // var places =
  }

  void onCircleClick() {
    var navigationService = locator.get<NavigationService>();
    navigationService.openDialog(
        content: AlertDialog(
      title: const Text("Info"),
      content: const Text("This works"),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        TextButton(
            onPressed: () {
              navigationService.navigatoryKey.currentState?.pop();
              QuickNotify.hasPermission().then((value) {
                print(value);
              });
            },
            child: const Text("Ok")),
        TextButton(onPressed: () {}, child: const Text("Tell me more")),
      ],
    ));
  }
}
