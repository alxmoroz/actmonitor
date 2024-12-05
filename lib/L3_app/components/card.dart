// Copyright (c) 2024. Alexandr Moroz

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../L2_data/repositories/platform.dart';
import 'colors.dart';
import 'constants.dart';
import 'text_widgets.dart';

class CardTitle extends StatelessWidget {
  const CardTitle(this.title, {this.padding});

  @protected
  final String title;
  @protected
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final offset = Offset(0, (CupertinoTheme.brightnessOf(context) == Brightness.dark ? -1 : 1) * 1.2);

    return NormalText(
      title,
      size: isTablet ? 22 : 17,
      weight: FontWeight.bold,
      color: CupertinoColors.systemGrey,
      shadow: TextShadow(CupertinoColors.systemBackground, offset),
      padding: padding ?? EdgeInsets.fromLTRB(onePadding, onePadding, onePadding, 0),
      align: TextAlign.left,
    );
  }
}

class AMCard extends StatelessWidget {
  const AMCard({this.body, this.title, this.margin});

  @protected
  final Widget? title;
  @protected
  final Widget? body;
  @protected
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    const double radius = 8;
    return Card(
      margin: margin ?? EdgeInsets.symmetric(horizontal: isTablet ? 50 : 12, vertical: isTablet ? 10 : 8),
      elevation: 6,
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
