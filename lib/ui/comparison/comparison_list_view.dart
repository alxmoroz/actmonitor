import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/components/images.dart';
import 'package:amonitor/ui/components/material_wrapper.dart';
import 'package:amonitor/ui/components/navbar.dart';
import 'package:amonitor/ui/components/text/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComparisonListView extends StatelessWidget {
  static String get routeName => 'ComparisonListView';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: navBar(context, middle: const TitleText('Select models')),
      child: Container(
        decoration: bgDecoration,
        child: materialWrap(
          ListView.builder(
            itemBuilder: (_, index) => ListTile(title: NormalText(comparisonState.comparisonDevices[index].name)),
            itemCount: comparisonState.comparisonDevices.length,
          ),
        ),
      ),
    );
  }
}
