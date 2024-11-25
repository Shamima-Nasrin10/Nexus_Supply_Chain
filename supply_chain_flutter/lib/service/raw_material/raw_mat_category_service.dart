import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/raw_material/raw_mat_category_model.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';
import '../../util/URL.dart';


class RawMaterialCategoryService {
  final String apiUrl = '${ApiURL.baseURL}/api/rawmaterialcategory';

  // Get all raw material categories
  Future<ApiResponse> getAllRawMaterialCategories() async {
    final response = await http.get(Uri.parse('$apiUrl/list'));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to fetch categories: ${response.reasonPhrase}",
      );
    }
  }

  // Save a new raw material category
  Future<ApiResponse> saveRawMaterialCategory(RawMatCategory category) async {
    final response = await http.post(
      Uri.parse('$apiUrl/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to save category: ${response.reasonPhrase}",
      );
    }
  }

  // Update an existing raw material category
  Future<ApiResponse> updateRawMaterialCategory(RawMatCategory category) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to update category: ${response.reasonPhrase}",
      );
    }
  }

  // Delete a raw material category by ID
  Future<ApiResponse> deleteRawMaterialCategoryById(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to delete category: ${response.reasonPhrase}",
      );
    }
  }

  // Find a raw material category by ID
  Future<ApiResponse> findRawMaterialCategoryById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to find category: ${response.reasonPhrase}",
      );
    }
  }
}
