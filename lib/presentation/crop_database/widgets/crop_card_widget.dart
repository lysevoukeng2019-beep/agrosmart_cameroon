import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CropCardWidget extends StatelessWidget {
  final Map<String, dynamic> cropData;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isFavorite;

  const CropCardWidget({
    super.key,
    required this.cropData,
    this.onTap,
    this.onLongPress,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: CustomImageWidget(
            imageUrl: cropData["image"] as String,
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
          ),
        ),
        if (isFavorite)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: 'favorite',
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        _buildSeasonalIndicator(context),
      ],
    );
  }

  Widget _buildSeasonalIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final currentMonth = DateTime.now().month;
    final plantingMonths = (cropData["plantingMonths"] as List).cast<int>();
    final harvestMonths = (cropData["harvestMonths"] as List).cast<int>();

    String status = '';
    Color statusColor = theme.colorScheme.surface;

    if (plantingMonths.contains(currentMonth)) {
      status = 'Planting Season';
      statusColor = AppTheme.successLight;
    } else if (harvestMonths.contains(currentMonth)) {
      status = 'Harvest Season';
      statusColor = AppTheme.warningLight;
    }

    if (status.isNotEmpty) {
      return Positioned(
        bottom: 8,
        left: 8,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildContentSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cropData["localName"] as String,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            cropData["scientificName"] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          _buildDifficultyBadge(context),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge(BuildContext context) {
    final theme = Theme.of(context);
    final difficulty = cropData["difficulty"] as String;

    Color badgeColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        badgeColor = AppTheme.successLight;
        break;
      case 'medium':
        badgeColor = AppTheme.warningLight;
        break;
      case 'hard':
        badgeColor = AppTheme.errorLight;
        break;
      default:
        badgeColor = theme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        difficulty,
        style: theme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
