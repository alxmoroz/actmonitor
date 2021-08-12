// Copyright (c) 2021. Alexandr Moroz

import SwiftUI

public struct ChartView: View {
  public let title: String
  public let mainLabel: String
  public let mainValue: String
  public let values: [Int64]
  public var colors: [Color]
  public var lineWidthFraction: CGFloat
  
  var slices: [SliceData] {
    let sum = Double(values.reduce(0, +))
    var endDeg: Double = 0
    var tempSlices: [SliceData] = []
    
    for (i, value) in values.enumerated() {
      let degrees:Double = 360.0 * Double(value) / sum
      tempSlices.append(
        SliceData(
          startAngle: Angle(degrees: endDeg),
          endAngle: Angle(degrees: endDeg + degrees),
          color: self.colors[i]
        ))
      endDeg += degrees
    }
    return tempSlices
  }
  
  public init(
    title: String,
    mainLabel: String,
    mainValue: String,
    values:[Int64],
    colors: [Color],
    lineWidthFraction: CGFloat = 0.12) {
    
    self.title = title
    self.mainLabel = mainLabel
    self.mainValue = mainValue
    self.values = values
    self.colors = colors
    self.lineWidthFraction = lineWidthFraction
  }
  
  public var body: some View {
    VStack(spacing: 4, content: {
      Text(title)
      GeometryReader { geometry in
        let size: CGFloat = min(geometry.size.width, geometry.size.height)
        HStack {
          Spacer()
          ZStack {
            ForEach(0..<self.values.count) { i in
              ChartSlice(sliceData: self.slices[i], lineWidth: size * lineWidthFraction)
            }
            VStack{
              Text(mainLabel).foregroundColor(Color.gray)
              Text(mainValue)
              Text("")
            }
          }
          .frame(width: size, height: size)
          Spacer()
        }
      }
    })
    .padding(8)
    .background(Color(UIColor.systemGray6))
  }
  
  struct ChartSlice: View {
    var sliceData: SliceData
    var lineWidth: CGFloat
    
    var body: some View {
      GeometryReader { geometry in
        Path { path in
          let size: CGFloat = min(geometry.size.width, geometry.size.height)
          path.addArc(
            center: CGPoint(x: size / 2, y: size / 2),
            radius: size / 2 - lineWidth / 2,
            startAngle: Angle(degrees: -90.0) + sliceData.startAngle,
            endAngle: Angle(degrees: -90.0) + sliceData.endAngle,
            clockwise: false
          )
        }
        .stroke(sliceData.color, lineWidth: lineWidth)
      }
    }
  }
  
  struct SliceData {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
  }
}
