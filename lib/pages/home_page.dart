import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import '../services/api_service.dart';
import '../pages/widgets/menu_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService();
  late Future<List<Menu>> _futureMenus;
  String _search = '';
  String _selectedCategory = "Semua";
  int _currentBanner = 0;

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
  }

  void _refresh() {
    setState(() {
      _futureMenus = _api.fetchMenus(
        category: _selectedCategory == "Semua" ? null : _selectedCategory,
        search: _search.isEmpty ? null : _search,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          "3awan Cafe Resto",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refresh,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _refresh(),
          color: Colors.brown.shade400,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // 🔹 Header
                  const Text(
                    "Temukan Menu Favoritmu ☕",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 🔹 Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Cari menu...',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.6)),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onChanged: (v) {
                        _search = v;
                        _refresh();
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Category Chips
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
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Banner Carousel
                  Column(
                    children: [
                      CarouselSlider(
                        items: bannerImages.map((imgPath) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  imgPath,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.3),
                                        Colors.transparent
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
                            setState(() {
                              _currentBanner = index;
                            });
                          },
                        ),
                      ),

                      // 🔹 Dot Indicator
                      const SizedBox(height: 10),
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

                  const SizedBox(height: 28),

                  // 🔹 Menu Grid
                  FutureBuilder<List<Menu>>(
                    future: _futureMenus,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(50),
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.brown)),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        );
                      }

                      final menus = snapshot.data ?? [];
                      if (menus.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "Menu tidak ditemukan 😔",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 280,
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

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
