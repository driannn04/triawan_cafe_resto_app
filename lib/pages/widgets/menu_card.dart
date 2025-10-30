import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/menu_model.dart';
import '../../providers/cart_provider.dart';

class MenuCard extends StatefulWidget {
  final Menu menu;
  const MenuCard({super.key, required this.menu});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;
    final count = Provider.of<CartProvider>(context).getItemCount(menu);

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _showDetail(context);
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4), // ✅ FIXED
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Gambar
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    menu.imageUrl.isNotEmpty ? menu.imageUrl : 'https://picsum.photos/200',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),

                // 🔹 Nama + Harga
                Text(
                  menu.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${menu.price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Color(0xFFCA965C),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),

                // 🔹 Tombol bawah card
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 4, right: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 🔸 tombol + -
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                            onPressed: () =>
                                Provider.of<CartProvider>(context, listen: false).removeItem(menu),
                          ),
                          Text(count.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 15)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                            onPressed: () =>
                                Provider.of<CartProvider>(context, listen: false).addItem(menu),
                          ),
                        ],
                      ),

                      // 🔸 Tombol Detail
                      ElevatedButton(
                        onPressed: () => _showDetail(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5E3C),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Detail",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    int qty = 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 0.85,
              minChildSize: 0.4,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            widget.menu.imageUrl.isNotEmpty
                                ? widget.menu.imageUrl
                                : 'https://picsum.photos/300',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.menu.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Rp ${widget.menu.price.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFCA965C),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.menu.description.isNotEmpty
                              ? widget.menu.description
                              : "Menu istimewa dari 3awan Café Resto ☕",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (qty > 1) setState(() => qty--);
                              },
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                qty.toString(),
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => qty++),
                              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addItemWithQuantity(widget.menu, qty);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${widget.menu.name} x$qty ditambahkan ke keranjang"),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shopping_cart_outlined),
                            label: const Text(
                              "Tambah ke Keranjang",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5E3C),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
