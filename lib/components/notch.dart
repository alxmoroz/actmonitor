// Copyright (c) 2021. Alexandr Moroz

import 'package:choice/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notch extends StatelessWidget {
  const Notch();

  static double height = 30;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Container(
          width: 45,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: greyColor(context),
          ),
        ),
      ),
    );
  }
}
