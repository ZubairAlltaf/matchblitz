import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import 'game_screen.dart';
import 'main_menu_screen.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use 'read' to get the final scores without listening for further changes.
    final provider = context.read<GameStateProvider>();

    return Scaffold(
      // UI: Matching the game's "Blueprint" theme
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Game Over Title ---
            Text(
              'Game Over',
              style: GoogleFonts.sourceCodePro(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE94560), // Use an accent color for impact
              ),
            ).animate().fadeIn(duration: 1.seconds).shake(),
            const SizedBox(height: 40),

            // --- Score Display ---
            _InfoDisplay(label: 'Your Score', value: provider.score.toString()),
            const SizedBox(height: 20),
            _InfoDisplay(label: 'High Score', value: provider.highScore.toString()),
            const SizedBox(height: 60),

            // --- Action Buttons ---
            _ActionButton(
              text: 'Replay',
              onTap: () {
                // ✅ FIXED: This now calls 'continueFromSave' which loads the state
                // from the beginning of the level the player just failed on.
                Provider.of<GameStateProvider>(context, listen: false).continueFromSave();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                );
              },
              isPrimary: true,
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5),
            const SizedBox(height: 20),

            _ActionButton(
              text: 'Back to Menu',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainMenuScreen()),
                );
              },
              isPrimary: false,
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
          ],
        ),
      ),
    );
  }
}

// --- Custom UI Widgets for the Blueprint Theme (reused from Main Menu) ---

class _InfoDisplay extends StatelessWidget {
  final String label;
  final String value;

  const _InfoDisplay({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.sourceCodePro(
            fontSize: 16,
            color: Colors.white70,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.sourceCodePro(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.text,
    required this.onTap,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF00E5FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isPrimary ? Colors.transparent : Colors.white54,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.sourceCodePro(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isPrimary ? const Color(0xFF0D1B2A) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
