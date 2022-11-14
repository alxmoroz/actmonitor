// Copyright (c) 2022. Alexandr Moroz

import '../entities/net_stat.dart';
import '../repositories/abs_db_repo.dart';

class NetStatsUC {
  NetStatsUC({required this.repo});

  final AbstractDBRepo<AbstractDBModel, NetStat> repo;

  Future<NetStat?> getOne() async => await repo.getOne();
  Future update(NetStat stat) async => await repo.update(stat);

  Future cleanData() async {
    final data = await repo.get();
    final count = data.length;
    for (int i = 0; i < count - 1; i++) {
      await repo.delete(data.elementAt(i));
    }
  }
}
