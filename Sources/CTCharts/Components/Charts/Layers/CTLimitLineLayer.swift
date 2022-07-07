//
//  CTLimitLineLayer.swift
//  
//
//  Created by Gorgias on 2022/5/27.
//

import UIKit

/// This layer shows horizontal limit lines and is intended to be added as a background to various kinds of graphs.
class CTLimitLineLayer: CTCartesianCoordinatesLayer {
    private enum Constants {
        static let margin: CGFloat = 8
    }

    /// A number formatter used for the vertical axis values.
    var numberFormatter = NumberFormatter()

    /// 標示線位置
    var limitLinePoint = 0 {
        didSet { setNeedsLayout() }
    }

    /// The color of the limit lines.
    var limitLineColor: UIColor = CTStyle().color.label {
        didSet {
            limitLines.strokeColor = limitLineColor.cgColor
        }
    }

    /// 寬度
    var limitLineWidth: CGFloat = 4 {
        didSet {
            limitLines.lineWidth = limitLineWidth
        }
    }

    /// 透明度
    var limitLineOpacity: CGFloat = 0.8 {
        didSet {
            limitLines.opacity = Float(limitLineOpacity)
        }
    }

    /// 字體大小
    var fontSize: CGFloat = 10 {
        didSet { setNeedsLayout() }
    }

    let limitLines = CAShapeLayer()
    let limitValueLayer = CATextLayer()

    /// Create an instance of a limit layer.
    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /// Create an instance of a limit layer by specifying the layer class.
    ///
    /// - Parameter layer: Layer class to use as this object's layer.
    override init(layer: Any) {
        super.init(layer: layer)
        setup()
    }

    func setup() {
        addSublayer(limitLines)
        addSublayer(limitValueLayer)
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        redraw()
    }

    private func redraw() {
        drawLimitLines()
        drawLimitValue()
    }

    private func drawLimitLines() {
        limitLines.path = pathForLimitLines().cgPath
        //虛線
//        limitLines.lineDashPattern = [2, 2]
        limitLines.lineCap = .round
        limitLines.lineWidth = limitLineWidth
        limitLines.strokeColor = limitLineColor.cgColor
        limitLines.opacity = Float(limitLineOpacity)
        limitLines.fillColor = nil
        limitLines.frame = bounds
    }

    private func drawLimitValue() {
        limitValueLayer.contentsScale = UIScreen.main.scale
        limitValueLayer.string = numberFormatter.string(for: limitLinePoint)
        limitValueLayer.foregroundColor = limitLineColor.cgColor
        limitValueLayer.fontSize = fontSize
        let frameY = limitLineHeights() - fontSize - (limitLineWidth / 2) - 3
        limitValueLayer.frame = CGRect(origin: CGPoint(x: Constants.margin, y: frameY), size: CGSize(width: 100, height: 44))
    }

    private func pathForLimitLines() -> UIBezierPath {
        let path = UIBezierPath()
        let lineHeight = limitLineHeights()
        path.move(to: CGPoint(x: 0, y: lineHeight))
        path.addLine(to: CGPoint(x: bounds.width, y: lineHeight))
        return path
    }
    
    private func limitLineHeights() -> CGFloat {
        let spacing =  bounds.height / CGFloat(graphBounds().maxY)
        return bounds.height - ( spacing * CGFloat(limitLinePoint))
    }
}
