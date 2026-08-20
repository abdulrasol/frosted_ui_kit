import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

class DialogsCatalog extends StatelessWidget with Dialogs, Buttons {
  const DialogsCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'Dialogs Catalog',
      child: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? const [Color(0xFF1F1C2C), Color(0xFF928DAB)]
                      : const [Color(0xFFE2E2E2), Color(0xFFC9D6FF)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SizedBox(height: context.appBarHeight),
                appButton(
                  context: context,
                  title: 'Show Warning Dialog',
                  style: AppButtonStyle.colored,
                  onPressed: () async {
                    final result = await showAppWarningDialog(
                      context: context,
                      title: 'Delete Customer?',
                      description: 'Are you sure you want to delete this customer? This action cannot be undone.',
                      confirmText: 'Delete',
                    );
                    if (result == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Customer deleted!')));
                    }
                  },
                ),
                const SizedBox(height: 16),
                appButton(
                  context: context,
                  title: 'Show Error Dialog',
                  style: AppButtonStyle.colored,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  onPressed: () {
                    showAppErrorDialog(context: context, title: 'Access Denied', description: 'You do not have permission to perform this action.');
                  },
                ),
                const SizedBox(height: 16),
                appButton(
                  context: context,
                  title: 'Show Input Dialog (With Validation)',
                  style: AppButtonStyle.colored,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  onPressed: () async {
                    final result = await showAppInputDialog(
                      context: context,
                      title: 'Rename Project',
                      description: 'Enter a new name for your project.',
                      hintText: 'Project Name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name cannot be empty';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    );
                    if (result != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Renamed to: $result')));
                    }
                  },
                ),
                const SizedBox(height: 16),
                appButton(
                  context: context,
                  title: 'Show Custom Styled Dialog',
                  style: AppButtonStyle.colored,
                  backgroundColor: Colors.indigo,
                  onPressed: () async {
                    await showAppWarningDialog(
                      context: context,
                      title: 'Custom Styled',
                      description: 'This dialog uses custom colors for title, description, and buttons.',
                      confirmText: 'Awesome!',
                      cancelText: 'Dismiss',
                      icon: Icons.palette_rounded,
                      iconColor: Colors.purpleAccent,
                      titleColor: Colors.deepPurpleAccent,
                      descriptionColor: Colors.purple,
                      confirmButtonColor: Colors.deepPurple,
                      confirmTextColor: Colors.white,
                      cancelButtonColor: Colors.purple.withValues(alpha: 0.1),
                      cancelTextColor: Colors.deepPurpleAccent,
                    );
                  },
                ),
                const SizedBox(height: 16),
                appButton(
                  context: context,
                  title: 'Show Lottie Loading Dialog',
                  style: AppButtonStyle.colored,

                  backgroundColor: Colors.teal,
                  onPressed: () async {
                    // Show the loading dialog without awaiting it
                    showAppLoadingDialog(context: context, barrierDismissible: true, message: 'Authenticating...', color: Colors.teal);
                    // Simulate a network request
                    await Future.delayed(const Duration(seconds: 50));
                    // Close the dialog if still mounted
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
