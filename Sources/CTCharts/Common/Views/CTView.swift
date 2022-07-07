
import UIKit

open class CTView: UIView, CTStylable {
    var customStyle: CTStyler? {
        didSet { styleChildren() }
    }

    public init() {
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        preservesSuperviewLayoutMargins = true
        styleDidChange()
    }

    open func styleDidChange() {}

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        styleDidChange()
    }

    override open func removeFromSuperview() {
        super.removeFromSuperview()
        styleChildren()
    }
}
