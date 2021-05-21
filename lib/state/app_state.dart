// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'app_state.g.dart';

class AppState = _AppStateBase with _$AppState;

abstract class _AppStateBase with Store {
  @observable
  BuildContext? context;

  @action
  void setContext(BuildContext ctx) {
    context = ctx;
  }
}
