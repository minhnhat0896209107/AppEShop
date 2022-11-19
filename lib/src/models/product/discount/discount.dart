class Discount {
    Discount({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.percent,
        this.startDate,
        this.endDate,
    });

    int? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? name;
    int? percent;
    DateTime? startDate;
    DateTime? endDate;

    factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        percent: json["percent"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "name": name,
        "percent": percent,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
    };
}
