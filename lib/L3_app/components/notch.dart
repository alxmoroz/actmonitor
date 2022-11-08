// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';

class Notch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: Center(
        child: Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey, context),
          ),
        ),
      ),
    );
  }
}
