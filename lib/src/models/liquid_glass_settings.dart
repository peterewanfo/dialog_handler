import 'package:flutter/material.dart';

/// Appearance of the liquid glass surface drawn behind a dialog body when
/// `enableLiquidGlass` is true.
///
/// [borderRadius] shape of the glass surface. For a bottomSheetDialog you will
/// usually want only the top corners rounded, e.g.
/// `BorderRadius.vertical(top: Radius.circular(28))`
///
/// [blur] sigma of the backdrop blur, higher values give a frostier glass
///
/// [saturation] saturation multiplier applied to the blurred backdrop, values
/// above 1 make colours behind the glass more vivid. Use 1 to disable
///
/// [tintColor] translucent colour laid over the blurred backdrop
///
/// [borderWidth] width of the specular rim around the glass edge
///
/// [highlightOpacity] strength of the rim light and surface sheen, from 0 to 1
///
/// [lightSource] direction the light hits the glass from. The rim is brightest
/// on this side and catches a softer refraction on the opposite side
///
/// [shadows] drop shadows painted outside the glass only, so they never darken
/// what is seen through it
///
@immutable
class LiquidGlassSettings {
  final BorderRadiusGeometry borderRadius;
  final double blur;
  final double saturation;
  final Color tintColor;
  final double borderWidth;
  final double highlightOpacity;
  final Alignment lightSource;
  final List<BoxShadow> shadows;

  const LiquidGlassSettings({
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blur = 18,
    this.saturation = 1.6,
    this.tintColor = const Color(0x1FFFFFFF),
    this.borderWidth = 1.2,
    this.highlightOpacity = 0.6,
    this.lightSource = Alignment.topLeft,
    this.shadows = const [
      BoxShadow(
        color: Color(0x26000000),
        blurRadius: 30,
        offset: Offset(0, 12),
      ),
    ],
  })  : assert(blur >= 0),
        assert(saturation >= 0),
        assert(borderWidth >= 0),
        assert(highlightOpacity >= 0 && highlightOpacity <= 1);

  LiquidGlassSettings copyWith({
    BorderRadiusGeometry? borderRadius,
    double? blur,
    double? saturation,
    Color? tintColor,
    double? borderWidth,
    double? highlightOpacity,
    Alignment? lightSource,
    List<BoxShadow>? shadows,
  }) {
    return LiquidGlassSettings(
      borderRadius: borderRadius ?? this.borderRadius,
      blur: blur ?? this.blur,
      saturation: saturation ?? this.saturation,
      tintColor: tintColor ?? this.tintColor,
      borderWidth: borderWidth ?? this.borderWidth,
      highlightOpacity: highlightOpacity ?? this.highlightOpacity,
      lightSource: lightSource ?? this.lightSource,
      shadows: shadows ?? this.shadows,
    );
  }
}
