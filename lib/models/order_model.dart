class Order {
  final int id;
  final String custumerName;
  final double totalPrice;
  final String createdAt;

  Order({
    required this.id,
    required this.custumerName,
    required this.totalPrice,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      custumerName: json['custumer_name'] ?? '',
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "custumer_name": custumerName,
      "total_price": totalPrice,
      "created_at": createdAt,
    };
  }
}
