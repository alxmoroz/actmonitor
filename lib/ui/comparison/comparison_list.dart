import 'package:amonitor/ui/components/text/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComparisonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (_, index) => ListTile(title: NormalText('dev - $index')), itemCount: 10);
  }
}
