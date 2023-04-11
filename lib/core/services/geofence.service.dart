import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mazenki/core/data/models/place.dart';
import 'package:mazenki/core/services/hive.service.dart';
import 'package:mazenki/core/vendors/get.it.dart';
import 'package:mazenki/helpers/utils/navigation.service.dart';
import 'package:mazenki/ui/setting/setting.controller.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
import 'package:quick_notify/quick_notify.dart';

class GeoFencService {
  static void addNewGeofencing({required Place place}) {
    var pG = PolyGeofence(id: place.id, polygon: place.geometry);
    polyGeofenceService.addPolyGeofence(pG);
    locator.getAsync<HiveService>().then((value) {
      value.placeBox.put(place.id, place);
    });
    // place.box?.put(place.id, place);
    // place.save().then((value) {
    //   print("Place have been saved");
    // });
  }
  // late PolyGeofenceService _polyService;
  // GeoFencService() {
  //   _polyService =
  // }

  // static PolyGeofenceService get service {
  //   return PolyGeofenceService.instance.setup(
  //       interval: 5000,
  //       accuracy: 100,
  //       loiteringDelayMs: 60000,
  //       statusChangeDelayMs: 10000,
  //       allowMockLocations: false,
  //       printDevLog: false);
  // }
}

final polyGeofenceService = PolyGeofenceService.instance.setup(
    interval: 5000,
    accuracy: 100,
    loiteringDelayMs: 60000,
    statusChangeDelayMs: 10000,
    allowMockLocations: false,
    printDevLog: false);
// This function is to be called when the geofence status is changed.
Future<void> onPolyGeofenceStatusChanged(PolyGeofence polyGeofence,
    PolyGeofenceStatus polyGeofenceStatus, Location location) async {
  var navigationService = locator.get<NavigationService>();
  var settingController = locator.get<SettingController>();
  if (polyGeofenceStatus == PolyGeofenceStatus.DWELL) {
    settingController.toggleIsInGeofence(true);
    navigationService.openDialog(
        content: AlertDialog(
      title: const Text("Info"),
      content: const Text("You are in a geofence zone"),
      actions: [
        TextButton(
            onPressed: () {
              navigationService.navigatoryKey.currentState?.pop();
            },
            child: const Text("Ok")),
        TextButton(onPressed: () {}, child: const Text("Tell me more")),
      ],
    ));
  }
  if (polyGeofenceStatus == PolyGeofenceStatus.ENTER) {
    QuickNotify.notify(
      title: 'Mazenki',
      content: 'You are in Ekpaye zone ! click to access the app',
    );
    settingController.toggleIsInGeofence(true);
    navigationService.openDialog(
        content: AlertDialog(
      title: const Text("Info"),
      content: const Text("You entered in a known geofence zone"),
      actions: [
        TextButton(
            onPressed: () {
              navigationService.navigatoryKey.currentState?.pop();
            },
            child: const Text("Ok")),
        TextButton(onPressed: () {}, child: const Text("Tell me more")),
      ],
    ));
    if (kDebugMode) {
      print(polyGeofence.id);
    }
  }
  if (polyGeofenceStatus == PolyGeofenceStatus.EXIT) {
    QuickNotify.notify(
      title: 'Mazenki',
      content: 'You just exit a zone',
    );
    // var hiveService = await locator.getAsync<HiveService>();
    navigationService.openDialog(
        content: AlertDialog(
      title: Text(
        "Info",
      ),
      content: Text("You leave a place"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
            onPressed: () {
              navigationService.navigatoryKey.currentState?.pop();
            },
            child: const Text("Ok")),
        // TextButton(onPressed: () {}, child: const Text("Tell me more")),
      ],
    ));
    var settingController = locator.get<SettingController>();
    settingController.toggleIsInGeofence(false);
    if (kDebugMode) {
      print(polyGeofence.id);
    }
  }
}

// This function is to be called when the location has changed.
void onLocationChanged(Location location) {
  if (kDebugMode) {
    print('location: ${location.toJson()}');
  }
}

// This function is to be called when a location services status change occurs
// since the service was started.
void onLocationServicesStatusChanged(bool status) {
  if (kDebugMode) {
    print('isLocationServicesEnabled: $status');
  }
}

// This function is used to handle errors that occur in the service.
FutureOr<Null> onError(error) async {
  final errorCode = getErrorCodesFromError(error);
  if (errorCode == null) {
    if (kDebugMode) {
      print('Undefined error: $error');
    }
    return;
  }

  if (kDebugMode) {
    print('ErrorCode: $errorCode');
  }
}

// @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     _polyGeofenceService.addPolyGeofenceStatusChangeListener(_onPolyGeofenceStatusChanged);
//     _polyGeofenceService.addLocationChangeListener(_onLocationChanged);
//     _polyGeofenceService.addLocationServicesStatusChangeListener(_onLocationServicesStatusChanged);
//     _polyGeofenceService.addStreamErrorListener(_onError);
//     _polyGeofenceService.start(_polyGeofenceList).catchError(_onError);
//   });
// }