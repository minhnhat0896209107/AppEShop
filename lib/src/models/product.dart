import 'dart:convert';

class Product {
  String? id;
  String? name;
  String? description;
  String? unit;
  String? status;
  int? price;
  int? originPrice;
  String? imageUrl;
  String? category;
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
    price = json['price'];
    category = json['category']?['name'];
    imageUrl = json['imageUrl'];
    // originPrice = json['price'];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'status': status,
      'category': {'name': category},
      'imageUrl': imageUrl
    };
    return map;
  }
}
