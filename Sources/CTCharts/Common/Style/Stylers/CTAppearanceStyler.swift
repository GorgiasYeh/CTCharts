
import UIKit

/// Defines constants for view appearance styling.
protocol CTAppearanceStyler {
    var shadowOpacity1: Float { get }
    var shadowRadius1: CGFloat { get }
    var shadowOffset1: CGSize { get }
    var opacity1: CGFloat { get }
    var lineWidth1: CGFloat { get }

    var cornerRadius1: CGFloat { get }
    var cornerRadius2: CGFloat { get }

    var borderWidth1: CGFloat { get }
    var borderWidth2: CGFloat { get }
}

/// Default appearance values.
extension CTAppearanceStyler {
    var shadowOpacity1: Float { 0.15 }
    var shadowRadius1: CGFloat { 8 }
    var shadowOffset1: CGSize { CGSize(width: 0, height: 2) }
    var opacity1: CGFloat { 0.45 }
    var lineWidth1: CGFloat { 4 }

    var cornerRadius1: CGFloat { 15 }
    var cornerRadius2: CGFloat { 12 }

    var borderWidth1: CGFloat { 2 }
    var borderWidth2: CGFloat { 1 }
}

/// Concrete object for appearance constants.
struct CTAppearanceStyle: CTAppearanceStyler {
    public init() {}
}
