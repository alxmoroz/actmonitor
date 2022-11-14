// Copyright (c) 2022. Alexandr Moroz

import 'package:hive/hive.dart';

import '../../../L1_domain/entities/base_entity.dart';
import '../../../L1_domain/repositories/abs_db_repo.dart';

abstract class BaseModel<E extends LocalPersistable> extends HiveObject implements AbstractDBModel<E> {}
