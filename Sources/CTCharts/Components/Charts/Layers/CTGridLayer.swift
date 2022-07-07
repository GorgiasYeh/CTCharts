
import UIKit

/// This layer shows horizontal grid lines and is intended to be added as a background to various kinds of graphs.
class CTGridLayer: CTCartesianCoordinatesLayer {
    private enum Constants {
        static let margin: CGFloat = 16
    }

    /// A number formatter used for the vertical axis values.
    var numberFormatter = NumberFormatter()

    /// The number of vertical lines in the grid.
    var numberOfVerticalDivisions = 4 {
        didSet { setNeedsLayout() }
    }

    /// The color of the grid lines.
    var gridLineColor: UIColor = CTStyle().color.customGray {
        didSet {
            bottomGridLine.strokeColor = gridLineColor.cgColor
            gridLines.strokeColor = gridLineColor.cgColor
        }
    }

    var gridLineWidth: CGFloat = 0.7 {
        didSet {
            gridLines.lineWidth = gridLineWidth
            bottomGridLine.lineWidth = gridLineWidth
        }
    }

    var gridLineOpacity: CGFloat = 0.25 {
        didSet {
            gridLines.opacity = Float(gridLineOpacity)
            bottomGridLine.opacity = Float(gridLineOpacity)
        }
    }

    var fontSize: CGFloat = 10 {
        didSet { setNeedsLayout() }
    }

    let gridLines = CAShapeLayer()
    let bottomGridLine = CAShapeLayer()
    let topValueLayer = CATextLayer()
    let middleValueLayer = CATextLayer()

    /// Create an instance of a grid layer.
    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /// Create an instance of a grid layer by specifying the layer class.
    ///
    /// - Parameter layer: Layer class to use as this object's layer.
    override init(layer: Any) {
        super.init(layer: layer)
        setup()
    }

    func setup() {
        addSublayer(gridLines)
        addSublayer(bottomGridLine)
        addSublayer(topValueLayer)
        addSublayer(middleValueLayer)
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        redraw()
    }

    private func redraw() {
        drawBottomGridLine()
        drawMiddleGridLines()
        drawTopValue()
        drawMiddleValue()
    }

    private func drawBottomGridLine() {
        bottomGridLine.path = pathForBottomLine().cgPath
        bottomGridLine.lineCap = .round
        bottomGridLine.lineWidth = gridLineWidth
        bottomGridLine.strokeColor = gridLineColor.cgColor
        bottomGridLine.opacity = Float(gridLineOpacity)
        bottomGridLine.fillColor = nil
        bottomGridLine.frame = bounds
    }

    private func drawMiddleGridLines() {
        gridLines.path = pathForMiddleLines().cgPath
        gridLines.lineDashPattern = [2, 2]
        gridLines.lineWidth = gridLineWidth
        gridLines.strokeColor = gridLineColor.cgColor
        gridLines.opacity = Float(gridLineOpacity)
        gridLines.fillColor = nil
        gridLines.frame = bounds
    }

    private func drawTopValue() {
        topValueLayer.contentsScale = UIScreen.main.scale
        topValueLayer.string = numberFormatter.string(for: graphBounds().maxY)
        topValueLayer.foregroundColor = gridLineColor.cgColor
        topValueLayer.fontSize = fontSize
        topValueLayer.frame = CGRect(origin: CGPoint(x: Constants.margin, y: 0), size: CGSize(width: 100, height: 44))
    }

    private func drawMiddleValue() {
        middleValueLayer.contentsScale = UIScreen.main.scale
        middleValueLayer.string = numberFormatter.string(for: graphBounds().midY)
        middleValueLayer.foregroundColor = gridLineColor.cgColor
        middleValueLayer.fontSize = fontSize
        middleValueLayer.frame = CGRect(origin: CGPoint(x: Constants.margin, y: bounds.height / 2), size: CGSize(width: 100, height: 44))
    }

    private func pathForBottomLine() -> UIBezierPath {
        let bottomLeft = CGPoint(x: 0, y: bounds.height - gridLineWidth / 2)
        let bottomRight = CGPoint(x: bounds.width, y: bounds.height - gridLineWidth / 2)
        let path = UIBezierPath()
        path.move(to: bottomLeft)
        path.addLine(to: bottomRight)
        return path
    }

    private func pathForMiddleLines() -> UIBezierPath {
        let path = UIBezierPath()
        for heigth in middleLineHeights() {
            path.move(to: CGPoint(x: 0, y: heigth))
            path.addLine(to: CGPoint(x: bounds.width, y: heigth))
        }
        return path
    }

    private func middleLineHeights() -> [CGFloat] {
        let spacing = bounds.height / CGFloat(numberOfVerticalDivisions)
        var heights = [CGFloat](repeating: 0, count: numberOfVerticalDivisions)
        for index in 0..<numberOfVerticalDivisions {
            heights[index] = spacing * CGFloat(index)
        }
        return heights
    }
}
