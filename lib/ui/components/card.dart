import 'dart:math';

import 'package:amonitor/ui/components/text/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'colors.dart';

class CardTitle extends StatelessWidget {
  const CardTitle(this.title);

  @protected
  final String title;

  @override
  Widget build(BuildContext context) {
    final offset = Offset(0, (CupertinoTheme.brightnessOf(context) == Brightness.dark ? -1 : 1) * 1.2);

    return H3(
      title,
      weight: FontWeight.bold,
      color: CupertinoColors.systemGrey,
      shadow: TextShadow(CupertinoColors.systemBackground, offset),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    );
  }
}

class AMCard extends StatelessWidget {
  const AMCard({this.body, this.title});

  @protected
  final Widget? title;

  @protected
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    const double radius = 8;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 5,
      color: CupertinoDynamicColor.resolve(cardBackgroundColor, context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            transform: const GradientRotation(pi / 2),
            colors: [
              CupertinoDynamicColor.resolve(cardBackgroundColor, context),
              CupertinoDynamicColor.resolve(cardBackgroundColor, context),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) title!,
            if (body != null) body!,
          ],
        ),
      ),
    );
  }
}
