# CTCharts

- - -

A Line Chart & Bar Chart for Storyboard like Health App Use.


## Demo

## Requirements

- iOS 11 +

## Installation

### CocoaPods

```:Podfile
  pod 'CTCharts', :git => "https://github.com/GorgiasYeh/CTCharts.git"
```

### Swift Package Manager

1. Go to File > Add Packages
2. The Add Package dialog appears, by default with Apple packages. 
3. In the upper right hand corner, paste https://github.com/GorgiasYeh/CTCharts.git into the search bar
```SHELL
https://github.com/GorgiasYeh/CTCharts.git
```
4. Hit Return to kick off the search
5. Click Add Package. 

## Usage

```swift
// SetData
    let data30Points1 = Array(0...30).map { (index) in CGPoint(x: CGFloat(index), y: CGFloat(Int.random(in: 1000...12000))) }
    var data30 = CTDataSeries(dataPoints: data30Points1, title: "六月步數", color: .green)
    
    data30.size = 7
    data30.gradientStartColor = .orange
    data30.gradientEndColor = .red
    
// SetChart
    let chart = CTCartesianChartView(type: .bar)
    scrollView.addSubview(chart)
        
    chart.headerView.titleLabel.text = "六月步數"
    chart.headerView.detailLabel.text = "成人平均每日應走3500步"
    chart.delegate = self
    chart.graphView.isHidenSelectLayer = false
    chart.graphView.dataSeries = [data30]
    chart.graphView.yMinimum = 0
    chart.graphView.yMaximum = 15000
    chart.graphView.xMinimum = 0
    chart.graphView.xMaximum = 30
    chart.graphView.horizontalAxisMarkers = ["6/1", "6/30"]
    
```

## Author

## License
