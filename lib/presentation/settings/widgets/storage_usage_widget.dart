import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StorageUsageWidget extends StatelessWidget {
  final double usedStorage;
  final double totalStorage;

  const StorageUsageWidget({
    Key? key,
    required this.usedStorage,
    required this.totalStorage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (usedStorage / totalStorage * 100).clamp(0.0, 100.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'storage',
                color: AppTheme.primaryLight,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Storage Usage',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${usedStorage.toStringAsFixed(1)} MB / ${totalStorage.toStringAsFixed(1)} MB',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: percentage > 80
                            ? AppTheme.errorLight
                            : percentage > 60
                                ? AppTheme.warningLight
                                : AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${percentage.toStringAsFixed(1)}% used',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
