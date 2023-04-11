import 'package:hive/hive.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart' as pg;
import 'package:uuid/uuid.dart';

import 'place.coord.dart';
part 'place.g.dart';

@HiveType(typeId: 0)
class Place extends HiveObject {
  static String boxName = "placeBox";
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  List<List<PlaceGeoCodes>> places;
  @HiveField(3)
  DateTime? dateCreated;

  Place({required this.id, required this.name, required this.places}) {
    dateCreated = DateTime.now();
  }

  factory Place.fromMap(
      {required String name, required List<List<LatLng>> geometry}) {
    var listOfListofPoints = <List<PlaceGeoCodes>>[];
    for (var elements in geometry) {
      var listOfplace = <PlaceGeoCodes>[];
      for (var child in elements) {
        listOfplace.add(PlaceGeoCodes.fromLatLng(child));
      }

      listOfListofPoints.add(listOfplace);
    }
    return Place(id: const Uuid().v4(), name: name, places: listOfListofPoints);
  }

  List<pg.LatLng> get geometry {
    var data = <pg.LatLng>[];
    for (var element in places) {
      for (var e in element) {
        var tmp = pg.LatLng(e.lat, e.long);
        data.add(tmp);
      }
    }
    return data;
  }

  List<List<LatLng>> get fillGeometry {
    var data = <List<LatLng>>[];
    for (var elements in places) {
      var list = <LatLng>[];
      for (var element in elements) {
        list.add(element.latLng);
      }
      data.add(list);
    }
    return data;
  }
}
