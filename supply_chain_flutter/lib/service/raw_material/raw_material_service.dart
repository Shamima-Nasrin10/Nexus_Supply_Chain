import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../../model/raw_material/raw_material_model.dart';
import '../../util/apiresponse.dart';

class RawMaterialService {
  final String apiUrl = 'http://localhost:8080/api/rawmaterial';

  // Method to get all raw materials
  Future<ApiResponse> getRawMaterials() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/list'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to load raw materials');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Method to save a raw material with optional image
  Future<ApiResponse> saveRawMaterial(RawMaterial rawMaterial, {File? imageFile}) async {
    var uri = Uri.parse('$apiUrl/save');
    var request = http.MultipartRequest('POST', uri);

    // Add rawMaterial JSON data
    request.fields['rawMaterial'] = json.encode(rawMaterial.toJson());

    // Add image file if provided
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('imageFile', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
    }

    // Send request and handle response
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      return ApiResponse(success: false, message: 'Failed to save raw material');
    }
  }

  // Method to delete a raw material by ID
  Future<ApiResponse> deleteRawMaterialById(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to delete raw material');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // Method to update a raw material with optional image
  Future<ApiResponse> updateRawMaterial(RawMaterial rawMaterial, {File? imageFile}) async {
    var uri = Uri.parse('$apiUrl/update');
    var request = http.MultipartRequest('PUT', uri);

    // Add rawMaterial JSON data
    request.fields['rawMaterial'] = json.encode(rawMaterial.toJson());

    // Add image file if provided
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('imageFile', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
    }

    // Send request and handle response
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      return ApiResponse(success: false, message: 'Failed to update raw material');
    }
  }

}
