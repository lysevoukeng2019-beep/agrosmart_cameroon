import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for agricultural application
/// Provides consistent navigation and branding across the app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        ),
      ),
      actions: _buildActions(context),
      leading: leading ??
          (automaticallyImplyLeading ? _buildLeading(context) : null),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: elevation ?? 2.0,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      bottom: bottom,
      iconTheme: IconThemeData(
        color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        size: 24,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }
    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions != null) {
      return actions;
    }

    // Default actions based on current route
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (currentRoute) {
      case '/home-dashboard':
        return [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show weather alerts and notifications
              _showNotifications(context);
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/user-profile');
            },
            tooltip: 'Profile',
          ),
        ];
      case '/crop-database':
        return [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement crop search functionality
              _showCropSearch(context);
            },
            tooltip: 'Search Crops',
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Show crop filters
              _showCropFilters(context);
            },
            tooltip: 'Filter',
          ),
        ];
      case '/community-forum':
        return [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Create new forum post
              _createForumPost(context);
            },
            tooltip: 'New Post',
          ),
        ];
      case '/user-profile':
        return [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              // Show settings
              _showSettings(context);
            },
            tooltip: 'Settings',
          ),
        ];
      default:
        return null;
    }
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.wb_sunny, color: Colors.orange),
              title: Text('Weather Alert'),
              subtitle: Text('High temperature expected today'),
              trailing: Text('2h ago'),
            ),
            ListTile(
              leading: Icon(Icons.water_drop, color: Colors.blue),
              title: Text('Irrigation Reminder'),
              subtitle: Text('Time to water your crops'),
              trailing: Text('4h ago'),
            ),
            ListTile(
              leading: Icon(Icons.bug_report, color: Colors.red),
              title: Text('Pest Alert'),
              subtitle: Text('Aphids detected in your area'),
              trailing: Text('1d ago'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCropSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: CropSearchDelegate(),
    );
  }

  void _showCropFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Crops',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: Text('Vegetables'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: Text('Fruits'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: Text('Grains'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: Text('Herbs'),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createForumPost(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Post',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Post Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Post created successfully!')),
                      );
                    },
                    child: Text('Post'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark Mode'),
              trailing: Switch(value: false, onChanged: (value) {}),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// Custom search delegate for crop search functionality
class CropSearchDelegate extends SearchDelegate<String> {
  final List<String> crops = [
    'Tomato',
    'Potato',
    'Corn',
    'Wheat',
    'Rice',
    'Beans',
    'Carrots',
    'Lettuce',
    'Spinach',
    'Onions',
    'Peppers',
    'Cucumber',
    'Squash',
    'Pumpkin',
    'Cabbage'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = crops
        .where((crop) => crop.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          leading: Icon(Icons.eco),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = crops
        .where((crop) => crop.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          leading: Icon(Icons.eco),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
