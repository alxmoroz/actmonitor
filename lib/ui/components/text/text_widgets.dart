// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/ui/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  const NormalText(this.text, {this.size, this.sizeScale, this.color, this.weight, this.align, this.padding, this.height, this.overflow});

  @protected
  final String text;
  @protected
  final Color? color;
  @protected
  final FontWeight? weight;
  @protected
  final TextAlign? align;
  @protected
  final double? size;
  @protected
  final double? sizeScale;
  @protected
  final EdgeInsets? padding;
  @protected
  final double? height;
  @protected
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final cupertinoTS = CupertinoTheme.of(context).textTheme.textStyle;
    final textStyle = cupertinoTS.copyWith(
      color: CupertinoDynamicColor.maybeResolve(color ?? darkColor, context),
      fontWeight: weight ?? cupertinoTS.fontWeight,
      fontSize: size ?? cupertinoTS.fontSize! * (sizeScale ?? 1),
      height: height ?? cupertinoTS.height,
    );
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(text, style: textStyle, textAlign: align, overflow: overflow),
    );
  }
}

class SubtitleText extends NormalText {
  const SubtitleText(String text, {double? size, Color? color, FontWeight? weight, TextAlign? align, EdgeInsets? padding})
      : super(
          text,
          color: color ?? CupertinoColors.systemGrey,
          weight: weight,
          size: size,
          sizeScale: 0.85,
          align: align,
          padding: padding,
        );
}

class MediumText extends NormalText {
  const MediumText(String text, {double? size, Color? color, FontWeight? weight, TextAlign? align, EdgeInsets? padding})
      : super(
          text,
          color: color,
          weight: weight ?? FontWeight.w500,
          size: size,
          align: align,
          padding: padding,
        );
}

class TitleText extends MediumText {
  const TitleText(String text, {Color? color, FontWeight? weight, TextAlign? align, EdgeInsets? padding})
      : super(
          text,
          color: color,
          weight: weight,
          size: 20,
          align: align,
          padding: padding,
        );
}

class H3 extends MediumText {
  const H3(String text, {Color? color, TextAlign align = TextAlign.center, EdgeInsets? padding})
      : super(
          text,
          color: color,
          size: 20,
          align: align,
          padding: padding,
        );
}
