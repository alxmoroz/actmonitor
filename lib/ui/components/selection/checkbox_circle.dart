// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui_constants.dart';

class CheckboxCircle extends StatelessWidget {
  const CheckboxCircle({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: borderRadiusCircle,
            border: Border.all(color: isActive ? CupertinoColors.activeBlue : CupertinoColors.systemGrey4, width: 2)),
        child: Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: isActive ? CupertinoColors.activeBlue : Colors.transparent, borderRadius: borderRadiusCircle),
          ),
        ),
      ),
    );
  }
}
