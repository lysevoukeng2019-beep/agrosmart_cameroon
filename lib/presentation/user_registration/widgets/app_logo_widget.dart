import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppLogoWidget extends StatelessWidget {
  final double? size;
  final bool showText;

  const AppLogoWidget({
    super.key,
    this.size,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 15.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(logoSize * 0.2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background pattern
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(logoSize * 0.2),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),
              // Main icon
              CustomIconWidget(
                iconName: 'eco',
                color: Colors.white,
                size: logoSize * 0.4,
              ),
              // Accent elements
              Positioned(
                top: logoSize * 0.15,
                right: logoSize * 0.15,
                child: Container(
                  width: logoSize * 0.12,
                  height: logoSize * 0.12,
                  decoration: BoxDecoration(
                    color: AppTheme.accentLight,
                    borderRadius: BorderRadius.circular(logoSize * 0.06),
                  ),
                ),
              ),
              Positioned(
                bottom: logoSize * 0.2,
                left: logoSize * 0.2,
                child: Container(
                  width: logoSize * 0.08,
                  height: logoSize * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(logoSize * 0.04),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          SizedBox(height: 2.h),
          Text(
            'AgroSmart',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
          ),
          Text(
            'Cameroun',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ],
    );
  }
}
