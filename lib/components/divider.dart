// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator();

  @override
  Widget build(BuildContext context) {
    return Divider(color: greyColor3(context));
  }
}
