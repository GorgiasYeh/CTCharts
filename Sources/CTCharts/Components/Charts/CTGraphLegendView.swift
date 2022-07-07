
import UIKit

class CTGraphLegendView: UIStackView {
    private enum Constants {
        static let iconCornerRadius: CGFloat = 4.0
        static let iconPadding: CGFloat = 6.0
        static let keySpacing: CGFloat = 10.0
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setDataSeries(_ dataSeries: [CTDataSeries]) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        dataSeries.map(makeKey).forEach(addArrangedSubview)
    }

    private func setup() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = Constants.keySpacing
    }

    private func makeKey(for series: CTDataSeries) -> UIView {
        let icon = makeIcon(startColor: series.gradientStartColor ?? tintColor, endColor: series.gradientEndColor ?? tintColor)
        let label = makeLabel(title: series.title, color: series.gradientStartColor ?? tintColor)
        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = Constants.iconPadding
        return stack
    }

    private func makeLabel(title: String, color: UIColor) -> UIView {
        let label = CTCappedSizeLabel(textStyle: .caption1, weight: .regular)
        label.textAlignment = .left
        label.textColor = color
        label.text = "\(title)"
        label.clipsToBounds = true
        label.isAccessibilityElement = false
        return label
    }

    private func makeIcon(startColor: UIColor, endColor: UIColor) -> UIView {
        let icon = CTGradientView()
        icon.startColor = startColor
        icon.endColor = endColor
        icon.clipsToBounds = true
        icon.layer.cornerRadius = Constants.iconCornerRadius
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalTo: icon.widthAnchor).isActive = true
        return icon
    }
}

private class CTGradientView: CTView {
    var startColor: UIColor = CTStyle().color.customGray2 {
        didSet { gradient.colors = [startColor.cgColor, endColor.cgColor] }
    }

    var endColor: UIColor = CTStyle().color.customGray2 {
        didSet { gradient.colors = [startColor.cgColor, endColor.cgColor] }
    }

    private var gradient: CAGradientLayer {
        guard let layer = layer as? CAGradientLayer else { fatalError("Unsupported type") }
        return layer
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func setup() {
        super.setup()
        setupGradient()
    }

    private func setupGradient() {
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
    }
}
