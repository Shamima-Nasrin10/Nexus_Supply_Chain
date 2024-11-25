import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/raw_material/supplier_model.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';

import '../../util/URL.dart';

class SupplierService {
  final String apiUrl = '${ApiURL.baseURL}/api/supplier';

  Future<ApiResponse> getAllSuppliers() async {
    final response = await http.get(Uri.parse('$apiUrl/list'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to fetch suppliers: ${response.reasonPhrase}",
      );
    }
  }

  Future<ApiResponse> saveSupplier(Supplier supplier) async {
    final response = await http.post(
      Uri.parse('$apiUrl/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(supplier.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to save supplier: ${response.reasonPhrase}",
      );
    }
  }

  // Update an existing raw material category
  Future<ApiResponse> updateSupplier(Supplier supplier) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(supplier.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to update supplier: ${response.reasonPhrase}",
      );
    }
  }

  Future<ApiResponse> deleteSupplierById(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));

    if (response.statusCode == 200 || response.statusCode==201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to delete supplier: ${response.reasonPhrase}",
      );
    }
  }

  // Find a raw material category by ID
  Future<ApiResponse> findSupplierById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to find supplier: ${response.reasonPhrase}",
      );
    }
  }
}
