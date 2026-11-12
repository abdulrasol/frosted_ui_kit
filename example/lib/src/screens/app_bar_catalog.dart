import 'package:example_app/src/shared/playground_background.dart';
import 'package:material_ui/material_ui.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import '../shared/playground_controls.dart';

class AppBarCatalog extends StatefulWidget {
  const AppBarCatalog({super.key});

  @override
  State<AppBarCatalog> createState() => _AppBarCatalogState();
}

class _AppBarCatalogState extends State<AppBarCatalog> with Buttons, Cards {
  PlaygroundState _state = const PlaygroundState();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      floatingActionButton: _buildFab(),
      title: 'App Bar Playground',
      appBarScrollBehavior: AppBarScrollBehavior.hideAll,

      actions: [
        circleButton(context: context, icon: Icons.settings, onPressed: () {}),
        circleButton(context: context, icon: Icons.add, onPressed: () {}),
      ],

      child: Stack(
        children: [
          // Background content to show off blur behind app bar
          const Positioned.fill(child: PlaygroundBackground()),
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 88, 16, 120),
            itemCount: 24,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildDemoCard(index),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(int index) {
    return blurredCard(
      context: context,
      sigmaX: _state.sigmaX,
      sigmaY: _state.sigmaY,
      color: _state.glassColor ?? Colors.black.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(_state.borderRadius),
      border: _state.border ?? Border.all(color: Colors.white24),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scrollable glass card',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Scroll down to hide the app bar, then scroll up to reveal it.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white70),
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
