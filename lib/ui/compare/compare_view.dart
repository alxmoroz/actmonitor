import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../components/colors.dart';
import '../components/text/text_widgets.dart';

class CompareView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Observer(
          builder: (_) => Card(
            margin: const EdgeInsets.all(12),
            elevation: 5,
            color: greyColor6,
            child: const H3('Compare', padding: EdgeInsets.all(12)),
          ),
        ),
      ),
    );
  }
}
