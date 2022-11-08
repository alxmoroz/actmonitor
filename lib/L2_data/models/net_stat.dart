import 'package:hive/hive.dart';

import '../../L1_domain/entities/net_stat.dart';
import '../repositories/db.dart';
import 'base.dart';

part 'net_stat.g.dart';

@HiveType(typeId: HType.NetStat)
class NetStatHO extends BaseModel<NetStat> {
  @HiveField(0, defaultValue: <NetInfoHO>[])
  List<NetInfoHO> records = [];
  @HiveField(1)
  NetInfoHO? kernelData;

  @override
  NetStat toEntity() => NetStat(
        records: records.map((r) => r.toEntity()).toList(),
        kernelData: kernelData?.toEntity() ?? NetInfo(dateTime: DateTime.now()),
      );

  @override
  Future update(NetStat entity) async {
    id = entity.id;
    records.clear();
    for (final r in entity.records) {
      records.add(await NetInfoHO().update(r));
    }

    kernelData = await NetInfoHO().update(entity.kernelData);
    await save();
  }
}

@HiveType(typeId: HType.NetInfo)
class NetInfoHO extends BaseModel<NetInfo> {
  @HiveField(0, defaultValue: 0)
  int wifiReceived = 0;
  @HiveField(1, defaultValue: 0)
  int wifiSent = 0;
  @HiveField(2, defaultValue: 0)
  int cellularReceived = 0;
  @HiveField(3, defaultValue: 0)
  int cellularSent = 0;
  @HiveField(4)
  DateTime? dateTime;

  @override
  NetInfo toEntity() => NetInfo(
        id: '${dateTime?.millisecondsSinceEpoch}',
        wifiReceived: wifiReceived,
        wifiSent: wifiSent,
        cellularReceived: cellularReceived,
        cellularSent: cellularSent,
        dateTime: dateTime ?? DateTime.now(),
      );

  @override
  Future update(NetInfo entity) async {
    id = entity.id;
    wifiReceived = entity.wifiReceived;
    wifiSent = entity.wifiSent;
    cellularReceived = entity.cellularReceived;
    cellularSent = entity.cellularSent;
    dateTime = entity.dateTime;

    return this;
  }
}
