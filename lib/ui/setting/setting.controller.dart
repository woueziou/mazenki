import 'package:mazenki/helpers/ui/components/base.controller.dart';

class SettingController extends BaseController {
  bool isInDesignatedPlace = false;

  void toggleIsInGeofence(bool state) {
    isInDesignatedPlace = state;
    notifyListeners();
  }
}
