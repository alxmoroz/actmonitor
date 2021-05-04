// Copyright (c) 2021. Alexandr Moroz

import 'package:mobx/mobx.dart';

part 'global_state.g.dart';

class GlobalState = _GlobalStateBase with _$GlobalState;

abstract class _GlobalStateBase with Store {}
