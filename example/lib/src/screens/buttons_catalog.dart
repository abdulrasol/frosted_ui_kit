import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import '../shared/playground_controls.dart';

class ButtonsCatalog extends StatefulWidget {
  const ButtonsCatalog({super.key});

  @override
  State<ButtonsCatalog> createState() => _ButtonsCatalogState();
}

class _ButtonsCatalogState extends State<ButtonsCatalog> with Buttons, Cards {
  PlaygroundState _state = const PlaygroundState();

  int _fabFlavor = 0; // 0 = Icon, 1 = Text, 2 = Extended

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'Buttons Playground',
      floatingActionButton: appFab(
        context: context,
        icon: _fabFlavor != 1 ? Icons.add : null,
        title: _fabFlavor != 0 ? 'Create' : null,
        sigmaX: _state.sigmaX,
        sigmaY: _state.sigmaY,
        backgroundColor: _state.glassColor,
        border: _state.border,
        onPressed: () {
          setState(() {
            _fabFlavor = (_fabFlavor + 1) % 3;
          });
        },
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
                        Colors.accents.reversed.toList()[index % Colors.accents.length],
                        Colors.accents.reversed.toList()[(index + 1) % Colors.accents.length],
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
                  SizedBox(height: context.appBarHeight),
                  const Text('AppButton Styles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),

                  appButton(
                    context: context,
                    title: 'Glass Style',
                    style: AppButtonStyle.glass,
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    backgroundColor: _state.glassColor,
                    border: _state.border,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),

                  appButton(
                    context: context,
                    title: 'Colored Style',
                    style: AppButtonStyle.colored,
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    backgroundColor: _state.glassColor ?? Theme.of(context).primaryColor,
                    border: _state.border,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),

                  appButton(
                    context: context,
                    title: 'Outlined Style',
                    style: AppButtonStyle.outlined,
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    backgroundColor: _state.glassColor,
                    border: _state.border,
                    onPressed: () {},
                  ),

                  const SizedBox(height: 32),
                  const Text('Circle Buttons', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      circleButton(
                        context: context,
                        icon: Icons.add,
                        sigmaX: _state.sigmaX,
                        sigmaY: _state.sigmaY,
                        glassColor: _state.glassColor,
                        border: _state.border,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      circleButton(
                        context: context,
                        icon: Icons.favorite,
                        sigmaX: _state.sigmaX,
                        sigmaY: _state.sigmaY,
                        glassColor: _state.glassColor,
                        border: _state.border,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      circleButton(
                        context: context,
                        icon: Icons.share,
                        sigmaX: _state.sigmaX,
                        sigmaY: _state.sigmaY,
                        glassColor: _state.glassColor,
                        border: _state.border,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  const Text('FAB Flavors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      appFab(
                        context: context,
                        icon: Icons.edit,
                        sigmaX: _state.sigmaX,
                        sigmaY: _state.sigmaY,
                        backgroundColor: _state.glassColor,
                        border: _state.border,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      appFab(
                        context: context,
                        title: 'Save',
                        sigmaX: _state.sigmaX,
                        sigmaY: _state.sigmaY,
                        backgroundColor: _state.glassColor,
                        border: _state.border,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      appFab(
                        context: context,
                        icon: Icons.send,
                        title: 'Send',
                        sigmaX: _state.sigmaX,
                        sigmaY: _state.sigmaY,
                        backgroundColor: _state.glassColor,
                        border: _state.border,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  
                  // Extra padding at the bottom so FAB doesn't cover content
                  const SizedBox(height: 80),
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
              showBorderRadius: false, // Buttons have fixed border radius generally, except custom ones.
              onChanged: (s) => setState(() => _state = s),
            ),
          ),
        ],
      ),
    );
  }
}
