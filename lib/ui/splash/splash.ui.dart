import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:mazenki/app/built_assets/assets.gen.dart';
import 'package:mazenki/helpers/ui/components/base_view.dart';
import 'package:mazenki/ui/splash/splash.controller.dart';

class SplashUi extends StatelessWidget {
  const SplashUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<SplashController>(
        onModelReady: (p0) {
          Future.delayed(const Duration(seconds: 2))
              .then((value) => context.go("/"));
        },
        builder: (context, viewController, child) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.svg.mazenkiLogo.svg(),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Mazenki"),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("by Taas Ekpaye"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
