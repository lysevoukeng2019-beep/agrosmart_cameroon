import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchHeaderWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback? onFilterPressed;
  final Function(String)? onSearchChanged;
  final List<String> suggestions;
  final bool showSuggestions;

  const SearchHeaderWidget({
    super.key,
    required this.searchController,
    this.onFilterPressed,
    this.onSearchChanged,
    this.suggestions = const [],
    this.showSuggestions = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          _buildSearchBar(context),
          if (showSuggestions && suggestions.isNotEmpty)
            _buildSuggestions(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Rechercher des cultures...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Container(
            width: 1,
            height: 6.h,
            color: theme.dividerColor,
          ),
          InkWell(
            onTap: onFilterPressed,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
            child: Container(
              padding: EdgeInsets.all(16),
              child: CustomIconWidget(
                iconName: 'filter_list',
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(top: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: suggestions.length > 5 ? 5 : suggestions.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            dense: true,
            leading: CustomIconWidget(
              iconName: 'eco',
              color: theme.colorScheme.primary,
              size: 20,
            ),
            title: Text(
              suggestion,
              style: theme.textTheme.bodyMedium,
            ),
            onTap: () {
              searchController.text = suggestion;
              if (onSearchChanged != null) {
                onSearchChanged!(suggestion);
              }
            },
          );
        },
      ),
    );
  }
}
