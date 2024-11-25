import 'dart:convert';
import 'package:supply_chain_flutter/model/raw_material/raw_mat_category_model.dart';

class RawMaterial {
   int? id;
   String name;
   Unit unit;
   String? image;
   RawMatCategory? category;
   int? quantity;

  RawMaterial({
    this.id,
    required this.name,
    required this.unit,
    this.image,
    required this.category,
    this.quantity
  });

  factory RawMaterial.fromJson(Map<String, dynamic> json) {
    return RawMaterial(
      id: json['id'] as int?,
      name: json['name'] as String,
      unit: Unit.values.firstWhere((e) => e.toString() == 'Unit.${json['unit']}'),
      image: json['image'] as String?,
      category: json['category'] != null
          ? RawMatCategory.fromJson(json['category'])
          : null,
      quantity: json['quantity'] as int? ?? 0,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit.toString().split('.').last,
      'image': image,
      'category': category?.toJson(),
      'quantity': quantity,
    };
  }
}

enum Unit {
  LITRE,
  PIECE,
  KG,
  GRAM,
}