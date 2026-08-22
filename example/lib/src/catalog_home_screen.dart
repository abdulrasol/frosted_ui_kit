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

class _CatalogHomeScreenState extends State<CatalogHomeScreen> with Cards, Buttons, Tabs {
  final FrostedNavbarController _navController = FrostedNavbarController();
  int _currentTab = 0;

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MySandboxApp.of(context).isDarkMode;

    return BaseWidget(
      title: 'Frosted UI Kit',
      actions: [
        circleButton(context: context, icon: isDark ? Icons.light_mode : Icons.dark_mode, onPressed: () => MySandboxApp.of(context).toggleTheme()),
        circleButton(
          context: context,
          icon: Icons.person,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthScreen()));
          },
        ),
      ],
      bottomNavigationBar: FrostedNavigationButtomBar(
        controller: _navController,
        items: [
          FrostedNavbarItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, title: 'Catalog'),
          FrostedNavbarItem(icon: Icons.search, title: 'Search'),
          FrostedNavbarItem(icon: Icons.notifications_none, activeIcon: Icons.notifications, title: 'Alerts', badgeCount: 3),
          FrostedNavbarItem(icon: Icons.person_outline, activeIcon: Icons.person, title: 'Profile'),
        ],
        action: appFab(context: context, icon: Icons.add, onPressed: () {}),
      ),
      child: Stack(
        children: [
          // Vibrant Mesh Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [
                          Color(0xFF2C1930), // Deep Purple
                          Color(0xFF14243A), // Deep Blue
                          Color(0xFF20132B), // Very Dark Violet
                          Color(0xFF0F1E28), // Dark Cyan tint
                        ]
                      : const [
                          Color(0xFFF9D423), // Warm yellow
                          Color(0xFFFF4E50), // Vibrant Red/Pink
                          Color(0xFF6dd5ed), // Sky Blue
                          Color(0xFF2193b0), // Deep Blue
                        ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              children: [
                SizedBox(height: context.appBarHeight),

                // Hero Section
                bluredCard(
                  context: context,
                  padding: const EdgeInsets.all(24),
                  borderRadius: BorderRadius.circular(32),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(colors: [Colors.purpleAccent, Colors.blueAccent]),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                            ),
                            child: const Icon(Icons.person, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pro Dashboard',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Liquid Glass Aesthetics',
                                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Showcase Sliding Tabs inline
                      appSlidingTabs(
                        context: context,
                        tabs: const ['Components', 'Settings', 'Analytics'],
                        selectedIndex: _currentTab,
                        onTabChanged: (index) {
                          setState(() {
                            _currentTab = index;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Component Library',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                const SizedBox(height: 16),
                // Grid Catalog
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildGridTile(
                      context: context,
                      title: 'Cards',
                      icon: Icons.layers_outlined,
                      onTap: () => _navigateTo(context, const CardsCatalog()),
                    ),
                    _buildGridTile(
                      context: context,
                      title: 'Buttons',
                      icon: Icons.touch_app_outlined,
                      onTap: () => _navigateTo(context, const ButtonsCatalog()),
                    ),
                    _buildGridTile(
                      context: context,
                      title: 'Loading',
                      icon: Icons.hourglass_top_rounded,
                      onTap: () => _navigateTo(context, const LoadingButtonCatalog()),
                    ),
                    _buildGridTile(
                      context: context,
                      title: 'Inputs',
                      icon: Icons.text_fields_rounded,
                      onTap: () => _navigateTo(context, const InputsCatalog()),
                    ),
                    _buildGridTile(
                      context: context,
                      title: 'Tabs',
                      icon: Icons.tab_unselected_rounded,
                      onTap: () => _navigateTo(context, const TabsCatalog()),
                    ),
                    _buildGridTile(
                      context: context,
                      title: 'Bottom Sheets',
                      icon: Icons.call_to_action_outlined,
                      onTap: () => _navigateTo(context, const BottomSheetCatalog()),
                    ),
                    _buildGridTile(
                      context: context,
                      title: 'Dialogs',
                      icon: Icons.chat_bubble_outline_rounded,
                      onTap: () => _navigateTo(context, const DialogsCatalog()),
                    ),
                    _buildGridTile(
                      context: context,
                      title: 'Steppers',
                      icon: Icons.linear_scale_rounded,
                      onTap: () => _navigateTo(context, const StepperCatalog()),
                    ),
                    _buildGridTile(
                      context: context,
                      title: 'List Sections',
                      icon: Icons.format_list_bulleted_rounded,
                      onTap: () => _navigateTo(context, const ListTileCatalog()),
                    ),
                    _buildGridTile(
                      context: context,
                      title: 'App Bars',
                      icon: Icons.view_headline_rounded,
                      onTap: () => _navigateTo(context, const AppBarCatalog()),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
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

  Widget _buildGridTile({required BuildContext context, required String title, required IconData icon, required VoidCallback onTap}) {
    return bluredCard(
      context: context,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)),
                child: Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
