import 'package:supply_chain_flutter/model/raw_material/raw_material_model.dart';

class RawMatUsage {
  int id;
  RawMaterial rawMaterial;
  int quantity;

  RawMatUsage({
    required this.id,
    required this.rawMaterial,
    required this.quantity,
  });

  factory RawMatUsage.fromJson(Map<String, dynamic> json) {
    return RawMatUsage(
      id: json['id'],
      rawMaterial: RawMaterial.fromJson(json['rawMaterial']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rawMaterial': rawMaterial.toJson(),
      'quantity': quantity,
    };
  }
}