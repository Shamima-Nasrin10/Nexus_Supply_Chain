import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:supply_chain_flutter/model/production/product_model.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

import '../../util/util.dart';


class ProductCreatePage extends StatefulWidget {
  const ProductCreatePage({Key? key}) : super(key: key);

  @override
  _ProductCreatePageState createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final TextEditingController nameTEC = TextEditingController();
  final TextEditingController descriptionTEC = TextEditingController();
  XFile? selectedImage;
  Uint8List? webImage;
  Product _product = Product(name: '', description: '');
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

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
      } else {
        NotifyUtil.error(
            context, 'Failed to save. Status code: ${response.statusCode}');
      }
    } catch (e) {
      NotifyUtil.error(context, 'Error occurred while submitting: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Product",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // Name Text Field
            TextField(
              controller: nameTEC,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
                icon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 10),
            // Description Text Field
            TextField(
              controller: descriptionTEC,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                icon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 10),
            // Image Picker Button
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
              onPressed: pickImage,
            ),
            // Display selected image preview
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
            else
              if (!kIsWeb && selectedImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    File(selectedImage!.path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
            const SizedBox(height: 20),
            // Save Product Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: submitProduct,
              child: const Text(
                "Save Product",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}