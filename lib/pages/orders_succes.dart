import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/menu_model.dart';
// import 'home_page.dart';
// import 'history_page.dart';
import '../main.dart'; // akses MainPage dari main.dart
import '../utils/page_transition.dart';

class OrderSuccessPage extends StatelessWidget {
  final int orderId;
  final double totalPrice;
  final Map<Menu, int> items;
  final String paymentMethod;

  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.totalPrice,
    required this.items,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          "Pesanan Berhasil",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF9CCB86), size: 100),
            const SizedBox(height: 18),
            const Text(
              "Pesanan Kamu Berhasil 🎉",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Terima kasih telah memesan di 3awan Café Resto!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // 🔹 Detail pesanan
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("No. Pesanan: #ORD$orderId",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text("Tanggal: $date",
                      style: const TextStyle(color: Colors.white70)),
                  const Divider(color: Colors.white24, height: 20),

                  const Text("Detail Pesanan:",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 8),

                  ...items.entries.map((e) {
                    final menu = e.key;
                    final qty = e.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text("${menu.name} x$qty",
                                  style:
                                      const TextStyle(color: Colors.white70))),
                          Text(
                            "Rp ${(menu.price * qty).toStringAsFixed(0)}",
                            style: const TextStyle(color: Color(0xFFD6A86A)),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Bayar:",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text("Rp ${totalPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD6A86A))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("Metode Pembayaran: $paymentMethod",
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const Spacer(),

            // 🔹 Tombol navigasi bawah
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransitionHelper.fadeSlide(
                          const MainPage(initialIndex: 0), // Home tab
                        ),
                      );
                    },
                    icon: const Icon(Icons.home, color: Colors.white),
                    label: const Text("Kembali ke Home"),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransitionHelper.fadeSlide(
                          const MainPage(initialIndex: 2), // History tab
                        ),
                      );
                    },
                    icon: const Icon(Icons.receipt_long),
                    label: const Text("Lihat Riwayat"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
