
class Product {
  int? id;
  String name;
  String description;
  String? image;

  Product({
    this.id,
    required this.name,
    required this.description,
    this.image,
  });


  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }
}
