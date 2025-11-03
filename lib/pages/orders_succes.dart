import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/menu_model.dart';
import '../main.dart';
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
      backgroundColor: const Color(0xFF2B1B12),
      appBar: AppBar(
        title: const Text(
          "Pesanan Berhasil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3A2314),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // ✅ Ikon sukses
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.15),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                ),
                padding: const EdgeInsets.all(25),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.greenAccent,
                  size: 80,
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Pesanan Kamu Berhasil 🎉",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
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

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A2314),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("No. Pesanan: #ORD$orderId",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    Text("Tanggal: $date",
                        style: const TextStyle(color: Colors.white70)),
                    const Divider(color: Colors.white24, height: 20),
                    const Text("Detail Pesanan:",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    const SizedBox(height: 8),

                    if (items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Tidak ada item dalam pesanan.",
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    else
                      ...items.entries.map((e) {
                        final menu = e.key;
                        final qty = e.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text("${menu.name} x$qty",
                                    style:
                                        const TextStyle(color: Colors.white70)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Rp ${(menu.price * qty).toStringAsFixed(0)}",
                                style: const TextStyle(color: Color(0xFFD6A86A)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

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
                    const SizedBox(height: 8),
                    Text("Metode Pembayaran: $paymentMethod",
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Tombol bawah
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransitionHelper.fadeSlide(
                            const MainPage(initialIndex: 0),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                            const MainPage(initialIndex: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long),
                      label: const Text("Lihat Riwayat"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5E3C),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
