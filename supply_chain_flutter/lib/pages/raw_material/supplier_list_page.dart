import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/model/raw_material/raw_mat_category_model.dart';
import 'package:supply_chain_flutter/model/raw_material/supplier_model.dart';
import 'package:supply_chain_flutter/service/raw_material/raw_mat_category_service.dart';
import 'package:supply_chain_flutter/service/raw_material/supplier_service.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';
import '../../util/notify_util.dart';

class SupplierListPage extends StatefulWidget {
  @override
  _SupplierListPageState createState() => _SupplierListPageState();
}

class _SupplierListPageState extends State<SupplierListPage> {
  final SupplierService _service = SupplierService();
  List<Supplier> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _fetchSuppliers();
  }

  Future<void> _fetchSuppliers() async {
    ApiResponse response = await _service.getAllSuppliers();
    if (response.success) {
      setState(() {
        _suppliers = (response.data?['rawMaterialSuppliers'] as List)
            .map((json) => Supplier.fromJson(json))
            .toList();
      });
    } else {
      NotifyUtil.error(context, response.message ?? 'Failed to load suppliers');
    }
  }

  Future<void> _deleteSupplier(int id) async {
    ApiResponse response = await _service.deleteSupplierById(id);
    if (response.success) {
      NotifyUtil.success(context, response.message);
      _fetchSuppliers();
    } else {
      NotifyUtil.error(
          context, response.message ?? 'Failed to delete supplier');
    }
  }

  void _showCreateSupplierDialog() {
    final _companyNameController = TextEditingController();
    final _contactPersonController = TextEditingController();
    final _emailController = TextEditingController();
    final _cellNoController = TextEditingController();
    final _addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Supplier'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _companyNameController,
                  decoration: InputDecoration(labelText: 'Company Name'),
                ),
                TextField(
                  controller: _contactPersonController,
                  decoration: InputDecoration(labelText: 'Contact Person'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _cellNoController,
                  decoration: InputDecoration(labelText: 'Cell No'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final companyName = _companyNameController.text.trim();
                if (companyName.isNotEmpty) {
                  Supplier newSupplier = Supplier(
                    companyName: companyName,
                    contactPerson: _contactPersonController.text.trim(),
                    email: _emailController.text.trim(),
                    cellNo: _cellNoController.text.trim(),
                    address: _addressController.text.trim(),
                  );

                  ApiResponse response = await _service.saveSupplier(newSupplier);
                  if (response.success) {
                    NotifyUtil.success(context, response.message ?? 'Supplier saved successfully');
                    Navigator.of(context).pop();
                    _fetchSuppliers();
                  } else {
                    NotifyUtil.error(context, response.message ?? 'Failed to save supplier');
                  }
                } else {
                  NotifyUtil.error(context, 'Company name cannot be empty');
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
        title: Text(
          'List of Suppliers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.lightBlue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _suppliers.isEmpty
            ? Center(
          child: Text(
            'No suppliers available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: _suppliers.length,
          itemBuilder: (context, index) {
            final supplier = _suppliers[index];
            return Card(
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.blueGrey.withOpacity(0.5),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade300,
                  child: Icon(Icons.business, color: Colors.white, size: 28),
                ),
                title: Text(
                  supplier.companyName ?? 'Unnamed Supplier',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo.shade800,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (supplier.contactPerson != null)
                        Row(
                          children: [
                            Icon(Icons.person, size: 16, color: Colors.blueGrey),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Contact Person: ${supplier.contactPerson}',
                                style: TextStyle(color: Colors.blueGrey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      if (supplier.email != null)
                        Row(
                          children: [
                            Icon(Icons.email, size: 16, color: Colors.blueGrey),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Email: ${supplier.email}',
                                style: TextStyle(color: Colors.blueGrey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      if (supplier.cellNo != null)
                        Row(
                          children: [
                            Icon(Icons.phone, size: 16, color: Colors.blueGrey),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Cell: ${supplier.cellNo}',
                                style: TextStyle(color: Colors.blueGrey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      if (supplier.address != null)
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.blueGrey),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Address: ${supplier.address}',
                                style: TextStyle(color: Colors.blueGrey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteSupplier(supplier.id!);
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
                  icon: Icon(Icons.more_vert, color: Colors.blueGrey.shade600),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateSupplierDialog,
        label: Text(
          'Add Supplier',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
    );
  }
}
