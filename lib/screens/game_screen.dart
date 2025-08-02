import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../game/icon_match_game.dart';
import '../providers/game_state_provider.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final IconMatchGame _game;

  @override
  void initState() {
    super.initState();
    _game = IconMatchGame(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameStateProvider>();

    if (!provider.isGameActive && provider.timeLeft <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const GameOverScreen()),
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // Main background color
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ✅ UI: Header now has its own container for better visual separation.
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B263B).withOpacity(0.5), // Slightly different background
                    border: Border(
                      bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Score: ${provider.score}', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('Level: ${provider.level}', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('Time: ${provider.timeLeft}s', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: GameWidget(game: _game),
                ),
              ],
            ),
            if (provider.isLevelComplete)
              _LevelCompleteOverlay(),
          ],
        ),
      ),
    );
  }
}

class _LevelCompleteOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<GameStateProvider>();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Level ${provider.level} Complete!',
                style: GoogleFonts.russoOne(fontSize: 32, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Consumer<GameStateProvider>(
                builder: (context, p, _) => Text(
                  'Score: ${p.score}',
                  style: GoogleFonts.poppins(fontSize: 24, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () {
                  provider.nextLevel();
                },
                child: const Text('Next Level', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await provider.saveAndExit();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Save & Exit to Menu',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
