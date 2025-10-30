// lib/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import '../models/menu_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<Menu, int> _items = {};

  Map<Menu, int> get items => _items;

  void addItem(Menu menu) {
    addItemWithQuantity(menu, 1);
  }

  void addItemWithQuantity(Menu menu, int qty) {
    if (_items.containsKey(menu)) {
      _items[menu] = _items[menu]! + qty;
    } else {
      _items[menu] = qty;
    }
    notifyListeners();
  }

  void removeItem(Menu menu) {
    if (!_items.containsKey(menu)) return;
    if (_items[menu]! > 1) {
      _items[menu] = _items[menu]! - 1;
    } else {
      _items.remove(menu);
    }
    notifyListeners();
  }

  int getItemCount(Menu menu) => _items[menu] ?? 0;

  double get totalPrice {
    double total = 0;
    _items.forEach((menu, qty) {
      total += menu.price * qty;
    });
    return total;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
