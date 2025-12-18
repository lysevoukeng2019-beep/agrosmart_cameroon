import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgeWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementBadgeWidget({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.accentLight,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Réalisations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          achievements.isEmpty
              ? _buildEmptyAchievements(context)
              : Wrap(
                  spacing: 3.w,
                  runSpacing: 2.h,
                  children: achievements
                      .map((achievement) => _buildBadge(context, achievement))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyAchievements(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'emoji_events',
            color: AppTheme.textSecondaryLight,
            size: 8.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Aucune réalisation pour le moment',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Continuez à utiliser l\'application pour débloquer des badges',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, Map<String, dynamic> achievement) {
    final isUnlocked = achievement['unlocked'] as bool;
    final badgeColor = isUnlocked
        ? _getBadgeColor(achievement['type'] as String)
        : AppTheme.textSecondaryLight;

    return Container(
      width: 25.w,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: badgeColor,
                width: 2,
              ),
            ),
            child: CustomIconWidget(
              iconName: achievement['icon'] as String,
              color: badgeColor,
              size: 7.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            achievement['title'] as String,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isUnlocked
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textSecondaryLight,
                  fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w400,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (achievement['description'] != null) ...[
            SizedBox(height: 0.5.h),
            Text(
              achievement['description'] as String,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Color _getBadgeColor(String type) {
    switch (type.toLowerCase()) {
      case 'farming':
        return AppTheme.successLight;
      case 'community':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'usage':
        return AppTheme.accentLight;
      case 'milestone':
        return AppTheme.warningLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
