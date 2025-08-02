import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';
import 'main_menu_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextScreen();
  }

  Future<void> _decideNextScreen() async {
    final storage = StorageService();
    final hasSeenOnboarding = await storage.hasSeenOnboarding();

    // Wait for the animation to have some impact
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => hasSeenOnboarding
              ? const MainMenuScreen()
              : const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A large, friendly emoji to greet the user
            Text(
              '�',
              style: TextStyle(fontSize: 80),
            )
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 2.seconds, color: const Color(0xFF00E5FF))
                .animate() // chain animations
                .scale(duration: 1.seconds, curve: Curves.easeOutBack),

            const SizedBox(height: 20),
            Text(
              'Match Blitz',
              style: GoogleFonts.sourceCodePro(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fadeIn(duration: 1.seconds, delay: 500.ms),
          ],
        ),
      ),
    );
  }
}
