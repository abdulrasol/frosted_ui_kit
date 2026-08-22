import 'package:example_app/src/shared/playground_background.dart';
import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import '../shared/playground_controls.dart';

class InputsCatalog extends StatefulWidget {
  const InputsCatalog({super.key});

  @override
  State<InputsCatalog> createState() => _InputsCatalogState();
}

class _InputsCatalogState extends State<InputsCatalog> with Inputs, Buttons, Cards {
  PlaygroundState _state = const PlaygroundState();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      floatingActionButton: _buildFab(),
      title: 'Inputs Playground',
      child: Stack(
        children: [
          // Background content to show off blur
          // Background content to show off
          const Positioned.fill(child: PlaygroundBackground()),

          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 400, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: context.topPadding + 10),

                emailField(context: context, sigmaX: _state.sigmaX, sigmaY: _state.sigmaY, fillColor: _state.glassColor, border: _state.border),
                const SizedBox(height: 16),

                passwordField(context: context, sigmaX: _state.sigmaX, sigmaY: _state.sigmaY, fillColor: _state.glassColor, border: _state.border),
                const SizedBox(height: 16),

                nameField(context: context, sigmaX: _state.sigmaX, sigmaY: _state.sigmaY, fillColor: _state.glassColor, border: _state.border),
                const SizedBox(height: 16),

                textField(
                  context: context,
                  label: 'Custom Field',
                  placeholder: 'Try typing...',
                  sigmaX: _state.sigmaX,
                  sigmaY: _state.sigmaY,
                  fillColor: _state.glassColor,
                  border: _state.border,
                  prefix: const Icon(Icons.star_border, size: 20),
                ),
              ],
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
