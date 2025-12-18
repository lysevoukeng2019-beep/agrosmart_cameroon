import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar for agricultural application
/// Provides main navigation between core app sections
class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final bool showLabels;
  final double? elevation;

  const CustomBottomBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.showLabels = true,
    this.elevation,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black12,
            blurRadius: widget.elevation ?? 8.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavigationItems(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavigationItems(BuildContext context) {
    final items = _getNavigationItems();

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == widget.currentIndex;

      return Expanded(
        child: GestureDetector(
          onTap: () => _handleTap(context, index),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: isSelected ? _animation.value : 1.0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: isSelected
                                ? Theme.of(context)
                                    .bottomNavigationBarTheme
                                    .selectedItemColor
                                : Theme.of(context)
                                    .bottomNavigationBarTheme
                                    .unselectedItemColor,
                            size: 24,
                          ),
                          if (item.badgeCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  item.badgeCount > 99
                                      ? '99+'
                                      : item.badgeCount.toString(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (widget.showLabels) ...[
                        SizedBox(height: 4),
                        Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? Theme.of(context)
                                    .bottomNavigationBarTheme
                                    .selectedItemColor
                                : Theme.of(context)
                                    .bottomNavigationBarTheme
                                    .unselectedItemColor,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }).toList();
  }

  List<NavigationItem> _getNavigationItems() {
    return [
      NavigationItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
        route: '/home-dashboard',
        badgeCount: 0,
      ),
      NavigationItem(
        icon: Icons.eco_outlined,
        activeIcon: Icons.eco,
        label: 'Crops',
        route: '/crop-database',
        badgeCount: 0,
      ),
      NavigationItem(
        icon: Icons.forum_outlined,
        activeIcon: Icons.forum,
        label: 'Community',
        route: '/community-forum',
        badgeCount: 3, // Example: 3 new messages
      ),
      NavigationItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
        route: '/user-profile',
        badgeCount: 0,
      ),
    ];
  }

  void _handleTap(BuildContext context, int index) {
    if (index == widget.currentIndex) {
      // If tapping the same tab, scroll to top or refresh
      return;
    }

    // Trigger animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Handle navigation
    final items = _getNavigationItems();
    final selectedItem = items[index];

    // Call the onTap callback if provided
    if (widget.onTap != null) {
      widget.onTap!(index);
    } else {
      // Default navigation behavior
      Navigator.pushReplacementNamed(context, selectedItem.route);
    }

    // Provide haptic feedback
    _triggerHapticFeedback();
  }

  void _triggerHapticFeedback() {
    // Light haptic feedback for navigation
    // Note: You might want to add haptic_feedback package for more control
  }
}

/// Navigation item model for bottom bar items
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final int badgeCount;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    this.badgeCount = 0,
  });
}

/// Enhanced Bottom Navigation Bar with floating action button integration
class CustomBottomBarWithFAB extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final VoidCallback? onFABPressed;
  final IconData? fabIcon;
  final String? fabTooltip;

  const CustomBottomBarWithFAB({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.onFABPressed,
    this.fabIcon,
    this.fabTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        CustomBottomBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
        Positioned(
          top: -28,
          child: FloatingActionButton(
            onPressed: onFABPressed ?? () => _handleFABPress(context),
            child: Icon(fabIcon ?? Icons.camera_alt),
            tooltip: fabTooltip ?? 'Capture Photo',
            elevation: 6.0,
          ),
        ),
      ],
    );
  }

  void _handleFABPress(BuildContext context) {
    // Default FAB action - open camera for plant analysis
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Capture Plant Photo',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Open camera
                      },
                      icon: Icon(Icons.camera_alt, size: 32),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        padding: EdgeInsets.all(16),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Camera', style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Open gallery
                      },
                      icon: Icon(Icons.photo_library, size: 32),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        padding: EdgeInsets.all(16),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Gallery', style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
