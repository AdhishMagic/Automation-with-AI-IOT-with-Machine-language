import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/humidity_input_widget.dart';
import './widgets/measurement_guidance_modal.dart';
import './widgets/ph_input_widget.dart';
import './widgets/pressure_input_widget.dart';
import './widgets/soil_moisture_input_widget.dart';
import './widgets/temperature_input_widget.dart';

class SensorDataInput extends StatefulWidget {
  const SensorDataInput({Key? key}) : super(key: key);

  @override
  State<SensorDataInput> createState() => _SensorDataInputState();
}

class _SensorDataInputState extends State<SensorDataInput> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Sensor data values
  double? _temperature;
  double? _humidity;
  double? _soilMoisture;
  double? _pressure;
  double? _phLevel;

  bool _isProcessing = false;
  bool _hasUnsavedChanges = false;

  // Mock sensor data for auto-save demonstration
  final Map<String, dynamic> _autoSavedData = {
    "temperature": 24.5,
    "humidity": 65.0,
    "soilMoisture": 45.0,
    "pressure": 1013.2,
    "phLevel": 6.8,
    "lastSaved": DateTime.now().subtract(const Duration(minutes: 5)),
  };

  @override
  void initState() {
    super.initState();
    _loadAutoSavedData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadAutoSavedData() {
    // Simulate loading auto-saved data
    if (_autoSavedData.isNotEmpty) {
      setState(() {
        _temperature = (_autoSavedData["temperature"] as num?)?.toDouble();
        _humidity = (_autoSavedData["humidity"] as num?)?.toDouble();
        _soilMoisture = (_autoSavedData["soilMoisture"] as num?)?.toDouble();
        _pressure = (_autoSavedData["pressure"] as num?)?.toDouble();
        _phLevel = (_autoSavedData["phLevel"] as num?)?.toDouble();
      });
    }
  }

  void _onDataChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  bool _isFormValid() {
    return _temperature != null &&
        _humidity != null &&
        _soilMoisture != null &&
        _pressure != null &&
        _phLevel != null;
  }

  void _showGuidanceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MeasurementGuidanceModal(),
    );
  }

  void _clearForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Form',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to clear all entered data? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _temperature = null;
                _humidity = null;
                _soilMoisture = null;
                _pressure = null;
                _phLevel = null;
                _hasUnsavedChanges = false;
              });
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePrediction() async {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all sensor data fields'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    // Haptic feedback
    HapticFeedback.mediumImpact();

    try {
      // Simulate TensorFlow Lite model processing
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to prediction results with sensor data
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/prediction-results',
          arguments: {
            'temperature': _temperature,
            'humidity': _humidity,
            'soilMoisture': _soilMoisture,
            'pressure': _pressure,
            'phLevel': _phLevel,
            'timestamp': DateTime.now(),
          },
        );

        setState(() => _hasUnsavedChanges = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Error processing sensor data. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Sensor Input'),
        actions: [
          IconButton(
            onPressed: _showGuidanceModal,
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Measurement Guidance',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                _clearForm();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 20),
                    SizedBox(width: 8),
                    Text('Clear Form'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Auto-save indicator
          if (_autoSavedData.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'cloud_done',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Auto-saved data loaded from ${(_autoSavedData["lastSaved"] as DateTime).hour}:${(_autoSavedData["lastSaved"] as DateTime).minute.toString().padLeft(2, '0')}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                  if (_hasUnsavedChanges)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Unsaved',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Form content
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Progress indicator
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'sensors',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Sensor Data Collection',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          LinearProgressIndicator(
                            value: [
                                  _temperature,
                                  _humidity,
                                  _soilMoisture,
                                  _pressure,
                                  _phLevel
                                ].where((value) => value != null).length /
                                5,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.primaryColor),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${[
                              _temperature,
                              _humidity,
                              _soilMoisture,
                              _pressure,
                              _phLevel
                            ].where((value) => value != null).length}/5 fields completed',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Input widgets
                    TemperatureInputWidget(
                      onTemperatureChanged: (value) {
                        setState(() => _temperature = value);
                        _onDataChanged();
                      },
                      initialValue: _temperature,
                    ),

                    HumidityInputWidget(
                      onHumidityChanged: (value) {
                        setState(() => _humidity = value);
                        _onDataChanged();
                      },
                      initialValue: _humidity,
                    ),

                    SoilMoistureInputWidget(
                      onMoistureChanged: (value) {
                        setState(() => _soilMoisture = value);
                        _onDataChanged();
                      },
                      initialValue: _soilMoisture,
                    ),

                    PressureInputWidget(
                      onPressureChanged: (value) {
                        setState(() => _pressure = value);
                        _onDataChanged();
                      },
                      initialValue: _pressure,
                    ),

                    PhInputWidget(
                      onPhChanged: (value) {
                        setState(() => _phLevel = value);
                        _onDataChanged();
                      },
                      initialValue: _phLevel,
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Generate prediction button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _generatePrediction,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid()
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                disabledForegroundColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: _isFormValid() ? 2 : 0,
              ),
              child: _isProcessing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Processing...',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'psychology',
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Generate Prediction',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
