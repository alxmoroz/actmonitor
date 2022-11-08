// Copyright (c) 2022. Alexandr Moroz

import 'package:hive/hive.dart';

import '../../L1_domain/entities/app_settings.dart';
import '../../L1_domain/entities/base_entity.dart';
import '../../L1_domain/entities/net_stat.dart';
import '../../L1_domain/repositories/abs_db_repo.dart';
import '../models/app_settings.dart';
import '../models/base.dart';
import '../models/net_stat.dart';

typedef ModelCreator<T> = T Function();

abstract class DBRepo<M extends BaseModel, E extends LocalPersistable> extends AbstractDBRepo<M, E> {
  DBRepo(this.boxName, this.modelCreator);

  final String boxName;
  ModelCreator<M> modelCreator;

  Box<M>? _box;

  Future<Box<M>> get box async {
    _box ??= await Hive.openBox<M>(boxName);
    return _box!;
  }

  Future<M> _getOrCreateModel(String? id) async {
    M model;
    try {
      model = (await box).values.firstWhere((model) => model.id == id);
    } catch (e) {
      model = modelCreator();
      await (await box).add(model);
    }

    return model;
  }

  @override
  Future<Iterable<E>> get([Filter<E>? filter]) async {
    var entities = (await box).values.map((model) => model.toEntity() as E);
    if (filter != null) {
      entities = entities.where((e) => filter(e));
    }
    return entities;
  }

  @override
  Future<E?> getOne([Filter<E>? filter]) async {
    final entities = await get(filter);
    return entities.isNotEmpty ? entities.first : null;
  }

  @override
  Future<M> update(E entity) async {
    final model = await _getOrCreateModel(entity.id);
    try {
      await model.update(entity);
    } catch (e) {
      print('update error ${entity.id} $e');
    }
    return model;
  }

  @override
  Future delete(E entity) async {
    try {
      final model = await _getOrCreateModel(entity.id);
      await model.delete();
    } catch (e) {
      print('delete error ${entity.id} $e');
    }
  }
}

class SettingsRepo extends DBRepo<AppSettingsHO, AppSettings> {
  SettingsRepo() : super('AppSettings', () => AppSettingsHO());
}

class NetStatsRepo extends DBRepo<NetStatHO, NetStat> {
  NetStatsRepo() : super('NetStat', () => NetStatHO());
}

// class NetInfoRepo extends DBRepo<NetInfoHO, NetInfo> {
//   NetInfoRepo() : super('NetInfo', () => NetInfoHO());
// }
