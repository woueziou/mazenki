import 'package:mapbox_gl/mapbox_gl.dart';

class Place {
  final List<LatLng> points;
  final String name;
  Place(
    this.name, {
    required this.points,
  });
}
