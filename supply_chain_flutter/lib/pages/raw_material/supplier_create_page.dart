import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/model/supplier_model.dart';
import 'package:supply_chain_flutter/service/supplier_service.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';
import '../../util/notify_util.dart';

class SupplierCreatePage extends StatefulWidget {
  final Supplier? supplier;

  const SupplierCreatePage({Key? key, this.supplier}) : super(key: key);

  @override
  _SupplierCreatePageState createState() => _SupplierCreatePageState();
}

class _SupplierCreatePageState extends State<SupplierCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _cellNoController = TextEditingController();
  final _addressController = TextEditingController();
  final SupplierService _service = SupplierService();

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _companyNameController.text = widget.supplier!.companyName ?? '';
      _contactPersonController.text = widget.supplier!.contactPerson ?? '';
      _emailController.text = widget.supplier!.email ?? '';
      _cellNoController.text = widget.supplier!.cellNo ?? '';
      _addressController.text = widget.supplier!.address ?? '';
    }
  }

  Future<void> _saveSupplier() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newSupplier = Supplier(
        id: widget.supplier?.id,
        companyName: _companyNameController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        email: _emailController.text.trim(),
        cellNo: _cellNoController.text.trim(),
        address: _addressController.text.trim(),
      );

      ApiResponse response = await _service.saveSupplier(newSupplier);
      if (response.success) {
        NotifyUtil.success(context, response.message ?? 'Supplier saved successfully');
        Navigator.of(context).pop();
      } else {
        NotifyUtil.error(context, response.message ?? 'Failed to save supplier');
      }
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _cellNoController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplier != null ? 'Edit Supplier' : 'Create Supplier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _contactPersonController,
                decoration: InputDecoration(labelText: 'Contact Person'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a contact person name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _cellNoController,
                decoration: InputDecoration(labelText: 'Cell No'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a cell number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSupplier,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
