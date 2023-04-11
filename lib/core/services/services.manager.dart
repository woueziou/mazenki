import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mazenki/core/services/location.service.dart';
import 'package:mazenki/core/vendors/get.it.dart';
import 'package:mazenki/helpers/utils/navigation.service.dart';
import 'package:mazenki/ui/home/home.controller.dart';
import 'package:mazenki/ui/setting/setting.controller.dart';
import 'package:mazenki/ui/splash/splash.controller.dart';

import 'hive.service.dart';

class ServiceManager {
  static Future<void> initApp() async {
    await dotenv.load();
    await Hive.initFlutter();
    _initServices();
    _initControllers();
  }

  static void _initServices() {
    locator.registerSingletonAsync<HiveService>(() async {
      final service = await HiveService().init();
      return service;
    });
    locator.registerLazySingleton<LocationService>(() => LocationService());
    locator.registerLazySingleton<NavigationService>(() => NavigationService());
  }

  static void _initControllers() {
    locator.registerLazySingleton<SplashController>(() => SplashController());
    locator.registerLazySingleton<HomeController>(() => HomeController());
    locator.registerLazySingleton<SettingController>(() => SettingController());
  }
}
