
import UIKit

/// A configurator that defines constants view sizes.
protocol CTDimensionStyler {
    var separatorHeight: CGFloat { get }

    var lineWidth1: CGFloat { get }
    var stackSpacing1: CGFloat { get }

    var imageHeight2: CGFloat { get }
    var imageHeight1: CGFloat { get }

    var pointSize3: CGFloat { get }
    var pointSize2: CGFloat { get }
    var pointSize1: CGFloat { get }

    var buttonHeight3: CGFloat { get }
    var buttonHeight2: CGFloat { get }
    var buttonHeight1: CGFloat { get }

    var symbolPointSize5: CGFloat { get }
    var symbolPointSize4: CGFloat { get }
    var symbolPointSize3: CGFloat { get }
    var symbolPointSize2: CGFloat { get }
    var symbolPointSize1: CGFloat { get }

    var directionalInsets2: NSDirectionalEdgeInsets { get }
    var directionalInsets1: NSDirectionalEdgeInsets { get }
}

/// Default dimension values.
extension CTDimensionStyler {
    var separatorHeight: CGFloat { 1.0 / UIScreen.main.scale }

    var lineWidth1: CGFloat { 4 }
    var stackSpacing1: CGFloat { 8 }

    var imageHeight2: CGFloat { 40 }
    var imageHeight1: CGFloat { 150 }

    var pointSize3: CGFloat { 11 }
    var pointSize2: CGFloat { 14 }
    var pointSize1: CGFloat { 17 }

    var buttonHeight3: CGFloat { 20 }
    var buttonHeight2: CGFloat { 50 }
    var buttonHeight1: CGFloat { 60 }

    var symbolPointSize5: CGFloat { 8 }
    var symbolPointSize4: CGFloat { 12 }
    var symbolPointSize3: CGFloat { 16 }
    var symbolPointSize2: CGFloat { 20 }
    var symbolPointSize1: CGFloat { 30 }

    var directionalInsets2: NSDirectionalEdgeInsets { .init(top: 8, leading: 9, bottom: 8, trailing: 8) }
    var directionalInsets1: NSDirectionalEdgeInsets { .init(top: 16, leading: 16, bottom: 16, trailing: 16) }
}

/// Concrete object for cdimesnion constants.
struct CTDimensionStyle: CTDimensionStyler {
    public init() {}
}
