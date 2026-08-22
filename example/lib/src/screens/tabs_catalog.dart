import 'package:example_app/src/shared/playground_background.dart';
import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import '../shared/playground_controls.dart';

class TabsCatalog extends StatefulWidget {
  const TabsCatalog({super.key});

  @override
  State<TabsCatalog> createState() => _TabsCatalogState();
}

class _TabsCatalogState extends State<TabsCatalog> with Tabs, Buttons, Cards {
  int _currentIndex = 0;
  final FrostedNavbarController _navController = FrostedNavbarController();
  PlaygroundState _state = const PlaygroundState();

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'Tabs Playground',
      bottomNavigationBar: FrostedNavigationButtomBar(
        action: _buildFab(),
        controller: _navController,
        items: [
          FrostedNavbarItem(icon: Icons.home_max, color: Colors.amber),
          FrostedNavbarItem(icon: Icons.people),
          FrostedNavbarItem(icon: Icons.home_max),
          FrostedNavbarItem(icon: Icons.home_max),
        ],
      ),
      child: Stack(
        children: [
          // Background content to show off
          const Positioned.fill(child: PlaygroundBackground()),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: context.topPadding + 10, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  appSlidingTabs(
                    context: context,
                    tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
                    selectedIndex: _currentIndex,
                    onTabChanged: (i) => setState(() => _currentIndex = i),
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    glassColor: _state.glassColor,
                    border: _state.border,
                  ),
                  const SizedBox(height: 32),
                  appSlidingTabs(
                    context: context,
                    tabs: const ['Left', 'Right'],
                    selectedIndex: _currentIndex % 2,
                    onTabChanged: (i) => setState(() => _currentIndex = i),
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    glassColor: _state.glassColor,
                    border: _state.border,
                  ),
                ],
              ),
            ),
          ),
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
