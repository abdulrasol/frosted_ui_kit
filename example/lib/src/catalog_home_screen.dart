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
    with Cards, Buttons, Tabs {
  final FrostedNavbarController _navController = FrostedNavbarController();
  int _currentTab = 0;
  String _query = '';
  bool _compactPreview = false;
  bool _interactiveOnly = false;

  static const _catalogItems = <({String title, IconData icon})>[
    (title: 'Cards', icon: Icons.layers_outlined),
    (title: 'Buttons', icon: Icons.touch_app_outlined),
    (title: 'Loading', icon: Icons.hourglass_top_rounded),
    (title: 'Inputs', icon: Icons.text_fields_rounded),
    (title: 'Tabs', icon: Icons.tab_unselected_rounded),
    (title: 'Bottom Sheets', icon: Icons.call_to_action_outlined),
    (title: 'Dialogs', icon: Icons.chat_bubble_outline_rounded),
    (title: 'Steppers', icon: Icons.linear_scale_rounded),
    (title: 'List Sections', icon: Icons.format_list_bulleted_rounded),
    (title: 'App Bars', icon: Icons.view_headline_rounded),
  ];

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
        circleButton(
          context: context,
          icon: isDark ? Icons.light_mode : Icons.dark_mode,
          onPressed: () => MySandboxApp.of(context).toggleTheme(),
        ),
        circleButton(
          context: context,
          icon: Icons.person,
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AuthScreen()));
          },
        ),
        circleButton(
          context: context,
          icon: Icons.tune_rounded,
          tooltip: 'Catalog settings',
          semanticLabel: 'Catalog settings',
          onPressed: () => _showCatalogSettings(context),
        ),
      ],
      bottomNavigationBar: FrostedNavigationButtomBar(
        controller: _navController,
        items: [
          FrostedNavbarItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            title: 'Catalog',
          ),
          FrostedNavbarItem(icon: Icons.search, title: 'Search'),
          FrostedNavbarItem(
            icon: Icons.notifications_none,
            activeIcon: Icons.notifications,
            title: 'Alerts',
            badgeCount: 3,
          ),
          FrostedNavbarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            title: 'Profile',
          ),
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

          Center(
            child: SizedBox(
              width: _compactPreview ? 360 : double.infinity,
              child: ListView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: context.topPadding,
                  bottom: 16,
                ),
                children: [
                  SizedBox(height: context.appBarHeight),

                  // Hero Section
                  blurredCard(
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
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.purpleAccent,
                                    Colors.blueAccent,
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pro Dashboard',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Liquid Glass Aesthetics',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
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
                  _buildCatalogControls(context),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Component Library',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Grid Catalog
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final filtered = _catalogItems.where((item) {
                        final matchesQuery = item.title.toLowerCase().contains(
                          _query.toLowerCase(),
                        );
                        final matchesFilter =
                            !_interactiveOnly ||
                            const {
                              'Buttons',
                              'Loading',
                              'Inputs',
                              'Dialogs',
                              'Bottom Sheets',
                            }.contains(item.title);
                        return matchesQuery && matchesFilter;
                      }).toList();
                      return GridView.builder(
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth < 430 ? 1 : 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: constraints.maxWidth < 430
                              ? 1.8
                              : 1.1,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _buildGridTile(
                            context: context,
                            title: item.title,
                            icon: item.icon,
                            onTap: () => _openCatalog(context, item.title),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void _openCatalog(BuildContext context, String title) {
    final screens = <String, Widget>{
      'Cards': const CardsCatalog(),
      'Buttons': const ButtonsCatalog(),
      'Loading': const LoadingButtonCatalog(),
      'Inputs': const InputsCatalog(),
      'Tabs': const TabsCatalog(),
      'Bottom Sheets': const BottomSheetCatalog(),
      'Dialogs': const DialogsCatalog(),
      'Steppers': const StepperCatalog(),
      'List Sections': const ListTileCatalog(),
      'App Bars': const AppBarCatalog(),
    };
    _navigateTo(context, screens[title]!);
  }

  Widget _buildCatalogControls(BuildContext context) {
    return blurredCard(
      context: context,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search components',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () => setState(() => _query = ''),
                      icon: const Icon(Icons.clear),
                    ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Interactive'),
                selected: _interactiveOnly,
                onSelected: (value) => setState(() => _interactiveOnly = value),
              ),
              FilterChip(
                label: const Text('Compact preview'),
                selected: _compactPreview,
                onSelected: (value) => setState(() => _compactPreview = value),
              ),
              ActionChip(
                label: const Text('Compare button styles'),
                onPressed: () => _navigateTo(context, const ButtonsCatalog()),
              ),
              ActionChip(
                label: const Text('View code'),
                onPressed: () => _showCodePreview(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showCatalogSettings(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AppBottomSheet(
        title: 'Catalog preview',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: SwitchListTile.adaptive(
                title: const Text('Right-to-left layout'),
                value: Directionality.of(context) == TextDirection.rtl,
                onChanged: (_) => MySandboxApp.of(context).toggleDirection(),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: SwitchListTile.adaptive(
                title: const Text('Large text'),
                value: MediaQuery.textScalerOf(context).scale(1) > 1,
                onChanged: (_) => MySandboxApp.of(context).toggleTextScale(),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: SwitchListTile.adaptive(
                title: const Text('Compact preview'),
                value: _compactPreview,
                onChanged: (value) => setState(() => _compactPreview = value),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rendering mode',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'full', label: Text('Full')),
                ButtonSegment(value: 'balanced', label: Text('Balanced')),
                ButtonSegment(value: 'lite', label: Text('Lite')),
              ],
              selected: {
                MySandboxApp.of(context).performance == FrostedPerformance.full
                    ? 'full'
                    : MySandboxApp.of(context).performance ==
                          FrostedPerformance.lite
                    ? 'lite'
                    : 'balanced',
              },
              onSelectionChanged: (selection) {
                final mode = selection.first;
                MySandboxApp.of(context).setPerformance(
                  mode == 'full'
                      ? FrostedPerformance.full
                      : mode == 'lite'
                      ? FrostedPerformance.lite
                      : FrostedPerformance.balanced,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCodePreview(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => AppDialog(
        header: const Text(
          'Primary button',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: FrostedButton.secondary(
          label: 'Close',
          onPressed: () => Navigator.of(context).pop(),
        ),
        child: const SelectableText(
          "FrostedButton.primary(\n"
          "  label: 'Save',\n"
          "  onPressed: save,\n"
          ")",
        ),
      ),
    );
  }

  Widget _buildGridTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return blurredCard(
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.15),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
