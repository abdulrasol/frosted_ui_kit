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
      title: 'Bottom Sheet Playground',
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
                        Colors.accents[(index + 7) % Colors.accents.length],
                        Colors.accents[(index + 8) % Colors.accents.length],
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
                              const Text(
                                'This bottom sheet is using the playground properties for its blur and tint effect!',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              appButton(
                                context: context,
                                title: 'Close',
                                style: AppButtonStyle.glass,
                                onPressed: () => Navigator.pop(context),
                              ),
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
