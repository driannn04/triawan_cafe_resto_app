import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:triawan_cafe_resto_app/pages/splash_screen.dart';
import 'providers/cart_provider.dart';
import 'pages/home_page.dart';
import 'pages/cart_page.dart';
import 'pages/history_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '3awan Café Resto',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFF6F4E37), // coffee brown
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6F4E37), // utama
            secondary: Color(0xFFD7BFAE), // aksen lembut
            surface: Color(0xFF1E1E1E),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF000000),
            elevation: 3,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white70,
              fontFamily: 'Poppins',
            ),
            titleLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Poppins',
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F4E37),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final int initialIndex;
  const MainPage({super.key, this.initialIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // 🟤 pakai index dari parameter
  }

  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.brown.shade400,
        buttonBackgroundColor: Colors.brown.shade600,
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        items: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.shopping_cart, color: Colors.white, size: 30),
          Icon(Icons.receipt_long, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _pages[_selectedIndex],
    );
  }
}
