import 'package:example_app/src/shared/playground_background.dart';
import 'package:material_ui/material_ui.dart';
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
              padding: EdgeInsets.symmetric(
                vertical: context.topPadding + 10,
                horizontal: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FrostedButton.primary(
                    label: 'Save changes',
                    icon: Icons.save_outlined,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Changes saved')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const FrostedButton.secondary(
                    label: 'Unavailable action',
                    onPressed: null,
                  ),
                  const SizedBox(height: 12),
                  FrostedIconButton(
                    icon: Icons.info_outline,
                    tooltip: 'Button details',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Primary, secondary and icon actions use the shared Frosted theme',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Role stays destructive across appearances',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FrostedButton.destructive(
                          label: 'Delete filled',
                          icon: Icons.delete_outline,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FrostedButton.destructive(
                          label: 'Delete glass',
                          icon: Icons.delete_outline,
                          style: AppButtonStyle.glass,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'AppButton Styles',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  _buildStyleMatrix(context),
                  const SizedBox(height: 24),

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
                  Row(
                    children: [
                      Expanded(
                        child: appButton(
                          context: context,
                          title: 'Loading',
                          style: AppButtonStyle.colored,
                          isLoading: true,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: appButton(
                          context: context,
                          title: 'Disabled',
                          style: AppButtonStyle.outlined,
                          isDisabled: true,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  appButton(
                    context: context,
                    title: 'Colored Style',
                    style: AppButtonStyle.colored,
                    sigmaX: _state.sigmaX,
                    sigmaY: _state.sigmaY,
                    backgroundColor:
                        _state.glassColor ?? Theme.of(context).primaryColor,
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
                  const SizedBox(height: 12),
                  appButton(
                    context: context,
                    title: 'Water Drop Style',
                    style: AppButtonStyle.waterDrop,
                    icon: Icons.water_drop_outlined,
                    onPressed: () {},
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Circle Buttons',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Water Drop Style',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      circleButton(
                        context: context,
                        icon: Icons.water_drop_outlined,
                        style: CircleButtonStyle.waterDrop,
                        tooltip: 'Water drop button',
                        semanticLabel: 'Water drop button',
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      circleButton(
                        context: context,
                        icon: Icons.favorite,
                        style: CircleButtonStyle.waterDrop,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      circleButton(
                        context: context,
                        icon: Icons.add,
                        tooltip: 'Add item',
                        semanticLabel: 'Add item',
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
                  const Text(
                    'FAB Flavors',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      appFab(
                        context: context,
                        icon: Icons.edit,
                        style: AppButtonStyle.waterDrop,
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
                        style: AppButtonStyle.waterDrop,
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
                        style: AppButtonStyle.waterDrop,
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

  Widget _buildStyleMatrix(BuildContext context) {
    final styles = <({String label, AppButtonStyle style})>[
      (label: 'Glass', style: AppButtonStyle.glass),
      (label: 'Colored', style: AppButtonStyle.colored),
      (label: 'Outlined', style: AppButtonStyle.outlined),
      (label: 'Text', style: AppButtonStyle.text),
      (label: 'Water Drop', style: AppButtonStyle.waterDrop),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Complete style and state matrix',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...styles.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: appButton(
              context: context,
              title: entry.label,
              style: entry.style,
              onPressed: () {},
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: appButton(
                context: context,
                title: 'Loading',
                style: AppButtonStyle.colored,
                isLoading: true,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: appButton(
                context: context,
                title: 'Disabled',
                style: AppButtonStyle.outlined,
                isDisabled: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        appButton(
          context: context,
          title: 'Delete (destructive glass)',
          style: AppButtonStyle.glass,
          role: FrostedActionRole.destructive,
          icon: Icons.delete_outline,
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          children: [
            circleButton(
              context: context,
              icon: Icons.favorite,
              selected: true,
              tooltip: 'Selected favorite',
              semanticLabel: 'Selected favorite',
              onPressed: () {},
            ),
            circleButton(
              context: context,
              icon: Icons.favorite_border,
              tooltip: 'Disabled favorite',
              semanticLabel: 'Disabled favorite',
              onPressed: null,
            ),
          ],
        ),
      ],
    );
  }
}
