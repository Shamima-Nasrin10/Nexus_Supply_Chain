import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supply_chain_flutter/model/accounts/procurement_model.dart';
import 'package:supply_chain_flutter/model/raw_material/raw_material_model.dart';
import 'package:supply_chain_flutter/model/stakeholders/supplier_model.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';
import '../../service/accounts/procurement_service.dart';
import '../../service/raw_material/raw_material_service.dart';
import '../../service/stakeholders/supplier_service.dart';

class ProcurementCreatePage extends StatefulWidget {
  Procurement? procurement;

  ProcurementCreatePage({this.procurement});

  @override
  _ProcurementCreatePageState createState() => _ProcurementCreatePageState();
}

class _ProcurementCreatePageState extends State<ProcurementCreatePage> {
  final ProcurementService _procurementService = ProcurementService();
  final RawMaterialService _rawMaterialService = RawMaterialService();
  final SupplierService _supplierService = SupplierService();

  List<Procurement> _procurements = [
    Procurement(procurementDate: DateTime.now(), status: Status.PENDING)
  ];
  List<RawMaterial> _availableRawMaterials = [];
  List<Supplier> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _fetchData();

    if (widget.procurement != null) {
      _procurements = [
        widget.procurement!
      ];
    } else {
      _procurements = [
        Procurement(procurementDate: DateTime.now(), status: Status.PENDING)
      ];
    }
  }

  Future<void> _fetchData() async {
    ApiResponse supplierResponse = await _supplierService.getAllSuppliers();
    ApiResponse materialResponse = await _rawMaterialService.getRawMaterials();

    if (supplierResponse.success && materialResponse.success) {
      setState(() {
        _suppliers = (supplierResponse.data?['rawMaterialSuppliers'] as List)
            .map((json) => Supplier.fromJson(json))
            .toList();
        _availableRawMaterials =
            (materialResponse.data?['rawMaterials'] as List)
                .map((json) => RawMaterial.fromJson(json))
                .toList();
      });
    }
  }

  void _addProcurement() {
    setState(() {
      _procurements.add(
          Procurement(procurementDate: DateTime.now(), status: Status.PENDING));
    });
  }

  void _removeProcurement(int index) {
    if (_procurements.length > 1) {
      setState(() {
        _procurements.removeAt(index);
      });
    }
  }

  double _calculateTotalPrice() {
    return _procurements.fold(
        0, (sum, item) => sum + (item.unitPrice ?? 0) * (item.quantity ?? 1));
  }

  Future<void> _submitProcurement() async {
    bool isEditing = widget.procurement != null;

    for (var procurement in _procurements) {
      if (procurement.rawMaterial == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please select Raw Material")));
        return;
      }
      if (procurement.quantity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please enter quantity of Raw Material")));
        return;
      }
      if (procurement.unitPrice == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please enter unit price of Raw Material")));
        return;
      }
      if (procurement.status == null ||
          !Status.values.contains(procurement.status)) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please select a valid status")));
        return;
      }
    }

    ApiResponse response;

    if (isEditing) {
      response = await _procurementService.updateProcurement(
          widget.procurement!.id!, _procurements[0]);
    } else {
      response = await _procurementService.saveProcurements(_procurements);
    }

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isEditing
                ? "Procurement updated successfully"
                : "Procurement saved successfully")),
      );

      // Return success indicator to the list page
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text("Failed to ${isEditing ? "update" : "save"} procurement")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_availableRawMaterials.isEmpty || _suppliers.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text("Create Procurement")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._procurements.asMap().entries.map((entry) {
                int index = entry.key;
                Procurement item = entry.value;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                "Date: ${DateFormat('yyyy-MM-dd').format(item.procurementDate ?? DateTime.now())}"),
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      item.procurementDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    item.procurementDate = pickedDate;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        DropdownButtonFormField<RawMaterial>(
                          value:
                              _availableRawMaterials.contains(item.rawMaterial)
                                  ? item.rawMaterial
                                  : null,
                          onChanged: (value) =>
                              setState(() => item.rawMaterial = value),
                          items: _availableRawMaterials.map((material) {
                            return DropdownMenuItem<RawMaterial>(
                              value: material,
                              child: Text(material.name ?? 'Unknown Material'),
                            );
                          }).toList(),
                          decoration:
                              InputDecoration(labelText: "Raw Material"),
                        ),
                        DropdownButtonFormField<Supplier>(
                          value: _suppliers.contains(item.supplier) ? item.supplier : null,
                          onChanged: (value) => setState(() => item.supplier = value),
                          items: _suppliers.map((supplier) {
                            return DropdownMenuItem<Supplier>(
                              value: supplier,
                              child: Text(supplier.companyName ?? 'Unknown Supplier'),
                            );
                          }).toList(),
                          decoration: InputDecoration(labelText: "Supplier"),
                        ),
                        TextFormField(
                          initialValue: item.unitPrice?.toString(),
                          decoration: InputDecoration(labelText: "Unit Price"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => setState(() {
                            item.unitPrice = double.tryParse(value) ?? 0.0;
                          }),
                        ),
                        TextFormField(
                          initialValue: item.quantity?.toString(),
                          decoration: InputDecoration(labelText: "Quantity"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => setState(() {
                            item.quantity = int.tryParse(value) ?? 1;
                          }),
                        ),
                        DropdownButtonFormField<Status>(
                          value: item.status,
                          onChanged: (value) =>
                              setState(() => item.status = value),
                          items: Status.values.map((status) {
                            return DropdownMenuItem<Status>(
                              value: status,
                              child: Text(status.toString().split('.').last),
                            );
                          }).toList(),
                          decoration: InputDecoration(labelText: "Status"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle),
                              onPressed: () => _removeProcurement(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              TextButton.icon(
                icon: Icon(Icons.add),
                label: Text("Add Procurement"),
                onPressed: _addProcurement,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProcurement,
                child: Text("Save Procurement"),
              ),
              SizedBox(height: 10),
              Text("Total Price: ${_calculateTotalPrice().toStringAsFixed(2)}"),
            ],
          ),
        ),
      ),
    );
  }
}
