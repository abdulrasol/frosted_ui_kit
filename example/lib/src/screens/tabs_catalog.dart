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
          // Background content to show off blur
          Positioned.fill(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 500),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.accents[(index + 5) % Colors.accents.length],
                        Colors.accents[(index + 6) % Colors.accents.length],
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 400),
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

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PlaygroundControls(
              state: _state,
              showBorderRadius: false,
              onChanged: (s) => setState(() => _state = s),
            ),
          ),
        ],
      ),
    );
  }
}
