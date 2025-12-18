import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationSettingsWidget extends StatelessWidget {
  final Map<String, bool> notificationSettings;
  final Function(String, bool) onSettingChanged;

  const NotificationSettingsWidget({
    super.key,
    required this.notificationSettings,
    required this.onSettingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final settings = [
      {
        'key': 'weather_alerts',
        'title': 'Alertes météo',
        'subtitle':
            'Notifications pour les conditions météorologiques importantes',
        'icon': 'wb_sunny',
      },
      {
        'key': 'crop_reminders',
        'title': 'Rappels de culture',
        'subtitle': 'Notifications pour l\'arrosage, la fertilisation, etc.',
        'icon': 'schedule',
      },
      {
        'key': 'community_updates',
        'title': 'Mises à jour communautaires',
        'subtitle': 'Nouveaux messages et discussions du forum',
        'icon': 'forum',
      },
      {
        'key': 'expert_advice',
        'title': 'Conseils d\'experts',
        'subtitle': 'Recommandations personnalisées et conseils agricoles',
        'icon': 'lightbulb',
      },
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
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Paramètres de notification',
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
          ...settings
              .map((setting) => _buildNotificationSetting(context, setting))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildNotificationSetting(
      BuildContext context, Map<String, String> setting) {
    final isEnabled = notificationSettings[setting['key']] ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: setting['icon']!,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setting['title']!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textPrimaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  setting['subtitle']!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) => onSettingChanged(setting['key']!, value),
            activeColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
