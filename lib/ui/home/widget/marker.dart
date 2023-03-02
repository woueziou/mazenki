import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mazenki/app/built_assets/assets.gen.dart';

class Marker extends StatefulWidget {
  final String id;
  final Point intialPosition;
  final LatLng coordinate;
  final void Function(MarkerState) addMarkerState;
  final Widget child;
  const Marker({
    super.key,
    required this.intialPosition,
    required this.coordinate,
    required this.addMarkerState,
    required this.child,
    required this.id,
  });

  @override
  State<Marker> createState()
  // ignore: no_logic_in_create_state
  {
    final state = MarkerState(intialPosition, id);
    addMarkerState(state);
    return state;
  }
}

class MarkerState extends State<Marker> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Point position;
  String id;

  MarkerState(this.position, this.id);
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ratio = 1.0;
    const iconSize = 20.0;

    //web does not support Platform._operatingSystem
    if (!kIsWeb) {
      // iOS returns logical pixel while Android returns screen pixel
      ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
    }

    return Positioned(
      left: position.x / ratio - iconSize / 2,
      top: position.y / ratio - iconSize / 2,
      child: GestureDetector(
        onTap: () {},
        child: widget.child,
        // child: RotationTransition(
        //   turns: _animation,
        //   child: Assets.iconsax.twotone.map
        //       .svg(height: iconSize, color: Colors.white),
        // ),
      ),
    );
  }

  void updatePosition(Point<num> point) {
    setState(() {
      position = point;
    });
  }

  LatLng getCoordinate() {
    return (widget as Marker).coordinate;
  }
}
