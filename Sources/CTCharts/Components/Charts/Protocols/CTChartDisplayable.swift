
import UIKit

/// Any object that can display and handle interactions with a chart.
public protocol CTChartDisplayable: AnyObject {
    /// Handles events related to an `CTChartDisplayable` object.
    var delegate: CTChartViewDelegate? { get set }
}

/// Handles events related to an `CTChartDisplayable` object.
public protocol CTChartViewDelegate: AnyObject {
    
    /// Called when the view displaying the chart was selected.
    /// - Parameter chartView: The view displaying the chart.
    func didSelectChartView(_ chartView: UIView & CTChartDisplayable)
    
    
    /// 當長按時回傳ChartView和最近的資料點位置
    /// - Parameters:
    ///   - chartView: ChartView
    ///   - selectIndex: 觸控點最近的資料點位置
    func didSelectPlotDataPoints(_ chartView: UIView & CTChartDisplayable, _ selectIndex: Array.Index)
}
