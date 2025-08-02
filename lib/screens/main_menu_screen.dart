import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/game_state_provider.dart';
import 'game_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _savedLevel = 1;
  int _savedScore = 0;
  bool _hasSavedGame = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Functionality is unchanged
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _savedLevel = prefs.getInt('savedLevel') ?? 1;
      _savedScore = prefs.getInt('savedScore') ?? 0;
      _hasSavedGame = _savedLevel > 1 || _savedScore > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ UI: Matching the game's "Blueprint" theme
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Title ---
            Text(
              'Match Blitz',
              style: GoogleFonts.sourceCodePro(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fadeIn(duration: 1.seconds).slideY(begin: -0.2),
            const SizedBox(height: 30),

            // --- High Score ---
            Consumer<GameStateProvider>(
              builder: (context, provider, _) => _InfoDisplay(
                label: 'High Score',
                value: provider.highScore.toString(),
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 50),

            // --- Action Buttons ---
            _ActionButton(
              text: 'New Game',
              onTap: () {
                Provider.of<GameStateProvider>(context, listen: false).startNewGame();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                ).then((_) => _loadSavedData());
              },
            ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.5),
            const SizedBox(height: 20),

            // --- Conditional Continue Button ---
            if (_hasSavedGame)
              Column(
                children: [
                  _ActionButton(
                    text: 'Continue',
                    onTap: () {
                      Provider.of<GameStateProvider>(context, listen: false).continueFromSave();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GameScreen()),
                      ).then((_) => _loadSavedData());
                    },
                    isPrimary: false, // Use secondary style
                  ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.5),
                  const SizedBox(height: 10),
                  Text(
                    'Saved: Level $_savedLevel - Score $_savedScore',
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 16,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// --- Custom UI Widgets for the Blueprint Theme ---

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
            color: const Color(0xFF00E5FF),
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
