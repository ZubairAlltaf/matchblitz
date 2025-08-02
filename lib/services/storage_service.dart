import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // --- Keys for storing data ---
  static const String _highScoreKey = 'highScore';
  static const String _savedLevelKey = 'savedLevel';
  static const String _savedScoreKey = 'savedScore';
  static const String _onboardingKey = 'hasSeenOnboarding'; // ✅ ADDED

  // --- High Score Methods ---
  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<void> setHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHighScore = await getHighScore();
    if (score > currentHighScore) {
      await prefs.setInt(_highScoreKey, score);
    }
  }

  // --- Saved Game Methods ---
  Future<int> getSavedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_savedLevelKey) ?? 1;
  }

  Future<void> setSavedLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_savedLevelKey, level.clamp(1, 9999));
  }

  Future<int> getSavedScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_savedScoreKey) ?? 0;
  }

  Future<void> setSavedScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_savedScoreKey, score.clamp(0, 999999));
  }

  // --- ✅ ADDED: Onboarding Methods ---

  /// Checks if the user has seen the onboarding screens before.
  /// Defaults to false.
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  /// Sets the flag indicating the user has completed the onboarding flow.
  Future<void> setHasSeenOnboarding(bool hasSeen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, hasSeen);
  }
}
