// Copyright (c) 2021. Alexandr Moroz

import WidgetKit
import SwiftUI
import Flutter

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> UsageEntry {
    UsageEntry(date: Date(), freeDiskSpace: 0, totalDiskSpace: 0)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (UsageEntry) -> ()) {
    let entry = UsageEntry(date: Date(), freeDiskSpace: 0, totalDiskSpace: 0)
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [UsageEntry] = []
    
    let diskData = Usage._getDiskUsage()
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = UsageEntry(date: entryDate, freeDiskSpace: diskData[0], totalDiskSpace: diskData[1])
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct UsageEntry: TimelineEntry {
  let date: Date
  let freeDiskSpace: Int64
  let totalDiskSpace: Int64
}

struct UsageWidgetEntryView : View {
  var entry: Provider.Entry
  
  let formatter = ByteCountFormatter()
  var body: some View {
    ChartView(
      title: "Disk",
      mainLabel: "Free",
      mainValue: formatter.string(fromByteCount: Int64(entry.freeDiskSpace)),
      values: [Double(entry.freeDiskSpace), Double(entry.totalDiskSpace - entry.freeDiskSpace)],
      colors: [Color.gray, Color.blue]
    )
  }
}

@main
struct UsageWidget: Widget {
  let kind: String = "UsageWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      UsageWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("")
    .description("")
  }
}
