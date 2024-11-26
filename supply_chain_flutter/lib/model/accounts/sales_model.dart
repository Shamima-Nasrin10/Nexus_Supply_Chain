
import 'package:supply_chain_flutter/model/stakeholders/retailer_model.dart';
import '../production/production_product_model.dart';

class Sales {
  int? id;
  ProductionProduct? productionProduct;
  Retailer? productRetailer;
  DateTime? salesDate;
  double? unitPrice;
  int? quantity;
  double? totalPrice;
  Status? status;

  Sales({
    this.id,
    this.productionProduct,
    this.productRetailer,
    this.salesDate,
    this.unitPrice,
    this.quantity,
    this.totalPrice,
    this.status,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      id: json['id'],
      productionProduct: json['productionProduct'] != null
          ? ProductionProduct.fromJson(json['productionProduct'])
          : null,
      productRetailer: json['productRetailer'] != null
          ? Retailer.fromJson(json['productRetailer'])
          : null,
      salesDate: json['salesDate'] != null
          ? DateTime.parse(json['salesDate'])
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
      'productionProduct': productionProduct?.toJson(),
      'productRetailer': productRetailer?.toJson(),
      'salesDate': salesDate?.toIso8601String(),
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'status': status?.toString().split('.').last,
    };
  }
}

enum Status { PENDING, APPROVED, REJECTED }
