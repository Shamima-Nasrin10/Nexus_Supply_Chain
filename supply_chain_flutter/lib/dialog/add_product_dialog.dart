import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

import '../model/production/product_model.dart';
import '../util/util.dart';

class AddProductDialog extends StatefulWidget {
  final VoidCallback onSave;

  AddProductDialog({required this.onSave});

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController nameTEC = TextEditingController();
  final TextEditingController descriptionTEC = TextEditingController();
  XFile? selectedImage;
  Uint8List? webImage; // For storing the image bytes on web
  Product _product = Product(name: '', description: '');
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    if (kIsWeb) {
      // For Web
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        var uintImage = await Util.convertXFileToUint8List(pickedImage);
        setState(() {
          webImage = uintImage; // Store the picked image as Uint8List
        });
      }
    } else {
      // For Mobile/Desktop
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  Future<void> submitProduct() async {
    if (nameTEC.text.isEmpty) {
      NotifyUtil.error(context, 'Please enter name.');
      return;
    }
    _product.name = nameTEC.text;

    if (descriptionTEC.text.isEmpty) {
      NotifyUtil.error(context, 'Please enter description of product.');
      return;
    }
    _product.description = descriptionTEC.text;

    var uri = Uri.parse('http://localhost:8080/api/product/save');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromString(
        'product',
        jsonEncode(_product),
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
        NotifyUtil.success(context, 'Product saved successfully');
        widget.onSave(); // Callback to refresh the main page after saving
        Navigator.of(context).pop(); // Close the dialog
      } else {
        NotifyUtil.error(context, 'Failed to save. Status code: ${response.statusCode}');
      }
    } catch (e) {
      NotifyUtil.error(context, 'Error occurred while submitting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name Field
            TextField(
              controller: nameTEC,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            // Description Field
            TextField(
              controller: descriptionTEC,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            // Image Picker Button
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              label: Text('Pick Image'),
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
                  File(selectedImage!.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: submitProduct,
          child: Text('Save'),
        ),
      ],
    );
  }
}
