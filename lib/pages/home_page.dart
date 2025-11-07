  // lib/pages/home_page.dart
  import 'package:flutter/material.dart';
  import 'package:carousel_slider/carousel_slider.dart';
  import 'package:provider/provider.dart';
  import '../models/menu_model.dart';
  import '../services/api_service.dart';
  import '../pages/widgets/menu_card.dart';
  import '../providers/cart_provider.dart';
  import '../pages/cart_page.dart';
  import '../utils/page_transition.dart';
  import 'package:shimmer/shimmer.dart';


  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
    final ApiService _api = ApiService();
    late Future<List<Menu>> _futureMenus;
    String _search = '';
    String _selectedCategory = "Semua";
    int _currentBanner = 0;

    // 🔹 Animasi scale untuk ikon keranjang
    late AnimationController _animController;
    late Animation<double> _scaleAnim;

    final List<String> categories = [
      "Semua",
      "Coffee",
      "Makanan",
      "Non Coffee",
    ];

    final List<String> bannerImages = [
      'assets/images/banner1.jpeg',
      'assets/images/banner2.jpeg',
      'assets/images/banner3.jpeg',
    ];

    @override
    void initState() {
      super.initState();
      _futureMenus = _api.fetchMenus();

      _animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );

      _scaleAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
      );
    }

    @override
    void dispose() {
      _animController.dispose();
      super.dispose();
    }

    void _refresh() {
      setState(() {
        _futureMenus = _api.fetchMenus(
          category: _selectedCategory == "Semua" ? null : _selectedCategory,
          search: _search.isEmpty ? null : _search,
        );
      });
    }

    void _showAddSnack(BuildContext context, String menuName) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("‘$menuName’ ditambahkan ke keranjang 🛒"),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.brown.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    void _triggerCartAnim() {
      if (_animController.isAnimating) return;
      _animController.forward().then((_) => _animController.reverse());
    }

    @override
    Widget build(BuildContext context) {
      final cart = Provider.of<CartProvider>(context);

      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A120B), Color(0xFF3E2723)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => _refresh(),
              color: Colors.brown.shade400,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      const Text(
                        "Selamat Datang di 3awan Café ☕",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Nikmati kopi dan hidangan terbaik hari ini 🍰",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 🔍 Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white24, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Cari menu favoritmu...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: const Icon(Icons.search, color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          onChanged: (v) {
                            _search = v;
                            _refresh();
                          },
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 🔖 Category Chips
                      SizedBox(
                        height: 46,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final c = categories[index];
                            final selected = c == _selectedCategory;
                            return ChoiceChip(
                              label: Text(c),
                              selected: selected,
                              onSelected: (_) {
                                setState(() => _selectedCategory = c);
                                _refresh();
                              },
                              selectedColor: Colors.brown.shade400,
                              backgroundColor: Colors.white10,
                              labelStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: selected ? Colors.white : Colors.white70,
                                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🌟 Promo Box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade400.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.local_offer_rounded, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Promo Spesial: Diskon 20% untuk menu kopi hari ini!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🖼 Banner Carousel
                      Column(
                        children: [
                          CarouselSlider(
                            items: bannerImages.map((imgPath) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(imgPath, fit: BoxFit.cover),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.3),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 160,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.9,
                              autoPlayInterval: const Duration(seconds: 4),
                              onPageChanged: (index, reason) {
                                setState(() => _currentBanner = index);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: bannerImages.asMap().entries.map((entry) {
                              final isActive = entry.key == _currentBanner;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: isActive ? 10 : 6,
                                height: isActive ? 10 : 6,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.brown.shade400
                                      : Colors.white24,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // 🧾 Section Title
                      Row(
                        children: [
                          Container(
                              width: 6, height: 24, color: Colors.brown.shade400),
                          const SizedBox(width: 8),
                          const Text(
                            "Menu Hari Ini",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 🍽 Menu Grid
                      FutureBuilder<List<Menu>>(
                        future: _futureMenus,
                        builder: (context, snapshot) {                       
                            if (snapshot.connectionState == ConnectionState.waiting) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 280,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: 6, // jumlah shimmer placeholder
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.white.withOpacity(0.15),
                                  highlightColor: Colors.white.withOpacity(0.3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.white24, width: 0.8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 🔸 Gambar shimmer
                                        Container(
                                          height: 140,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                            color: Colors.white12,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        
                                        // 🔸 Nama menu shimmer
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Container(
                                            height: 16,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // 🔸 Harga shimmer
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Container(
                                            height: 14,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),

                                        // 🔸 Tombol “Tambah” shimmer
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Container(
                                            height: 36,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}",
                                  style: const TextStyle(color: Colors.redAccent)),
                            );
                          }

                          final menus = snapshot.data ?? [];
                          if (menus.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text("Menu tidak ditemukan 😔",
                                    style: TextStyle(color: Colors.white70)),
                              ),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 280,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: menus.length,
                            itemBuilder: (context, index) {
                              return MenuCard(
                                menu: menus[index],
                                onAddToCart: () {
                                  _triggerCartAnim();
                                  _showAddSnack(context, menus[index].name);
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // 🛒 Floating Cart Button (tidak ketutup nav bar)
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: ScaleTransition(
            scale: _scaleAnim,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF8B5E3C),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransitionHelper.fadeSlide(const CartPage()),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 28, color: Colors.white),
                  if (cart.totalItems > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart.totalItems.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
