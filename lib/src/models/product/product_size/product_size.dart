import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../category/category.dart';
part 'product_size.g.dart';

@JsonSerializable()
class ProductSize {
  int? id;
  int? quantity;
  Category? size;

  ProductSize({
    this.id,
    this.quantity,
    this.size,
  });
  factory ProductSize.fromJson(Map<String, dynamic> json) => _$ProductSizeFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSizeToJson(this);
}
