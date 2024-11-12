import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

class AddWarehouseDialog extends StatefulWidget {
  final VoidCallback onSave;

  AddWarehouseDialog({required this.onSave});

  @override
  _AddWarehouseDialogState createState() => _AddWarehouseDialogState();
}

class _AddWarehouseDialogState extends State<AddWarehouseDialog> {
  final TextEditingController nameTEC = TextEditingController();
  final TextEditingController locationTEC = TextEditingController();
  Warehouse _warehouse = Warehouse(name: '', location: '');

  Future<void> submitWarehouse() async {
    if (nameTEC.text.isEmpty) {
      NotifyUtil.error(context, 'Please enter warehouse name.');
      return;
    }
    _warehouse.name = nameTEC.text;

    if (locationTEC.text.isEmpty) {
      NotifyUtil.error(context, 'Please enter location.');
      return;
    }
    _warehouse.location = locationTEC.text;

    var uri = Uri.parse('http://localhost:8080/api/warehouse/save');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(_warehouse.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      NotifyUtil.success(context, 'Warehouse saved successfully');
      widget.onSave();
      Navigator.of(context).pop();
    } else {
      NotifyUtil.error(context, 'Failed to save. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Warehouse'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameTEC,
              decoration: InputDecoration(labelText: 'Warehouse Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationTEC,
              decoration: InputDecoration(labelText: 'Location'),
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
          onPressed: submitWarehouse,
          child: Text('Save'),
        ),
      ],
    );
  }
}
