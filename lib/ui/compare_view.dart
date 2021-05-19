import 'package:flutter/cupertino.dart';

import 'components/material_wrapper.dart';
import 'components/text/text_widgets.dart';

class CompareView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: materialWrap(
          const Center(
            child: H3('Compare'),
          ),
        ),
      ),
    );
  }
}
