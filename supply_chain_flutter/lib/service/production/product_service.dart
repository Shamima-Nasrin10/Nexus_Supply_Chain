import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:supply_chain_flutter/model/production/product_model.dart';
import '../../util/apiresponse.dart';
import '../../util/URL.dart';

class ProductService {
  final String apiUrl = '${ApiURL.baseURL}/api/product';


  Future<ApiResponse> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/list'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to load products');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }


  Future<ApiResponse> saveProduct(Product product, {File? imageFile}) async {
    var uri = Uri.parse('$apiUrl/save');
    var request = http.MultipartRequest('POST', uri);


    request.fields['product'] = json.encode(product.toJson());


    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('imageFile', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
    }


    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      return ApiResponse(success: false, message: 'Failed to save product');
    }
  }

  // Method to delete a raw material by ID
  Future<ApiResponse> deleteProductById(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse(success: false, message: 'Failed to delete product');
      }
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> updateProduct(Product product, {File? imageFile}) async {
    var uri = Uri.parse('$apiUrl/update');
    var request = http.MultipartRequest('PUT', uri);


    request.fields['product'] = json.encode(product.toJson());


    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('imageFile', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      return ApiResponse(success: false, message: 'Failed to update product');
    }
  }

}
