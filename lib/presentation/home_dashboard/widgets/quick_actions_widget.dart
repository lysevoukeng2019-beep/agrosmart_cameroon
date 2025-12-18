import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onCameraPressed;
  final VoidCallback? onWeatherAlertPressed;
  final VoidCallback? onEmergencyPressed;

  const QuickActionsWidget({
    super.key,
    this.onCameraPressed,
    this.onWeatherAlertPressed,
    this.onEmergencyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            context,
            icon: 'camera_alt',
            label: 'Analyser\nPlante',
            color: theme.colorScheme.primary,
            onPressed: onCameraPressed ?? () => _handleCameraAction(context),
          ),
          _buildQuickActionButton(
            context,
            icon: 'cloud',
            label: 'Météo\nDétaillée',
            color: Colors.blue,
            onPressed:
                onWeatherAlertPressed ?? () => _handleWeatherAction(context),
          ),
          _buildQuickActionButton(
            context,
            icon: 'emergency',
            label: 'Urgence\nAgricole',
            color: AppTheme.errorLight,
            onPressed:
                onEmergencyPressed ?? () => _handleEmergencyAction(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 25.w,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleCameraAction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Analyser une Plante',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Prenez une photo de votre plante pour détecter les maladies, parasites ou carences nutritionnelles.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCameraOption(
                  context,
                  icon: 'camera_alt',
                  label: 'Appareil Photo',
                  onPressed: () {
                    Navigator.pop(context);
                    // Open camera
                  },
                ),
                _buildCameraOption(
                  context,
                  icon: 'photo_library',
                  label: 'Galerie',
                  onPressed: () {
                    Navigator.pop(context);
                    // Open gallery
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleWeatherAction(BuildContext context) {
    Navigator.pushNamed(context, '/weather-details');
  }

  void _handleEmergencyAction(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.errorLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Urgence Agricole'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Que souhaitez-vous signaler?'),
            SizedBox(height: 2.h),
            _buildEmergencyOption(
              context,
              'Maladie des cultures',
              'bug_report',
            ),
            _buildEmergencyOption(
              context,
              'Invasion de parasites',
              'pest_control',
            ),
            _buildEmergencyOption(
              context,
              'Conditions météo extrêmes',
              'thunderstorm',
            ),
            _buildEmergencyOption(
              context,
              'Problème d\'irrigation',
              'water_damage',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraOption(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.primary,
              size: 32,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyOption(
    BuildContext context,
    String label,
    String icon,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.errorLight,
        size: 20,
      ),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        // Handle emergency report
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signalement envoyé: $label'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      },
    );
  }
}
