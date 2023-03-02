import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mazenki/app/built_assets/assets.gen.dart';
import 'package:mazenki/helpers/ui/components/base_view.dart';
import 'package:mazenki/ui/home/home.controller.dart';
import 'package:sizer/sizer.dart';

class HomeUi extends StatelessWidget {
  const HomeUi({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: true));
    return Scaffold(
      body: BaseView<HomeController>(
        builder: (context, viewController, child) {
          return Stack(
            children: [
              MapboxMap(
                onMapLongClick: (point, coordinates) {},
                onCameraIdle: () => viewController.updateMarkerPosition(),
                trackCameraPosition: true,
                myLocationEnabled: true,
                logoViewMargins: const Point<num>(-100, -100),
                rotateGesturesEnabled: false,
                onCameraTrackingChanged: (mode) {},
                tiltGesturesEnabled: true,
                minMaxZoomPreference: const MinMaxZoomPreference(2, 19),
                myLocationRenderMode: MyLocationRenderMode.GPS,
                onMapClick: (point, coordinates) {
                  debugPrint(point.toString());
                  print(coordinates);
                  if (viewController.isGeoFenceMode) {
                    viewController.addMarker(
                      point,
                      coordinates,
                      GestureDetector(
                          onTap: () {
                            viewController.removeMarker(
                                markerId: point.toString());
                          },
                          child: Assets.iconsax.twotone.addCircle
                              .svg(height: 20, color: Colors.white)),
                    );
                  }
                },
                accessToken: dotenv.get("MAPBOX_TOKEN"),
                styleString: dotenv.get("MAPBOX_STYLE"),
                compassEnabled: false,
                onMapCreated: ((controller) =>
                    viewController.onMapCreated(controller)),
                key: const ValueKey('MapboxViewMapKey'),
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0.0, 0.0),
                  zoom: 13,
                  tilt: 85,
                ),
              ),
              IgnorePointer(
                  ignoring: false,
                  child: Stack(
                    children: viewController.markers,
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40.w,
                        height: 5.h,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            "Fence mode : ${viewController.isGeoFenceMode ? 'ON' : 'OFF'}"))),
                              ],
                            )),
                      ),
                      if (viewController.isGeoFenceMode)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                                onPressed: () {
                                  viewController.fillArea();
                                },
                                color: Colors.white,
                                icon: Assets.iconsax.twotone.arrowDown.svg()),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              //  Align(
              //           alignment: Alignment.bottomCenter,
              //           child: SafeArea(
              //             child: SizedBox(
              //               width: 90.w,
              //               height: 40.h,
              //               child: Stack(
              //                 children: [
              //                   DecoratedBox(
              //                       decoration: BoxDecoration(
              //                           color: Colors.white,
              //                           borderRadius: BorderRadius.circular(15)),
              //                       child: Column(
              //                         children: [
              //                           const Padding(
              //                             padding: EdgeInsets.all(8.0),
              //                             child: Text(
              //                                 "Please select your point on the map"),
              //                           ),
              //                           viewController.selectesPlaces.isEmpty
              //                               ? const Expanded(
              //                                   child: Center(
              //                                     child: Text(
              //                                         "No point selected now"),
              //                                   ),
              //                                 )
              //                               : Expanded(
              //                                   child: ListView(
              //                                   shrinkWrap: true,
              //                                   children: viewController
              //                                       .selectesPlaces
              //                                       .asMap()
              //                                       .entries
              //                                       .map((e) => ListTile(
              //                                             trailing: IconButton(
              //                                                 onPressed: () {
              //                                                   viewController
              //                                                       .removePoint(
              //                                                           e.value);
              //                                                 },
              //                                                 icon: Assets
              //                                                     .iconsax
              //                                                     .twotone
              //                                                     .closeSquare
              //                                                     .svg()),
              //                                             leading: Text(
              //                                                 (e.key + 1)
              //                                                     .toString()),
              //                                             title: Text(
              //                                                 "Coord: lat:${e.value.latitude.toStringAsPrecision(3)} - lng: ${e.value.longitude.toStringAsPrecision(3)}"),
              //                                           ))
              //                                       .toList(),
              //                                 )),
              //                           Container(
              //                             // alignment: Alignment.center,
              //                             width: double.infinity,
              //                             height: 8.h,

              //                             child: Padding(
              //                               padding: const EdgeInsets.all(8.0),
              //                               child: OutlinedButton(
              //                                   style: OutlinedButton.styleFrom(
              //                                       shape: RoundedRectangleBorder(
              //                                           borderRadius:
              //                                               BorderRadius.circular(
              //                                                   10)),
              //                                       // const RoundedRectangleBorder(),
              //                                       backgroundColor:
              //                                           Theme.of(context)
              //                                               .canvasColor),
              //                                   onPressed: () {},
              //                                   child: const Text("Confirm")),
              //                             ),
              //                           )
              //                           // TextButton(
              //                           //     onPressed: () {
              //                           //       viewController.toggleGeofenceMode();
              //                           //     },
              //                           //     child: Text("Exit Fence Mode"))
              //                         ],
              //                       )),
              //                   Align(
              //                     alignment: Alignment.topRight,
              //                     child: IconButton(
              //                       icon: Assets.iconsax.bold.closeCircle.svg(),
              //                       onPressed: () {
              //                         viewController.toggleGeofenceMode();
              //                       },
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         )

              //       ,
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: 90.w,
                    height: 10.h,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    viewController.showMyLocation();
                                  },
                                  icon: Assets.iconsax.bold.location.svg()),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    viewController.toggleGeofenceMode();
                                  },
                                  icon: Assets.iconsax.bold.edit.svg()),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Assets.iconsax.bold.linkCircle.svg()),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Assets.iconsax.bold.setting.svg()),
                            ),
                          ],
                        )),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
