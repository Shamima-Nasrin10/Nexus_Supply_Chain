class Warehouse {
  int? id;
  String name;
  String location;

  Warehouse({
    this.id,
    required this.name,
    required this.location,
  });

  // Factory constructor to create a Warehouse instance from JSON data
  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'] as int?,
      name: json['name'] as String,
      location: json['location'] as String,
    );
  }

  // Method to convert Warehouse instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }
}
