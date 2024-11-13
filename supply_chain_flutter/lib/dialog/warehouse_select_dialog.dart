import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../util/apiresponse.dart';

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
      final response = await http.get(Uri.parse('http://localhost:8080/api/warehouse/list'));
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
      if (apiResponse.success) {
        setState(() {
          List<dynamic> wareHousesJson = apiResponse.data?['warehouses'];
          warehouses = List<Warehouse>.from(wareHousesJson.map((x) => Warehouse.fromJson(x)));
        });
      } else {
        NotifyUtil.error(context, apiResponse.message);
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
