import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mazenki/core/router/router.dart';
import 'package:sizer/sizer.dart';

class Mazenki extends StatelessWidget {
  final ThemeData light;
  const Mazenki({super.key, required this.light});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp.router(
        title: "Mazenki",
        theme: light.copyWith(textTheme: GoogleFonts.latoTextTheme()),
        routeInformationProvider: RouteHandler.router.routeInformationProvider,
        routeInformationParser: RouteHandler.router.routeInformationParser,
        routerDelegate: RouteHandler.router.routerDelegate,
      ),
    );
  }
}
