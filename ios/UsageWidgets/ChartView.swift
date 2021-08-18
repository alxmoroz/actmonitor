// Copyright (c) 2021. Alexandr Moroz

import SwiftUI

struct ChartView: View {
  let title: String
  let labels: [LabelData]
  let slices: [SliceData]
  
  var valuesSum: Double {
    var sum : Double = 0;
    for (_, slice) in slices.enumerated() {
      sum += Double(slice.value)
    }
    return sum
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(0..<slices.count) { i in
          SliceView(data: slices[i], valuesSum:valuesSum, lineWidth: 14)
        }
        VStack(spacing: 4, content: {
          Text(title).bold()
          ForEach(0..<labels.count) {i in
            LabelView(data: labels[i])
          }
          Text("")
        }).padding(24)
      }
    }
    .padding(6)
    .background(Color(UIColor.systemGray6))
  }
  
  struct SliceView: View {
    var data: SliceData
    var valuesSum: Double
    var lineWidth: CGFloat
    
    static var startDegree: Double = 0;
    
    var body: some View {
      GeometryReader { geometry in
        Path { path in
          let size: CGFloat = min(geometry.size.width, geometry.size.height)
          let delta: Double = 360.0 * Double(data.value) / valuesSum;
          path.addArc(
            center: CGPoint(x: size / 2, y: size / 2),
            radius: size / 2 - lineWidth / 2,
            startAngle: Angle(degrees: -90.0 + SliceView.startDegree),
            endAngle: Angle(degrees: -90.0 + SliceView.startDegree + delta),
            clockwise: false
          )
          SliceView.startDegree += delta;
        }
        .stroke(data.color, lineWidth: lineWidth)
      }
    }
  }
  
  struct LabelView : View {
    var data : LabelData
    
    var body: some View {
      if (data.oneLine!) {
        HStack (spacing: 0, content: {
          Text(data.title).foregroundColor(data.color)
          Spacer(minLength: 2)
          Text(data.value)
        })
      } else {
        VStack{
          Text(data.title).foregroundColor(Color.gray)
          Text(data.value)
        }
      }
    }
  }
}

struct SliceData {
  var color: Color
  var value: Int
}

struct LabelData {
  var color: Color
  var title: String
  var value: String
  var oneLine: Bool? = false
}
