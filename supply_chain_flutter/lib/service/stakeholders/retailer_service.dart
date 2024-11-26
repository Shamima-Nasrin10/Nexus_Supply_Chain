import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/stakeholders/retailer_model.dart';
import '../../util/URL.dart';
import '../../util/apiresponse.dart';

class RetailerService {
  final String apiUrl = '${ApiURL.baseURL}/api/retailer';

  Future<ApiResponse> getAllRetailers() async {
    final response = await http.get(Uri.parse('$apiUrl/list'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to fetch retailers: ${response.reasonPhrase}",
      );
    }
  }

  Future<ApiResponse> saveRetailer(Retailer retailer) async {
    final response = await http.post(
      Uri.parse('$apiUrl/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(retailer.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to save retailer: ${response.reasonPhrase}",
      );
    }
  }

  Future<ApiResponse> updateRetailer(Retailer retailer) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(retailer.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to update retailer: ${response.reasonPhrase}",
      );
    }
  }

  Future<ApiResponse> deleteRetailerById(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));

    if (response.statusCode == 200 || response.statusCode==201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to delete retailer: ${response.reasonPhrase}",
      );
    }
  }

  Future<ApiResponse> findRetailerById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to find retailer: ${response.reasonPhrase}",
      );
    }
  }
}