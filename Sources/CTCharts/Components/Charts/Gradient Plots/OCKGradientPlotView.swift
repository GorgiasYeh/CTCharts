/*
 Copyright (c) 2019, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3. Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

private let accessibilityElementBoundingBoxSize = CGSize(width: 10, height: 10)

/// This is an abstract base class for plots that use a gradient mask.
class OCKGradientPlotView<LayerType: OCKCartesianCoordinatesLayer> : UIView, OCKGradientPlotable, OCKMultiPlotable, PlotViewDisplayable {
    
    public weak var delegate: PlotViewDelegate?
    
    let gradientLayer = CAGradientLayer()
    let pointsLayer = CAShapeLayer()

    func makePath(points: [CGPoint]) -> CGPath {
        return UIBezierPath().cgPath
    }

    var dataSeries: [OCKDataSeries] = [] {
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
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(OCKGradientPlotView.longPress(recognizer:)))

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
            self.delegate?.beganSelectPlotDataPoints()
            
        } else if recognizer.state == .ended {
            print("長按結束")
            selectIndex = -1
            selectLayer.startColor = .clear
            selectLayer.endColor = .clear
            self.delegate?.endedSelectPlotDataPoints()
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
            
            self.delegate?.didSelectPlotDataPoints(dataSeries, index)
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
