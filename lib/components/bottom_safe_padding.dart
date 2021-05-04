// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';

class BottomSafePadding extends StatelessWidget {
  const BottomSafePadding(this.parentContext);

  @protected
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(parentContext).padding.bottom;
    return SizedBox(height: bottomInset > 0 ? 0 : 12);
  }
}
