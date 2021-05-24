// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey3, context),
      height: height,
    );
  }
}
