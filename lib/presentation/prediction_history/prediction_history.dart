import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_history_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/history_card_widget.dart';
import './widgets/search_bar_widget.dart';

class PredictionHistory extends StatefulWidget {
  const PredictionHistory({Key? key}) : super(key: key);

  @override
  State<PredictionHistory> createState() => _PredictionHistoryState();
}

class _PredictionHistoryState extends State<PredictionHistory> {
  final ScrollController _scrollController = ScrollController();
  final List<int> _selectedItems = [];

  String _searchQuery = '';
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  String? _filterPredictionType;
  bool _isMultiSelectMode = false;
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;

  // Mock prediction history data
  final List<Map<String, dynamic>> _allPredictions = [
    {
      "id": 1,
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "irrigationNeeded": true,
      "waterQuantity": 25.5,
      "fertilizerQuantity": 3.2,
      "sensorData": {
        "temperature": 28.5,
        "humidity": 65.0,
        "soilMoisture": 35.0,
        "pressure": 1013.2,
        "phLevel": 6.8,
      },
    },
    {
      "id": 2,
      "date": DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      "irrigationNeeded": false,
      "waterQuantity": 0.0,
      "fertilizerQuantity": 0.0,
      "sensorData": {
        "temperature": 24.2,
        "humidity": 78.0,
        "soilMoisture": 68.0,
        "pressure": 1015.8,
        "phLevel": 7.1,
      },
    },
    {
      "id": 3,
      "date": DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      "irrigationNeeded": true,
      "waterQuantity": 18.7,
      "fertilizerQuantity": 2.8,
      "sensorData": {
        "temperature": 31.0,
        "humidity": 52.0,
        "soilMoisture": 28.0,
        "pressure": 1011.5,
        "phLevel": 6.5,
      },
    },
    {
      "id": 4,
      "date": DateTime.now().subtract(const Duration(days: 3, hours: 8)),
      "irrigationNeeded": true,
      "waterQuantity": 32.1,
      "fertilizerQuantity": 4.5,
      "sensorData": {
        "temperature": 33.5,
        "humidity": 45.0,
        "soilMoisture": 22.0,
        "pressure": 1009.8,
        "phLevel": 6.2,
      },
    },
    {
      "id": 5,
      "date": DateTime.now().subtract(const Duration(days: 5, hours: 12)),
      "irrigationNeeded": false,
      "waterQuantity": 0.0,
      "fertilizerQuantity": 0.0,
      "sensorData": {
        "temperature": 26.8,
        "humidity": 72.0,
        "soilMoisture": 58.0,
        "pressure": 1016.2,
        "phLevel": 7.0,
      },
    },
    {
      "id": 6,
      "date": DateTime.now().subtract(const Duration(days: 7, hours: 4)),
      "irrigationNeeded": true,
      "waterQuantity": 21.3,
      "fertilizerQuantity": 3.1,
      "sensorData": {
        "temperature": 29.2,
        "humidity": 58.0,
        "soilMoisture": 31.0,
        "pressure": 1012.7,
        "phLevel": 6.7,
      },
    },
    {
      "id": 7,
      "date": DateTime.now().subtract(const Duration(days: 10, hours: 6)),
      "irrigationNeeded": true,
      "waterQuantity": 28.9,
      "fertilizerQuantity": 3.8,
      "sensorData": {
        "temperature": 30.5,
        "humidity": 48.0,
        "soilMoisture": 25.0,
        "pressure": 1010.3,
        "phLevel": 6.4,
      },
    },
    {
      "id": 8,
      "date": DateTime.now().subtract(const Duration(days: 14, hours: 2)),
      "irrigationNeeded": false,
      "waterQuantity": 0.0,
      "fertilizerQuantity": 0.0,
      "sensorData": {
        "temperature": 25.1,
        "humidity": 75.0,
        "soilMoisture": 62.0,
        "pressure": 1017.1,
        "phLevel": 7.2,
      },
    },
  ];

  List<Map<String, dynamic>> _filteredPredictions = [];
  List<Map<String, dynamic>> _displayedPredictions = [];

  @override
  void initState() {
    super.initState();
    _filteredPredictions = List.from(_allPredictions);
    _displayedPredictions = _filteredPredictions.take(5).toList();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final startIndex = _displayedPredictions.length;
    final endIndex = (startIndex + 5).clamp(0, _filteredPredictions.length);

    if (startIndex < _filteredPredictions.length) {
      setState(() {
        _displayedPredictions
            .addAll(_filteredPredictions.sublist(startIndex, endIndex));
        _hasMoreData = endIndex < _filteredPredictions.length;
        _isLoading = false;
      });
    } else {
      setState(() {
        _hasMoreData = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _displayedPredictions = _filteredPredictions.take(5).toList();
      _hasMoreData = _filteredPredictions.length > 5;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onFilterApplied(
      DateTime? startDate, DateTime? endDate, String? predictionType) {
    setState(() {
      _filterStartDate = startDate;
      _filterEndDate = endDate;
      _filterPredictionType = predictionType;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allPredictions);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((prediction) {
        final date = prediction['date'] as DateTime;
        final dateString = '${date.month}/${date.day}/${date.year}';
        final timeString = _formatTime(date);
        final irrigationStatus = (prediction['irrigationNeeded'] as bool)
            ? 'irrigation needed'
            : 'no irrigation';
        final waterQuantity = prediction['waterQuantity'].toString();
        final fertilizerQuantity = prediction['fertilizerQuantity'].toString();

        return dateString.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            timeString.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            irrigationStatus.contains(_searchQuery.toLowerCase()) ||
            waterQuantity.contains(_searchQuery.toLowerCase()) ||
            fertilizerQuantity.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply date range filter
    if (_filterStartDate != null && _filterEndDate != null) {
      filtered = filtered.where((prediction) {
        final date = prediction['date'] as DateTime;
        return date
                .isAfter(_filterStartDate!.subtract(const Duration(days: 1))) &&
            date.isBefore(_filterEndDate!.add(const Duration(days: 1)));
      }).toList();
    }

    // Apply prediction type filter
    if (_filterPredictionType != null &&
        _filterPredictionType != 'All Predictions') {
      filtered = filtered.where((prediction) {
        switch (_filterPredictionType) {
          case 'Irrigation Needed':
            return prediction['irrigationNeeded'] as bool;
          case 'No Irrigation':
            return !(prediction['irrigationNeeded'] as bool);
          case 'High Water Requirement':
            return (prediction['waterQuantity'] as num) > 25.0;
          case 'Low Water Requirement':
            return (prediction['waterQuantity'] as num) <= 25.0 &&
                (prediction['waterQuantity'] as num) > 0;
          default:
            return true;
        }
      }).toList();
    }

    setState(() {
      _filteredPredictions = filtered;
      _displayedPredictions = filtered.take(5).toList();
      _hasMoreData = filtered.length > 5;
      _selectedItems.clear();
      _isMultiSelectMode = false;
    });
  }

  void _toggleMultiSelect(int predictionId) {
    setState(() {
      if (_selectedItems.contains(predictionId)) {
        _selectedItems.remove(predictionId);
        if (_selectedItems.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedItems.add(predictionId);
        _isMultiSelectMode = true;
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedItems.clear();
      _selectedItems.addAll(_displayedPredictions.map((p) => p['id'] as int));
      _isMultiSelectMode = true;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
      _isMultiSelectMode = false;
    });
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Selected Predictions',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete ${_selectedItems.length} selected predictions? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performBulkDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Delete',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performBulkDelete() {
    setState(() {
      _allPredictions.removeWhere(
          (prediction) => _selectedItems.contains(prediction['id']));
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedItems.length} predictions deleted'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _exportHistory() {
    final predictions = _selectedItems.isNotEmpty
        ? _allPredictions
            .where((p) => _selectedItems.contains(p['id']))
            .toList()
        : _filteredPredictions;

    // Simulate CSV export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${predictions.length} predictions to CSV...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Handle CSV view/download
          },
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FilterBottomSheetWidget(
          startDate: _filterStartDate,
          endDate: _filterEndDate,
          predictionType: _filterPredictionType,
          onApplyFilter: _onFilterApplied,
        ),
      ),
    );
  }

  bool get _hasActiveFilters {
    return _filterStartDate != null ||
        _filterEndDate != null ||
        (_filterPredictionType != null &&
            _filterPredictionType != 'All Predictions');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _isMultiSelectMode ? '${_selectedItems.length} Selected' : 'History',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      leading: _isMultiSelectMode
          ? IconButton(
              onPressed: _clearSelection,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                size: 24,
              ),
            )
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                size: 24,
              ),
            ),
      actions: _isMultiSelectMode
          ? [
              IconButton(
                onPressed: _selectAll,
                icon: CustomIconWidget(
                  iconName: 'select_all',
                  color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: _deleteSelected,
                icon: CustomIconWidget(
                  iconName: 'delete',
                  color: Colors.red,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: _exportHistory,
                icon: CustomIconWidget(
                  iconName: 'file_download',
                  color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                  size: 24,
                ),
              ),
            ]
          : [
              IconButton(
                onPressed: _exportHistory,
                icon: CustomIconWidget(
                  iconName: 'file_download',
                  color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                  size: 24,
                ),
              ),
            ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        if (!_isMultiSelectMode) ...[
          SearchBarWidget(
            initialQuery: _searchQuery,
            onSearchChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
            hasActiveFilters: _hasActiveFilters,
          ),
        ],
        Expanded(
          child: _displayedPredictions.isEmpty
              ? EmptyHistoryWidget(
                  onMakeFirstPrediction: () {
                    Navigator.pushNamed(context, '/sensor-data-input');
                  },
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  color: AppTheme.lightTheme.primaryColor,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        _displayedPredictions.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _displayedPredictions.length) {
                        return _buildLoadingIndicator();
                      }

                      final prediction = _displayedPredictions[index];
                      final predictionId = prediction['id'] as int;

                      return HistoryCardWidget(
                        prediction: prediction,
                        isSelected: _selectedItems.contains(predictionId),
                        onTap: _isMultiSelectMode
                            ? () => _toggleMultiSelect(predictionId)
                            : () => _navigateToPredictionResults(prediction),
                        onLongPress: () => _toggleMultiSelect(predictionId),
                        onDelete: () => _deletePrediction(predictionId),
                        onRepeat: () => _repeatPrediction(prediction),
                        onShare: () => _sharePrediction(prediction),
                        onViewDetails: () =>
                            _navigateToPredictionResults(prediction),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.primaryColor,
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_isMultiSelectMode || _displayedPredictions.isEmpty) return null;

    return FloatingActionButton.extended(
      onPressed: _exportHistory,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: Colors.white,
      icon: CustomIconWidget(
        iconName: 'file_download',
        color: Colors.white,
        size: 20,
      ),
      label: Text(
        'Export History',
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _deletePrediction(int predictionId) {
    setState(() {
      _allPredictions
          .removeWhere((prediction) => prediction['id'] == predictionId);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Prediction deleted'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // Handle undo functionality
          },
        ),
      ),
    );
  }

  void _repeatPrediction(Map<String, dynamic> prediction) {
    Navigator.pushNamed(
      context,
      '/sensor-data-input',
      arguments: prediction['sensorData'],
    );
  }

  void _sharePrediction(Map<String, dynamic> prediction) {
    final date = prediction['date'] as DateTime;
    final irrigationNeeded = prediction['irrigationNeeded'] as bool;
    final waterQuantity = prediction['waterQuantity'] as double;
    final fertilizerQuantity = prediction['fertilizerQuantity'] as double;

    final shareText = '''
AgroPredict - ML Prediction Results
Date: ${_formatDate(date)} at ${_formatTime(date)}
Irrigation: ${irrigationNeeded ? 'Recommended' : 'Not Needed'}
${irrigationNeeded ? 'Water Required: ${waterQuantity.toStringAsFixed(1)}L' : ''}
${irrigationNeeded ? 'Fertilizer Required: ${fertilizerQuantity.toStringAsFixed(1)}L' : ''}
Generated by AgroPredict ML Models
    ''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Prediction shared successfully'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _navigateToPredictionResults(Map<String, dynamic> prediction) {
    Navigator.pushNamed(
      context,
      '/prediction-results',
      arguments: prediction,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
            ? 12
            : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
