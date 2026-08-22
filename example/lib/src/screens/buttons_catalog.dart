import 'package:example_app/src/shared/playground_background.dart';
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

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      floatingActionButton: _buildFab(),
      title: 'Buttons Playground',

      child: Stack(
        children: [
          // Background content to show off blur
          // Background content to show off
          const Positioned.fill(child: PlaygroundBackground()),

          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: context.topPadding + 10, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
