import 'package:flutter/material.dart';
import '../../models/menu_model.dart';

class CartItemTile extends StatelessWidget {
  final Menu menu;
  const CartItemTile({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(menu.imageUrl, width: 60, fit: BoxFit.cover),
      ),
      title: Text(menu.name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Rp ${menu.price.toStringAsFixed(0)}"),
    );
  }
}
