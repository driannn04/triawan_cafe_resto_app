import 'package:flutter/material.dart';

class PageTransitionHelper {
  static Route fadeSlide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(0.0, 0.1); // sedikit dari bawah
        const end = Offset.zero;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
