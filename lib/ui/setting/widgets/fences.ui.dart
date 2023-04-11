import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:mazenki/core/data/models/place.dart';
import 'package:mazenki/core/services/geofence.service.dart';
import 'package:mazenki/core/services/hive.service.dart';
import 'package:mazenki/core/vendors/get.it.dart';
import 'package:mazenki/helpers/utils/navigation.service.dart';
import 'package:mazenki/ui/home/home.controller.dart';

class FenceCard extends StatelessWidget {
  final Place place;
  const FenceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var homeController = locator.get<HomeController>();
        homeController.drawFill(geometry: place.fillGeometry, color: "#52B5AC");
        print(place.fillGeometry);
        context.pop();
      },
      onLongPress: () {
        locator.getAsync<HiveService>().then((value) {
          // value.placeBox.delete(place.id);
          polyGeofenceService.removePolyGeofenceById(place.id);
          place.delete();
          locator
              .get<NavigationService>()
              .showSnackBar(message: "Place delete with success");
        });
      },
      child: SizedBox(
        height: 90,
        width: double.infinity,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.grey[300],
                    width: 74,
                    height: 74,
                  )

                  // Image.network(
                  //   'https://images.unsplash.com/photo-1556741533-6e6a62bd8b49?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8c3RvcmV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
                  //   width: 74,
                  //   height: 74,
                  //   fit: BoxFit.cover,
                  // ),
                  ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 1, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          place.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          place.dateCreated.toString(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Text(
                          '1.7mi',
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
