import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/confirmation_dialog_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_toggle_widget.dart';
import './widgets/storage_usage_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isMetricUnits = true;
  bool _predictionReminders = true;
  bool _optimalTimingAlerts = false;
  bool _dataBackup = true;
  String _currentModelVersion = "v2.1.3";
  String _selectedCropType = "Wheat";
  String _selectedClimateRegion = "Temperate";
  String _selectedSoilType = "Loamy";
  double _usedStorage = 12.5;
  final double _totalStorage = 100.0;

  final List<Map<String, dynamic>> _cropTypes = [
    {"name": "Wheat", "icon": "grass"},
    {"name": "Rice", "icon": "grain"},
    {"name": "Corn", "icon": "agriculture"},
    {"name": "Tomato", "icon": "local_florist"},
    {"name": "Potato", "icon": "eco"},
  ];

  final List<Map<String, dynamic>> _climateRegions = [
    {"name": "Tropical", "icon": "wb_sunny"},
    {"name": "Temperate", "icon": "cloud"},
    {"name": "Arid", "icon": "wb_sunny"},
    {"name": "Continental", "icon": "ac_unit"},
  ];

  final List<Map<String, dynamic>> _soilTypes = [
    {"name": "Clay", "icon": "terrain"},
    {"name": "Sandy", "icon": "beach_access"},
    {"name": "Loamy", "icon": "landscape"},
    {"name": "Silty", "icon": "water_drop"},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMetricUnits = prefs.getBool('metric_units') ?? true;
      _predictionReminders = prefs.getBool('prediction_reminders') ?? true;
      _optimalTimingAlerts = prefs.getBool('optimal_timing_alerts') ?? false;
      _dataBackup = prefs.getBool('data_backup') ?? true;
      _selectedCropType = prefs.getString('crop_type') ?? "Wheat";
      _selectedClimateRegion = prefs.getString('climate_region') ?? "Temperate";
      _selectedSoilType = prefs.getString('soil_type') ?? "Loamy";
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('metric_units', _isMetricUnits);
    await prefs.setBool('prediction_reminders', _predictionReminders);
    await prefs.setBool('optimal_timing_alerts', _optimalTimingAlerts);
    await prefs.setBool('data_backup', _dataBackup);
    await prefs.setString('crop_type', _selectedCropType);
    await prefs.setString('climate_region', _selectedClimateRegion);
    await prefs.setString('soil_type', _selectedSoilType);
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.primaryLight,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _clearHistory() {
    ConfirmationDialogWidget.show(
      context: context,
      title: 'Clear History',
      content:
          'This will permanently delete all your prediction history. This action cannot be undone.',
      confirmText: 'Clear',
      isDestructive: true,
      onConfirm: () {
        setState(() {
          _usedStorage = 2.1;
        });
        _showToast('Prediction history cleared successfully');
      },
    );
  }

  void _exportData() {
    _showToast('Exporting agricultural data...');
    // Simulate export process
    Future.delayed(const Duration(seconds: 2), () {
      _showToast('Data exported successfully');
    });
  }

  void _checkForUpdates() {
    _showToast('Checking for model updates...');
    Future.delayed(const Duration(seconds: 2), () {
      _showToast('You have the latest model version');
    });
  }

  void _resetToDefaults() {
    ConfirmationDialogWidget.show(
      context: context,
      title: 'Reset to Defaults',
      content:
          'This will reset all settings to their default values. Your prediction history will not be affected.',
      confirmText: 'Reset',
      isDestructive: true,
      onConfirm: () {
        setState(() {
          _isMetricUnits = true;
          _predictionReminders = true;
          _optimalTimingAlerts = false;
          _dataBackup = true;
          _selectedCropType = "Wheat";
          _selectedClimateRegion = "Temperate";
          _selectedSoilType = "Loamy";
        });
        _saveSettings();
        _showToast('Settings reset to defaults');
      },
    );
  }

  void _showSelectionDialog(String title, List<Map<String, dynamic>> options,
      String currentValue, Function(String) onSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Select $title',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option['name'] == currentValue;

                return ListTile(
                  leading: CustomIconWidget(
                    iconName: option['icon'],
                    color: isSelected
                        ? AppTheme.primaryLight
                        : AppTheme.textSecondaryLight,
                    size: 6.w,
                  ),
                  title: Text(
                    option['name'],
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.textPrimaryLight,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.primaryLight,
                          size: 5.w,
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(option['name']);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 6.w,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 6.w,
            ),
            onPressed: _resetToDefaults,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Units Section
            SettingsSectionWidget(
              title: 'Units & Measurements',
              children: [
                SettingsToggleWidget(
                  title: 'Metric Units',
                  subtitle: _isMetricUnits
                      ? 'Celsius, Liters, Hectares'
                      : 'Fahrenheit, Gallons, Acres',
                  iconName: 'straighten',
                  value: _isMetricUnits,
                  onChanged: (value) {
                    setState(() {
                      _isMetricUnits = value;
                    });
                    _saveSettings();
                    _showToast(_isMetricUnits
                        ? 'Switched to Metric units'
                        : 'Switched to Imperial units');
                  },
                  showDivider: false,
                ),
              ],
            ),

            // Notifications Section
            SettingsSectionWidget(
              title: 'Notifications',
              children: [
                SettingsToggleWidget(
                  title: 'Prediction Reminders',
                  subtitle: 'Daily reminders to check crop conditions',
                  iconName: 'notifications',
                  value: _predictionReminders,
                  onChanged: (value) {
                    setState(() {
                      _predictionReminders = value;
                    });
                    _saveSettings();
                    _showToast(value
                        ? 'Prediction reminders enabled'
                        : 'Prediction reminders disabled');
                  },
                ),
                SettingsToggleWidget(
                  title: 'Optimal Timing Alerts',
                  subtitle:
                      'Alerts for best irrigation and fertilization times',
                  iconName: 'schedule',
                  value: _optimalTimingAlerts,
                  onChanged: (value) {
                    setState(() {
                      _optimalTimingAlerts = value;
                    });
                    _saveSettings();
                    _showToast(value
                        ? 'Timing alerts enabled'
                        : 'Timing alerts disabled');
                  },
                  showDivider: false,
                ),
              ],
            ),

            // Data Management Section
            SettingsSectionWidget(
              title: 'Data Management',
              children: [
                SettingsItemWidget(
                  title: 'Clear History',
                  subtitle: 'Remove all prediction records',
                  iconName: 'delete',
                  onTap: _clearHistory,
                ),
                SettingsItemWidget(
                  title: 'Export Data',
                  subtitle: 'Download agricultural records as CSV',
                  iconName: 'download',
                  onTap: _exportData,
                ),
                StorageUsageWidget(
                  usedStorage: _usedStorage,
                  totalStorage: _totalStorage,
                ),
                SettingsToggleWidget(
                  title: 'Auto Backup',
                  subtitle: 'Automatically backup data to cloud',
                  iconName: 'cloud_upload',
                  value: _dataBackup,
                  onChanged: (value) {
                    setState(() {
                      _dataBackup = value;
                    });
                    _saveSettings();
                    _showToast(
                        value ? 'Auto backup enabled' : 'Auto backup disabled');
                  },
                  showDivider: false,
                ),
              ],
            ),

            // Model Settings Section
            SettingsSectionWidget(
              title: 'Model Settings',
              children: [
                SettingsItemWidget(
                  title: 'TensorFlow Lite Version',
                  subtitle: 'Current: $_currentModelVersion',
                  iconName: 'psychology',
                  onTap: _checkForUpdates,
                  showDivider: false,
                ),
              ],
            ),

            // Agricultural Preferences Section
            SettingsSectionWidget(
              title: 'Agricultural Preferences',
              children: [
                SettingsItemWidget(
                  title: 'Crop Type',
                  subtitle: _selectedCropType,
                  iconName: 'agriculture',
                  onTap: () => _showSelectionDialog(
                    'Crop Type',
                    _cropTypes,
                    _selectedCropType,
                    (value) {
                      setState(() {
                        _selectedCropType = value;
                      });
                      _saveSettings();
                      _showToast('Crop type updated to $value');
                    },
                  ),
                ),
                SettingsItemWidget(
                  title: 'Climate Region',
                  subtitle: _selectedClimateRegion,
                  iconName: 'wb_cloudy',
                  onTap: () => _showSelectionDialog(
                    'Climate Region',
                    _climateRegions,
                    _selectedClimateRegion,
                    (value) {
                      setState(() {
                        _selectedClimateRegion = value;
                      });
                      _saveSettings();
                      _showToast('Climate region updated to $value');
                    },
                  ),
                ),
                SettingsItemWidget(
                  title: 'Soil Type',
                  subtitle: _selectedSoilType,
                  iconName: 'terrain',
                  onTap: () => _showSelectionDialog(
                    'Soil Type',
                    _soilTypes,
                    _selectedSoilType,
                    (value) {
                      setState(() {
                        _selectedSoilType = value;
                      });
                      _saveSettings();
                      _showToast('Soil type updated to $value');
                    },
                  ),
                  showDivider: false,
                ),
              ],
            ),

            // About Section
            SettingsSectionWidget(
              title: 'About',
              children: [
                SettingsItemWidget(
                  title: 'App Version',
                  subtitle: 'AgroPredict v1.2.0 (Build 2025073115)',
                  iconName: 'info',
                  onTap: () =>
                      _showToast('AgroPredict - Agricultural Prediction App'),
                ),
                SettingsItemWidget(
                  title: 'Developer',
                  subtitle: 'Agricultural Tech Solutions',
                  iconName: 'code',
                  onTap: () =>
                      _showToast('Developed by Agricultural Tech Solutions'),
                ),
                SettingsItemWidget(
                  title: 'Privacy Policy',
                  subtitle: 'View our privacy policy',
                  iconName: 'privacy_tip',
                  onTap: () => _showToast('Opening privacy policy...'),
                ),
                SettingsItemWidget(
                  title: 'Terms of Service',
                  subtitle: 'View terms and conditions',
                  iconName: 'description',
                  onTap: () => _showToast('Opening terms of service...'),
                  showDivider: false,
                ),
              ],
            ),

            // Help Section
            SettingsSectionWidget(
              title: 'Help & Support',
              children: [
                SettingsItemWidget(
                  title: 'Measurement Guide',
                  subtitle: 'Learn how to take accurate sensor readings',
                  iconName: 'help',
                  onTap: () => _showToast('Opening measurement guide...'),
                ),
                SettingsItemWidget(
                  title: 'FAQ',
                  subtitle: 'Frequently asked questions',
                  iconName: 'quiz',
                  onTap: () => _showToast('Opening FAQ...'),
                ),
                SettingsItemWidget(
                  title: 'Contact Support',
                  subtitle: 'Get help from our agricultural experts',
                  iconName: 'support_agent',
                  onTap: () => _showToast('Opening support contact...'),
                  showDivider: false,
                ),
              ],
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
