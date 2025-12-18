import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SocialLoginWidget extends StatelessWidget {
  final bool isLoading;
  final Function() onWhatsAppLogin;

  const SocialLoginWidget({
    super.key,
    required this.isLoading,
    required this.onWhatsAppLogin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'ou',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // WhatsApp Login Button
        SizedBox(
          height: 6.h,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onWhatsAppLogin,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Color(0xFF25D366),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            icon: CustomIconWidget(
              iconName: 'chat',
              color: Color(0xFF25D366),
              size: 6.w,
            ),
            label: Text(
              'Continuer avec WhatsApp',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Color(0xFF25D366),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Info text for WhatsApp login
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: theme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Connexion rapide pour les zones rurales avec WhatsApp',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
