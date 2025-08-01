import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/quick_action_card_widget.dart';
import './widgets/summary_card_widget.dart';
import './widgets/weather_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;
  Map<String, dynamic>? _lastPrediction;
  bool _isLoading = false;

  // Mock prediction history count
  final int _predictionCount = 12;

  @override
  void initState() {
    super.initState();
    _loadLastPrediction();
  }

  void _loadLastPrediction() {
    // Mock last prediction data
    _lastPrediction = {
      "id": 1,
      "irrigation_recommended": true,
      "water_quantity": 45.2,
      "fertilizer_quantity": 12.8,
      "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
      "temperature": 28.5,
      "humidity": 65.0,
      "soil_moisture": 42.0,
      "ph_level": 6.8,
    };
  }

  Future<void> _refreshDashboard() async {
    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Refresh data
    _loadLastPrediction();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body:
          _currentIndex == 0 ? _buildHomeContent() : _buildPlaceholderContent(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      color: AppTheme.primaryLight,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: const DashboardHeaderWidget(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 2.h),
          ),
          SliverToBoxAdapter(
            child: SummaryCardWidget(
              lastPrediction: _lastPrediction,
              onTap: () {
                if (_lastPrediction != null) {
                  Navigator.pushNamed(context, '/prediction-results');
                } else {
                  Navigator.pushNamed(context, '/sensor-data-input');
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: QuickActionCardWidget(
              title: 'New Prediction',
              subtitle: 'Start a new irrigation prediction',
              iconName: 'add_circle',
              iconColor: AppTheme.primaryLight,
              isPrimary: true,
              onTap: () => Navigator.pushNamed(context, '/sensor-data-input'),
            ),
          ),
          SliverToBoxAdapter(
            child: QuickActionCardWidget(
              title: 'View History',
              subtitle: '$_predictionCount predictions made',
              iconName: 'history',
              iconColor: Colors.blue,
              onTap: () => Navigator.pushNamed(context, '/prediction-history'),
            ),
          ),
          SliverToBoxAdapter(
            child: QuickActionCardWidget(
              title: 'Sensor Input',
              subtitle: 'Manual sensor data entry',
              iconName: 'sensors',
              iconColor: Colors.orange,
              onTap: () => Navigator.pushNamed(context, '/sensor-data-input'),
            ),
          ),
          const SliverToBoxAdapter(
            child: WeatherWidget(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 4.h),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    final List<String> tabTitles = ['Home', 'Input', 'History', 'Settings'];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.textSecondaryLight,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            '${tabTitles[_currentIndex]} Screen',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This screen is under development',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);

          // Navigate to respective screens when they're available
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.pushNamed(context, '/sensor-data-input');
              break;
            case 2:
              Navigator.pushNamed(context, '/prediction-history');
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: AppTheme.primaryLight,
        unselectedItemColor: AppTheme.textSecondaryLight,
        selectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'input',
              color: _currentIndex == 1
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: _currentIndex == 2
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: _currentIndex == 3
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
