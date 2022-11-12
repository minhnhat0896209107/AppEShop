// To parse this JSON data, do
//
//     final orderMomo = orderMomoFromJson(jsonString);

import 'dart:convert';

import 'order_item/order_item.dart';

OrderMomo orderMomoFromJson(String str) => OrderMomo.fromJson(json.decode(str));

String orderMomoToJson(OrderMomo data) => json.encode(data.toJson());

class OrderMomo {
    OrderMomo({
        this.id,
        this.createdAt,
        this.status,
        this.userId,
        this.total,
        this.address,
        this.name,
        this.phone,
        this.note,
        this.orderItems,
    });

    int? id;
    DateTime? createdAt;
    String? status;
    int? userId;
    String? total;
    String? address;
    String? name;
    String? phone;
    dynamic note;
    List<OrderItem>? orderItems;

    factory OrderMomo.fromJson(Map<String, dynamic> json) => OrderMomo(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        status: json["status"],
        userId: json["userId"],
        total: json["total"],
        address: json["address"],
        name: json["name"],
        phone: json["phone"],
        note: json["note"],
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "status": status,
        "userId": userId,
        "total": total,
        "address": address,
        "name": name,
        "phone": phone,
        "note": note,
        "orderItems": List<dynamic>.from(orderItems!.map((x) => x.toJson())),
    };
}



