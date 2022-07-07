
import UIKit

/// Defines constants for values used during animations.
protocol CTAnimationStyler {
    var stateChangeDuration: Double { get }
}

/// Default animation values.
extension CTAnimationStyler {
    var stateChangeDuration: Double { 0.2 }
}

/// Concrete object for animation constants.
struct CTAnimationStyle: CTAnimationStyler {
    public init() {}
}
