import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_model.dart';

const String baseUrl = "https://3awan-cofe-resto-api-production.up.railway.app";

class ApiService {
  Future<List<Menu>> fetchMenus({String? category, String? search}) async {
    String url = '$baseUrl/api/menus';
    final params = <String, String>{};

    if (category != null && category.isNotEmpty && category != "Semua") {
      params['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    if (params.isNotEmpty) {
      final queryString = params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      url = '$url?$queryString';
    }

    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => Menu.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat menu: ${resp.statusCode}');
  }

  /// 🔹 Kirim pesanan dan item ke backend (versi fix + return orderId)
  Future<int> createOrder(Map<Menu, int> cartItems) async {
    if (cartItems.isEmpty) return -1;

    // Buat list items dari keranjang
    final items = cartItems.entries.map((e) {
      final menu = e.key;
      final qty = e.value;
      final subtotal = menu.price * qty;
      return {
        "menu_id": menu.id,
        "quantity": qty,
        "price": menu.price,
        "subtotal": subtotal,
      };
    }).toList();

    // Hitung total harga keseluruhan
    final total =
        items.fold<double>(0, (sum, e) => sum + (e["subtotal"] as double));

    // Kirim ke backend
    final resp = await http.post(
      Uri.parse('$baseUrl/api/orders'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "customer_name": "User",
        "total_price": total,
        "items": items,
      }),
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final body = jsonDecode(resp.body);
      final orderId = body["order_id"] ?? 0;
      print("✅ Pesanan berhasil dikirim (order_id: $orderId)");
      return orderId;
    } else {
      print("❌ Gagal membuat order: ${resp.body}");
      throw Exception("Gagal membuat order (${resp.statusCode})");
    }
  }

  Future<List<dynamic>> fetchOrders() async {
    final resp = await http.get(Uri.parse('$baseUrl/api/orders'));
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    }
    throw Exception('Gagal memuat riwayat pesanan');
  }
}
