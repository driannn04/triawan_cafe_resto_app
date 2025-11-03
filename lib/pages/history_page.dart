import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'dart:io';

class HistoryPage extends StatefulWidget {
  final bool showBackButton;
  const HistoryPage({super.key, this.showBackButton = false});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = ApiService().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B1B12),
      appBar: AppBar(
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3A2314),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD6A86A)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan: ${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada riwayat pesanan ☕",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final order = orders[i];
              DateTime? parsedDate;
              try {
                parsedDate = DateTime.parse(order['created_at']);
              } catch (e) {
                parsedDate = HttpDate.parse(order['created_at']);
              }

              final date =
                  DateFormat('dd MMM yyyy, HH:mm').format(parsedDate.toLocal());
              final total = order["total_price"] ?? 0;
              final customer = order["customer_name"] ?? "Pelanggan";

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3A2314),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.brown.shade400.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.brown.shade600,
                            Colors.brown.shade300,
                          ],
                        ),
                      ),
                      child: const Icon(Icons.receipt_long,
                          color: Colors.white, size: 26),
                    ),
                  ),
                  title: Text(
                    "Pesanan #${order["id"]}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customer,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Poppins')),
                      const SizedBox(height: 4),
                      Text(date,
                          style: const TextStyle(
                              color: Colors.white38,
                              fontFamily: 'Poppins')),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rp ${total.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Color(0xFFD6A86A),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Text("Selesai",
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
