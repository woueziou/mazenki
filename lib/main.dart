import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:mazenki/core/services/services.manager.dart';
import 'package:mazenki/helpers/utils/colors.from.string.dart';
import 'package:mazenki/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final lightStr = await rootBundle.loadString("assets/theme/light.json");
  final lightJson = jsonDecode(lightStr);
  final light = ThemeDecoder.decodeThemeData(lightJson);
  await ServiceManager.initApp();
  runApp(Mazenki(
    light: light ??
        ThemeData(
            useMaterial3: true,
            primaryColor: ColorUtils.stringToColor("#6750A4")),
  ));
}
