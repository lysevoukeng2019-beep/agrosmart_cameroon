import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OfflineDataWidget extends StatelessWidget {
  final double storageUsed;
  final double totalStorage;
  final DateTime? lastSyncTime;
  final bool isSyncing;
  final VoidCallback onSyncPressed;
  final VoidCallback onClearCachePressed;

  const OfflineDataWidget({
    super.key,
    required this.storageUsed,
    required this.totalStorage,
    this.lastSyncTime,
    this.isSyncing = false,
    required this.onSyncPressed,
    required this.onClearCachePressed,
  });

  @override
  Widget build(BuildContext context) {
    final storagePercentage = (storageUsed / totalStorage).clamp(0.0, 1.0);

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
                iconName: 'cloud_download',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Données hors ligne',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildStorageInfo(context, storagePercentage),
          SizedBox(height: 3.h),
          _buildSyncInfo(context),
          SizedBox(height: 3.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildStorageInfo(BuildContext context, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Stockage utilisé',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              '${storageUsed.toStringAsFixed(1)} MB / ${totalStorage.toStringAsFixed(0)} MB',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          height: 1.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(0.5.h),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: _getStorageColor(percentage),
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          _getStorageStatusText(percentage),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStorageColor(percentage),
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildSyncInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isSyncing ? 'sync' : 'sync_disabled',
            color: isSyncing
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.textSecondaryLight,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSyncing
                      ? 'Synchronisation en cours...'
                      : 'État de synchronisation',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (!isSyncing && lastSyncTime != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'Dernière sync: ${_formatSyncTime(lastSyncTime!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isSyncing ? null : onSyncPressed,
            icon: CustomIconWidget(
              iconName: 'sync',
              color: isSyncing
                  ? AppTheme.textSecondaryLight
                  : AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            label: Text(isSyncing ? 'Synchronisation...' : 'Synchroniser'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onClearCachePressed,
            icon: CustomIconWidget(
              iconName: 'delete_sweep',
              color: AppTheme.errorLight,
              size: 4.w,
            ),
            label: Text('Vider cache'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorLight,
              side: BorderSide(color: AppTheme.errorLight),
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStorageColor(double percentage) {
    if (percentage < 0.7) return AppTheme.successLight;
    if (percentage < 0.9) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  String _getStorageStatusText(double percentage) {
    if (percentage < 0.7) return 'Espace disponible';
    if (percentage < 0.9) return 'Espace limité';
    return 'Espace presque plein';
  }

  String _formatSyncTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'À l\'instant';
    if (difference.inHours < 1) return '${difference.inMinutes}min';
    if (difference.inDays < 1) return '${difference.inHours}h';
    return '${difference.inDays}j';
  }
}
