// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';

ImageProvider get backgroundImage => const AssetImage('assets/images/background.png');

BoxDecoration get bgDecoration => BoxDecoration(image: DecorationImage(image: backgroundImage, fit: BoxFit.fill));
