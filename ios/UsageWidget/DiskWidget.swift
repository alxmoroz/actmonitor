// Copyright (c) 2021. Alexandr Moroz

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> UsageEntry {
    return UsageEntry.getEntry()
  }
  
  func getSnapshot(in context: Context, completion: @escaping (UsageEntry) -> ()) {
    completion(UsageEntry.getEntry())
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let timeline = Timeline(
      entries: [UsageEntry.getEntry()],
      policy: .atEnd
    )
    completion(timeline)
  }
}

struct UsageEntry: TimelineEntry {
  let date: Date
  let freeDiskSpace: Int64
  let totalDiskSpace: Int64
  
  static func getEntry() -> UsageEntry {
    let diskData = Usage._getDiskUsage()
    return UsageEntry(date: Date(), freeDiskSpace: diskData[0], totalDiskSpace: diskData[1])
  }
}

struct UsageWidgetEntryView : View {
  var entry: Provider.Entry
  
  let formatter = ByteCountFormatter()
  var body: some View {
    ChartView(
      title: "Disk",
      mainLabel: "Free",
      mainValue: formatter.string(fromByteCount: Int64(entry.freeDiskSpace)),
      values: [Double(entry.totalDiskSpace - entry.freeDiskSpace), Double(entry.freeDiskSpace)],
      colors: [Color.blue, FreeColor]
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
