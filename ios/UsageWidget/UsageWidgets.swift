// Copyright (c) 2021. Alexandr Moroz

import WidgetKit
import SwiftUI

let FreeColor = Color(UIColor.systemGray3)

@main
struct UsageWidgets: WidgetBundle {
  @WidgetBundleBuilder
  var body: some Widget {
    DiskWidget()
    RamWidget()
  }
}
