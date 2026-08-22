import 'package:example_app/src/shared/playground_background.dart';
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
      floatingActionButton: _buildFab(),
      title: 'App Bar Playground',

      actions: [
        circleButton(context: context, icon: Icons.settings, onPressed: () {}),
        circleButton(context: context, icon: Icons.add, onPressed: () {}),
      ],

      child: Stack(
        children: [
          // Background content to show off blur behind app bar
          const Positioned.fill(child: PlaygroundBackground()),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return appFab(
      context: context,
      icon: Icons.tune,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black26,
          builder: (context) => PlaygroundControls(
            state: _state,
            onChanged: (s) {
              setState(() => _state = s);
            },
          ),
        );
      },
    );
  }
}
