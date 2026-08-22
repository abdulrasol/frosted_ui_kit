import 'package:example_app/src/shared/playground_background.dart';
import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import '../shared/playground_controls.dart';

class BottomSheetCatalog extends StatefulWidget {
  const BottomSheetCatalog({super.key});

  @override
  State<BottomSheetCatalog> createState() => _BottomSheetCatalogState();
}

class _BottomSheetCatalogState extends State<BottomSheetCatalog> with BottomSheets, Buttons, Cards {
  PlaygroundState _state = const PlaygroundState();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      floatingActionButton: _buildFab(),
      title: 'Bottom Sheet Playground',
      child: Stack(
        children: [
          // Background content to show off blur
          const Positioned.fill(child: PlaygroundBackground()),

          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: context.topPadding + 16, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  appButton(
                    context: context,
                    title: 'Show Bottom Sheet',
                    style: AppButtonStyle.colored,
                    onPressed: () {
                      showAppBottomSheet(
                        context: context,
                        sigmaY: _state.sigmaY,
                        glassColor: _state.glassColor,
                        border: _state.border,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Glassmorphic Bottom Sheet',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              const Text('This bottom sheet is using the playground properties for its blur and tint effect!', textAlign: TextAlign.center),
                              const SizedBox(height: 32),
                              appButton(context: context, title: 'Close', style: AppButtonStyle.glass, onPressed: () => Navigator.pop(context)),
                            ],
                          ),
                        ),
                      );
                    },
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
