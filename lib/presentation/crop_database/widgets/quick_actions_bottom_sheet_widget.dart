import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsBottomSheetWidget extends StatelessWidget {
  final Map<String, dynamic> cropData;
  final bool isFavorite;
  final VoidCallback? onAddToFavorites;
  final VoidCallback? onRemoveFromFavorites;
  final VoidCallback? onShareInformation;
  final VoidCallback? onSetPlantingReminder;
  final VoidCallback? onViewDetails;

  const QuickActionsBottomSheetWidget({
    super.key,
    required this.cropData,
    this.isFavorite = false,
    this.onAddToFavorites,
    this.onRemoveFromFavorites,
    this.onShareInformation,
    this.onSetPlantingReminder,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          _buildCropInfo(context),
          _buildActionsList(context),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Actions rapides',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: cropData["image"] as String,
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
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
                SizedBox(height: 1.h),
                Text(
                  cropData["scientificName"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsList(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          _buildActionTile(
            context,
            icon: isFavorite ? 'favorite' : 'favorite_border',
            title: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
            subtitle: isFavorite
                ? 'Supprimer de votre liste de cultures favorites'
                : 'Sauvegarder dans votre liste de cultures favorites',
            iconColor: isFavorite ? Colors.red : theme.colorScheme.primary,
            onTap: isFavorite ? onRemoveFromFavorites : onAddToFavorites,
          ),
          _buildActionTile(
            context,
            icon: 'share',
            title: 'Partager les informations',
            subtitle: 'Partager les détails de cette culture avec d\'autres',
            iconColor: theme.colorScheme.primary,
            onTap: onShareInformation,
          ),
          _buildActionTile(
            context,
            icon: 'schedule',
            title: 'Définir un rappel de plantation',
            subtitle: 'Recevoir une notification pour la saison de plantation',
            iconColor: AppTheme.warningLight,
            onTap: onSetPlantingReminder,
          ),
          _buildActionTile(
            context,
            icon: 'info',
            title: 'Voir les détails complets',
            subtitle: 'Accéder à toutes les informations sur cette culture',
            iconColor: AppTheme.successLight,
            onTap: onViewDetails,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          if (onTap != null) {
            onTap();
          }
        },
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: iconColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          size: 16,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: theme.colorScheme.surface,
      ),
    );
  }
}
