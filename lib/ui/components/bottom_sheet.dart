// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'notch.dart';

class AMBottomSheet extends StatelessWidget {
  const AMBottomSheet(this.bodyWidget);

  final Widget bodyWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Container(
        decoration: BoxDecoration(
          color: secondaryBackgroundColor(context),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Notch(),
            bodyWidget,
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
