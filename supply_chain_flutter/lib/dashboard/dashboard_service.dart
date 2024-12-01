import 'dart:convert';
import 'package:http/http.dart' as http;

import '../util/URL.dart';
import '../util/apiresponse.dart';

class DashboardService {
  final String apiUrl = '${ApiURL.baseURL}/api/dashboard/stats';

  Future<ApiResponse> getDashboardStats() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load dashboard stats');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
