import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/raw_material/procurement_model.dart';
import '../../util/apiresponse.dart';
import '../../util/URL.dart';

class ProcurementService {
  final String apiUrl = '${ApiURL.baseURL}/api/procurement';

  Future<ApiResponse> getAllProcurements() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/list'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to load procurements');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> saveProcurements(List<Procurement> procurements) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/saveAll'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(procurements.map((procurement) => procurement.toJson()).toList()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to save procurement');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }


  Future<ApiResponse> updateProcurement(int id, Procurement procurement) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(procurement.toJson()),
      );
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to update procurement');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> deleteProcurementById(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to delete procurement');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> getProcurementById(int id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to fetch procurement');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
