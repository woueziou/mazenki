import 'package:hive/hive.dart';
import 'package:mazenki/core/data/models/place.coord.dart';
import 'package:mazenki/core/data/models/place.dart';

class HiveService {
  late Box<Place> placeBox;
  late Box<PlaceGeoCodes> placeGeoBox;
  Future<void> init() async {
    _registerAdapter();
    await _initBoxes();
  }

  void _registerAdapter() {
    Hive.registerAdapter(PlaceAdapter());
    Hive.registerAdapter(PlaceGeoCodesAdapter());
  }

  Future<void> _initBoxes() async {
    placeBox = await Hive.openBox<Place>(Place.boxName);
    placeGeoBox = await Hive.openBox<PlaceGeoCodes>(PlaceGeoCodes.boxName);
  }
}
