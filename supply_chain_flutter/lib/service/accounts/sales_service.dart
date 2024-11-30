import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/accounts/sales_model.dart';
import '../../model/production/production_product_model.dart';
import '../../util/apiresponse.dart';
import '../../util/URL.dart';

class SalesService {
  final String apiUrl = '${ApiURL.baseURL}/api/sales';

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

  Future<ApiResponse> saveAllSales(List<Sales> salesList) async {
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

}
