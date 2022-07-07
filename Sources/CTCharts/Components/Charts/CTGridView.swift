
import UIKit

class CTGridView: UIView, CTCartesianGridProtocol {

    private let layout = CTResponsiveLayout<CGFloat>(
        defaultLayout: 4,
        anySizeClassRuleSet: [
            .init(layout: 6, greaterThanOrEqualToContentSizeCategory: .small),
            .init(layout: 8, greaterThanOrEqualToContentSizeCategory: .medium),
            .init(layout: 10, greaterThanOrEqualToContentSizeCategory: .large),
            .init(layout: 12, greaterThanOrEqualToContentSizeCategory: .extraLarge),
            .init(layout: 14, greaterThanOrEqualToContentSizeCategory: .accessibilityMedium),
            .init(layout: 16, greaterThanOrEqualToContentSizeCategory: .accessibilityLarge),
            .init(layout: 18, greaterThanOrEqualToContentSizeCategory: .accessibilityExtraLarge)
        ]
    )

    private var gridLayer = CTGridLayer()
    
    var isGridHiden: Bool {
        get { return gridLayer.isHidden }
        set { gridLayer.isHidden = newValue }
    }
    
    private var limitLayer = CTLimitLineLayer()

    var isLimitHiden: Bool {
        get { return limitLayer.isHidden }
        set { limitLayer.isHidden = newValue }
    }
    
    var limitLinePoint: Int {
        get { return limitLayer.limitLinePoint }
        set { limitLayer.limitLinePoint = newValue }
    }
    
    var numberFormatter: NumberFormatter {
        get { gridLayer.numberFormatter }
        set {
            gridLayer.numberFormatter = newValue
            limitLayer.numberFormatter = newValue
        }
    }

    var numberOfDivisions: Int {
        return gridLayer.numberOfVerticalDivisions
    }

    var xMinimum: CGFloat? {
        get { return gridLayer.xMinimum }
        set {
            gridLayer.xMinimum = newValue
            limitLayer.xMinimum = newValue
        }
    }

    var xMaximum: CGFloat? {
        get { return gridLayer.xMaximum }
        set {
            gridLayer.xMaximum = newValue
            limitLayer.xMaximum = newValue
        }
    }

    var yMinimum: CGFloat? {
        get { return gridLayer.yMinimum }
        set {
            gridLayer.yMinimum = newValue
            limitLayer.yMinimum = newValue
        }
    }

    var yMaximum: CGFloat? {
        get { return gridLayer.yMaximum }
        set {
            gridLayer.yMaximum = newValue
            limitLayer.yMaximum = newValue
        }
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

        let fontSize = layout.responsiveLayoutRule(traitCollection: traitCollection)
        gridLayer.fontSize = fontSize
        gridLayer.isHidden = false
        self.layer.addSublayer(gridLayer)
        
        limitLayer.fontSize = fontSize
        limitLayer.isHidden = true
        self.layer.addSublayer(limitLayer)
        
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let fontSize = layout.responsiveLayoutRule(traitCollection: traitCollection)
        gridLayer.fontSize = fontSize
        limitLayer.fontSize = fontSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridLayer.frame = self.bounds
        limitLayer.frame = self.bounds
    }
}
