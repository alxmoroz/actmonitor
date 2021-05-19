// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class Separator extends StatelessWidget {
  const Separator({this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Divider(color: greyColor3, height: height);
  }
}
