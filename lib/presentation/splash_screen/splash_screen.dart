import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _progressAnimation;

  double _loadingProgress = 0.0;
  String _loadingStatus = 'Initializing...';
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Progress animation controller
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // Progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _startSplashSequence() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppTheme.lightTheme.primaryColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.colorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      // Start progress animation
      _progressAnimationController.forward();

      // Simulate model loading with realistic progress updates
      await _simulateModelLoading();

      // Navigate to home dashboard after successful loading
      if (mounted && !_hasError) {
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to initialize application. Please try again.';
          _loadingStatus = 'Error occurred';
        });
      }
    }
  }

  Future<void> _simulateModelLoading() async {
    final List<Map<String, dynamic>> loadingSteps = [
      {
        'status': 'Loading TensorFlow Lite models...',
        'progress': 0.2,
        'delay': 600
      },
      {
        'status': 'Initializing irrigation model...',
        'progress': 0.4,
        'delay': 500
      },
      {
        'status': 'Initializing fertigation model...',
        'progress': 0.6,
        'delay': 500
      },
      {
        'status': 'Setting up sensor data cache...',
        'progress': 0.8,
        'delay': 400
      },
      {
        'status': 'Preparing prediction database...',
        'progress': 0.9,
        'delay': 300
      },
      {'status': 'Ready to predict!', 'progress': 1.0, 'delay': 400},
    ];

    for (final step in loadingSteps) {
      if (!mounted) break;

      await Future.delayed(Duration(milliseconds: step['delay'] as int));

      if (mounted) {
        setState(() {
          _loadingProgress = step['progress'] as double;
          _loadingStatus = step['status'] as String;
        });
      }
    }
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _loadingProgress = 0.0;
      _loadingStatus = 'Initializing...';
    });

    // Reset animations
    _logoAnimationController.reset();
    _progressAnimationController.reset();

    // Restart sequence
    _logoAnimationController.forward();
    _startSplashSequence();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.surface,
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Animated Logo Section
              AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoFadeAnimation.value,
                      child: _buildLogoSection(),
                    ),
                  );
                },
              ),

              SizedBox(height: 8.h),

              // Loading Progress Section
              _buildProgressSection(),

              // Error Section (if any)
              if (_hasError) ...[
                SizedBox(height: 4.h),
                _buildErrorSection(),
              ],

              // Spacer to balance layout
              const Spacer(flex: 3),

              // App Version and Copyright
              _buildFooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // App Logo Container
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                blurRadius: 20.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'agriculture',
              color: Colors.white,
              size: 12.w,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // App Name
        Text(
          'AgroPredict',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        SizedBox(height: 1.h),

        // App Tagline
        Text(
          'Smart Agricultural Predictions',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        // Progress Indicator
        SizedBox(
          width: 60.w,
          height: 60.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Circle
              SizedBox(
                width: 60.w,
                height: 60.w,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 3.0,
                  backgroundColor: AppTheme.lightTheme.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.dividerColor,
                  ),
                ),
              ),

              // Progress Circle
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: 60.w,
                    height: 60.w,
                    child: CircularProgressIndicator(
                      value: _loadingProgress * _progressAnimation.value,
                      strokeWidth: 3.0,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  );
                },
              ),

              // Progress Percentage
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(_loadingProgress * 100).toInt()}%',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  CustomIconWidget(
                    iconName: 'eco',
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.6),
                    size: 6.w,
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        // Loading Status Text
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            _loadingStatus,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.errorContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Error Icon
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 8.w,
          ),

          SizedBox(height: 2.h),

          // Error Message
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),

          SizedBox(height: 3.h),

          // Retry Button
          ElevatedButton.icon(
            onPressed: _retryInitialization,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 5.w,
            ),
            label: Text(
              'Retry',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Column(
      children: [
        // Powered by TensorFlow Lite
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Powered by ',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            CustomIconWidget(
              iconName: 'memory',
              color: AppTheme.lightTheme.primaryColor,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              'TensorFlow Lite',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // Version and Copyright
        Text(
          'Version 1.0.0 • © 2024 AgroPredict',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.5),
          ),
        ),

        SizedBox(height: 2.h),
      ],
    );
  }
}
