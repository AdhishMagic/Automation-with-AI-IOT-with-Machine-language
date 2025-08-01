import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhInputWidget extends StatefulWidget {
  final Function(double?) onPhChanged;
  final double? initialValue;

  const PhInputWidget({
    Key? key,
    required this.onPhChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<PhInputWidget> createState() => _PhInputWidgetState();
}

class _PhInputWidgetState extends State<PhInputWidget> {
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
      widget.onPhChanged(null);
      return;
    }

    final double? ph = double.tryParse(value);
    if (ph == null) {
      setState(() => _errorText = 'Please enter a valid pH value');
      widget.onPhChanged(null);
      return;
    }

    if (ph < 0 || ph > 14) {
      setState(() => _errorText = 'pH must be between 0-14');
      widget.onPhChanged(null);
      return;
    }

    setState(() {
      _errorText = null;
      _currentValue = ph;
    });
    widget.onPhChanged(ph);
  }

  Color _getPhColor(double? ph) {
    if (ph == null) return Colors.grey;
    if (ph < 4) return Colors.red;
    if (ph < 6) return Colors.orange;
    if (ph < 8) return AppTheme.lightTheme.primaryColor;
    if (ph < 10) return Colors.blue;
    return Colors.purple;
  }

  String _getPhLevel(double? ph) {
    if (ph == null) return 'Unknown';
    if (ph < 4) return 'Very Acidic';
    if (ph < 6) return 'Acidic';
    if (ph < 8) return 'Neutral';
    if (ph < 10) return 'Alkaline';
    return 'Very Alkaline';
  }

  Widget _buildPhScale() {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
          ],
        ),
      ),
      child: _currentValue != null
          ? Stack(
              children: [
                Positioned(
                  left: (_currentValue! / 14) * 100.w - 20.w - 8,
                  top: -8,
                  child: Container(
                    width: 16,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _getPhColor(_currentValue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
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
                  iconName: 'science',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'pH Level',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getPhColor(_currentValue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getPhLevel(_currentValue),
                    style: TextStyle(
                      color: _getPhColor(_currentValue),
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
                hintText: 'Enter pH value (0-14)',
                errorText: _errorText,
                prefixIcon: Icon(
                  Icons.water_drop_outlined,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                suffixText: 'pH',
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'pH Scale',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            _buildPhScale(),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Acidic',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  '7',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Alkaline',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.blue,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  '14',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.purple,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (_errorText == null) ...[
              SizedBox(height: 1.h),
              Text(
                'Optimal for most crops: 6.0-7.5 pH',
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
