import 'package:supply_chain_flutter/model/raw_material/raw_material_model.dart';
import 'package:supply_chain_flutter/model/stakeholders/supplier_model.dart';

class Procurement {
  int? id;
  RawMaterial? rawMaterial;
  Supplier? supplier;
  DateTime? procurementDate;
  int? quantity;
  double? unitPrice;
  double? totalPrice;
  Status? status;

  Procurement({
    this.id,
    this.rawMaterial,
    this.supplier,
    this.procurementDate,
    this.totalPrice,
    this.quantity,
    this.unitPrice,
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
      quantity: json['quantity'],
      unitPrice: json['unitPrice']?.toDouble(),
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
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'status': status?.toString().split('.').last,
    };
  }
}

enum Status { PENDING, APPROVED, REJECTED }
