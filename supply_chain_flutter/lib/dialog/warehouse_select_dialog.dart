import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WarehouseSelectDialog extends StatefulWidget {
  @override
  _WarehouseSelectDialogState createState() => _WarehouseSelectDialogState();
}

class _WarehouseSelectDialogState extends State<WarehouseSelectDialog> {
  List<Warehouse> warehouses = [];
  Warehouse? selectedWarehouse;

  @override
  void initState() {
    super.initState();
    loadWarehouses();
  }

  Future<void> loadWarehouses() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/warehouses'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          warehouses = (data['warehouses'] as List).map((item) => Warehouse.fromJson(item)).toList();
        });
      } else {
        NotifyUtil.error(context, 'Failed to load warehouses.');
      }
    } catch (error) {
      NotifyUtil.error(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Warehouse'),
      content: DropdownButtonFormField<Warehouse>(
        hint: Text('Choose a warehouse'),
        value: selectedWarehouse,
        items: warehouses.map((warehouse) {
          return DropdownMenuItem(
            value: warehouse,
            child: Text(warehouse.name),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedWarehouse = value;
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedWarehouse != null) {
              Navigator.of(context).pop(selectedWarehouse);
            } else {
              NotifyUtil.error(context, 'Please select a warehouse.');
            }
          },
          child: Text('Select'),
        ),
      ],
    );
  }
}
