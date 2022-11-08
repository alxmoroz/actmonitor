// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';

import '../L2_data/repositories/platform.dart';
import 'components/colors.dart';

class TextShadow {
  const TextShadow(this.color, this.offset);

  final Color color;

  @protected
  final Offset offset;

  double get dx => offset.dx;

  double get dy => offset.dy;
}

class NormalText extends StatelessWidget {
  const NormalText(
    this.text, {
    this.size,
    this.sizeScale,
    this.color,
    this.weight,
    this.align,
    this.padding,
    this.height,
    this.overflow,
    this.shadow,
  });

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
  @protected
  final TextShadow? shadow;

  @override
  Widget build(BuildContext context) {
    final cupertinoTS = CupertinoTheme.of(context).textTheme.textStyle;
    final textStyle = cupertinoTS.copyWith(
      color: CupertinoDynamicColor.maybeResolve(color ?? darkColor, context),
      fontWeight: weight ?? cupertinoTS.fontWeight,
      fontSize: (size ?? cupertinoTS.fontSize ?? (isTablet ? 20 : 16)) * (sizeScale ?? 1),
      height: height ?? cupertinoTS.height,
    );
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (shadow != null)
            Positioned(
              top: shadow!.dy,
              left: shadow!.dx,
              child: Text(
                text,
                style: textStyle.copyWith(color: CupertinoDynamicColor.maybeResolve(shadow!.color, context)),
                textAlign: align,
                overflow: overflow,
              ),
            ),
          Text(text, style: textStyle, textAlign: align, overflow: overflow),
        ],
      ),
    );
  }
}

class SmallText extends NormalText {
  const SmallText(String text, {Color? color, FontWeight? weight, TextAlign? align, EdgeInsets? padding})
      : super(
          text,
          color: color ?? CupertinoColors.systemGrey,
          weight: weight,
          sizeScale: 0.85,
          align: align,
          padding: padding,
        );
}

class LightText extends NormalText {
  const LightText(String text, {double? size, Color? color, FontWeight? weight, TextAlign? align, EdgeInsets? padding, double? sizeScale})
      : super(
          text,
          color: color,
          weight: weight ?? FontWeight.w300,
          size: size,
          sizeScale: sizeScale,
          align: align,
          padding: padding,
        );
}

class MediumText extends NormalText {
  const MediumText(String text,
      {double? size, Color? color, FontWeight? weight, TextAlign? align, EdgeInsets? padding, TextShadow? shadow, double? sizeScale})
      : super(
          text,
          color: color,
          weight: weight ?? FontWeight.w500,
          size: size,
          sizeScale: sizeScale,
          align: align,
          padding: padding,
          shadow: shadow,
        );
}

class H3 extends MediumText {
  const H3(String text, {Color? color, FontWeight? weight, TextAlign? align, EdgeInsets? padding, TextShadow? shadow})
      : super(
          text,
          color: color,
          weight: weight,
          sizeScale: 1.12,
          align: align,
          padding: padding,
          shadow: shadow,
        );
}
