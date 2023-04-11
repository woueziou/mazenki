import 'package:hive/hive.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
part 'place.coord.g.dart';

@HiveType(typeId: 1)
class PlaceGeoCodes {
  @HiveField(0)
  final double lat;
  @HiveField(1)
  final double long;

  static String boxName = "placegeo";
  PlaceGeoCodes({
    required this.long,
    required this.lat,
  });

  factory PlaceGeoCodes.fromLatLng(LatLng latLng) {
    return PlaceGeoCodes(long: latLng.longitude, lat: latLng.latitude);
  }

  LatLng get latLng {
    return LatLng(lat, long);
  }
}
