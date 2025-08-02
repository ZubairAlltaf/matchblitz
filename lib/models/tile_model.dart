import 'package:flutter/material.dart';

class TileModel {
  // ✅ FIXED: The model now correctly holds a String for the emoji.
  final String icon;
  final int id;
  bool isFlipped;
  bool isMatched;

  TileModel({
    required this.icon,
    required this.id,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
