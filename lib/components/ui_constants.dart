// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/components/colors.dart';
import 'package:flutter/cupertino.dart';

final BorderRadius borderRadiusCircle = BorderRadius.circular(100);

BoxDecoration textFieldDecoration(BuildContext context) =>
    BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: greyColor4(context)!));
