import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CropHealthCardWidget extends StatelessWidget {
  final Map<String, dynamic> cropData;
  final VoidCallback? onTap;

  const CropHealthCardWidget({
    super.key,
    required this.cropData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 3.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Container(
              height: 20.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                color: Colors.grey.withValues(alpha: 0.1),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: CustomImageWidget(
                      imageUrl: cropData["image"] as String,
                      width: double.infinity,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Health status overlay
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getHealthStatusColor().withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: _getHealthStatusIcon(),
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            cropData["healthStatus"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Analysis date
                  Positioned(
                    bottom: 2.w,
                    left: 2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cropData["analysisDate"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content section
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cropData["cropName"] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    cropData["location"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  if (cropData["issues"] != null &&
                      (cropData["issues"] as List).isNotEmpty) ...[
                    Text(
                      'Problèmes détectés:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    ...(cropData["issues"] as List).take(2).map(
                          (issue) => Padding(
                            padding: EdgeInsets.only(bottom: 0.5.h),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'fiber_manual_record',
                                  color: AppTheme.errorLight,
                                  size: 8,
                                ),
                                SizedBox(width: 1.w),
                                Expanded(
                                  child: Text(
                                    issue as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 10.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    if ((cropData["issues"] as List).length > 2)
                      Text(
                        '+${(cropData["issues"] as List).length - 2} autres problèmes',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                        ),
                      ),
                  ] else ...[
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.successLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            'Aucun problème détecté',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.successLight,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 1.h),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Show detailed analysis
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            side: BorderSide(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            'Détails',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: _showContextMenu,
                          icon: CustomIconWidget(
                            iconName: 'more_vert',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 8.w,
                            minHeight: 4.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getHealthStatusColor() {
    switch (cropData["healthStatus"] as String) {
      case 'Excellent':
        return AppTheme.successLight;
      case 'Bon':
        return Colors.green;
      case 'Moyen':
        return AppTheme.warningLight;
      case 'Mauvais':
        return AppTheme.errorLight;
      case 'Critique':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  String _getHealthStatusIcon() {
    switch (cropData["healthStatus"] as String) {
      case 'Excellent':
        return 'star';
      case 'Bon':
        return 'check_circle';
      case 'Moyen':
        return 'warning';
      case 'Mauvais':
        return 'error';
      case 'Critique':
        return 'dangerous';
      default:
        return 'help';
    }
  }

  void _showContextMenu() {
    // Context menu implementation would go here
    // This is a placeholder for the long-press context menu
  }
}
