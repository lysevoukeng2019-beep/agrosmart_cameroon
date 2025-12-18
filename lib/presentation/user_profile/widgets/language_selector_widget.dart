import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

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
    final languages = [
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'ff', 'name': 'Fulfulde', 'flag': '🇨🇲'},
      {'code': 'ew', 'name': 'Ewondo', 'flag': '🇨🇲'},
      {'code': 'du', 'name': 'Duala', 'flag': '🇨🇲'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'language',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Langue de l\'application',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.dividerLight,
            indent: 4.w,
            endIndent: 4.w,
          ),
          ...languages
              .map((language) => _buildLanguageOption(context, language))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, Map<String, String> language) {
    final isSelected = selectedLanguage == language['code'];

    return InkWell(
      onTap: () => onLanguageChanged(language['code']!),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            Text(
              language['flag']!,
              style: TextStyle(fontSize: 6.w),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                language['name']!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.textPrimaryLight,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }
}
