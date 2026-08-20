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
      title: 'Inputs Playground',
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
                      colors: [Colors.accents[(index + 3) % Colors.accents.length], Colors.accents[(index + 4) % Colors.accents.length]],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 400, left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: context.appBarHeight + 10),

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
