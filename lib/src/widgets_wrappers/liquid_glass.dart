import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/liquid_glass_settings.dart';

/// Wraps [child] in a liquid glass surface: a blurred and saturated backdrop,
/// a translucent tint, a soft surface sheen and a specular rim.
///
/// Used by `DialogManager` when a dialog is shown with `enableLiquidGlass`,
/// and can also be used on its own. The glass only shows through where [child]
/// is transparent, so give dialog bodies no opaque background colour.
class LiquidGlass extends StatelessWidget {
  final Widget child;
  final LiquidGlassSettings settings;

  const LiquidGlass({
    super.key,
    required this.child,
    this.settings = const LiquidGlassSettings(),
  });

  ui.ImageFilter _backdropFilter() {
    final ui.ImageFilter blur = ui.ImageFilter.blur(
      sigmaX: settings.blur,
      sigmaY: settings.blur,
    );
    if (settings.saturation == 1) return blur;

    return ui.ImageFilter.compose(
      outer: ColorFilter.matrix(_saturationMatrix(settings.saturation)),
      inner: blur,
    );
  }

  /// Colour matrix scaling saturation around Rec. 709 luminance
  static List<double> _saturationMatrix(double s) {
    const double r = 0.2126, g = 0.7152, b = 0.0722;
    final double i = 1 - s;
    return <double>[
      r * i + s, g * i, b * i, 0, 0, //
      r * i, g * i + s, b * i, 0, 0, //
      r * i, g * i, b * i + s, 0, 0, //
      0, 0, 0, 1, 0, //
    ];
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius =
        settings.borderRadius.resolve(Directionality.maybeOf(context));

    return CustomPaint(
      painter: _GlassShadowPainter(
        borderRadius: borderRadius,
        shadows: settings.shadows,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: _backdropFilter(),
          child: CustomPaint(
            painter: _GlassBodyPainter(
              borderRadius: borderRadius,
              settings: settings,
            ),
            foregroundPainter: _GlassRimPainter(
              borderRadius: borderRadius,
              settings: settings,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Paints drop shadows outside the glass shape only
class _GlassShadowPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;

  _GlassShadowPainter({required this.borderRadius, required this.shadows});

  @override
  void paint(Canvas canvas, Size size) {
    if (shadows.isEmpty) return;

    final RRect shape = borderRadius.toRRect(Offset.zero & size);
    final double reach = shadows
        .map((s) => s.blurRadius * 2 + s.spreadRadius + s.offset.distance)
        .reduce((a, b) => a > b ? a : b);

    canvas.save();
    canvas.clipPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect((Offset.zero & size).inflate(reach))
        ..addRRect(shape),
    );
    for (final BoxShadow shadow in shadows) {
      canvas.drawRRect(
        shape.shift(shadow.offset).inflate(shadow.spreadRadius),
        shadow.toPaint(),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GlassShadowPainter old) =>
      old.borderRadius != borderRadius || old.shadows != shadows;
}

/// Paints the tint and the diagonal sheen behind the dialog body
class _GlassBodyPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final LiquidGlassSettings settings;

  _GlassBodyPainter({required this.borderRadius, required this.settings});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect shape = borderRadius.toRRect(rect);

    canvas.drawRRect(shape, Paint()..color = settings.tintColor);

    final double sheen = settings.highlightOpacity * 0.35;
    canvas.drawRRect(
      shape,
      Paint()
        ..shader = LinearGradient(
          begin: settings.lightSource,
          end: -settings.lightSource,
          colors: [
            Colors.white.withValues(alpha: sheen),
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: sheen * 0.4),
          ],
          stops: const [0, 0.45, 0.8, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_GlassBodyPainter old) =>
      old.borderRadius != borderRadius || old.settings != settings;
}

/// Paints the specular rim and inner edge glow over the dialog body
class _GlassRimPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final LiquidGlassSettings settings;

  _GlassRimPainter({required this.borderRadius, required this.settings});

  @override
  void paint(Canvas canvas, Size size) {
    if (settings.borderWidth == 0 || settings.highlightOpacity == 0) return;

    final Rect rect = Offset.zero & size;
    final double h = settings.highlightOpacity;
    final Shader rimShader = LinearGradient(
      begin: settings.lightSource,
      end: -settings.lightSource,
      colors: [
        Colors.white.withValues(alpha: h),
        Colors.white.withValues(alpha: h * 0.12),
        Colors.white.withValues(alpha: h * 0.12),
        Colors.white.withValues(alpha: h * 0.7),
      ],
      stops: const [0, 0.35, 0.65, 1],
    ).createShader(rect);

    // Soft glow just inside the edge, gives the glass its thickness
    canvas.drawRRect(
      borderRadius.toRRect(rect).deflate(settings.borderWidth * 1.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = settings.borderWidth * 3
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, settings.borderWidth * 2)
        ..shader = rimShader,
    );

    // Crisp specular rim
    canvas.drawRRect(
      borderRadius.toRRect(rect).deflate(settings.borderWidth / 2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = settings.borderWidth
        ..shader = rimShader,
    );
  }

  @override
  bool shouldRepaint(_GlassRimPainter old) =>
      old.borderRadius != borderRadius || old.settings != settings;
}
