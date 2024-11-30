import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supply_chain_flutter/model/accounts/sales_model.dart';
import 'package:supply_chain_flutter/model/production/production_product_model.dart';
import 'package:supply_chain_flutter/model/stakeholders/retailer_model.dart';
import 'package:supply_chain_flutter/service/production/production_product_service.dart';
import 'package:supply_chain_flutter/service/stakeholders/retailer_service.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';
import '../util/notify_util.dart';

class SalesCreateDialog extends StatefulWidget {
  final Sales? sales;

  SalesCreateDialog({this.sales});

  @override
  _SalesCreateDialogState createState() => _SalesCreateDialogState();
}

class _SalesCreateDialogState extends State<SalesCreateDialog> {
  final RetailerService _retailerService = RetailerService();
  final ProdProductService _prodProductService = ProdProductService();

  List<ProductionProduct> _products = [];
  List<Retailer> _retailers = [];
  Sales _sales = Sales(status: Status.PENDING);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();

    if (widget.sales != null) {
      _sales = widget.sales!;
    }
  }

  Future<void> _fetchData() async {
    try {
      ApiResponse productResponse = await _prodProductService.getAllMovedToWarehouseProducts();
      ApiResponse retailerResponse = await _retailerService.getAllRetailers();

      if (productResponse.success && retailerResponse.success) {
        setState(() {
          _products = (productResponse.data?['productionProducts'] as List)
              .map((json) => ProductionProduct.fromJson(json))
              .toList();
          _retailers = (retailerResponse.data?['productRetailers'] as List)
              .map((json) => Retailer.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        NotifyUtil.error(context,'Failed to load products or retailers');
      }
    } catch (e) {
      NotifyUtil.error(context,e.toString());
    }
  }

  void _saveSales() {
    if (_sales.productionProduct == null || _sales.productRetailer == null) {
      NotifyUtil.error(context, "Please select both product and retailer");
      return;
    }

    if (_sales.quantity == null ||
        _sales.unitPrice == null ||
        _sales.quantity! <= 0 ||
        _sales.unitPrice! <= 0) {
      NotifyUtil.error(context, "Please enter valid quantity and unit price");
      return;
    }

    setState(() {
      _sales.totalPrice = _sales.unitPrice! * _sales.quantity!;
    });
    Navigator.of(context).pop(_sales);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AlertDialog(
        title: Text('Loading...'),
        content: Center(child: CircularProgressIndicator()),
      );
    }

    return AlertDialog(
      title: Text(widget.sales != null ? "Edit Sales" : "Create Sales"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<ProductionProduct>(
              value: _sales.productionProduct,
              onChanged: (value) =>
                  setState(() => _sales.productionProduct = value),
              items: _products.map((product) {
                return DropdownMenuItem<ProductionProduct>(
                  value: product,
                  child: Text(product?.product?.name ?? 'Unknown Product'),
                );
              }).toList(),
              decoration: InputDecoration(labelText: "Product"),
            ),
            DropdownButtonFormField<Retailer>(
              value: _sales.productRetailer,
              onChanged: (value) =>
                  setState(() => _sales.productRetailer = value),
              items: _retailers.map((retailer) {
                return DropdownMenuItem<Retailer>(
                  value: retailer,
                  child: Text(retailer.companyName ?? 'Unknown Retailer'),
                );
              }).toList(),
              decoration: InputDecoration(labelText: "Retailer"),
            ),
            TextFormField(
              initialValue: _sales.unitPrice?.toString(),
              decoration: InputDecoration(labelText: "Unit Price"),
              keyboardType: TextInputType .number,
              onChanged: (value) => setState(() {
                _sales.unitPrice = double.tryParse(value) ?? 0.0;
                _sales.totalPrice = _sales.unitPrice! * (_sales.quantity ?? 0);
              }),
            ),
            TextFormField(
              initialValue: _sales.quantity?.toString(),
              decoration: InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {
                _sales.quantity = int.tryParse(value) ?? 0;
                _sales.totalPrice = _sales.unitPrice! * (_sales.quantity ?? 0);
              }),
            ),
            DropdownButtonFormField<Status>(
              value: _sales.status,
              onChanged: (value) => setState(() => _sales.status = value),
              items: Status.values.map((status) {
                return DropdownMenuItem<Status>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              decoration: InputDecoration(labelText: "Status"),
            ),
            Row(
              children: [
                Text(
                    "Sales Date: ${_sales.salesDate != null ? DateFormat('yyyy-MM-dd').format(_sales.salesDate!) : 'Not Set'}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _sales.salesDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _sales.salesDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _saveSales,
          child: Text("Save"),
        ),
      ],
    );
  }
}