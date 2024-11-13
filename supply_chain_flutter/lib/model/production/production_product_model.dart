import 'package:supply_chain_flutter/model/production/product_model.dart';
import 'package:supply_chain_flutter/model/production/raw_mat_usage_model.dart';
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';

class ProductionProduct {
  int? id;
  Product? product;
  DateTime? completionDate;
  DateTime? movedToWarehouseDate;
  int? batchNumber;
  int? quantity;
  Warehouse? warehouse;
  String? qrCodePath;
  List<RawMatUsage>? rawMatUsages;
  ProductionStatus? status;

  ProductionProduct({
    this.id,
    this.product,
    this.completionDate,
    this.movedToWarehouseDate,
    this.batchNumber,
    this.quantity,
    this.warehouse,
    this.qrCodePath,
    this.rawMatUsages,
    this.status = ProductionStatus.IN_PROGRESS,
  });

  factory ProductionProduct.fromJson(Map<String, dynamic> json) {
      return ProductionProduct(
        id: json['id'],
        product: Product.fromJson(json['product']),
        completionDate: json['completionDate'] != null
            ? DateTime.parse(json['completionDate'])
            : null,
        movedToWarehouseDate: json['movedToWarehouseDate'] != null
            ? DateTime.parse(json['movedToWarehouseDate'])
            : null,
        batchNumber: json['batchNumber'],
        quantity: json['quantity'],
        warehouse: json['warehouse'] != null ? Warehouse.fromJson(json['warehouse']) : null,
        qrCodePath: json['qrCodePath'],
        rawMatUsages: (json['rawMatUsages'] as List)
            .map((item) => RawMatUsage.fromJson(item))
            .toList(),
        status: ProductionStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['status'],
          orElse: () => ProductionStatus.IN_PROGRESS, // Provide a fallback or default status
        ),
      );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product?.toJson(),
      'batchNumber': batchNumber,
      'quantity': quantity,
      'warehouse': warehouse?.toJson(),
      'qrCodePath': qrCodePath,
      'rawMatUsages': rawMatUsages?.map((item) => item.toJson()).toList(),
      'status': status.toString().split('.').last,
      // Dates are not included in `toJson` since they are managed by the backend
    };
  }
}

enum ProductionStatus { IN_PROGRESS, COMPLETED, MOVED_TO_WAREHOUSE }