import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/model/raw_mat_category_model.dart';
import 'package:supply_chain_flutter/service/raw_mat_category_service.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';
import '../../util/notify_util.dart';

class RawMatCategoryCreatePage extends StatefulWidget {
  final RawMatCategory? category; // Accepts an optional category for editing

  const RawMatCategoryCreatePage({Key? key, this.category}) : super(key: key);
  @override
  _RawMaterialCategoryCreatePageState createState() => _RawMaterialCategoryCreatePageState();
}

class _RawMaterialCategoryCreatePageState extends State<RawMatCategoryCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final RawMaterialCategoryService _service = RawMaterialCategoryService();

  Future<void> _saveCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newCategory = RawMatCategory(name: _nameController.text.trim());

      ApiResponse response = await _service.saveRawMaterialCategory(newCategory);
      if (response.success) {
        NotifyUtil.success(context, response.message ?? 'Category saved successfully');
        Navigator.of(context).pop(); // Navigate back after saving
      } else {
        NotifyUtil.error(context, response.message ?? 'Failed to save category');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Raw Material Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Category Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCategory,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
