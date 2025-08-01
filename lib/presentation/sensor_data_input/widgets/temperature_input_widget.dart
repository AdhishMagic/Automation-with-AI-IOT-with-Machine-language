import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TemperatureInputWidget extends StatefulWidget {
  final Function(double?) onTemperatureChanged;
  final double? initialValue;

  const TemperatureInputWidget({
    Key? key,
    required this.onTemperatureChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<TemperatureInputWidget> createState() => _TemperatureInputWidgetState();
}

class _TemperatureInputWidgetState extends State<TemperatureInputWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isCelsius = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
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
      setState(() => _errorText = null);
      widget.onTemperatureChanged(null);
      return;
    }

    final double? temp = double.tryParse(value);
    if (temp == null) {
      setState(() => _errorText = 'Please enter a valid number');
      widget.onTemperatureChanged(null);
      return;
    }

    final double celsiusTemp = _isCelsius ? temp : (temp - 32) * 5 / 9;

    if (celsiusTemp < 0 || celsiusTemp > 50) {
      setState(
          () => _errorText = 'Temperature must be between 0-50°C (32-122°F)');
      widget.onTemperatureChanged(null);
      return;
    }

    setState(() => _errorText = null);
    widget.onTemperatureChanged(celsiusTemp);
  }

  void _toggleUnit() {
    final currentValue = double.tryParse(_controller.text);
    if (currentValue != null) {
      final convertedValue = _isCelsius
          ? (currentValue * 9 / 5) + 32 // C to F
          : (currentValue - 32) * 5 / 9; // F to C
      _controller.text = convertedValue.toStringAsFixed(1);
    }
    setState(() => _isCelsius = !_isCelsius);
    _validateAndUpdate(_controller.text);
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
                  iconName: 'thermostat',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Temperature',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _isCelsius ? null : _toggleUnit,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: _isCelsius
                                ? AppTheme.lightTheme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '°C',
                            style: TextStyle(
                              color: _isCelsius
                                  ? Colors.white
                                  : AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: !_isCelsius ? null : _toggleUnit,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: !_isCelsius
                                ? AppTheme.lightTheme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '°F',
                            style: TextStyle(
                              color: !_isCelsius
                                  ? Colors.white
                                  : AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                hintText: 'Enter temperature',
                suffixText: _isCelsius ? '°C' : '°F',
                errorText: _errorText,
                prefixIcon: Icon(
                  Icons.device_thermostat,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
            if (_errorText == null) ...[
              SizedBox(height: 1.h),
              Text(
                'Range: ${_isCelsius ? "0-50°C" : "32-122°F"}',
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
