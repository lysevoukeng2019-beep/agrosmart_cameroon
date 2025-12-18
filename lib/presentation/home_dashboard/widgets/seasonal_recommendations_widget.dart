import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SeasonalRecommendationsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recommendations;
  final VoidCallback? onSeeAll;

  const SeasonalRecommendationsWidget({
    super.key,
    required this.recommendations,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Recommandations Saisonnières',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'Voir tout',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          ...recommendations.take(3).map(
                (recommendation) =>
                    _buildRecommendationItem(context, recommendation),
              ),
          if (recommendations.length > 3) ...[
            SizedBox(height: 1.h),
            Center(
              child: TextButton.icon(
                onPressed: onSeeAll,
                icon: CustomIconWidget(
                  iconName: 'expand_more',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  'Voir ${recommendations.length - 3} autres recommandations',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
    BuildContext context,
    Map<String, dynamic> recommendation,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _getCategoryColor(recommendation["category"] as String)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getCategoryColor(recommendation["category"] as String)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color:
                      _getCategoryColor(recommendation["category"] as String),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName:
                      _getCategoryIcon(recommendation["category"] as String),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation["title"] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(
                                    recommendation["category"] as String)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            recommendation["category"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getCategoryColor(
                                  recommendation["category"] as String),
                              fontWeight: FontWeight.w500,
                              fontSize: 9.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.6) ??
                              Colors.grey,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          recommendation["timeframe"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 9.sp,
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            recommendation["description"] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (recommendation["benefits"] != null &&
              (recommendation["benefits"] as List).isNotEmpty) ...[
            SizedBox(height: 1.h),
            Text(
              'Avantages:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 0.5.h),
            ...(recommendation["benefits"] as List).take(2).map(
                  (benefit) => Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.successLight,
                          size: 12,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            benefit as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: Colors.amber,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Priorité ${recommendation["priority"]}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Bookmark functionality
                    },
                    icon: CustomIconWidget(
                      iconName: 'bookmark_border',
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 6.w,
                      minHeight: 3.h,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Share functionality
                    },
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 6.w,
                      minHeight: 3.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'plantation':
        return AppTheme.successLight;
      case 'irrigation':
        return Colors.blue;
      case 'fertilisation':
        return Colors.brown;
      case 'traitement':
        return AppTheme.warningLight;
      case 'récolte':
        return Colors.orange;
      case 'préparation du sol':
        return Colors.brown.shade600;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'plantation':
        return 'eco';
      case 'irrigation':
        return 'water_drop';
      case 'fertilisation':
        return 'grass';
      case 'traitement':
        return 'healing';
      case 'récolte':
        return 'agriculture';
      case 'préparation du sol':
        return 'landscape';
      default:
        return 'info';
    }
  }
}
