class Product {
  String? id;
  String? name;
  String? description;
  String? unit;
  String? status;
  int? price = 100000;
  String? imageUrl;
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.status,
    required this.price,
    required this.imageUrl,
  });
  Product.fromJson(Map json) {
    id = json['id'].toString();
    name = json['name'];
    description = json['description'];
    unit = json['unit'];
    status = json['status'];
  }
}
