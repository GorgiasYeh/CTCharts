
import Foundation

/// Defines styling constants.
protocol CTStyler {
    var color: CTColorStyler { get }
    var animation: CTAnimationStyler { get }
    var appearance: CTAppearanceStyler { get }
    var dimension: CTDimensionStyler { get }
}

/// Defines default values for style constants.
extension CTStyler {
    var color: CTColorStyler { CTColorStyle() }
    var animation: CTAnimationStyler { CTAnimationStyle() }
    var appearance: CTAppearanceStyler { CTAppearanceStyle() }
    var dimension: CTDimensionStyler { CTDimensionStyle() }
}

// Concrete object that contains style constants
struct CTStyle: CTStyler {
    public init() {}
}
