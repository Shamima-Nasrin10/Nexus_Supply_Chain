import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/model/raw_material/raw_mat_category_model.dart';
import 'package:supply_chain_flutter/service/raw_material/raw_mat_category_service.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';
import '../../util/notify_util.dart';

class RawMaterialCategoryListPage extends StatefulWidget {
  @override
  _RawMaterialCategoryListPageState createState() => _RawMaterialCategoryListPageState();
}

class _RawMaterialCategoryListPageState extends State<RawMaterialCategoryListPage> {
  final RawMaterialCategoryService _service = RawMaterialCategoryService();
  List<RawMatCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    ApiResponse response = await _service.getAllRawMaterialCategories();
    if (response.success) {
      setState(() {
        _categories = (response.data?['categories'] as List)
            .map((json) => RawMatCategory.fromJson(json))
            .toList();
      });
    } else {
      NotifyUtil.error(context, response.message ?? 'Failed to load categories');
    }
  }

  Future<void> _deleteCategory(int id) async {
    ApiResponse response = await _service.deleteRawMaterialCategoryById(id);
    if (response.success) {
      NotifyUtil.success(context, response.message);
      _fetchCategories(); // Refresh the list after deletion
    } else {
      NotifyUtil.error(context, response.message ?? 'Failed to delete category');
    }
  }

  void _showCreateCategoryDialog() {
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Category'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  RawMatCategory newCategory = RawMatCategory(name: name);
                  ApiResponse response = await _service.saveRawMaterialCategory(newCategory);
                  if (response.success) {
                    NotifyUtil.success(context, response.message ?? 'Category saved successfully');
                    Navigator.of(context).pop(); // Close the dialog
                    _fetchCategories(); // Refresh the list to show the new category
                  } else {
                    NotifyUtil.error(context, response.message ?? 'Failed to save category');
                  }
                } else {
                  NotifyUtil.error(context, 'Category name cannot be empty');
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raw Material Categories'),
        centerTitle: true,
      ),
      body: _categories.isEmpty
          ? Center(
        child: Text(
          'No categories available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade200,
                child: Icon(Icons.category, color: Colors.white),
              ),
              title: Text(
                category.name ?? 'Unnamed Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteCategory(category.id!);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateCategoryDialog,
        label: Text('Add Category'),
        icon: Icon(Icons.add),
        tooltip: 'Create Category',
      ),
    );
  }
}
