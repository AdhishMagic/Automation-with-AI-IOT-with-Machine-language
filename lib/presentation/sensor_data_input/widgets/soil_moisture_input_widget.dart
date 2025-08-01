import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SoilMoistureInputWidget extends StatefulWidget {
  final Function(double?) onMoistureChanged;
  final double? initialValue;

  const SoilMoistureInputWidget({
    Key? key,
    required this.onMoistureChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<SoilMoistureInputWidget> createState() =>
      _SoilMoistureInputWidgetState();
}

class _SoilMoistureInputWidgetState extends State<SoilMoistureInputWidget> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  double? _currentValue;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _currentValue = widget.initialValue;
      _controller.text = widget.initialValue!.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndUpdate(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorText = null;
        _currentValue = null;
      });
      widget.onMoistureChanged(null);
      return;
    }

    final double? moisture = double.tryParse(value);
    if (moisture == null) {
      setState(() => _errorText = 'Please enter a valid number');
      widget.onMoistureChanged(null);
      return;
    }

    if (moisture < 0 || moisture > 100) {
      setState(() => _errorText = 'Soil moisture must be between 0-100%');
      widget.onMoistureChanged(null);
      return;
    }

    setState(() {
      _errorText = null;
      _currentValue = moisture;
    });
    widget.onMoistureChanged(moisture);
  }

  Color _getMoistureColor(double? moisture) {
    if (moisture == null) return Colors.grey;
    if (moisture < 20) return Colors.red;
    if (moisture < 40) return Colors.orange;
    if (moisture < 60) return AppTheme.lightTheme.primaryColor;
    if (moisture < 80) return Colors.blue;
    return Colors.indigo;
  }

  String _getMoistureLevel(double? moisture) {
    if (moisture == null) return 'Unknown';
    if (moisture < 20) return 'Very Dry';
    if (moisture < 40) return 'Dry';
    if (moisture < 60) return 'Optimal';
    if (moisture < 80) return 'Moist';
    return 'Saturated';
  }

  List<Widget> _buildMoistureIndicators() {
    return List.generate(5, (index) {
      final threshold = (index + 1) * 20.0;
      final isActive =
          _currentValue != null && _currentValue! >= threshold - 20;
      final color =
          isActive ? _getMoistureColor(threshold) : Colors.grey.shade300;

      return Expanded(
        child: Container(
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    });
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
                  iconName: 'grass',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Soil Moisture',
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
                        _getMoistureColor(_currentValue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getMoistureLevel(_currentValue),
                    style: TextStyle(
                      color: _getMoistureColor(_currentValue),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: _validateAndUpdate,
              decoration: InputDecoration(
                hintText: 'Enter soil moisture percentage',
                suffixText: '%',
                errorText: _errorText,
                prefixIcon: Icon(
                  Icons.opacity,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Moisture Level Indicator',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Row(children: _buildMoistureIndicators()),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dry',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  'Optimal',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  'Saturated',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.indigo,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
            if (_errorText == null) ...[
              SizedBox(height: 1.h),
              Text(
                'Range: 0-100% • Optimal: 40-60%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
