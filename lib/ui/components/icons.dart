// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';

Widget get usageTabbarIcon => const Icon(CupertinoIcons.chart_pie_fill);

Widget get specsTabbarIcon => const Icon(CupertinoIcons.info_circle_fill);

Widget get compareTabbarIcon => const Icon(CupertinoIcons.chart_bar_alt_fill);

Widget get dropdownIcon => const Icon(CupertinoIcons.chevron_up_chevron_down, color: CupertinoColors.systemBlue);

Widget get pencilIcon => const Icon(CupertinoIcons.pencil, color: CupertinoColors.systemBlue);

Widget get plusIcon => const Icon(CupertinoIcons.plus_circle, size: 30);

Widget get removeIcon => const Icon(CupertinoIcons.minus_circle, size: 30, color: CupertinoColors.systemRed);

Widget get netDetailsIcon => const Icon(CupertinoIcons.info_circle);

Widget chevronBackIcon(BuildContext context, {Color? color}) => Icon(
      CupertinoIcons.chevron_back,
      color: CupertinoDynamicColor.maybeResolve(color, context),
    );

Widget chevronForwardIcon(BuildContext context, {Color? color}) => Icon(
      CupertinoIcons.chevron_forward,
      color: CupertinoDynamicColor.maybeResolve(color, context),
    );
