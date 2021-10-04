// Copyright (c) 2021. Alexandr Moroz

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> DiskUsageEntry {
    return DiskUsageEntry.getEntry()
  }
  
  func getSnapshot(in context: Context, completion: @escaping (DiskUsageEntry) -> ()) {
    completion(DiskUsageEntry.getEntry())
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let timeline = Timeline(
      entries: [DiskUsageEntry.getEntry()],
      policy: .atEnd
    )
    completion(timeline)
  }
}

struct DiskUsageEntry: TimelineEntry {
  let date: Date
  let free: Int
  let total: Int
  
  static func getEntry() -> DiskUsageEntry {
    let diskData = Usage._getDiskUsage()
    return DiskUsageEntry(date: Date(), free: diskData[0], total: diskData[1])
  }
}

struct UsageWidgetEntryView : View {
  var entry: Provider.Entry
  
  let formatter = ByteCountFormatter()
  var body: some View {
    ChartView(
      title: "Disk",
      labels: [
        LabelData(color: FreeColor, title: "Free", value: formatter.string(fromByteCount: Int64(entry.free)))
      ],
      slices: [
        SliceData(color: Color.blue, value: entry.total - entry.free),
        SliceData(color: FreeColor, value: entry.free)
      ],
      valuesSum: entry.total
    )
  }
}

struct DiskWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "ru.aeonika.ActMonitor.UsageWidget.Disk",
      provider: Provider()
    ) { entry in
      UsageWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Disk")
    .description("Free space")
    .supportedFamilies([.systemSmall])
  }
}
