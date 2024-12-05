// Copyright (c) 2024. Alexandr Moroz

import 'package:flutter/cupertino.dart';

Color get darkColor => const CupertinoDynamicColor.withBrightness(color: Color(0xFF333333), darkColor: Color(0xFFCCCCCC));

Color get inactiveColor => const CupertinoDynamicColor.withBrightness(color: Color(0xFF758599), darkColor: Color(0xFF999999));

Color get cardBackgroundColor => CupertinoColors.systemGrey5;
// Color get cardBackgroundColor => const CupertinoDynamicColor.withBrightness(color: Color(0xFFE0E0F0), darkColor: Color.fromARGB(255, 50, 50, 52));
// Color get cardBackgroundColor2 => CupertinoColors.systemGrey3;

const CupertinoDynamicColor f3Color = CupertinoDynamicColor.withBrightness(
  color: Color.fromARGB(255, 180, 180, 188),
  darkColor: Color.fromARGB(255, 94, 94, 96),
);

// Color get navbarBgColor => CupertinoColors.systemFill;
Color get navbarBgColor => const CupertinoDynamicColor.withBrightness(
      color: Color.fromARGB(170, 200, 215, 240),
      darkColor: Color.fromARGB(170, 40, 50, 60),
    );

extension ResolvedColor on Color {
  Color resolve(BuildContext context) => CupertinoDynamicColor.resolve(this, context);
}
