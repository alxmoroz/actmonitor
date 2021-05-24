// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';

Color _r(CupertinoDynamicColor color, BuildContext ctx) => CupertinoDynamicColor.resolve(color, ctx);

Color warningColor(BuildContext ctx) => _r(CupertinoColors.activeOrange, ctx);

Color purpleColor(BuildContext ctx) => _r(CupertinoColors.systemPurple, ctx);

Color tealColor(BuildContext ctx) => _r(CupertinoColors.systemTeal, ctx);

Color indigoColor(BuildContext ctx) => _r(CupertinoColors.systemIndigo, ctx);

Color greenColor(BuildContext ctx) => _r(CupertinoColors.systemGreen, ctx);

Color darkColor(BuildContext ctx) => _r(const CupertinoDynamicColor.withBrightness(color: Color(0xFF666666), darkColor: Color(0xFFBBBBBB)), ctx);

Color greyColor(BuildContext ctx) => _r(CupertinoColors.systemGrey, ctx);

Color greyColor2(BuildContext ctx) => _r(CupertinoColors.systemGrey2, ctx);

Color greyColor3(BuildContext ctx) => _r(CupertinoColors.systemGrey3, ctx);

Color greyColor4(BuildContext ctx) => _r(CupertinoColors.systemGrey4, ctx);

Color greyColor5(BuildContext ctx) => _r(CupertinoColors.systemGrey5, ctx);

Color greyColor6(BuildContext ctx) => _r(CupertinoColors.systemGrey6, ctx);

Color secondaryBackgroundColor(BuildContext ctx) => _r(CupertinoColors.secondarySystemBackground, ctx);
