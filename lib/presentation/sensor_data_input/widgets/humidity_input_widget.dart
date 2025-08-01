import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HumidityInputWidget extends StatefulWidget {
  final Function(double?) onHumidityChanged;
  final double? initialValue;

  const HumidityInputWidget({
    Key? key,
    required this.onHumidityChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<HumidityInputWidget> createState() => _HumidityInputWidgetState();
}

class _HumidityInputWidgetState extends State<HumidityInputWidget> {
  double _currentValue = 50.0;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _currentValue = widget.initialValue!.clamp(0.0, 100.0);
    }
    widget.onHumidityChanged(_currentValue);
  }

  void _updateValue(double value) {
    setState(() {
      _currentValue = value;
      _errorText = null;
    });

    // Haptic feedback for iOS
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      HapticFeedback.selectionClick();
    }

    widget.onHumidityChanged(_currentValue);
  }

  Color _getHumidityColor(double humidity) {
    if (humidity < 30) return Colors.orange;
    if (humidity > 70) return Colors.blue;
    return AppTheme.lightTheme.primaryColor;
  }

  String _getHumidityLevel(double humidity) {
    if (humidity < 30) return 'Low';
    if (humidity > 70) return 'High';
    return 'Optimal';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'water_drop',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Humidity',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        _getHumidityColor(_currentValue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getHumidityLevel(_currentValue),
                    style: TextStyle(
                      color: _getHumidityColor(_currentValue),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _getHumidityColor(_currentValue),
                      thumbColor: _getHumidityColor(_currentValue),
                      overlayColor: _getHumidityColor(_currentValue)
                          .withValues(alpha: 0.2),
                      valueIndicatorColor: _getHumidityColor(_currentValue),
                      trackHeight: 6,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12),
                    ),
                    child: Slider(
                      value: _currentValue,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: '${_currentValue.round()}%',
                      onChanged: _updateValue,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Container(
                  width: 15.w,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${_currentValue.round()}%',
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getHumidityColor(_currentValue),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Optimal: 30-70%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '100%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
