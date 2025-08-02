import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import '../../models/tile_model.dart';
import '../icon_match_game.dart';

class TileComponent extends RectangleComponent with TapCallbacks {
  final TileModel model;
  bool _isFlipping = false;

  TileComponent({required this.model, required Vector2 position, required Vector2 size})
      : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    paint: Paint()..color = const Color(0xFF4A4E69), // Start with the back color
  );

  @override
  void render(Canvas canvas) {
    // We override the default render method to draw a rounded rectangle
    // using the component's own 'paint' property.
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      paint,
    );

    // Render the icon if the tile is flipped and not matched
    if (model.isFlipped && !model.isMatched) {
      // ✅ FIXED: This section is now simplified to render the emoji string.
      final textStyle = TextStyle(
        fontSize: size.x * 0.6,
        // We don't need a specific font family; the default font handles emojis.
      );
      // We pass the emoji string directly to the TextSpan.
      final textSpan = TextSpan(text: model.icon, style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();

      final offset = (size - textPainter.size.toVector2()) / 2;
      textPainter.paint(canvas, offset.toOffset());
    }
  }

  void flip() {
    if (_isFlipping) return;
    _isFlipping = true;

    // This logic remains the same. It changes the component's paint color,
    // which our new render method will use automatically.
    final newColor = model.isFlipped ? const Color(0xFF4A4E69) : const Color(0xFF9A8C98);

    add(ScaleEffect.to(
      Vector2(0, 1),
      EffectController(duration: 0.2, curve: Curves.easeIn),
      onComplete: () {
        model.isFlipped = !model.isFlipped;
        paint.color = newColor; // Change the color when it's "flipped"
        add(ScaleEffect.to(
          Vector2(1, 1),
          EffectController(duration: 0.2, curve: Curves.easeOut),
          onComplete: () => _isFlipping = false,
        ));
      },
    ));
  }

  void onMatch() {
    model.isMatched = true;
    // OpacityEffect now works correctly because RectangleComponent supports it.
    add(OpacityEffect.to(0, EffectController(duration: 0.4)));
    add(ScaleEffect.to(Vector2.all(0), EffectController(duration: 0.4)));
  }

  @override
  void onTapDown(TapDownEvent event) {
    (parent as IconMatchGame).onTileTapped(model.id);
  }
}
