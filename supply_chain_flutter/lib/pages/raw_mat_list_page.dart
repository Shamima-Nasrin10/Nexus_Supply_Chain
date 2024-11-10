import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/model/raw_material.dart';
import 'package:supply_chain_flutter/service/raw_material_service.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

import '../dialog/add_raw_mat_dialog.dart';

class RawMatListPage extends StatefulWidget {
  const RawMatListPage({Key? key}) : super(key: key);

  @override
  _RawMatListPageState createState() => _RawMatListPageState();
}

class _RawMatListPageState extends State<RawMatListPage> {
  List<RawMaterial> rawMaterials = [];

  @override
  void initState() {
    super.initState();
    loadRawMaterials();
  }

  Future<void> loadRawMaterials() async {
    final response = await RawMaterialService().getRawMaterials();

    // Error handling and debug logging
    if (response.success) {
      setState(() {
        // Verify the correct structure of response data
        if (response.data != null && response.data!['rawMaterials'] != null) {
          rawMaterials = (response.data!['rawMaterials'] as List)
              .map((json) => RawMaterial.fromJson(json))
              .toList();
        } else {
          NotifyUtil.error(context, 'Data format is incorrect');
        }
      });
    } else {
      NotifyUtil.error(context, response.message ?? 'Failed to load raw materials');
    }
  }

  Future<void> deleteRawMaterial(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Raw Material'),
        content: Text('Are you sure you want to delete this raw material?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
        ],
      ),
    );

    if (confirmDelete) {
      final response = await RawMaterialService().deleteRawMaterialById(id);
      if (response.success) {
        NotifyUtil.success(context, response.message ?? 'Raw Material deleted successfully');
        loadRawMaterials(); // Refresh list after deletion
      } else {
        NotifyUtil.error(context, response.message ?? 'Failed to delete raw material');
      }
    }
  }

  Future<void> openAddRawMaterialDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AddRawMaterialDialog(onSave: loadRawMaterials),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raw Materials List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: rawMaterials.isEmpty
            ? Center(child: CircularProgressIndicator())
            : DataTable(
          columns: const [
            DataColumn(label: Text("SL")),
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Unit")),
            DataColumn(label: Text("Category")),
            DataColumn(label: Text("Stock")),
            DataColumn(label: Text("Image")),
            DataColumn(label: Text("Actions")),
          ],
          rows: rawMaterials.asMap().entries.map((entry) {
            int index = entry.key;
            RawMaterial rawMaterial = entry.value;

            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(Text(rawMaterial.name ?? '-')),
                DataCell(Text(rawMaterial.unit?.toString().split('.').last ?? '-')),
                DataCell(Text(rawMaterial.category?.name ?? '-')),
                DataCell(Text('${rawMaterial.quantity ?? 0}')),
                DataCell(rawMaterial.image != null
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                                        'http://localhost:8080/images/rawmaterial/${rawMaterial.image}',
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                    )
                    : Text('No Image')),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Handle edit
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteRawMaterial(rawMaterial.id!),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddRawMaterialDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
