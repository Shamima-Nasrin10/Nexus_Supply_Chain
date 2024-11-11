import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';

class WarehouseService {
  final String apiUrl = 'http://localhost:8080/api/warehouse';

  // Fetch all warehouses
  Future<ApiResponse> getAllWarehouses() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/list'));
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to load warehouses');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Fetch a single warehouse by ID
  Future<ApiResponse> findWarehouseById(int id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Warehouse not found');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Save a new warehouse
  Future<ApiResponse> saveWarehouse(Warehouse warehouse) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/save'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(warehouse.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to save warehouse');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Update an existing warehouse
  Future<ApiResponse> updateWarehouse(Warehouse warehouse) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/update'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(warehouse.toJson()),
      );
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to update warehouse');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Delete a warehouse by ID
  Future<ApiResponse> deleteWarehouseById(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to delete warehouse');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
