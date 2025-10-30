import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();

    // 🔹 Jalankan animasi awal (fade & zoom)
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });

    // 🔹 Pindah ke onboarding setelah animasi selesai
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingPage(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 900),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutBack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔸 Ganti ini dengan logo kamu
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                      color: Colors.brown.shade300.withValues(alpha: 0.7),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/images/onboard1.png', // 🔹 Ganti sesuai lokasi logo kamu
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  "3AwanOrder",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Coffee • Food • Relax",
                  style: TextStyle(
                    color: Colors.brown.shade300.withValues(alpha: 0.8),
                    letterSpacing: 1.4,
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
