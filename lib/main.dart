import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matchblitz/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/game_state_provider.dart';

void main() {
  runApp(const IconMatchBlitzApp());
}

class IconMatchBlitzApp extends StatelessWidget {
  const IconMatchBlitzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameStateProvider(),
      child: MaterialApp(
        title: 'Icon Match Blitz',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // Set the main font to match the game's aesthetic
          textTheme: GoogleFonts.sourceCodeProTextTheme(),
        ),
        // ✅ CHANGED: The app now starts with the SplashScreen
        home:  SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
