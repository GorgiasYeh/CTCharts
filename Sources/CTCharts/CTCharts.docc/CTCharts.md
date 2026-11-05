# ``CTCharts``

Health-style line and bar charts for UIKit apps, supporting iOS 11 and later.

## Overview

Apple's Swift Charts works only with SwiftUI and requires iOS 16. CTCharts is for UIKit apps
that need charts like the Health app without SwiftUI or a high minimum iOS version.

CTCharts is based on the chart components of Apple's [CareKit](https://github.com/carekit-apple/CareKit),
extracted into a standalone package and extended with:

- A limit line to mark a target value
- Long-press selection that reports the nearest data point
- Support for iOS 11 (CareKit requires iOS 13)
- Swift Package Manager and CocoaPods distribution

## Topics

### Essentials

- <doc:GettingStarted>
- ``CTCartesianChartView``
- ``CTCartesianGraphView``
- ``CTDataSeries``

### Responding to Interaction

- ``CTChartViewDelegate``
- ``CTChartDisplayable``
