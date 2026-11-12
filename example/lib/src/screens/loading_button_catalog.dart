import 'package:example_app/src/shared/playground_background.dart';
import 'package:material_ui/material_ui.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

class LoadingButtonCatalog extends StatefulWidget {
  const LoadingButtonCatalog({super.key});

  @override
  State<LoadingButtonCatalog> createState() => _LoadingButtonCatalogState();
}

class _LoadingButtonCatalogState extends State<LoadingButtonCatalog>
    with Buttons {
  final FrostLoadingButtonController _controller =
      FrostLoadingButtonController();
  int _requestGeneration = 0;
  int _automaticAttempt = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _simulateNetworkRequest() async {
    final generation = ++_requestGeneration;
    _controller.start();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted ||
        generation != _requestGeneration ||
        _controller.value != FrostLoadingButtonState.loading) {
      return;
    }

    // Simulate a random success or failure
    final isSuccess = DateTime.now().second % 2 == 0;

    if (isSuccess) {
      _controller.success();
    } else {
      _controller.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FrostedAppLocalizations.of(context)!;
    return BaseWidget(
      title: 'Loading Button Catalog',
      child: Stack(
        children: [
          // Background Gradient
          // Background content to show off
          const Positioned.fill(child: PlaygroundBackground()),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SizedBox(height: context.appBarHeight),

                Text(
                  'Animated State Button',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A button that animates between idle, loading (Lottie), success, and error states.',
                ),
                const SizedBox(height: 32),

                FrostedAsyncButton(
                  title: l10n.asyncSaveProfile,
                  icon: Icons.save_outlined,
                  style: AppButtonStyle.waterDrop,
                  onPressed: () async {
                    await Future<void>.delayed(const Duration(seconds: 1));
                  },
                  onSuccess: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.asyncProfileSaved)),
                  ),
                ),
                const SizedBox(height: 16),
                FrostedAsyncButton(
                  title: l10n.asyncRetryRequest,
                  icon: Icons.refresh_rounded,
                  style: AppButtonStyle.outlined,
                  onPressed: () async {
                    await Future<void>.delayed(const Duration(seconds: 1));
                    _automaticAttempt++;
                    if (_automaticAttempt.isOdd) {
                      throw FormatException(l10n.asyncExampleRequestRejected);
                    }
                  },
                  onError: (error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$error — ${l10n.asyncTapAgainToRetry}'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                Text(
                  l10n.manualControllerApi,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.manualControllerDescription),
                const SizedBox(height: 24),

                // The main state button
                Center(
                  child: FrostLoadingButton(
                    controller: _controller,
                    title: 'Submit Order',
                    icon: Icons.shopping_cart,
                    style: AppButtonStyle.waterDrop,
                    onPressed: _simulateNetworkRequest,
                  ),
                ),

                const SizedBox(height: 48),
                const Divider(),
                const SizedBox(height: 24),

                Text(
                  'Manual Controls',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Manual controls to test states
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    appButton(
                      context: context,
                      title: 'Start',
                      style: AppButtonStyle.waterDrop,
                      width: 140,
                      backgroundColor: Colors.blueGrey,
                      onPressed: () => _controller.start(),
                    ),
                    appButton(
                      context: context,
                      title: 'Success',
                      style: AppButtonStyle.waterDrop,
                      width: 140,
                      backgroundColor: Colors.green,
                      onPressed: () => _controller.success(),
                    ),
                    appButton(
                      context: context,
                      title: 'Error',
                      style: AppButtonStyle.waterDrop,
                      width: 140,
                      backgroundColor: Colors.red,
                      onPressed: () => _controller.error(),
                    ),
                    appButton(
                      context: context,
                      title: 'Reset',
                      style: AppButtonStyle.waterDrop,
                      width: 140,
                      backgroundColor: Colors.orange,
                      onPressed: () {
                        _requestGeneration++;
                        _controller.reset();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
