import 'package:example_app/src/shared/playground_background.dart';
import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import '../shared/playground_controls.dart';

class ListTileCatalog extends StatefulWidget {
  const ListTileCatalog({super.key});

  @override
  State<ListTileCatalog> createState() => _ListTileCatalogState();
}

class _ListTileCatalogState extends State<ListTileCatalog> {
  PlaygroundState _state = const PlaygroundState();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'List Tile Playground',
      child: Stack(
        children: [
          // Background content to show off blur
          const Positioned.fill(child: PlaygroundBackground()),

          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: context.topPadding + 16, horizontal: context.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FrostedListSection(
                    header: const Text(
                      'Settings',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    backgroundColor: _state.glassColor,
                    children: [
                      FrostedListTile(
                        title: const Text('Wi-Fi'),
                        subtitle: const Text('Connected to MyNetwork'),
                        leading: const Icon(Icons.wifi),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      FrostedListTile(
                        title: const Text('Bluetooth'),
                        subtitle: const Text('On'),
                        leading: const Icon(Icons.bluetooth),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FrostedListSection(
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    backgroundColor: _state.glassColor,
                    children: [
                      FrostedListTile(
                        title: const Text('Notifications'),
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.notifications, color: Colors.white, size: 20),
                        ),
                        trailing: Switch(value: true, onChanged: (val) {}),
                      ),
                      FrostedListTile(
                        title: const Text('Sounds'),
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.volume_up, color: Colors.white, size: 20),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PlaygroundControls(state: _state, showBorderRadius: false, onChanged: (s) => setState(() => _state = s)),
          ),
        ],
      ),
    );
  }
}
