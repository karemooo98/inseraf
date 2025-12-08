import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/user_summary.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/remote_api_service.dart';
import '../models/user_summary_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._api);

  final RemoteApiService _api;
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  Future<List<UserSummary>> getAllUsersSummary({
    required DateTime from,
    required DateTime to,
  }) async {
    if (kDebugMode) {
      debugPrint('=== ReportRepositoryImpl.getAllUsersSummary called ===');
      debugPrint('From: $from');
      debugPrint('To: $to');
      debugPrint('About to call _api.getAllUsersSummary');
    }
    try {
      if (kDebugMode) {
        debugPrint('Calling _api.getAllUsersSummary now...');
      }
    final dynamic response = await _api.getAllUsersSummary(from: from, to: to);
      if (kDebugMode) {
        debugPrint('_api.getAllUsersSummary returned');
      }
      
      // Handle null response
      if (response == null) {
        if (kDebugMode) {
          debugPrint('ERROR: API returned null response');
        }
        return <UserSummary>[];
      }
      
      // Check for error response
      if (response is Map<String, dynamic>) {
        if (response.containsKey('success') && response['success'] == false) {
          final String errorMsg = response['message']?.toString() ?? 'Unknown error';
          if (kDebugMode) {
            debugPrint('ERROR: API returned error response: $errorMsg');
          }
          throw Exception(errorMsg);
        }
      }
      
      // Debug logging to see actual response structure
      if (kDebugMode) {
        debugPrint('=== Reports API Response ===');
        debugPrint('Response type: ${response.runtimeType}');
        if (response is Map) {
          debugPrint('Response keys: ${response.keys.toList()}');
          if (response.containsKey('success')) {
            debugPrint('Success: ${response['success']}');
          }
          if (response.containsKey('data')) {
            final dynamic dataValue = response['data'];
            if (dataValue is List) {
              debugPrint('Data array length: ${dataValue.length}');
              if (dataValue.isNotEmpty && dataValue[0] is Map) {
                debugPrint('First item keys: ${(dataValue[0] as Map).keys.toList()}');
              }
            }
          }
          if (response.containsKey('totals')) {
            debugPrint('Totals available: ${response['totals']}');
          }
        }
      }
    
    final List<Map<String, dynamic>> parsed = _asList(response);
    
    if (kDebugMode) {
      debugPrint('Parsed list length: ${parsed.length}');
      if (parsed.isEmpty && response != null) {
        debugPrint('WARNING: Response received but parsed list is empty');
        debugPrint('This might indicate an unexpected response structure');
      }
    }
    
    // If we got a response but couldn't parse it, log a warning
    if (parsed.isEmpty && response != null && response is! List && response is Map) {
      if (kDebugMode) {
        debugPrint('ERROR: Received Map response but no list found in expected keys');
        debugPrint('Response structure: $response');
      }
    }
    
    // Parse each item, skipping invalid ones
    final List<UserSummary> summaries = <UserSummary>[];
    for (final Map<String, dynamic> item in parsed) {
      try {
        summaries.add(UserSummaryModel.fromJson(item));
      } catch (e, stackTrace) {
        // Log error but continue processing other items
        if (kDebugMode) {
          debugPrint('Error parsing user summary item: $e');
          debugPrint('Item: $item');
          debugPrint('Stack trace: $stackTrace');
        }
        continue;
      }
    }
    
    if (kDebugMode) {
      debugPrint('Successfully parsed ${summaries.length} summaries');
      if (parsed.isNotEmpty && summaries.isEmpty) {
        debugPrint('ERROR: Had ${parsed.length} items but none parsed successfully');
      }
    }
    
    return summaries;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('ERROR in getAllUsersSummary: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserReport({
    required int userId,
    DateTime? from,
    DateTime? to,
  }) async {
    final dynamic response = await _api.getUserReport(
      userId: userId,
      from: from != null ? _dateFormatter.format(from) : null,
      to: to != null ? _dateFormatter.format(to) : null,
    );
    return Map<String, dynamic>.from(response as Map);
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    // Handle direct List response
    if (response is List) {
      if (kDebugMode) {
        debugPrint('Response is a direct List with ${response.length} items');
      }
      return response
          .map((dynamic item) {
            if (item is Map) {
              return Map<String, dynamic>.from(item);
            }
            return <String, dynamic>{};
          })
          .where((Map<String, dynamic> item) => item.isNotEmpty)
          .toList();
    }
    
    // Handle Map response with various possible keys
    if (response is Map<String, dynamic>) {
      if (kDebugMode) {
        debugPrint('Response is a Map with keys: ${response.keys.toList()}');
      }
      
      // Check common response wrapper keys
      final List<String> possibleKeys = <String>['data', 'users', 'summaries', 'results', 'items'];
      
      for (final String key in possibleKeys) {
        final dynamic value = response[key];
        if (value is List) {
          if (kDebugMode) {
            debugPrint('Found list in key "$key" with ${value.length} items');
          }
          return value
              .map((dynamic item) {
                if (item is Map) {
                  return Map<String, dynamic>.from(item);
                }
                return <String, dynamic>{};
              })
              .where((Map<String, dynamic> item) => item.isNotEmpty)
              .toList();
        }
      }
      
      // Check if any value in the map is a list
      for (final dynamic value in response.values) {
        if (value is List) {
          if (kDebugMode) {
            debugPrint('Found list in response values');
          }
          return value
              .map((dynamic item) {
                if (item is Map) {
                  return Map<String, dynamic>.from(item);
                }
                return <String, dynamic>{};
              })
              .where((Map<String, dynamic> item) => item.isNotEmpty)
            .toList();
      }
    }
      
      // If no list found in common keys, check if the entire response is a single item
      // This shouldn't happen for a list endpoint, but handle it gracefully
      if (response.containsKey('user_id') || response.containsKey('name')) {
        if (kDebugMode) {
          debugPrint('Response appears to be a single item, wrapping in list');
        }
        // Single item wrapped in response, return as list with one item
        return <Map<String, dynamic>>[response];
      }
      
      if (kDebugMode) {
        debugPrint('No list found in response map');
      }
    }
    
    if (kDebugMode) {
      debugPrint('Response type not recognized: ${response.runtimeType}');
    }
    
    return <Map<String, dynamic>>[];
  }
}
