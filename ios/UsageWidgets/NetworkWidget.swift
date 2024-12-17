// Copyright (c) 2021. Alexandr Moroz

import WidgetKit
import SwiftUI

struct NetworkProvider: TimelineProvider {
  func placeholder(in context: Context) -> NetworkEntry {
    return NetworkEntry.getEntry()
  }
  
  func getSnapshot(in context: Context, completion: @escaping (NetworkEntry) -> ()) {
    completion(NetworkEntry.getEntry())
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let timeline = Timeline(
      entries: [NetworkEntry.getEntry()],
      policy: .atEnd
    )
    completion(timeline)
  }
}

struct NetworkEntry: TimelineEntry {
  let date: Date
  let netUsage: NetUsage
  
  static func getEntry() -> NetworkEntry {
    return NetworkEntry(date: Calendar.current.date(byAdding: .minute, value: 5, to: Date())!, netUsage: Usage.getNetUsageFromDefaults())
  }
}

struct WiFiEntryView : View {
  var entry: NetworkProvider.Entry
  
  let formatter = ByteCountFormatter()
  var body: some View {
    ChartView(
      title: "WiFi",
      labels: [
        LabelData(color: Color.blue, title: "▲", value: formatter.string(fromByteCount: Int64(entry.netUsage.wifiSent)), oneLine: true),
        LabelData(color: Color.orange, title: "▼", value: formatter.string(fromByteCount: Int64(entry.netUsage.wifiReceived)), oneLine: true)
      ],
      slices: [
        SliceData(color: Color.orange, value: entry.netUsage.wifiReceived),
        SliceData(color: Color.blue, value: entry.netUsage.wifiSent),
        SliceData(color: FreeColor, value: 1),
      ],
      valuesSum: entry.netUsage.wifiReceived + entry.netUsage.wifiSent + 1
    )
  }
}

struct CellularEntryView : View {
  var entry: NetworkProvider.Entry
  
  let formatter = ByteCountFormatter()
  var body: some View {
    ChartView(
      title: "Cellular",
      labels: [
        LabelData(color: Color.blue, title: "▲", value: formatter.string(fromByteCount: Int64(entry.netUsage.cellularSent)), oneLine: true),
        LabelData(color: Color.orange, title: "▼", value: formatter.string(fromByteCount: Int64(entry.netUsage.cellularReceived)), oneLine: true)
      ],
      slices: [
        SliceData(color: Color.orange, value: entry.netUsage.cellularReceived),
        SliceData(color: Color.blue, value: entry.netUsage.cellularSent),
        SliceData(color: FreeColor, value: 1),
      ],
      valuesSum: entry.netUsage.cellularReceived + entry.netUsage.cellularSent + 1
    )
  }
}

struct CellularWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "ru.aeonika.ActMonitor.UsageWidget.Network.Cellular",
      provider: NetworkProvider()
    ) { entry in
      CellularEntryView(entry: entry)
    }
    .contentMarginsDisabled()
    .configurationDisplayName("Network Cellular")
    .description("Cellular traffic")
    .supportedFamilies([.systemSmall])
  }
}

struct WiFiWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "ru.aeonika.ActMonitor.UsageWidget.Network.WiFi",
      provider: NetworkProvider()
    ) { entry in
      WiFiEntryView(entry: entry)
    } 
    .contentMarginsDisabled()
    .configurationDisplayName("Network WiFi")
    .description("WiFi traffic")
    .supportedFamilies([.systemSmall])
  }
}
