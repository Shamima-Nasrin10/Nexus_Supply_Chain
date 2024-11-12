import 'package:supply_chain_flutter/model/production/product_model.dart';
import 'package:supply_chain_flutter/model/production/raw_mat_usage_model.dart';
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';

class ProductionProduct {
  int id;
  Product product;
  DateTime completionDate;
  DateTime movedToWarehouseDate;
  int batchNumber;
  int quantity;
  Warehouse? warehouse;
  String? qrCodePath;
  List<RawMatUsage> rawMatUsages;
  Status status;

  ProductionProduct({
    required this.id,
    required this.product,
    required this.completionDate,
    required this.movedToWarehouseDate,
    required this.batchNumber,
    required this.quantity,
    this.warehouse,
    this.qrCodePath,
    required this.rawMatUsages,
    this.status = Status.IN_PROGRESS,
  });

  factory ProductionProduct.fromJson(Map<String, dynamic> json) {
    return ProductionProduct(
      id: json['id'],
      product: Product.fromJson(json['product']),
      completionDate: DateTime.parse(json['completionDate']),
      movedToWarehouseDate: DateTime.parse(json['movedToWarehouseDate']),
      batchNumber: json['batchNumber'],
      quantity: json['quantity'],
      warehouse: json['warehouse'] != null ? Warehouse.fromJson(json['warehouse']) : null,
      qrCodePath: json['qrCodePath'],
      rawMatUsages: (json['rawMatUsages'] as List)
          .map((item) => RawMatUsage.fromJson(item))
          .toList(),
      status: Status.values.firstWhere((e) => e.toString() == 'Status.' + json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'completionDate': completionDate.toIso8601String(),
      'movedToWarehouseDate': movedToWarehouseDate.toIso8601String(),
      'batchNumber': batchNumber,
      'quantity': quantity,
      'warehouse': warehouse?.toJson(),
      'qrCodePath': qrCodePath,
      'rawMatUsages': rawMatUsages.map((item) => item.toJson()).toList(),
      'status': status.toString().split('.').last,
    };
  }
}

enum Status {
  IN_PROGRESS,
  COMPLETED,
  MOVED_TO_WAREHOUSE }