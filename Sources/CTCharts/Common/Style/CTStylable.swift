
import UIKit

// An object that can be styled.
protocol CTStylable: AnyObject {
    /// Used to override the style.
    var customStyle: CTStyler? { get set }

    /// Returns in order of existence: This object's custom style, the first parent with a custom style, or the default style.
    func style() -> CTStyler

    /// Called when the style changes.
    func styleDidChange()
}

/// In order to propogate style through the view hierearchy:
/// 1. Call `styleChildren()` from a `didSet` observer on `customStyle`.
/// 2. Call `styleChildren()` from `removeFromSuperView()`.
/// 3. Call `styleDidChange()` from `didMoveToSuperview()`.
extension CTStylable where Self: UIView {
    /// Returns in order of existence: This object's custom style, the first parent with a custom style, or the default style.
    func style() -> CTStyler {
        return customStyle ?? getParentCustomStyle() ?? CTStyle()
    }

    /// Notify this view and subviews that the style has changed. Guarantees that the outermost view's `styleDidChange` method will be called after
    /// that of inner views.
    func styleChildren() {
        recursiveStyleChildren()
        styleDidChange()
    }
}

private extension UIView {
    // Find the first custom style in the superview hierarchy.
    func getParentCustomStyle() -> CTStyler? {
        guard let superview = superview else { return nil }

        // if the view has a custom style, return it
        if let typedSuperview = superview as? CTStylable, let customStyle = typedSuperview.customStyle {
            return customStyle
        }

        // else check if the superview has a custom style
        return superview.getParentCustomStyle()
    }

    // Recursively notify subviews that the style has changed.
    func recursiveStyleChildren() {
        for view in subviews {
            // Propogate style through any `UIView`s
            guard let typedView = view as? CTStylable & UIView else {
                view.recursiveStyleChildren()
                continue
            }

            // Propogate style to subviews that are not the child of a view that has set a custom style
            if typedView.customStyle == nil {
                typedView.recursiveStyleChildren()
                typedView.styleDidChange()
            }
        }
    }
}
