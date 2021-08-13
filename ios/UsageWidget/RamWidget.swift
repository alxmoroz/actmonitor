// Copyright (c) 2021. Alexandr Moroz

import WidgetKit
import SwiftUI

struct RamProvider: TimelineProvider {
  func placeholder(in context: Context) -> RamEntry {
    return RamEntry.getEntry()
  }
  
  func getSnapshot(in context: Context, completion: @escaping (RamEntry) -> ()) {
    completion(RamEntry.getEntry())
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let timeline = Timeline(
      entries: [RamEntry.getEntry()],
      policy: .atEnd
    )
    completion(timeline)
  }
}

struct RamEntry: TimelineEntry {
  let date: Date
  let free: Int64
  let total: Int64
  
  static func getEntry() -> RamEntry {
    let data = Usage._getRamUsage()
    return RamEntry(date: Date(), free: data[2] + data[4], total: data[5])
  }
}

struct RamWidgetEntryView : View {
  var entry: RamProvider.Entry
  
  let formatter = ByteCountFormatter()
  var body: some View {
    ChartView(
      title: "Ram",
      labels: [
        LabelData(color: FreeColor, title: "Free", value: formatter.string(fromByteCount: entry.free))
      ],
      slices: [
        SliceData(color: Color.blue, value: entry.total - entry.free),
        SliceData(color: FreeColor, value: entry.free)
      ]
    )
  }
}

struct RamWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "ru.aeonika.ActMonitor.UsageWidget.Ram",
      provider: RamProvider()
    ) { entry in
      RamWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Ram")
    .description("Free")
    .supportedFamilies([.systemSmall])
  }
}
