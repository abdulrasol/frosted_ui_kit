import 'screens/stepper_catalog.dart';
import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import 'screens/app_bar_catalog.dart';
import 'screens/bottom_sheet_catalog.dart';
import 'screens/buttons_catalog.dart';
import 'screens/cards_catalog.dart';
import 'screens/dialogs_catalog.dart';
import 'screens/inputs_catalog.dart';
import 'screens/list_tile_catalog.dart';
import 'screens/tabs_catalog.dart';
import 'screens/loading_button_catalog.dart';
import '../main.dart';

class CatalogHomeScreen extends StatefulWidget {
  const CatalogHomeScreen({super.key});

  @override
  State<CatalogHomeScreen> createState() => _CatalogHomeScreenState();
}

class _CatalogHomeScreenState extends State<CatalogHomeScreen>
    with Cards, Buttons {
  final FrostedNavbarController _navController = FrostedNavbarController();

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MySandboxApp.of(context).isDarkMode;

    return BaseWidget(
      title: 'Frosted UI Kit Catalog',
      actions: [
        circleButton(
          context: context,
          icon: isDark ? Icons.light_mode : Icons.dark_mode,
          onPressed: () => MySandboxApp.of(context).toggleTheme(),
        ),
      ],
      bottomNavigationBar: FrostedNavigationButtomBar(
        controller: _navController,
        items: [
          FrostedNavbarItem(
            icon: Icons.home,
            activeIcon: Icons.home_filled,
            title: 'Home',
          ),
          FrostedNavbarItem(icon: Icons.search, title: 'Search'),
          FrostedNavbarItem(
            icon: Icons.notifications_none,
            activeIcon: Icons.notifications,
            title: 'Notifications',
          ),
          FrostedNavbarItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            title: 'Settings',
          ),
        ],
        action: appFab(context: context, icon: Icons.add, onPressed: () {}),
      ),
      child: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [Color(0xFF1F1C2C), Color(0xFF928DAB)]
                      : const [Color(0xFFE2E2E2), Color(0xFFC9D6FF)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom:
                    16, //+ (_navType == FrostedNavigationBarType.circular ? 80 : 56), // Padding for nav bar
              ),
              children: [
                SizedBox(height: context.appBarHeight),
                _buildCatalogTile(
                  context: context,
                  title: 'Cards',
                  icon: Icons.rectangle_outlined,
                  onTap: () => _navigateTo(context, const CardsCatalog()),
                ),
                _buildCatalogTile(
                  context: context,
                  title: 'Buttons',
                  icon: Icons.smart_button,
                  onTap: () => _navigateTo(context, const ButtonsCatalog()),
                ),
                _buildCatalogTile(
                  context: context,
                  title: 'Loading Buttons',
                  icon: Icons.animation,
                  onTap: () =>
                      _navigateTo(context, const LoadingButtonCatalog()),
                ),
                _buildCatalogTile(
                  context: context,
                  title: 'Inputs',
                  icon: Icons.text_fields,
                  onTap: () => _navigateTo(context, const InputsCatalog()),
                ),
                _buildCatalogTile(
                  context: context,
                  title: 'Tabs',
                  icon: Icons.tab,
                  onTap: () => _navigateTo(context, const TabsCatalog()),
                ),
                _buildCatalogTile(
                  context: context,
                  title: 'Bottom Sheets',
                  icon: Icons.call_to_action_outlined,
                  onTap: () => _navigateTo(context, const BottomSheetCatalog()),
                ),
                _buildCatalogTile(
                  context: context,
                  title: 'Dialogs',
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () => _navigateTo(context, const DialogsCatalog()),
                ),
                _buildCatalogTile(
                  context: context,
                  title: 'Steppers',
                  icon: Icons.linear_scale_rounded,
                  onTap: () => _navigateTo(context, const StepperCatalog()),
                ),
                _buildCatalogTile(
                  context: context,
                  title: 'List Sections',
                  icon: Icons.format_list_bulleted,
                  onTap: () => _navigateTo(context, const ListTileCatalog()),
                ),
                _buildCatalogTile(
                  context: context,
                  title: 'App Bars',
                  icon: Icons.view_headline,
                  onTap: () => _navigateTo(context, const AppBarCatalog()),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 35),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildCatalogTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: bluredCard(
        context: context,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
