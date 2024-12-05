// Copyright (c) 2024. Alexandr Moroz

import 'package:flutter/material.dart';

import 'colors.dart';

class MTCircle extends StatelessWidget {
  const MTCircle({
    super.key,
    this.color,
    this.size,
    this.border,
    this.child,
  });

  final Color? color;
  final double? size;
  final Border? border;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 12,
      height: size ?? 12,
      decoration: BoxDecoration(
        color: (color ?? darkColor).resolve(context),
        shape: BoxShape.circle,
        border: border ?? const Border(),
      ),
      child: child,
    );
  }
}
