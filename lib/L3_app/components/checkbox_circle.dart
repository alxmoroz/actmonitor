// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class CheckboxCircle extends StatelessWidget {
  const CheckboxCircle({required this.isActive, this.alreadySelected = false});

  final bool isActive;
  final bool alreadySelected;

  @override
  Widget build(BuildContext context) {
    const Color inactiveColor = CupertinoColors.systemGrey4;
    final Color activeColor = alreadySelected ? inactiveColor : CupertinoColors.activeBlue;

    return SizedBox(
      width: 20,
      height: 20,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: isActive ? activeColor : inactiveColor, width: 2),
        ),
        child: Center(
          child: Container(
            width: onePadding,
            height: onePadding,
            decoration: BoxDecoration(
              color: (isActive || alreadySelected) ? activeColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
