import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:emojis/emojis.dart'; // ✅ ADDED: Import for the emojis package
import '../services/storage_service.dart';

class GameStateProvider with ChangeNotifier {
  // --- Public State ---
  int level = 1;
  int score = 0;
  int timeLeft = 40;
  int highScore = 0;
  List<String> currentLevelIcons = [];
  bool isGameActive = false;
  bool isChecking = false;
  bool isLevelComplete = false;

  // --- Private State ---
  final StorageService _storageService = StorageService();
  Timer? _timer;

  GameStateProvider() {
    _loadHighScore();
  }

  // --- Game Flow Control (Functionality is unchanged) ---

  void startNewGame() {
    level = 1;
    score = 0;
    _startGameSession();
  }

  void continueFromSave() async {
    level = await _storageService.getSavedLevel();
    score = await _storageService.getSavedScore();
    _startGameSession();
  }

  void nextLevel() {
    level++;
    _startGameSession();
  }

  void _startGameSession() {
    timeLeft = (40 - (level * 2)).clamp(15, 40);
    isGameActive = true;
    isChecking = false;
    isLevelComplete = false;
    _generateIconsForLevel();
    _startTimer();
    _notify();
  }

  void levelCompleted() {
    isLevelComplete = true;
    _timer?.cancel();
    _notify();
  }

  Future<void> saveAndExit() async {
    if (isLevelComplete) {
      level++;
    }
    await _storageService.setSavedLevel(level);
    await _storageService.setSavedScore(score);
    isGameActive = false;
    _timer?.cancel();
  }

  // --- In-Game Actions (Functionality is unchanged) ---

  void onCorrectMatch() {
    score += 10;
    timeLeft = (timeLeft + 3).clamp(0, 999);
    _updateHighScore();
    _notify();
  }

  void onWrongMatch() {
    score = (score - 5).clamp(0, 999999);
    _notify();
  }

  void setChecking(bool value) {
    isChecking = value;
    _notify();
  }

  // --- Internal & Data ---

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0 && isGameActive && !isLevelComplete) {
        timeLeft--;
        _notify();
      } else if (isGameActive && !isLevelComplete) {
        isGameActive = false;
        _updateHighScore();
        timer.cancel();
        _notify();
      }
    });
  }

  void _generateIconsForLevel() {
    // ✅ CHANGED: Using a large pool of emojis from the 'emojis' package.
    // This list can be easily expanded.
    final iconPool = [
      Emojis.grinningFace, Emojis.smilingFaceWithHeartEyes, Emojis.faceWithTearsOfJoy,
      Emojis.winkingFace, Emojis.zanyFace, Emojis.partyingFace, Emojis.smilingFaceWithSunglasses,
      Emojis.nerdFace, Emojis.faceWithMonocle, Emojis.ghost, Emojis.alien, Emojis.robot,
      Emojis.glowingStar, Emojis.fire, Emojis.bomb, Emojis.gemStone, Emojis.crown,
      Emojis.redHeart, Emojis.dog, Emojis.cat, Emojis.lion, Emojis.tiger, Emojis.unicorn,
      Emojis.dragon, Emojis.pizza, Emojis.hamburger, Emojis.frenchFries, Emojis.hotDog,
      Emojis.iceCream, Emojis.doughnut, Emojis.birthdayCake, Emojis.soccerBall,
      Emojis.basketball, Emojis.americanFootball, Emojis.baseball, Emojis.tennis,
      Emojis.rocket, Emojis.jackOLantern, Emojis.videoGame, Emojis.joystick,
      Emojis.trophy, Emojis.guitar, Emojis.violin, Emojis.saxophone, Emojis.magicWand,
      Emojis.brain, Emojis.lightBulb, Emojis.magnifyingGlassTiltedLeft, Emojis.key,
      Emojis.locked, Emojis.unlocked, Emojis.books, Emojis.moneyBag, Emojis.bomb,
    ];

    final rows = (level / 2).floor() + 3;
    final cols = (level / 2).ceil() + 2;
    final pairCount = (rows * cols) ~/ 2;

    currentLevelIcons = [];
    // Ensure we don't request more pairs than we have unique emojis
    final uniqueIconsNeeded = pairCount.clamp(0, iconPool.length);

    for (int i = 0; i < uniqueIconsNeeded; i++) {
      final icon = iconPool[i];
      currentLevelIcons.addAll([icon, icon]);
    }
    currentLevelIcons.shuffle();
  }

  Future<void> _loadHighScore() async {
    highScore = await _storageService.getHighScore();
    _notify();
  }

  Future<void> _updateHighScore() async {
    if (score > highScore) {
      highScore = score;
      await _storageService.setHighScore(highScore);
    }
  }

  void _notify() {
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      notifyListeners();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
