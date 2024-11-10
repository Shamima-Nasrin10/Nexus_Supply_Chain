import 'dart:convert';
import 'package:supply_chain_flutter/model/raw_mat_category_model.dart';

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

  // Method to convert from JSON to RawMaterial
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

  // Method to convert RawMaterial to JSON
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

// Enum for Unit types
enum Unit {
  LITRE,
  PIECE,
  KG,
  GRAM,
}