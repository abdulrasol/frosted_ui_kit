import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

class StepperCatalog extends StatefulWidget {
  const StepperCatalog({super.key});

  @override
  State<StepperCatalog> createState() => _StepperCatalogState();
}

class _StepperCatalogState extends State<StepperCatalog>
    with Buttons, Steppers {
  late FrostedStepperController _controller;

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

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'Stepper Catalog',
      child: Stack(
        children: [
          // Background Gradient
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //   ),
          // ),
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
                  appStepper(
                    controller: _controller,
                    direction: FrostedStepperDirection.horizontal,
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
}
