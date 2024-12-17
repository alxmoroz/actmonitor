// Copyright (c) 2021. Alexandr Moroz

import SwiftUI

let _lineWidth: CGFloat = 15
let _padding: CGFloat = 8

struct ChartView: View {
  let title: String
  let labels: [LabelData]
  let slices: [SliceData]
  let valuesSum : Int;

  var sliceViews: [SliceView]
  
  init(title: String, labels: [LabelData], slices: [SliceData], valuesSum: Int) {
    
    self.title = title
    self.labels = labels
    self.slices = slices
    self.valuesSum = valuesSum
    self.sliceViews = []

    var startDegree: Int = 0;
    for (_, slice) in slices.enumerated() {
      let delta = 360 * slice.value / valuesSum;
      sliceViews.append(SliceView(startDegree: startDegree, endDegree: startDegree + delta, color: slice.color))
      startDegree += delta;
    }
  }
  
  var body: some View {
    ZStack {
        ForEach(0 ..< sliceViews.count, id: \.self) { i in
          sliceViews[i]
        }
        VStack(spacing: 4, content: {
          Text(title).bold()
          ForEach(0 ..< labels.count, id: \.self) {i in
            LabelView(data: labels[i])
          }
          Spacer().frame(height: 10)
        }).padding(_lineWidth * 1.5)
    }.padding(_padding)
  }
  
  struct SliceView: View {
    var startDegree: Int
    var endDegree: Int
    var color: Color
    
    var body: some View {
      GeometryReader { geometry in
        let halfSize: CGFloat = min(geometry.size.width, geometry.size.height) / 2
        Path { path in
          path.addArc(
            center: CGPoint(x: halfSize, y: halfSize),
            radius: halfSize - _lineWidth / 2,
            startAngle: Angle(degrees: Double(startDegree) - 90),
            endAngle: Angle(degrees: Double(endDegree) - 90),
            clockwise: false
          )
        }
        .stroke(color, lineWidth: _lineWidth)
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
  let color: Color
  let value: Int
}

struct LabelData {
  let color: Color
  let title: String
  let value: String
  var oneLine: Bool? = false
}
