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
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: widget.showBackButton,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator(color: Color(0xFFD6A86A)));
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
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.brown.shade400,
                    child:
                        const Icon(Icons.receipt_long, color: Colors.white70),
                  ),
                  title: Text(
                    "Pesanan #${order["id"]}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customer,
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text(date, style: const TextStyle(color: Colors.white38)),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rp ${total.toStringAsFixed(0)}",
                        style: const TextStyle(
                            color: Color(0xFFD6A86A),
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Selesai",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
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
