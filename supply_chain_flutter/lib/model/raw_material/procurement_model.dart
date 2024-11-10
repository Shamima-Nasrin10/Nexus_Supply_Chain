import 'dart:convert';

import 'package:supply_chain_flutter/model/raw_material/raw_material_model.dart';
import 'package:supply_chain_flutter/model/raw_material/supplier_model.dart';

class Procurement {
  int? id;
  RawMaterial? rawMaterial;
  Supplier? supplier;
  DateTime? procurementDate;
  double? unitPrice;
  int? quantity;
  double? totalPrice;
  Status? status;

  Procurement({
    this.id,
    this.rawMaterial,
    this.supplier,
    this.procurementDate,
    this.unitPrice,
    this.quantity,
    this.totalPrice,
    this.status,
  });

  factory Procurement.fromJson(Map<String, dynamic> json) {
    return Procurement(
      id: json['id'],
      rawMaterial: json['rawMaterial'] != null
          ? RawMaterial.fromJson(json['rawMaterial'])
          : null,
      supplier: json['rawMaterialSupplier'] != null
          ? Supplier.fromJson(json['rawMaterialSupplier'])
          : null,
      procurementDate: json['procurementDate'] != null
          ? DateTime.parse(json['procurementDate'])
          : null,
      unitPrice: json['unitPrice']?.toDouble(),
      quantity: json['quantity'],
      totalPrice: json['totalPrice']?.toDouble(),
      status: json['status'] != null
          ? Status.values.firstWhere((e) => e.toString() == 'Status.${json['status']}')
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rawMaterial': rawMaterial?.toJson(),
      'rawMaterialSupplier': supplier?.toJson(),
      'procurementDate': procurementDate?.toIso8601String(),
      'unitPrice': unitPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'status': status?.toString().split('.').last,
    };
  }
}
enum Status { PENDING, APPROVED, REJECTED }
