import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/dialog/add_warehouse_dialog.dart';
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';
import 'package:supply_chain_flutter/service/production/warehouse_service.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';


class WarehouseListPage extends StatefulWidget {
  const WarehouseListPage({Key? key}) : super(key: key);

  @override
  _WarehouseListPageState createState() => _WarehouseListPageState();
}

class _WarehouseListPageState extends State<WarehouseListPage> {
  List<Warehouse> warehouses = [];

  @override
  void initState() {
    super.initState();
    loadWarehouses();
  }

  Future<void> loadWarehouses() async {
    final response = await WarehouseService().getAllWarehouses();

    if (response.success) {
      setState(() {
        warehouses = (response.data!['warehouses'] as List)
            .map((json) => Warehouse.fromJson(json))
            .toList();
      });
    } else {
      NotifyUtil.error(context, response.message ?? 'Failed to load warehouses');
    }
  }

  Future<void> openAddWarehouseDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AddWarehouseDialog(onSave: loadWarehouses),
    );
  }

  Future<void> deleteWarehouse(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Warehouse'),
        content: Text('Are you sure you want to delete this warehouse?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
        ],
      ),
    );

    if (confirmDelete) {
      final response = await WarehouseService().deleteWarehouseById(id);
      if (response.success) {
        NotifyUtil.success(context, response.message ?? 'Warehouse deleted successfully');
        loadWarehouses();
      } else {
        NotifyUtil.error(context, response.message ?? 'Failed to delete warehouse');
      }
    }
  }

  void viewWarehouse(Warehouse warehouse) {
    // Leave this empty for now
  }

  void editWarehouse(Warehouse warehouse) async {
    await showDialog(
      context: context,
      builder: (context) => AddWarehouseDialog(
        onSave: loadWarehouses,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: <Color>[
              Colors.cyanAccent,
              Colors.tealAccent,
            ],
          ).createShader(bounds),
          child: const Text(
            "Warehouse List",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // This color will be masked by the gradient
            ),
          ),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: warehouses.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: warehouses.length,
          itemBuilder: (context, index) {
            final warehouse = warehouses[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        warehouse.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          warehouse.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility, color: Colors.blue[400]),
                            onPressed: () => viewWarehouse(warehouse),
                            tooltip: 'View Details',
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange[400]),
                            onPressed: () => editWarehouse(warehouse),
                            tooltip: 'Edit Warehouse',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[400]),
                            onPressed: () => deleteWarehouse(warehouse.id!),
                            tooltip: 'Delete Warehouse',
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Add Warehouse",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: openAddWarehouseDialog,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
