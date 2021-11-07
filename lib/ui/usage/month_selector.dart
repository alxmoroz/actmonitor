// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../services/globals.dart';
import '../components/buttons.dart';
import '../components/card.dart';
import '../components/icons.dart';

class MonthSelector extends StatelessWidget {
  bool get _showTodayBtn {
    final today = DateTime.now();
    return !(usageState.selectedMonth.year == today.year && usageState.selectedMonth.month == today.month);
  }

  @override
  Widget build(BuildContext context) {
    const emptyButton = Button('', null);
    return Observer(
        builder: (_) => Stack(
              children: [
                if (_showTodayBtn)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Button(loc.today, usageState.setCurrentMonth, padding: EdgeInsets.only(right: sidePadding * 2)),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    usageState.canPrevMonth ? Button.icon(chevronBackIcon(context), usageState.setPrevMonth) : emptyButton,
                    CardTitle(DateFormat.yMMMM().format(usageState.selectedMonth), padding: EdgeInsets.zero),
                    usageState.canNextMonth ? Button.icon(chevronForwardIcon(context), usageState.setNextMonth) : emptyButton,
                  ],
                ),
              ],
            ));
  }
}
