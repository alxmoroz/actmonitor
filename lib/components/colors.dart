// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';

Color? resolvedColor(CupertinoDynamicColor? color, BuildContext context) {
  return CupertinoDynamicColor.resolve(color!, context);
}

Color? darkColor(BuildContext context) =>
    resolvedColor(const CupertinoDynamicColor.withBrightness(color: Color(0xFF666666), darkColor: Color(0xFFBBBBBB)), context);

Color? greyColor(BuildContext context) => resolvedColor(CupertinoColors.systemGrey, context);

Color? greyColor2(BuildContext context) => resolvedColor(CupertinoColors.systemGrey2, context);

Color? greyColor3(BuildContext context) => resolvedColor(CupertinoColors.systemGrey3, context);

Color? greyColor4(BuildContext context) => resolvedColor(CupertinoColors.systemGrey4, context);

Color? greyColor5(BuildContext context) => resolvedColor(CupertinoColors.systemGrey5, context);

Color? greyColor6(BuildContext context) => resolvedColor(CupertinoColors.systemGrey6, context);

Color? secondaryBackgroundColor(BuildContext context) => resolvedColor(CupertinoColors.secondarySystemBackground, context);
