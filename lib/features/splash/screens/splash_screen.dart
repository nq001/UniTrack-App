import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Fade: 0 → 1
  late Animation<double> _fadeAnimation;

  // Scale: 0.85 → 1.0
  late Animation<double> _scaleAnimation;

  // Slide: slight upward drift (optional, subtle)
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Make status bar transparent for a full-screen feel
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Fade in over the full animation duration
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Scale 0.85 → 1.0 with an overshoot feel
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // Subtle upward slide (starts 20px below, ends at centre)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animation immediately
    _controller.forward();

    // After 3 seconds total, navigate to Home
    Future.delayed(const Duration(seconds: 3), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Clean, very light gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF), // pure white
              Color(0xFFF0F0FA), // very faint lavender
              Color(0xFFEAEAF8), // slightly deeper
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Never wider than 80% of screen, never taller than 60%
                    maxWidth: size.width * 0.80,
                    maxHeight: size.height * 0.60,
                  ),
                  child: Image.asset(
                    'assets/images/unitrack_splash.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
