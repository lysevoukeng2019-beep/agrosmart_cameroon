import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FarmingTaskCardWidget extends StatefulWidget {
  final Map<String, dynamic> task;
  final Function(String taskId, bool completed)? onTaskToggle;
  final Function(String taskId)? onTaskPostpone;

  const FarmingTaskCardWidget({
    super.key,
    required this.task,
    this.onTaskToggle,
    this.onTaskPostpone,
  });

  @override
  State<FarmingTaskCardWidget> createState() => _FarmingTaskCardWidgetState();
}

class _FarmingTaskCardWidgetState extends State<FarmingTaskCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task["completed"] as bool? ?? false;
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Dismissible(
            key: Key(widget.task["id"] as String),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                // Swipe right - mark as completed
                _toggleTask();
                return false;
              } else {
                // Swipe left - postpone
                _postponeTask();
                return false;
              }
            },
            background: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.successLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Terminé',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Reporter',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
            child: GestureDetector(
              onTapDown: (_) => _animationController.forward(),
              onTapUp: (_) => _animationController.reverse(),
              onTapCancel: () => _animationController.reverse(),
              onLongPress: _showContextMenu,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: _isCompleted
                      ? AppTheme.successLight.withValues(alpha: 0.1)
                      : theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCompleted
                        ? AppTheme.successLight.withValues(alpha: 0.3)
                        : theme.dividerColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleTask,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: _isCompleted
                              ? AppTheme.successLight
                              : Colors.transparent,
                          border: Border.all(
                            color: _isCompleted
                                ? AppTheme.successLight
                                : theme.dividerColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task["title"] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              decoration: _isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: _isCompleted
                                  ? theme.textTheme.bodySmall?.color
                                  : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          if (widget.task["description"] != null) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              widget.task["description"] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                decoration: _isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor()
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.task["priority"] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: _getPriorityColor(),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'schedule',
                                color: theme.textTheme.bodySmall?.color ??
                                    Colors.grey,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                widget.task["time"] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: _getTaskIcon(),
                      color: _getPriorityColor(),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPriorityColor() {
    switch (widget.task["priority"] as String) {
      case 'Urgent':
        return AppTheme.errorLight;
      case 'Important':
        return AppTheme.warningLight;
      case 'Normal':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getTaskIcon() {
    final category = widget.task["category"] as String? ?? "";
    switch (category.toLowerCase()) {
      case 'irrigation':
        return 'water_drop';
      case 'plantation':
        return 'eco';
      case 'fertilisation':
        return 'grass';
      case 'récolte':
        return 'agriculture';
      case 'traitement':
        return 'healing';
      default:
        return 'task_alt';
    }
  }

  void _toggleTask() {
    setState(() {
      _isCompleted = !_isCompleted;
    });

    if (widget.onTaskToggle != null) {
      widget.onTaskToggle!(
        widget.task["id"] as String,
        _isCompleted,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCompleted ? 'Tâche terminée!' : 'Tâche marquée comme non terminée',
        ),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            setState(() {
              _isCompleted = !_isCompleted;
            });
            if (widget.onTaskToggle != null) {
              widget.onTaskToggle!(
                widget.task["id"] as String,
                _isCompleted,
              );
            }
          },
        ),
      ),
    );
  }

  void _postponeTask() {
    if (widget.onTaskPostpone != null) {
      widget.onTaskPostpone!(widget.task["id"] as String);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tâche reportée à demain'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showContextMenu() {
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
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Partager'),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Ajouter aux favoris'),
              onTap: () {
                Navigator.pop(context);
                // Implement bookmark functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Définir un rappel'),
              onTap: () {
                Navigator.pop(context);
                // Implement reminder functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
