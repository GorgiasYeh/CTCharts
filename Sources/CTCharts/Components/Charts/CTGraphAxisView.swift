
import UIKit

class CTGraphAxisView: UIView {
    var axisMarkers = [String]() {
        didSet { redrawLabels() }
    }

    var selectedIndex: Int? {
        didSet { redrawLabels() }
    }

    private var tickViews = [CTCircleLabelView]()

    private func redrawLabels() {
        tickViews.forEach { $0.removeFromSuperview() }
        tickViews = axisMarkers.enumerated().map { index, text in
            let view = CTCircleLabelView(textStyle: .callout)
            view.frame = frameForMarker(atIndex: index)
            view.label.text = text
            view.label.textAlignment = .center
            view.label.isAccessibilityElement = false
            view.isSelected = index == selectedIndex
            return view
        }
        tickViews.forEach(addSubview)
    }

    private func frameForMarker(atIndex index: Int) -> CGRect {
        guard !axisMarkers.isEmpty else { return .zero }
        guard axisMarkers.count > 1 else { return bounds }
        let spacing = bounds.width / CGFloat(axisMarkers.count - 1)
        let centerX = spacing * CGFloat(index)
        let origin = CGPoint(x: centerX - spacing / 2, y: 0)
        let size = CGSize(width: spacing, height: bounds.height)
        let rect = CGRect(origin: origin, size: size)
        return rect
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tickViews.enumerated().forEach { index, view in
            view.frame = frameForMarker(atIndex: index)
        }
    }
}

private class CTCircleLabelView: CTView {
    let label: CTLabel

    var circleLayer: CAShapeLayer {
        guard let layer = layer as? CAShapeLayer else { fatalError("Unsupported type.") }
        return layer
    }

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        applyTintColor()
    }

    var isSelected: Bool = false {
        didSet {
            updateLabelColor()
            circleLayer.fillColor = isSelected ? tintColor.cgColor : nil
        }
    }

    init(textStyle: UIFont.TextStyle) {
        label = CTCappedSizeLabel(textStyle: .caption1, weight: .medium)
        super.init()
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported initializer")
    }

    override func setup() {
        super.setup()
        addSubview(label)
        updateLabelColor()
        applyTintColor()

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            label.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 4.0
        let maxDimension = max(label.intrinsicContentSize.width, label.intrinsicContentSize.height) + padding
        let size = CGSize(width: maxDimension, height: maxDimension)
        let origin = CGPoint(x: label.center.x - maxDimension / 2, y: label.center.y - maxDimension / 2)

        circleLayer.path = UIBezierPath(ovalIn: CGRect(origin: origin, size: size)).cgPath
        circleLayer.fillColor = isSelected ? tintColor.cgColor : nil
    }

    private func updateLabelColor() {
        label.textColor = isSelected ? style().color.customBackground : style().color.label
    }

    override func styleDidChange() {
        super.styleDidChange()
        updateLabelColor()
    }

    private func applyTintColor() {
        // Note: If animation is not disabled, the axis will fly in from the top of the view.
        CATransaction.performWithoutAnimations {
            circleLayer.fillColor = isSelected ? tintColor.cgColor : nil
        }
    }
}
