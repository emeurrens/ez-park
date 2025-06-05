import 'dart:ui' show Color;

///
/// Color palette implementing primary, secondary, and neutral colors based off
/// of the UF Brand Center's guidelines (https://brandcenter.ufl.edu/colors/)
///
/// Primary Colors:
///   - orange
///   - blue
///
/// Secondary Colors:
///   - bottlebrush (red)
///   - alachua (yellow)
///   - gator (green)
///   - darkBlue
///   - perennial (purple)
///
/// Neutral Colors:
///   - black
///   - coolGray11 (dark grey)
///   - coolGray3 (light grey with cooler tone)
///   - warmGray1 (light grey with warmer tone)
///   - white
///
class ColorPalette {
  // Primary Colors
  static const orange = Color(0xFFFA4616);
  static const blue = Color(0xFF0021A5);

  // Secondary Colors
  static const bottlebrush = Color(0xFFD32737);
  static const alachua = Color(0xFFF2A900);
  static const gator = Color(0xFF22884C);
  static const darkBlue = Color(0xFF002657);
  static const perennial = Color(0xFF6A2A60);

  // Neutral Colors
  static const black = Color(0xFF000000);
  static const coolGray11 = Color(0xFF343741);
  static const coolGray3 = Color(0xFFC7C9C8);
  static const warmGray1 = Color(0xFFD8D4D7);
  static const white = Color(0xFFFFFFFF);
}