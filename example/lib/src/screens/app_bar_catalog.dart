import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import '../shared/playground_controls.dart';

class AppBarCatalog extends StatefulWidget {
  const AppBarCatalog({super.key});

  @override
  State<AppBarCatalog> createState() => _AppBarCatalogState();
}

class _AppBarCatalogState extends State<AppBarCatalog> with Buttons, Cards {
  PlaygroundState _state = const PlaygroundState();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'App Bar Playground',

      actions: [
        circleButton(context: context, icon: Icons.settings, onPressed: () {}),
      ],

      child: Stack(
        children: [
          // Background content to show off blur behind app bar
          Positioned.fill(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 500),
              itemCount: 40,
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.accents[(index + 9) % Colors.accents.length],
                        Colors.accents[(index + 10) % Colors.accents.length],
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PlaygroundControls(
              state: _state,
              onChanged: (s) => setState(() => _state = s),
            ),
          ),
        ],
      ),
    );
  }
}
