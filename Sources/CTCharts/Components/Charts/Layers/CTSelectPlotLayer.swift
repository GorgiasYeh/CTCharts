//
//  SelectPlotLayer.swift
//  
//
//  Created by Gorgias on 2022/5/26.
//

import UIKit

class CTSelectPlotLayer: OCKCartesianCoordinatesLayer, OCKGradientPlotable {
    let gradientLayer = CAGradientLayer()
    let pointsLayer = CAShapeLayer()

    var startColor: UIColor = OCKStyle().color.customGray {
        didSet { gradientLayer.colors = [startColor.cgColor, endColor.cgColor] }
    }

    var endColor: UIColor = OCKStyle().color.customGray {
        didSet { gradientLayer.colors = [startColor.cgColor, endColor.cgColor] }
    }

    var barWidth: CGFloat = 2 {
        didSet { setNeedsLayout() }
    }

    var horizontalOffset: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    override init() {
        super.init()
        setupSublayers()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        setupSublayers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSublayers()
    }

    private func setupSublayers() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.mask = pointsLayer
        addSublayer(gradientLayer)

        pointsLayer.fillColor = OCKStyle().color.customGray.cgColor
        pointsLayer.strokeColor = nil
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        drawPoints(points)
    }

    override func animateInGraphCoordinates(from oldPoints: [CGPoint], to newPoints: [CGPoint]) {
//        let grow = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
//        grow.fromValue = pointsLayer.presentation()?.path ?? makePath(points: oldPoints)
//        grow.toValue = makePath(points: newPoints)
//        grow.timingFunction = CAMediaTimingFunction(name: .easeOut)
//        grow.duration = 1.0
//        pointsLayer.add(grow, forKey: "grow")
    }

    func makePath(points: [CGPoint]) -> CGPath {
        let path = UIBezierPath()
        for point in points {
            let origin = CGPoint(x: point.x - barWidth / 2 + horizontalOffset, y: 0)
            let size = CGSize(width: barWidth, height: bounds.height)
            let rectangle = CGRect(origin: origin, size: size)
            let cornerRadii = CGSize(width: barWidth / 4, height: barWidth / 4)
            let rectPath = UIBezierPath(roundedRect: rectangle, byRoundingCorners: [.topLeft, .topRight], cornerRadii: cornerRadii)
            path.append(rectPath)
        }
        return path.cgPath
    }
}
