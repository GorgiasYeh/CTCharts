# Getting Started with CTCharts

Add a bar or line chart to a UIKit view.

## Overview

A chart has two parts: a ``CTCartesianChartView``, which provides the header and container,
and its ``CTCartesianChartView/graphView``, which draws one or more ``CTDataSeries``.

### Install the package

In Xcode, choose **File > Add Package Dependencies** and enter:

```
https://github.com/GorgiasYeh/CTCharts.git
```

Or add it to your `Podfile`:

```ruby
pod 'CTCharts', :git => 'https://github.com/GorgiasYeh/CTCharts.git'
```

### Create the data

Create a ``CTDataSeries`` from points. A gradient color is optional.

```swift
import CTCharts

let points = (0...30).map { CGPoint(x: CGFloat($0), y: CGFloat(Int.random(in: 1000...12000))) }

var steps = CTDataSeries(dataPoints: points, title: "Steps", color: .green)
steps.size = 7
steps.gradientStartColor = .orange
steps.gradientEndColor = .red
```

### Show the chart

Create the chart view with a plot type, then set the data and the axis range.

```swift
let chart = CTCartesianChartView(type: .bar)
view.addSubview(chart)

chart.headerView.titleLabel.text = "Steps in June"
chart.headerView.detailLabel.text = "Goal: 3,500 steps a day"

chart.graphView.dataSeries = [steps]
chart.graphView.yMinimum = 0
chart.graphView.yMaximum = 15000
chart.graphView.xMinimum = 0
chart.graphView.xMaximum = 30
chart.graphView.horizontalAxisMarkers = ["6/1", "6/30"]
```

### Add a limit line

Show a horizontal line to mark a target value.

```swift
chart.graphView.isLimitHiden = false
chart.graphView.limitLinePoint = 3500
```

### Respond to selection

Set a delegate to know which data point the user long-pressed.

```swift
chart.delegate = self
chart.graphView.isHidenSelectLayer = false

extension ViewController: CTChartViewDelegate {
    func didSelectChartView(_ chartView: UIView & CTChartDisplayable) {}

    func didSelectPlotDataPoints(_ chartView: UIView & CTChartDisplayable, _ selectIndex: Array.Index) {
        print("Selected index:", selectIndex)
    }
}
```
