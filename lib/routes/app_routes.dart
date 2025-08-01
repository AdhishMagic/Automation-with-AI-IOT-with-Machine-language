import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/prediction_history/prediction_history.dart';
import '../presentation/prediction_results/prediction_results.dart';
import '../presentation/sensor_data_input/sensor_data_input.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String predictionHistory = '/prediction-history';
  static const String predictionResults = '/prediction-results';
  static const String sensorDataInput = '/sensor-data-input';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    settings: (context) => const Settings(),
    predictionHistory: (context) => const PredictionHistory(),
    predictionResults: (context) => const PredictionResults(),
    sensorDataInput: (context) => const SensorDataInput(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    // TODO: Add your other routes here
  };
}
