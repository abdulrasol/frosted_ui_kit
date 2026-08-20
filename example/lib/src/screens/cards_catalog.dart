import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import '../shared/playground_controls.dart';

class CardsCatalog extends StatefulWidget {
  const CardsCatalog({super.key});

  @override
  State<CardsCatalog> createState() => _CardsCatalogState();
}

class _CardsCatalogState extends State<CardsCatalog> with Cards, Buttons {
  PlaygroundState _state = const PlaygroundState();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'Cards Playground',
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
                    gradient: LinearGradient(colors: [Colors.accents[index % Colors.accents.length], Colors.accents[(index + 1) % Colors.accents.length]]),
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
                  SizedBox(height: context.appBarHeight),
                  bluredCard(
                    context: context,
                    padding: const EdgeInsets.all(32),
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    color: _state.glassColor,
                    borderRadius: BorderRadius.circular(_state.borderRadius),
                    border: _state.border,
                    child: const Text(
                      'This is a Glass Card\nNotice the background blur!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 32),
                  bluredCard(
                    context: context,
                    padding: const EdgeInsets.all(32),
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    color: _state.glassColor,
                    shape: BoxShape.circle,
                    border: _state.border,
                    child: const Text(
                      'Circle',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PlaygroundControls(state: _state, onChanged: (s) => setState(() => _state = s)),
          ),
        ],
      ),
    );
  }
}
