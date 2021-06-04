// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';

Color get darkColor => const CupertinoDynamicColor.withBrightness(color: Color(0xFF333333), darkColor: Color(0xFFCCCCCC));

Color get cardBackgroundColor => CupertinoColors.systemGrey5;
// Color get cardBackgroundColor2 => CupertinoColors.systemGrey3;

// Color get navbarBgColor => CupertinoColors.systemFill;
Color get navbarBgColor => const CupertinoDynamicColor.withBrightness(
      color: Color.fromARGB(150, 180, 180, 190),
      darkColor: Color.fromARGB(150, 80, 80, 85),
    );
