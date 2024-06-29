// This file defines helper methods by using extension on specific dart/flutter classes eg:

import 'package:flutter/material.dart';

extension InkWellExtensions on InkWell {
  InkWell get noShadow => InkWell(
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: onTap,
        child: child,
      );
}
