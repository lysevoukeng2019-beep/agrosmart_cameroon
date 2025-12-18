import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostContextMenu extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback? onSave;
  final VoidCallback? onFollow;
  final VoidCallback? onReport;
  final VoidCallback? onShare;

  const PostContextMenu({
    super.key,
    required this.post,
    this.onSave,
    this.onFollow,
    this.onReport,
    this.onShare,
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
          _buildHandle(theme),
          _buildPostPreview(theme),
          _buildMenuOptions(theme, context),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHandle(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      width: 12.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPostPreview(ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: post["avatar"] as String,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post["author"] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  post["title"] as String,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(ThemeData theme, BuildContext context) {
    return Column(
      children: [
        _buildMenuOption(
          theme,
          'bookmark_border',
          'Sauvegarder la publication',
          'Enregistrer pour plus tard',
          onSave,
        ),
        _buildMenuOption(
          theme,
          'notifications_active',
          'Suivre la discussion',
          'Recevoir des notifications pour les réponses',
          onFollow,
        ),
        _buildMenuOption(
          theme,
          'share',
          'Partager',
          'Partager avec d\'autres agriculteurs',
          onShare,
        ),
        Divider(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          height: 2.h,
        ),
        _buildMenuOption(
          theme,
          'report',
          'Signaler le contenu',
          'Signaler un contenu inapproprié',
          () => _showReportDialog(context, theme),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildMenuOption(
    ThemeData theme,
    String iconName,
    String title,
    String subtitle,
    VoidCallback? onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: isDestructive
              ? theme.colorScheme.error.withValues(alpha: 0.1)
              : theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            size: 20,
            color: isDestructive
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
          ),
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: isDestructive ? theme.colorScheme.error : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      onTap: onTap,
    );
  }

  void _showReportDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Signaler le contenu',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pourquoi signalez-vous cette publication ?',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            ..._getReportReasons().map((reason) => RadioListTile<String>(
                  title: Text(
                    reason,
                    style: theme.textTheme.bodyMedium,
                  ),
                  value: reason,
                  groupValue: null,
                  onChanged: (value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Signalement envoyé. Merci pour votre aide.'),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    );
                  },
                )),
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

  List<String> _getReportReasons() {
    return [
      'Contenu inapproprié',
      'Spam ou publicité',
      'Informations incorrectes',
      'Harcèlement',
      'Autre',
    ];
  }
}
