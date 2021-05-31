// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'text/text_widgets.dart';

CupertinoNavigationBar navBar(
  BuildContext context, {
  String? backTitle,
  Widget? leading,
  Widget? middle,
  String? title,
  Widget? trailing,
  Color? bgColor,
}) {
  Widget backButton() => CupertinoNavigationBarBackButton(
        previousPageTitle: backTitle,
        onPressed: () => Navigator.of(context).canPop() ? Navigator.of(context).pop() : null,
      );

  MediaQuery mQuery(Widget child) => MediaQuery(
        data: MediaQuery.of(context),
        child: child,
      );

  return CupertinoNavigationBar(
    leading: leading != null || Navigator.of(context).canPop() ? mQuery(leading ?? backButton()) : null,
    middle: middle != null
        ? mQuery(middle)
        : title != null
            ? mQuery(MediumText(title))
            : null,
    trailing: trailing != null ? mQuery(trailing) : null,
    padding: const EdgeInsetsDirectional.only(start: 0),
    backgroundColor: bgColor ?? navbarBgColor,
  );
}
