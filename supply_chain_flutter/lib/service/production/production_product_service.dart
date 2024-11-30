import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/production/production_product_model.dart';
import '../../util/apiresponse.dart';
import '../../util/URL.dart';


class ProdProductService {
  final String apiUrl = '${ApiURL.baseURL}/api/productionProduct';

  Future<ApiResponse> getAllProductionProducts() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/list'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(
          success: false,
          message: 'Error retrieving production products',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> saveProdProduct(ProductionProduct productionProduct) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/save'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(productionProduct.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(
          success: false,
          message: 'Error saving production product',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> updateProductionStatus(
      int id, ProductionStatus status, {int? warehouseId}) async {
    try {
      final uri = Uri.parse('$apiUrl/status/$id').replace(queryParameters: {
        'status': status.toString().split('.').last,
        'warehouseId': warehouseId?.toString() ?? '',
      });

      final response = await http.put(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(
          success: false,
          message: 'Error updating production status',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> getProdProductsByWarehouseId(int warehouseId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/warehouse/$warehouseId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(
          success: false,
          message: 'Error fetching products by warehouse ID',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> getAllMovedToWarehouseProducts() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/moved-to-warehouse'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(jsonDecode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to load products moved to warehouse');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
