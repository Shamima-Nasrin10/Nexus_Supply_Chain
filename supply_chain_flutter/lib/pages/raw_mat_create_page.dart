import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:supply_chain_flutter/model/raw_mat_category_model.dart';
import 'package:supply_chain_flutter/service/raw_mat_category_service.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

import '../model/raw_material.dart';

class RawMatCreatePage extends StatefulWidget {
  const RawMatCreatePage({Key? key}) : super(key: key);

  @override
  _RawMatCreatePageState createState() => _RawMatCreatePageState();
}

class _RawMatCreatePageState extends State<RawMatCreatePage> {
  final TextEditingController nameTEC = TextEditingController();
  final TextEditingController quantityTEC = TextEditingController(text: '0');
  RawMatCategory? selectedCategory;
  XFile? selectedImage;
  Uint8List? webImage; // For storing the image bytes on web
  RawMaterial _rawMaterial = RawMaterial(name: '', unit: Unit.PIECE, quantity: 0, category: null);
  List<RawMatCategory> _categories = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final response =
    await RawMaterialCategoryService().getAllRawMaterialCategories();
    if (response.success) {
      setState(() {
        _categories = (response.data?['categories'] as List)
            .map((json) => RawMatCategory.fromJson(json))
            .toList();
      });
    } else {
      NotifyUtil.error(
          context, response.message ?? 'Failed to load categories');
    }
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      // For Web: Use image_picker_web to pick image and store as bytes
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage; // Store the picked image as Uint8List
        });
      }
    } else {
      // For Mobile: Use image_picker to pick image
      final XFile? pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  Future<void> submitRawMaterial() async {
    if (nameTEC.text.isEmpty) {
      NotifyUtil.error(context, 'Please enter name.');
      return;
    }
    _rawMaterial.name = nameTEC.text;
    if (_rawMaterial.unit == null) {
      NotifyUtil.error(context, 'Please select unit.');
      return;
    }
    if (_rawMaterial.category == null) {
      NotifyUtil.error(context, 'Please select a category before saving.');
      return;
    }

    var uri = Uri.parse('http://localhost:8080/api/rawmaterial/save');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromString(
        'rawMaterial',
        jsonEncode(_rawMaterial),
        contentType: MediaType('application', 'json'),
      ),
    );

    if (kIsWeb && webImage != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'imageFile',
        webImage!,
        filename: 'upload.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    } else if (selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'imageFile',
        selectedImage!.path,
      ));
    }

    await _sendRequest(request);
  }


  Future<void> _sendRequest(http.MultipartRequest request) async {
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        NotifyUtil.success(context, 'Raw Material saved successfully');
      } else {
        NotifyUtil.error(
            context, 'Failed to save. Status code: ${response.statusCode}');
      }
    } catch (e) {
      NotifyUtil.error(context, 'Error occurred while submitting: $e');
    }
  }

  List<DropdownMenuItem<Unit>> _buildUnitDropdownItems() {
    return Unit.values.map((unit) {
      return DropdownMenuItem<Unit>(
        value: unit,
        child: Text(unit.toString().split('.').last), // Get the enum name
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Raw Material"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Raw Material",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameTEC,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
                icon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _rawMaterial.category?.id,
              items: _categories
                  .map((category) => DropdownMenuItem(
                value: category.id,
                child: Text(category.name ?? ''),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _rawMaterial.category = _categories
                      .firstWhere((category) => category.id == value);
                });
              },
              decoration: InputDecoration(labelText: 'Category'),
              validator: (value) =>
              value == null ? 'Please select a category' : null,
            ),
            const SizedBox(height: 10),
            // Dropdown for Unit enum
            DropdownButtonFormField<Unit>(
              value: _rawMaterial.unit,
              items: _buildUnitDropdownItems(),
              onChanged: (Unit? newValue) {
                setState(() {
                  _rawMaterial.unit = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Unit'),
              validator: (value) =>
              value == null ? 'Please select a unit' : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
              onPressed: pickImage,
            ),
            if (kIsWeb && webImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(
                  webImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              )
            else if (!kIsWeb && selectedImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  // Use XFile for mobile without using `File`
                  File(selectedImage!.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: submitRawMaterial,
              child: const Text(
                "Save Raw Material",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
