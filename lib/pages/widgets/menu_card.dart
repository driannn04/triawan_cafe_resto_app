import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/menu_model.dart';
import '../../providers/cart_provider.dart';

class MenuCard extends StatefulWidget {
  final Menu menu;
  final VoidCallback? onAddToCart; // callback ke HomePage

  const MenuCard({
    super.key,
    required this.menu,
    this.onAddToCart,
  });

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
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: const Color(0xFF2B1B12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.brown.shade400.withOpacity(0.35),
              width: 1,
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.brown.shade800.withOpacity(0.2),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼 Gambar Menu
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    children: [
                      Image.network(
                        menu.imageUrl.isNotEmpty
                            ? menu.imageUrl
                            : 'https://picsum.photos/200',
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.25),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 🔹 Nama & Harga
                Text(
                  menu.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${menu.price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Color(0xFFD2A679),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),

                const Spacer(),

                // 🔸 Tombol bawah
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 4, right: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 🔹 Tombol + -
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: Colors.white70),
                            onPressed: () => Provider.of<CartProvider>(context, listen: false)
                                .removeItem(menu),
                          ),
                          Text(
                            count.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline,
                                color: Colors.white70),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addItem(menu);
                              widget.onAddToCart?.call(); // 🔔 Trigger animasi SnackBar & pop
                            },
                          ),
                        ],
                      ),

                      // 🔹 Tombol Detail
                      ElevatedButton(
                        onPressed: () => _showDetail(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5E3C),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          elevation: 4,
                          shadowColor: Colors.brown.shade300.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Detail",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
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

  // 🟤 BottomSheet Detail Menu
  void _showDetail(BuildContext context) {
    int qty = 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.85,
            minChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF3A2314),
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
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Rp ${widget.menu.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD2A679),
                          fontFamily: 'Poppins',
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
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🔸 Jumlah + -
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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

                      // 🔸 Tombol Tambah ke Keranjang
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .addItemWithQuantity(widget.menu, qty);
                            Navigator.pop(ctx);
                            widget.onAddToCart?.call(); // 🔔 trigger animasi pop-scale
                          },
                          icon: const Icon(Icons.shopping_cart_outlined, size: 22),
                          label: const Text(
                            "Tambah ke Keranjang",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5E3C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 5,
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
        });
      },
    );
  }
}
