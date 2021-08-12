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
    return NetworkEntry(date: Calendar.current.date(byAdding: .minute, value: 5, to: Date())!, netUsage: Usage._getNetUsage())
  }
}

struct WiFiEntryView : View {
  var entry: NetworkProvider.Entry
  
  let formatter = ByteCountFormatter()
  var body: some View {
    ChartView(
      title: "WiFi",
      mainLabel: "⇩⇩⇩",
      mainValue: formatter.string(fromByteCount: entry.netUsage.wifiReceived),
      values: [entry.netUsage.wifiReceived, entry.netUsage.wifiSent, 1],
      colors: [Color.orange, Color.blue, FreeColor]
    )
  }
}

struct CellularEntryView : View {
  var entry: NetworkProvider.Entry
  
  let formatter = ByteCountFormatter()
  var body: some View {
    ChartView(
      title: "Cellular",
      mainLabel: "⇩⇩⇩",
      mainValue: formatter.string(fromByteCount: entry.netUsage.cellularReceived),
      values: [entry.netUsage.cellularReceived, entry.netUsage.cellularSent, 1],
      colors: [Color.orange, Color.blue, FreeColor]
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
    .configurationDisplayName("Network WiFi")
    .description("WiFi traffic")
    .supportedFamilies([.systemSmall])
  }
}
