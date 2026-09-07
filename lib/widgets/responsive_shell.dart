import 'package:flutter/material.dart';

import '../data/app_navigation.dart';

class ResponsiveShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final void Function(int index) onTap;

  const ResponsiveShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTap,
  });

  static const double _tabletBreakpoint = 800;
  static const double _desktopBreakpoint = 1200;
  static const double _maxContentWidth = 1400;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= _tabletBreakpoint) {
      return _buildTabletLayout(context, screenWidth);
    }
    return _buildMobileLayout();
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: [
          for (final destination in AppNavigationData.destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, double screenWidth) {
    final theme = Theme.of(context);
    final isDesktop = screenWidth >= _desktopBreakpoint;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onTap,
              extended: isDesktop,
              minExtendedWidth: 220,
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              leading: isDesktop
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.movie,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Movie Explorer',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.movie,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
              destinations: [
                for (final destination in AppNavigationData.destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: Text(destination.label),
                  ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _desktopBreakpoint;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= _desktopBreakpoint) return 4;
    if (width >= _tabletBreakpoint) return 3;
    return 2;
  }
}
