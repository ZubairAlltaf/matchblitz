import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tile_model.dart';
import '../providers/game_state_provider.dart';
import 'components/tile_component.dart';

class IconMatchGame extends FlameGame {
  final BuildContext context;
  late final GameStateProvider provider;
  List<TileComponent> tiles = [];
  List<int> _flippedTileIds = [];
  int _internalLevelTracker = -1;

  IconMatchGame(this.context) {
    provider = Provider.of<GameStateProvider>(context, listen: false);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    provider.addListener(_onProviderChange);
    _initializeLevel();
  }

  @override
  void onRemove() {
    provider.removeListener(_onProviderChange);
    super.onRemove();
  }

  void _onProviderChange() {
    if (provider.level != _internalLevelTracker && provider.isGameActive && !provider.isLevelComplete) {
      _initializeLevel();
    }
  }

  void _initializeLevel() {
    _internalLevelTracker = provider.level;

    children.whereType<TileComponent>().forEach(remove);
    tiles.clear();
    _flippedTileIds.clear();

    final totalTiles = provider.currentLevelIcons.length;
    final cols = (totalTiles / 4).ceil().clamp(3, 5);
    final rows = (totalTiles / cols).ceil();

    // ✅ FIXED: The layout calculation is now aware of the header.
    const double headerHeight = 80.0; // Approximate height of the top UI bar
    final availableWidth = size.x * 0.95;
    final availableHeight = size.y - headerHeight; // Calculate space *below* the header

    // Ensure tile size is calculated based on the more constrained dimension
    final tileWidth = availableWidth / cols;
    final tileHeight = availableHeight / rows;
    final tileSize = tileWidth < tileHeight ? tileWidth : tileHeight;

    final totalGridWidth = cols * tileSize;
    final totalGridHeight = rows * tileSize;
    final offsetX = (size.x - totalGridWidth) / 2;
    // The vertical offset now starts below the header area
    final offsetY = ((availableHeight - totalGridHeight) / 2) + headerHeight;


    for (int i = 0; i < totalTiles; i++) {
      final row = i ~/ cols;
      final col = i % cols;
      final tile = TileComponent(
        model: TileModel(icon: provider.currentLevelIcons[i], id: i),
        position: Vector2(
          offsetX + col * tileSize + tileSize / 2,
          offsetY + row * tileSize + tileSize / 2,
        ),
        size: Vector2.all(tileSize * 0.9),
      );
      tiles.add(tile);
      add(tile);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!provider.isGameActive || provider.isLevelComplete) return;

    final allMatched = tiles.every((tile) => tile.model.isMatched);
    if (allMatched && tiles.isNotEmpty) {
      provider.levelCompleted();
    }
  }

  void onTileTapped(int tileId) {
    if (!provider.isGameActive || provider.isChecking || tileId >= tiles.length || provider.isLevelComplete) return;

    final tile = tiles[tileId];
    if (tile.model.isFlipped || tile.model.isMatched) return;

    tile.flip();
    _flippedTileIds.add(tileId);

    if (_flippedTileIds.length == 2) {
      provider.setChecking(true);

      final firstId = _flippedTileIds[0];
      final secondId = _flippedTileIds[1];
      final firstTile = tiles[firstId];
      final secondTile = tiles[secondId];

      if (firstTile.model.icon == secondTile.model.icon) {
        provider.onCorrectMatch();
        Future.delayed(const Duration(milliseconds: 400), () {
          firstTile.onMatch();
          secondTile.onMatch();
          provider.setChecking(false);
        });
      } else {
        provider.onWrongMatch();
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!firstTile.model.isMatched) firstTile.flip();
          if (!secondTile.model.isMatched) secondTile.flip();
          provider.setChecking(false);
        });
      }
      _flippedTileIds.clear();
    }
  }
}
