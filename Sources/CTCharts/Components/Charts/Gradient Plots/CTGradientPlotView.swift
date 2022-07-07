
import UIKit

private let accessibilityElementBoundingBoxSize = CGSize(width: 10, height: 10)

/// This is an abstract base class for plots that use a gradient mask.
class CTGradientPlotView<LayerType: CTCartesianCoordinatesLayer> : UIView, CTGradientPlotable, CTMultiPlotable {
    
    let gradientLayer = CAGradientLayer()
    let pointsLayer = CAShapeLayer()

    func makePath(points: [CGPoint]) -> CGPath {
        return UIBezierPath().cgPath
    }

    var dataSeries: [CTDataSeries] = [] {
        didSet { resetLayers() }
    }

    var xMinimum: CGFloat? {
        didSet { seriesLayers.forEach { $0.xMinimum = xMinimum } }
    }

    var xMaximum: CGFloat? {
        didSet { seriesLayers.forEach { $0.xMaximum = xMaximum } }
    }

    var yMinimum: CGFloat? {
        didSet { seriesLayers.forEach { $0.yMinimum = yMinimum } }
    }

    var yMaximum: CGFloat? {
        didSet { seriesLayers.forEach { $0.yMaximum = yMaximum } }
    }

    var seriesLayers: [LayerType] = []
    
    private let selectLayer = CTSelectPlotLayer()
    
    var isHidenSelectLayer: Bool {
        get { return selectLayer.isHidden }
        set { selectLayer.isHidden = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // 長按
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(CTGradientPlotView.longPress(recognizer:)))

        // 為視圖加入監聽手勢
        self.addGestureRecognizer(longPress)
        self.layer.addSublayer(selectLayer)
        selectLayer.startColor = .clear
        selectLayer.endColor = .clear
        selectLayer.setPlotBounds(rect: graphBounds())
        selectLayer.frame = bounds
        isHidenSelectLayer = true
    }
    
    var selectIndex = -1
    
    // 觸發長按手勢後 執行的動作
    @objc func longPress(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            print("長按開始")
            self.beganSelectPlotDataPoints()
            
        } else if recognizer.state == .ended {
            print("長按結束")
            selectIndex = -1
            selectLayer.startColor = .clear
            selectLayer.endColor = .clear
            self.endedSelectPlotDataPoints()
        }
        
        if recognizer.state != .ended {
            let point = recognizer.location(ofTouch: 0, in: recognizer.view)
    //        print("第 1 指的位置：\(NSCoder.string(for: point))")
            let index = findClosest(value: point.x, array: graphSpacePointsX)
            let dataPoint = dataSeries.first?.dataPoints[index]
            
            if selectIndex != index {
                selectLayer.startColor = .gray
                selectLayer.endColor = .gray
                selectIndex = index
                selectLayer.dataPoints = [dataPoint!]
                selectLayer.setPlotBounds(rect: graphBounds())
                selectLayer.frame = bounds
            }
            
            self.didSelectPlotDataPoints(index)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 75)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        seriesLayers.forEach { $0.frame = bounds }
        resetGraphSpacePointsX()
    }

    func resetLayers() {
        if let dataPoint = dataSeries.first?.dataPoints.first {
            selectLayer.dataPoints = [dataPoint]
        }
    }
    
    var graphSpacePointsX:[CGFloat] = []
    
    func findClosest(value:CGFloat, array:[CGFloat]) -> Array.Index {
        let subArray = array.map {$0 - value}.map{ $0 < 0 ? $0 * -1 : $0 }
        guard let index = subArray.firstIndex(of: subArray.min()!) else { return -1 }
        return index
    }
    
    func resetGraphSpacePointsX() {
        graphSpacePointsX = []
        dataSeries.enumerated().forEach { seriesIndex, series in
            series.dataPoints.enumerated().forEach { pointIndex, point in

                let pointInViewSpace = seriesLayers[seriesIndex].convert(graphSpacePoints: [point]).first!
                graphSpacePointsX.append(pointInViewSpace.x)
            }
        }
    }
}
