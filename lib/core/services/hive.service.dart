import 'package:hive/hive.dart';
import 'package:mazenki/core/data/models/place.coord.dart';
import 'package:mazenki/core/data/models/place.dart';

class HiveService {
  static HiveService? _instance;
  late Box<Place> placeBox;
  late Box<PlaceGeoCodes> placeGeoBox;
  Future<HiveService> init() async {
    if (_instance != null) {
      _instance = this;
      return _instance!;
    }

    _registerAdapter();
    await _initBoxes();
    _instance = this;
    return _instance!;
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
