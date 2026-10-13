import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _escala;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _escala = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primario,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _escala,
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: AppTheme.acento,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Sabor Casero',
              style: TextStyle(
                color: AppTheme.texto,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cocina fácil y barata, lejos de casa',
              style: TextStyle(color: AppTheme.texto, fontSize: 15),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: AppTheme.texto,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
