# CTCharts

Health-style line and bar charts for **UIKit** apps. Supports **iOS 11+**.

[Documentation](https://gorgiasyeh.github.io/CTCharts/documentation/ctcharts/) · Swift Package Manager · CocoaPods

## Why

Apple's Swift Charts works only with SwiftUI and needs iOS 16.
CTCharts is for UIKit apps that want charts like the Health app, without SwiftUI and without raising the minimum iOS version.

## Features

- Line chart and bar chart, with gradient colors
- Limit line to mark a target value
- Long-press to select a data point (delegate callback with the index)
- Header with title and detail text
- iOS 11 and later

## Based on CareKit

CTCharts is based on the chart components of Apple's [CareKit](https://github.com/carekit-apple/CareKit) (BSD-3-Clause).
I extracted the charts into a standalone package and added:

| Added | Notes |
| --- | --- |
| Limit line | `isLimitHiden`, `limitLinePoint` |
| Data point selection | long press, `CTChartViewDelegate.didSelectPlotDataPoints` |
| iOS 11 support | CareKit needs iOS 13 |
| Packaging | Swift Package Manager and CocoaPods |
| Documentation | DocC, built and published by GitHub Actions on every push |

## Requirements

- iOS 11+
- Swift 5.6+

## Installation

### Swift Package Manager

In Xcode, choose **File > Add Package Dependencies** and enter:

```
https://github.com/GorgiasYeh/CTCharts.git
```

### CocoaPods

```ruby
pod 'CTCharts', :git => 'https://github.com/GorgiasYeh/CTCharts.git'
```

## Usage

```swift
import CTCharts

// Data
let points = (0...30).map { CGPoint(x: CGFloat($0), y: CGFloat(Int.random(in: 1000...12000))) }
var steps = CTDataSeries(dataPoints: points, title: "Steps", color: .green)
steps.size = 7
steps.gradientStartColor = .orange
steps.gradientEndColor = .red

// Chart
let chart = CTCartesianChartView(type: .bar)
view.addSubview(chart)

chart.headerView.titleLabel.text = "Steps in June"
chart.headerView.detailLabel.text = "Goal: 3,500 steps a day"
chart.delegate = self
chart.graphView.isHidenSelectLayer = false
chart.graphView.dataSeries = [steps]
chart.graphView.yMinimum = 0
chart.graphView.yMaximum = 15000
chart.graphView.xMinimum = 0
chart.graphView.xMaximum = 30
chart.graphView.horizontalAxisMarkers = ["6/1", "6/30"]

// Limit line
chart.graphView.isLimitHiden = false
chart.graphView.limitLinePoint = 3500
```

More in [Getting Started](https://gorgiasyeh.github.io/CTCharts/documentation/ctcharts/gettingstarted).

## Documentation

The documentation is written with [DocC](https://www.swift.org/documentation/docc/)
(`Sources/CTCharts/CTCharts.docc`). GitHub Actions builds it with `xcodebuild docbuild`
and publishes it to GitHub Pages on every push to `main` (see `.github/workflows/docs.yml`).

To build it locally: in Xcode, choose **Product > Build Documentation**.

## Author

Gorgias Yeh · [GitHub](https://github.com/GorgiasYeh) · [LinkedIn](https://www.linkedin.com/in/yehchangtai)

## License

BSD-3-Clause. Includes code from CareKit, Copyright (c) 2019 Apple Inc. See [LICENSE.md](LICENSE.md).
