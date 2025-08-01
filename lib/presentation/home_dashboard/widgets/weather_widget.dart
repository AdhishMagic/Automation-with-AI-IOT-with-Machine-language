import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock weather data
    final Map<String, dynamic> weatherData = {
      "temperature": 24.5,
      "humidity": 68,
      "condition": "Partly Cloudy",
      "icon": "partly_cloudy_day",
      "wind_speed": 12.3,
      "pressure": 1013.2,
      "uv_index": 6,
    };

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Weather',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.primaryLight,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${weatherData['temperature'].toStringAsFixed(0)}°',
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: AppTheme.textPrimaryLight,
                          ),
                        ),
                        Text(
                          'C',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      weatherData['condition'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomIconWidget(
                  iconName: 'wb_cloudy',
                  color: AppTheme.primaryLight,
                  size: 48,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildWeatherMetric(
                  icon: 'water_drop',
                  iconColor: Colors.blue,
                  label: 'Humidity',
                  value: '${weatherData['humidity']}%',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildWeatherMetric(
                  icon: 'air',
                  iconColor: Colors.grey,
                  label: 'Wind',
                  value: '${weatherData['wind_speed']} km/h',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildWeatherMetric(
                  icon: 'compress',
                  iconColor: Colors.purple,
                  label: 'Pressure',
                  value: '${weatherData['pressure']} hPa',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherMetric({
    required String icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: iconColor,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondaryLight,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
