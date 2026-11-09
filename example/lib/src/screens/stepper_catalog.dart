import 'package:example_app/src/shared/playground_background.dart';
import 'package:example_app/src/shared/playground_controls.dart';
import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

class StepperCatalog extends StatefulWidget {
  const StepperCatalog({super.key});

  @override
  State<StepperCatalog> createState() => _StepperCatalogState();
}

class _StepperCatalogState extends State<StepperCatalog>
    with Buttons, Steppers {
  static const _stepIcons = [
    Icons.shopping_cart,
    Icons.location_on,
    Icons.payment,
    Icons.rate_review,
  ];

  late FrostedStepperController _controller;
  _StepperContentMode _contentMode = _StepperContentMode.numbers;

  @override
  void initState() {
    super.initState();
    _controller = FrostedStepperController(
      steps: 4,
      stepsList: ['Cart', 'Address', 'Payment', 'Review'],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PlaygroundState _state = const PlaygroundState();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'Stepper Catalog',
      floatingActionButton: _buildFab(),
      child: Stack(
        children: [
          // Background content to show off
          const Positioned.fill(child: PlaygroundBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: context.appBarHeight,
                horizontal: context.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Horizontal Stepper',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildContentModeSelector(),
                  const SizedBox(height: 24),
                  appStepper(
                    controller: _controller,
                    direction: FrostedStepperDirection.horizontal,
                    stepBuilder: _buildStepContent,
                  ),

                  const SizedBox(height: 48),

                  const Text(
                    'Vertical Stepper',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: appStepper(
                      controller: _controller,
                      direction: FrostedStepperDirection.vertical,
                      stepBuilder: _buildStepContent,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      appButton(
                        context: context,
                        title: 'Back',
                        style: AppButtonStyle.glass,
                        onPressed: () => _controller.previous(),
                      ),
                      appButton(
                        context: context,
                        title: 'Next',
                        style: AppButtonStyle.colored,
                        onPressed: () => _controller.next(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: appButton(
                      context: context,
                      title: 'Reset',
                      style: AppButtonStyle.text,
                      onPressed: () => _controller.reset(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step content',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _contentModeButton(_StepperContentMode.numbers, 'Numbers'),
            _contentModeButton(_StepperContentMode.icons, 'Icons'),
            _contentModeButton(_StepperContentMode.images, 'Images'),
          ],
        ),
      ],
    );
  }

  Widget _contentModeButton(_StepperContentMode mode, String label) {
    final selected = _contentMode == mode;
    return appButton(
      context: context,
      title: label,
      style: selected ? AppButtonStyle.colored : AppButtonStyle.outlined,
      onPressed: () => setState(() => _contentMode = mode),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    int index,
    FrostedStepState state,
  ) {
    switch (_contentMode) {
      case _StepperContentMode.numbers:
        return Text('${index + 1}');
      case _StepperContentMode.icons:
        return Icon(_stepIcons[index]);
      case _StepperContentMode.images:
        return _ImageStepPreview(index: index, state: state);
    }
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

enum _StepperContentMode { numbers, icons, images }

class _ImageStepPreview extends StatelessWidget {
  const _ImageStepPreview({required this.index, required this.state});

  final int index;
  final FrostedStepState state;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.95),
            Colors.lightBlueAccent.withValues(alpha: 0.65),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          state == FrostedStepState.completed
              ? Icons.check
              : Icons.image_outlined,
          size: 18,
          color: Colors.indigo,
          semanticLabel: 'Image preview ${index + 1}',
        ),
      ),
    );
  }
}
