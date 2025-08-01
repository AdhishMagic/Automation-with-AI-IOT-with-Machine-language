import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MeasurementGuidanceModal extends StatelessWidget {
  const MeasurementGuidanceModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'help_outline',
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Measurement Guidance',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGuidanceSection(
                    icon: 'thermostat',
                    title: 'Temperature',
                    description:
                        'Measure air temperature at crop level, avoiding direct sunlight. Best measured in shade during mid-morning (9-11 AM).',
                    tips: [
                      'Use a thermometer at plant height',
                      'Avoid metal surfaces and direct sun',
                      'Take multiple readings for accuracy',
                    ],
                  ),
                  _buildGuidanceSection(
                    icon: 'water_drop',
                    title: 'Humidity',
                    description:
                        'Relative humidity affects plant transpiration and disease risk. Measure at the same time as temperature.',
                    tips: [
                      'Use a digital hygrometer',
                      'Measure in crop canopy area',
                      'Early morning readings most critical',
                    ],
                  ),
                  _buildGuidanceSection(
                    icon: 'grass',
                    title: 'Soil Moisture',
                    description:
                        'Measure soil water content at root zone depth (6-12 inches for most crops).',
                    tips: [
                      'Insert probe to root depth',
                      'Take readings from multiple spots',
                      'Avoid recently watered areas',
                    ],
                  ),
                  _buildGuidanceSection(
                    icon: 'speed',
                    title: 'Barometric Pressure',
                    description:
                        'Atmospheric pressure affects plant stress and weather patterns. Stable readings indicate good conditions.',
                    tips: [
                      'Use a digital barometer',
                      'Record at same time daily',
                      'Note weather changes',
                    ],
                  ),
                  _buildGuidanceSection(
                    icon: 'science',
                    title: 'pH Level',
                    description:
                        'Soil pH affects nutrient availability. Most crops prefer slightly acidic to neutral soil (6.0-7.5).',
                    tips: [
                      'Use calibrated pH meter',
                      'Test multiple soil samples',
                      'Mix soil with distilled water',
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'tips_and_updates',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Pro Tips',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '• Take measurements at consistent times daily\n• Record weather conditions with readings\n• Calibrate instruments regularly\n• Keep a measurement log for trends',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceSection({
    required String icon,
    required String title,
    required String description,
    required List<String> tips,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          SizedBox(height: 1.h),
          ...tips.map((tip) => Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
