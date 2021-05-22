// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';

Color _r(CupertinoDynamicColor color) => CupertinoDynamicColor.resolve(color, appState.context!);

Color get warningColor => _r(CupertinoColors.activeOrange);

Color get purpleColor => _r(CupertinoColors.systemPurple);

Color get tealColor => _r(CupertinoColors.systemTeal);

Color get indigoColor => _r(CupertinoColors.systemIndigo);

Color get greenColor => _r(CupertinoColors.systemGreen);

Color get darkColor => _r(const CupertinoDynamicColor.withBrightness(color: Color(0xFF666666), darkColor: Color(0xFFBBBBBB)));

Color get greyColor => _r(CupertinoColors.systemGrey);

Color get greyColor2 => _r(CupertinoColors.systemGrey2);

Color get greyColor3 => _r(CupertinoColors.systemGrey3);

Color get greyColor4 => _r(CupertinoColors.systemGrey4);

Color get greyColor5 => _r(CupertinoColors.systemGrey5);

Color get greyColor6 => _r(CupertinoColors.systemGrey6);

Color get secondaryBackgroundColor => _r(CupertinoColors.secondarySystemBackground);
