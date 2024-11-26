import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/accounts/sales_model.dart';
import '../../model/production/production_product_model.dart';
import '../../util/apiresponse.dart';
import '../../util/URL.dart';

class SalesService {
  final String apiUrl = '${ApiURL.baseURL}/api/sales';

  // Get all sales
  Future<ApiResponse> getAllSales() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/list'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to load sales');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Save multiple sales
  Future<ApiResponse> saveSales(List<Sales> salesList) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/saveAll'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(salesList.map((sales) => sales.toJson()).toList()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to save sales');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Save a single sale
  Future<ApiResponse> saveSale(Sales sales) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/save'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(sales.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to save sale');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Update a sale
  Future<ApiResponse> updateSale(int id, Sales sales) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(sales.toJson()),
      );
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to update sale');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Delete a sale by ID
  Future<ApiResponse> deleteSaleById(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to delete sale');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Get a sale by ID
  Future<ApiResponse> getSaleById(int id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to fetch sale');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> getAllMovedToWarehouseProducts() async {
    try {
      final response = await http.get(Uri.parse('${ApiURL.baseURL}/api/productionProduct/moved-to-warehouse'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming you have a model for ProductionProduct that maps the response
        List<ProductionProduct> products = (json.decode(response.body) as List)
            .map((data) => ProductionProduct.fromJson(data))
            .toList();
        return ApiResponse(success: true, data: {"productionProducts": products});
      } else {
        return ApiResponse(success: false, message: 'Failed to load products moved to warehouse');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
