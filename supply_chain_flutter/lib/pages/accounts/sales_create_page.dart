import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supply_chain_flutter/model/accounts/sales_model.dart';
import 'package:supply_chain_flutter/model/production/production_product_model.dart';
import 'package:supply_chain_flutter/service/production/production_product_service.dart';
import 'package:supply_chain_flutter/service/stakeholders/retailer_service.dart';
import '../../model/stakeholders/retailer_model.dart';
import '../../service/accounts/sales_service.dart';
import '../../util/apiresponse.dart';
import '../../util/notify_util.dart';
import 'sales_list_page.dart';

class SalesCreatePage extends StatefulWidget {
  final int? saleId;

  SalesCreatePage({Key? key, this.saleId}) : super(key: key);

  @override
  _SalesCreatePageState createState() => _SalesCreatePageState();
}

class _SalesCreatePageState extends State<SalesCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SalesService _salesService = SalesService();
  final ProdProductService _prodProductService = ProdProductService();
  final RetailerService _retailerService = RetailerService();

  Sales _sales = Sales();
  List<ProductionProduct> _productionProducts = [];
  List<Retailer> _retailers = [];
  bool _isLoading = true;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.saleId != null) {
      _isEditMode = true;
      _loadSales(widget.saleId!);
    }
    _loadProdProducts();
    _loadRetailers();
  }

  Future<void> _loadProdProducts() async {
    ApiResponse response = await _prodProductService.getAllMovedToWarehouseProducts();
    print(response);

    if (response.success) {
      setState(() {
        _productionProducts = (response.data?['productionProducts'] as List)
            .map((json) => ProductionProduct.fromJson(json))
            .toList();
      });
    } else {
      NotifyUtil.error(context, 'Failed to load production products.');
    }
  }



  Future<void> _loadRetailers() async {
    ApiResponse response = await _retailerService.getAllRetailers();
    if (response.success) {
      setState(() {
        _retailers = (response.data?['productRetailers'] as List)
            .map((json) => Retailer.fromJson(json))
            .toList();
      });
    } else {
      NotifyUtil.error(context, 'Failed to load retailers.');
    }
  }

  // Load sale details for editing
  Future<void> _loadSales(int id) async {
    ApiResponse response = await _salesService.getSaleById(id);
    if (response.success) {
      setState(() {
        _sales = Sales.fromJson(response.data?['sale']);
      });
    } else {
      NotifyUtil.error(context, 'Failed to load sale.');
    }
  }

  void _updateTotalPrice() {
    setState(() {
      _sales.totalPrice = (_sales.quantity ?? 0) * (_sales.unitPrice ?? 0);
    });
  }

  Future<void> _saveSale() async {
    ApiResponse response;
    if (_isEditMode) {
      if (_sales.id != null) {
        response = await _salesService.updateSale(_sales.id!, _sales);
      } else {
        NotifyUtil.error(context, 'Sale ID is required for updating.');
        return;
      }
    } else {
      response = await _salesService.saveSale(_sales);
    }

    if (response.success) {
      NotifyUtil.success(context, 'Sale saved successfully!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SalesListPage()),
      );
    } else {
      NotifyUtil.error(context, response.message ?? 'Failed to save sale.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Sales' : 'Create New Sales'),
        elevation: 4,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildDropdown(
                label: 'Production Product',
                value: _sales.productionProduct,
                items: _productionProducts,
                itemLabel: (item) => item.product!.name ?? '',
                onChanged: (value) => setState(() => _sales.productionProduct = value),
              ),
              _buildDropdown(
                label: 'Product Retailer',
                value: _sales.productRetailer,
                items: _retailers,
                itemLabel: (item) => item.companyName ?? '',
                onChanged: (value) => setState(() => _sales.productRetailer = value),
              ),
              _buildDatePicker(
                label: 'Sales Date',
                initialDate: _sales.salesDate,
                onChanged: (value) => setState(() => _sales.salesDate = value),
              ),
              _buildTextField(
                label: 'Quantity',
                initialValue: _sales.quantity?.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _sales.quantity = int.tryParse(value ?? '') ?? 0;
                    _updateTotalPrice();
                  });
                },
              ),
              _buildTextField(
                label: 'Unit Price',
                initialValue: _sales.unitPrice?.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _sales.unitPrice = double.tryParse(value ?? '') ?? 0.0;
                    _updateTotalPrice();
                  });
                },
              ),
              _buildTextField(
                label: 'Total Price',
                initialValue: _sales.totalPrice?.toString(),
                keyboardType: TextInputType.number,
                enabled: false,
              ),
              _buildDropdown(
                label: 'Status',
                value: _sales.status,
                items: Status.values,
                itemLabel: (status) => status.toString().split('.').last,
                onChanged: (value) => setState(() => _sales.status = value),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveSale,
                child: Text(_isEditMode ? 'Update Sale' : 'Save Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generic dropdown widget
  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField<T>(
            value: value,
            decoration: InputDecoration(border: OutlineInputBorder()),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabel(item)),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) => value == null ? 'This field is required' : null,
          ),
        ],
      ),
    );
  }

  // Date picker widget
  Widget _buildDatePicker({
    required String label,
    required DateTime? initialDate,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: initialDate != null ? DateFormat('yyyy-MM-dd').format(initialDate) : 'Select a date',
            ),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: initialDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                onChanged(picked);
              }
            },
            validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
          ),
        ],
      ),
    );
  }

  // Text field widget
  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String?>? onChanged,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(border: OutlineInputBorder()),
            enabled: enabled,
            validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
          ),
        ],
      ),
    );
  }
}
