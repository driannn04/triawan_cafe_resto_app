import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../models/menu_model.dart';
import '../pages/orders_succes.dart';
import '../utils/page_transition.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _paymentMethod = "Cash";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items.entries.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF2B1B12), // ☕ Warm espresso background
      appBar: AppBar(
        title: const Text(
          "Keranjang",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3A2314),
        elevation: 3,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                "Keranjang masih kosong 🍽️",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 200),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final menu = items[i].key;
                      final qty = items[i].value;

                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A2314),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.brown.shade300.withOpacity(0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              menu.imageUrl.isEmpty
                                  ? 'https://picsum.photos/80'
                                  : menu.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            menu.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          subtitle: Text(
                            "Rp ${menu.price.toStringAsFixed(0)} x $qty",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => cart.removeItem(menu),
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.white70),
                              ),
                              Text(
                                qty.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              IconButton(
                                onPressed: () => cart.addItem(menu),
                                icon: const Icon(Icons.add_circle_outline,
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🟤 Total dan tombol bawah
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 75,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A2314),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total:",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: 'Poppins')),
                            Text(
                              "Rp ${cart.totalPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Color(0xFFD6A86A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Dropdown pembayaran
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.white24, width: 1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: const Color(0xFF3A2314),
                              value: _paymentMethod,
                              items: const [
                                DropdownMenuItem(
                                  value: "Cash",
                                  child: Text("Cash",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins')),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _paymentMethod = v!),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        SizedBox(
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                final orderId =
                                    await ApiService().createOrder(cart.items);

                                if (!context.mounted) return;

                                final total = cart.totalPrice;
                                final itemsCopy =
                                    Map<Menu, int>.from(cart.items);
                                final payment = _paymentMethod;
                                cart.clearCart();

                                Navigator.pushReplacement(
                                  context,
                                  PageTransitionHelper.fadeSlide(
                                    OrderSuccessPage(
                                      orderId: orderId,
                                      totalPrice: total,
                                      items: itemsCopy,
                                      paymentMethod: payment,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent.shade200,
                                    content: Text(
                                      "Gagal memesan: $e",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins'),
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.payment, size: 24),
                            label: const Text(
                              "Pesan Sekarang",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5E3C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
