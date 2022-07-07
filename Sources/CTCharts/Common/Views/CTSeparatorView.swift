
import Foundation
import UIKit

/// Horizontal separator view.
class CTSeparatorView: CTView {
    // MARK: Properties

    private var heightConstraint: NSLayoutConstraint?

    // MARK: Methods

    override func setup() {
        super.setup()
        constrainSubviews()
        styleDidChange()
    }

    private func constrainSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        styleDidChange()
    }

    override open func removeFromSuperview() {
        super.removeFromSuperview()
        styleChildren()
    }

    override open func styleDidChange() {
        super.styleDidChange()
        let cachedStyle = style()
        backgroundColor = cachedStyle.color.separator
        heightConstraint?.constant = cachedStyle.dimension.separatorHeight
    }
}
