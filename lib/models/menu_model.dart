// lib/models/menu_model.dart
class Menu {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  Menu({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? json['menu_name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : (json['price'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? json['image'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
