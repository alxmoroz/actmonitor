// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/ui/components/text/text_widgets.dart';
import 'package:flutter/cupertino.dart';

enum ButtonType { primary, secondary, outlined, error }

class Button extends StatelessWidget {
  const Button(this.title, this.onPressed, {this.child, this.color, this.type, this.titleColor, this.padding, this.icon});

  const Button.primary(this.title, this.onPressed, {this.child, this.titleColor, this.padding})
      : type = ButtonType.primary,
        icon = null,
        color = null;

  const Button.icon(this.icon, this.onPressed, {this.color, this.type, this.padding})
      : title = null,
        child = icon,
        titleColor = null;

  final String? title;
  final VoidCallback? onPressed;
  final Widget? child;
  final Icon? icon;
  final ButtonType? type;
  final Color? color;
  final Color? titleColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final Color? resolvedColor = type == ButtonType.primary ? color ?? CupertinoTheme.of(context).primaryColor : color;
    return CupertinoButton(
      padding: padding ?? EdgeInsets.zero,
      onPressed: onPressed,
      color: resolvedColor,
      disabledColor: CupertinoColors.systemGrey5,
      child: child ?? MediumText(title ?? '', color: onPressed != null ? titleColor ?? CupertinoTheme.of(context).primaryColor : null),
    );
  }
}
