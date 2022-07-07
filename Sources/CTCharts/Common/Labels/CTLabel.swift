
import UIKit

/// A label that handles animating state changes and provides accessibilty features.
///
/// To animate changes to the text, set `animatesTextChanges` to true.
///
/// To have the label automatically change its text size whenever the accessibility content size changes,
/// use the initialzer that takes a `textStyle` and `weight`.
open class CTLabel: UILabel, CTStylable {

    // MARK: Properties

    var customStyle: CTStyler? {
        didSet { styleChildren() }
    }

    /// Flag determining whether to animate text changes.
    public var animatesTextChanges = false

    override open var text: String? {
        get {
            return super.text
        } set {
            guard animatesTextChanges else { super.text = newValue; return; }
            UIView.transition(with: self, duration: style().animation.stateChangeDuration, options: .transitionCrossDissolve, animations: {
                super.text = newValue
            }, completion: nil)
        }
    }

    private let textStyle: UIFont.TextStyle?
    private let weight: UIFont.Weight?

    // MARK: Life Cycle

    /// Create an instance of and `CTLabel`. By default, the label will not animate text changes and will not scale with
    /// accessibility content size changes.
    public init() {
        textStyle = nil
        weight = nil
        super.init(frame: .zero)
        setup()
    }

    /// Create an instance of and `CTLabel`. By default, the label will not animate text changes and will scale with
    /// accessibility content size changes.
    ///
    /// - Parameters:
    ///   - textStyle: The style of the font.
    ///   - weight: The weight of the font.
    public init(textStyle: UIFont.TextStyle, weight: UIFont.Weight) {
        self.textStyle = textStyle
        self.weight = weight
        super.init(frame: .zero)
        font = UIFont.preferredCustomFont(forTextStyle: textStyle, weight: weight)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        textStyle = nil
        weight = nil
        super.init(coder: aDecoder)
        setup()
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard
            let textStyle = textStyle, let weight = weight,
            traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory
        else { return }
        font = UIFont.preferredCustomFont(forTextStyle: textStyle, weight: weight)
    }

    // MARK: Methods

    private func setup() {
        preservesSuperviewLayoutMargins = true
        adjustsFontForContentSizeCategory = false
        styleDidChange()
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        styleDidChange()
    }

    override open func removeFromSuperview() {
        super.removeFromSuperview()
        styleChildren()
    }

    open func styleDidChange() {}
}
