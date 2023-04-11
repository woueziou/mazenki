import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mazenki/core/data/models/place.dart';
import 'package:mazenki/helpers/ui/components/base_view.dart';
import 'package:mazenki/ui/setting/setting.controller.dart';
import 'package:mazenki/ui/setting/widgets/fences.ui.dart';

class SettingUi extends StatelessWidget {
  const SettingUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BaseView<SettingController>(
          builder: (context, viewController, child) {
            return Column(
              children: [
                // Center(
                //   child: Text(
                //       "Is in geofence zone: ${viewController.isInDesignatedPlace}"),
                // ),
                const Text("Geofence zones"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      // filled: true,
                      fillColor: Colors.grey,
                      // border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.tune_rounded,
                        color: Color(0xFF95A1AC),
                        size: 24,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0),
                        child: Icon(
                          Icons.search_rounded,
                          color: Color(0xFF95A1AC),
                          size: 24,
                        ),
                      ),
                      // labelText: 'Search your fences here...',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                      ),
                      // focusedBorder: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0x00000000), width: 1),
                        //
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable:
                        Hive.box<Place>(Place.boxName).listenable(),
                    builder: (context, data, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var place = data.values.toList()[index];
                          return FenceCard(place: place);
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
