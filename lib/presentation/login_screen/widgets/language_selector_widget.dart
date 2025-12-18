import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelectorWidget({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final languages = [
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'ff', 'name': 'Fulfulde', 'flag': '🇨🇲'},
      {'code': 'ew', 'name': 'Ewondo', 'flag': '🇨🇲'},
      {'code': 'du', 'name': 'Duala', 'flag': '🇨🇲'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          onChanged: (String? newValue) {
            if (newValue != null) {
              onLanguageChanged(newValue);
            }
          },
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: theme.colorScheme.onSurface,
            size: 5.w,
          ),
          style: theme.textTheme.bodyMedium,
          dropdownColor: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(2.w),
          items: languages.map<DropdownMenuItem<String>>((language) {
            return DropdownMenuItem<String>(
              value: language['code'],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    language['flag']!,
                    style: TextStyle(fontSize: 5.w),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    language['name']!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: selectedLanguage == language['code']
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
