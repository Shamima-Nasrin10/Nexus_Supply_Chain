class Supplier {
  int? id;
  String? companyName;
  String? contactPerson;
  String? email;
  String? cellNo;
  String? address;


  Supplier({this.id, this.companyName, this.contactPerson, this.email, this.cellNo, this.address});

  Supplier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
    contactPerson=json['contactPerson'];
    email=json['email'];
    cellNo=json['cellNo'];
    address=json['address'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'contactPerson': contactPerson,
      'email': email,
      'cellNo': cellNo,
      'address': address,
    };
  }
}