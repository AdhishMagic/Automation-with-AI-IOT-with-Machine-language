import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PressureInputWidget extends StatefulWidget {
  final Function(double?) onPressureChanged;
  final double? initialValue;

  const PressureInputWidget({
    Key? key,
    required this.onPressureChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<PressureInputWidget> createState() => _PressureInputWidgetState();
}

class _PressureInputWidgetState extends State<PressureInputWidget> {
  final TextEditingController _controller = TextEditingController();
  String _selectedUnit = 'hPa';
  String? _errorText;

  final List<String> _units = ['hPa', 'kPa', 'mmHg', 'inHg'];
  final Map<String, double> _conversionFactors = {
    'hPa': 1.0,
    'kPa': 0.1,
    'mmHg': 0.750062,
    'inHg': 0.0295300,
  };

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
      widget.onPressureChanged(null);
      return;
    }

    final double? pressure = double.tryParse(value);
    if (pressure == null) {
      setState(() => _errorText = 'Please enter a valid number');
      widget.onPressureChanged(null);
      return;
    }

    // Convert to hPa for validation
    final double hPaValue = pressure / _conversionFactors[_selectedUnit]!;

    if (hPaValue < 800 || hPaValue > 1200) {
      setState(() =>
          _errorText = 'Pressure must be within normal atmospheric range');
      widget.onPressureChanged(null);
      return;
    }

    setState(() => _errorText = null);
    widget.onPressureChanged(hPaValue);
  }

  void _changeUnit(String newUnit) {
    final currentValue = double.tryParse(_controller.text);
    if (currentValue != null) {
      // Convert current value to hPa first
      final hPaValue = currentValue / _conversionFactors[_selectedUnit]!;
      // Then convert to new unit
      final newValue = hPaValue * _conversionFactors[newUnit]!;
      _controller.text = newValue.toStringAsFixed(1);
    }
    setState(() => _selectedUnit = newUnit);
    _validateAndUpdate(_controller.text);
  }

  String _getPressureStatus(double? hPaValue) {
    if (hPaValue == null) return 'Unknown';
    if (hPaValue < 1000) return 'Low';
    if (hPaValue > 1020) return 'High';
    return 'Normal';
  }

  Color _getPressureColor(double? hPaValue) {
    if (hPaValue == null) return Colors.grey;
    if (hPaValue < 1000) return Colors.orange;
    if (hPaValue > 1020) return Colors.blue;
    return AppTheme.lightTheme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final currentHPa = double.tryParse(_controller.text) != null
        ? double.parse(_controller.text) / _conversionFactors[_selectedUnit]!
        : null;

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
                  iconName: 'speed',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Barometric Pressure',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getPressureColor(currentHPa).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getPressureStatus(currentHPa),
                    style: TextStyle(
                      color: _getPressureColor(currentHPa),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: _validateAndUpdate,
                    decoration: InputDecoration(
                      hintText: 'Enter pressure',
                      errorText: _errorText,
                      prefixIcon: Icon(
                        Icons.compress,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    items: _units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(
                          unit,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) _changeUnit(value);
                    },
                  ),
                ),
              ],
            ),
            if (_errorText == null) ...[
              SizedBox(height: 1.h),
              Text(
                'Normal range: 1000-1020 hPa',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (currentHPa != null) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Equivalent:',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${currentHPa.toStringAsFixed(1)} hPa',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
