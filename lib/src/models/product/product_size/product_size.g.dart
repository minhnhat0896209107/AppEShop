
part  of 'product_size.dart';

extension ProductSizeCopyWith on ProductSize{
  ProductSize copyWith({
    int? id,
  int? quantity,
  Category? size,
  }){
    return ProductSize(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size
    );
  }
}

ProductSize _$ProductSizeFromJson(Map json){
  return ProductSize(
    id: json['id'] as int?,
    quantity: json['quantity'] as int?,
    size: json['size'] == null
      ? null
      : Category.fromJson(Map<String, dynamic>.from(json['size'] as Map))
  );
}

Map<String, dynamic> _$ProductSizeToJson(ProductSize instance){
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value){
    if(value != null){
      val[key] = value;
    }
  }

  writeNotNull("id", instance.id);
  writeNotNull("quantity", instance.quantity);
  writeNotNull("size", instance.size);
  return val;
}