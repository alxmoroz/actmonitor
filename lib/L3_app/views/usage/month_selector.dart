// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../components/buttons.dart';
import '../../components/card.dart';
import '../../components/constants.dart';
import '../../components/icons.dart';
import '../../extra/services.dart';
import 'usage_controller.dart';

class MonthSelector extends StatelessWidget {
  UsageController get _controller => usageController;

  bool get _showTodayBtn {
    final today = DateTime.now();
    return !(_controller.selectedMonth.year == today.year && _controller.selectedMonth.month == today.month);
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
                    child: Button(loc.today, _controller.setCurrentMonth, padding: EdgeInsets.only(right: onePadding * 2)),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _controller.canPrevMonth ? Button.icon(chevronBackIcon(context), _controller.setPrevMonth) : emptyButton,
                    CardTitle(DateFormat.yMMMM().format(_controller.selectedMonth), padding: EdgeInsets.zero),
                    _controller.canNextMonth ? Button.icon(chevronForwardIcon(context), _controller.setNextMonth) : emptyButton,
                  ],
                ),
              ],
            ));
  }
}
