import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SummaryCardWidget extends StatelessWidget {
  final Map<String, dynamic>? lastPrediction;
  final VoidCallback onTap;

  const SummaryCardWidget({
    Key? key,
    this.lastPrediction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickActions(context),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: lastPrediction != null
            ? _buildPredictionSummary()
            : _buildEmptyState(),
      ),
    );
  }

  Widget _buildPredictionSummary() {
    final irrigationRecommended =
        lastPrediction!['irrigation_recommended'] as bool? ?? false;
    final waterQuantity = lastPrediction!['water_quantity'] as double? ?? 0.0;
    final fertilizerQuantity =
        lastPrediction!['fertilizer_quantity'] as double? ?? 0.0;
    final timestamp =
        lastPrediction!['timestamp'] as DateTime? ?? DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Last Prediction',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: irrigationRecommended
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : AppTheme.textSecondaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: irrigationRecommended ? 'check_circle' : 'cancel',
                    color: irrigationRecommended
                        ? AppTheme.successLight
                        : AppTheme.textSecondaryLight,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    irrigationRecommended ? 'Irrigate' : 'No Irrigation',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: irrigationRecommended
                          ? AppTheme.successLight
                          : AppTheme.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                icon: 'water_drop',
                iconColor: Colors.blue,
                label: 'Water',
                value: '${waterQuantity.toStringAsFixed(1)}L',
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildMetricItem(
                icon: 'eco',
                iconColor: Colors.orange,
                label: 'Fertilizer',
                value: '${fertilizerQuantity.toStringAsFixed(1)}L',
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          'Predicted ${_formatTimestamp(timestamp)}',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required String icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: iconColor,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'agriculture',
          color: AppTheme.textSecondaryLight,
          size: 48,
        ),
        SizedBox(height: 2.h),
        Text(
          'No Predictions Yet',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Start your first prediction to see results here',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildQuickActionItem(
              context,
              icon: 'share',
              title: 'Share Results',
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            _buildQuickActionItem(
              context,
              icon: 'visibility',
              title: 'View Details',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/prediction-results');
              },
            ),
            _buildQuickActionItem(
              context,
              icon: 'refresh',
              title: 'Repeat Prediction',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sensor-data-input');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.primaryLight,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textPrimaryLight,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
