import 'package:flutter/material.dart';
import 'package:triawan_cafe_resto_app/main.dart';


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      "image": "assets/images/onboard1.png",
      "title": "Selamat Datang di 3awan Café Resto ☕",
      "desc": "Nikmati kemudahan memesan makanan dan minuman favoritmu secara digital.",
    },
    {
      "image": "assets/images/onboard2.png",
      "title": "Pesan Cepat, Tanpa Ribet 🍰",
      "desc": "Pilih menu, atur pesanan, dan nikmati tanpa antre.",
    },
    {
      "image": "assets/images/onboard3.png",
      "title": "Temukan Rasa Baru Setiap Hari 💫",
      "desc": "Jelajahi berbagai menu spesial dari kami.",
    },
  ];

  void _nextPage() {
    if (_currentIndex < _slides.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    } else {
      _goToHome();
    }
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainPage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextButton(
                  onPressed: _goToHome,
                  child: const Text("Lewati",
                      style: TextStyle(color: Colors.white70)),
                ),
              ),
            ),

            // 🔹 PageView Slides
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemCount: _slides.length,
                itemBuilder: (context, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            slide["image"]!,
                            height: 260,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          slide["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide["desc"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white70, height: 1.5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 🔹 Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.brown.shade400
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 Next / Mulai Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _currentIndex == _slides.length - 1
                        ? "Mulai Sekarang"
                        : "Lanjut",
                    style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
