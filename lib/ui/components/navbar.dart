// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/ui/components/text/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

MediaQuery mQuery(Widget child) => MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: child,
    );

Widget _backButton(BuildContext context) =>
    CupertinoNavigationBarBackButton(onPressed: () => Navigator.of(context).canPop() ? Navigator.of(context).pop() : null);

CupertinoNavigationBar navBar(BuildContext context, {Widget? leading, Widget? middle, String? title, Widget? trailing, Color? bgColor}) =>
    CupertinoNavigationBar(
      leading: leading != null || Navigator.of(context).canPop() ? mQuery(leading ?? _backButton(context)) : null,
      middle: middle != null
          ? mQuery(middle)
          : title != null
              ? mQuery(NormalText(title))
              : null,
      trailing: trailing != null ? mQuery(trailing) : null,
      padding: const EdgeInsetsDirectional.only(start: 0),
      backgroundColor: bgColor,
    );
