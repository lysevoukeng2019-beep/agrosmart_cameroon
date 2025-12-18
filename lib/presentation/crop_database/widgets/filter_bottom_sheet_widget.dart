import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, List<String>> selectedFilters;
  final Function(Map<String, List<String>>)? onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.selectedFilters,
    this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, List<String>> _tempFilters;
  final Map<String, bool> _expandedSections = {
    'category': true,
    'season': false,
    'difficulty': false,
    'varieties': false,
  };

  @override
  void initState() {
    super.initState();
    _tempFilters = Map<String, List<String>>.from(widget.selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  _buildFilterSection(
                    context,
                    'category',
                    'Catégorie de culture',
                    [
                      'Légumes',
                      'Fruits',
                      'Céréales',
                      'Légumineuses',
                      'Tubercules',
                      'Épices'
                    ],
                  ),
                  _buildFilterSection(
                    context,
                    'season',
                    'Saison de plantation',
                    ['Saison sèche', 'Saison des pluies', 'Toute l\'année'],
                  ),
                  _buildFilterSection(
                    context,
                    'difficulty',
                    'Niveau de difficulté',
                    ['Facile', 'Moyen', 'Difficile'],
                  ),
                  _buildFilterSection(
                    context,
                    'varieties',
                    'Variétés locales',
                    [
                      'Variétés traditionnelles',
                      'Variétés améliorées',
                      'Variétés hybrides'
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Filtrer les cultures',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Tout effacer',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    String sectionKey,
    String title,
    List<String> options,
  ) {
    final theme = Theme.of(context);
    final isExpanded = _expandedSections[sectionKey] ?? false;
    final selectedOptions = _tempFilters[sectionKey] ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleSection(sectionKey),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
              bottom: isExpanded ? Radius.zero : Radius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (selectedOptions.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(right: 2.w),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedOptions.length.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: options
                    .map((option) => _buildFilterOption(
                          context,
                          sectionKey,
                          option,
                          selectedOptions.contains(option),
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String sectionKey,
    String option,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(option),
      selected: isSelected,
      onSelected: (selected) => _toggleFilter(sectionKey, option, selected),
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: theme.colorScheme.primary,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
        width: 1,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Appliquer'),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSection(String sectionKey) {
    setState(() {
      _expandedSections[sectionKey] = !(_expandedSections[sectionKey] ?? false);
    });
  }

  void _toggleFilter(String sectionKey, String option, bool selected) {
    setState(() {
      if (!_tempFilters.containsKey(sectionKey)) {
        _tempFilters[sectionKey] = [];
      }

      if (selected) {
        if (!_tempFilters[sectionKey]!.contains(option)) {
          _tempFilters[sectionKey]!.add(option);
        }
      } else {
        _tempFilters[sectionKey]!.remove(option);
        if (_tempFilters[sectionKey]!.isEmpty) {
          _tempFilters.remove(sectionKey);
        }
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      _tempFilters.clear();
    });
  }

  void _applyFilters() {
    if (widget.onFiltersChanged != null) {
      widget.onFiltersChanged!(_tempFilters);
    }
    Navigator.pop(context);
  }
}
