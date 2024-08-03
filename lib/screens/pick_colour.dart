import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kudiaccess/providers/color_providers.dart';
import 'package:kudiaccess/screens/fontscreen.dart';
import '../utils/commons/custom_button.dart';
import 'pick_colour_tabs/grid_color_picker.dart';
import 'pick_colour_tabs/sliders_color_picker.dart';
import 'pick_colour_tabs/spectrum_color_picker.dart';
import 'sign_up.dart';

class PickColorScreen extends ConsumerWidget {
  const PickColorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);
    final colorNotifier = ref.read(colorProvider.notifier);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colorState.baseColor,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12, 12.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Select colour',
                        style: TextStyle(
                          fontSize: 26,
                          color: colorState.generatedColors[2],
                        ),
                      ),
                      CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FontSelectionPage(),
                              ),
                            );
                          },
                          txt: "Next",
                          width: 80,
                          color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Preferred Color',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colorState.baseColor,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 36),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        color: Colors.grey[300],
                      ),
                      child: const TabBar(
                        padding: EdgeInsets.all(3.4),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black54,
                        tabs: [
                          Tab(
                            child: Text(
                              'Grid',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Spectrum',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Sliders',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Expanded(
                  child: TabBarView(
                    children: [
                      GridColorPicker(
                        currentColor: colorState.baseColor,
                        onColorChanged: (color) {
                          colorNotifier.setBaseColor(color);
                        },
                      ),
                      SpectrumColorPicker(
                        currentColor: colorState.baseColor,
                        onColorChanged: (color) {
                          colorNotifier.setBaseColor(color);
                        },
                      ),
                      SlidersColorPicker(
                        currentColor: colorState.baseColor,
                        onColorChanged: (color) {
                          colorNotifier.setBaseColor(color);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
