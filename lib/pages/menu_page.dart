import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/menu_model.dart';
// import '../providers/cart_provider.dart';
import '../pages/widgets/menu_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<Menu>> _menus;

  @override
  void initState() {
    super.initState();
    _menus = ApiService().fetchMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("3awan Cafe Resto"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Menu>>(
        future: _menus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final menus = snapshot.data ?? [];
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 260,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: menus.length,
            itemBuilder: (context, index) {
              return MenuCard(menu: menus[index]);
            },
          );
        },
      ),
    );
  }
}
