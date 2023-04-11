import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mazenki/core/vendors/get.it.dart';
import 'package:mazenki/helpers/utils/navigation.service.dart';
import 'package:mazenki/ui/home/home.ui.dart';
import 'package:mazenki/ui/setting/setting.ui.dart';
import 'package:mazenki/ui/splash/splash.ui.dart';

class RouteHandler {
  static GoRouter router = GoRouter(
      navigatorKey: locator.get<NavigationService>().navigatoryKey,
      debugLogDiagnostics: true,
      initialLocation: "/splash",
      // urlPathStrategy: UrlPathStrategy.,
      observers: <NavigatorObserver>[
        // NavigatorObserver()
      ],
      routes: <GoRoute>[
        GoRoute(
          path: "/",
          builder: ((context, state) => const HomeUi()),
        ),
        GoRoute(
          path: "/splash",
          builder: ((context, state) => const SplashUi()),
        ),
        GoRoute(
          path: "/settings",
          builder: ((context, state) => const SettingUi()),
        ),
      ]);
}
