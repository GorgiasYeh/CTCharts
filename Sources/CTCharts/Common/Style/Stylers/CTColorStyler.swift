
import UIKit

/// Defines color constants.
protocol CTColorStyler {
    var label: UIColor { get }
    var secondaryLabel: UIColor { get }
    var tertiaryLabel: UIColor { get }

    var customBackground: UIColor { get }
    var secondaryCustomBackground: UIColor { get }

    var customGroupedBackground: UIColor { get }
    var secondaryCustomGroupedBackground: UIColor { get }
    var tertiaryCustomGroupedBackground: UIColor { get }

    var separator: UIColor { get }

    var customFill: UIColor { get }
    var secondaryCustomFill: UIColor { get }
    var tertiaryCustomFill: UIColor { get }
    var quaternaryCustomFill: UIColor { get }

    var customBlue: UIColor { get }

    var customGray: UIColor { get }
    var customGray2: UIColor { get }
    var customGray3: UIColor { get }
    var customGray4: UIColor { get }
    var customGray5: UIColor { get }

    var black: UIColor { get }
    var white: UIColor { get }
    var clear: UIColor { get }
}

/// Defines default values for color constants.
extension CTColorStyler {
    var label: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    var secondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .black
        }
    }
    var tertiaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiaryLabel
        } else {
            return .black
        }
    }

    var customBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    var secondaryCustomBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemBackground
        } else {
            return .white
        }
    }

    var customGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGroupedBackground
        } else {
            return .white
        }
    }
    var secondaryCustomGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemGroupedBackground
        } else {
            return .white
        }
    }
    var tertiaryCustomGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiarySystemGroupedBackground
        } else {
            return .white
        }
    }

    var separator: UIColor {
        if #available(iOS 13.0, *) {
            return .separator
        } else {
            return .black
        }
    }

    var customFill: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiarySystemFill
        } else {
            return .black
        }
    }
    var secondaryCustomFill: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemFill
        } else {
            return .black
        }
    }
    var tertiaryCustomFill: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiarySystemFill
        } else {
            return .black
        }
    }
    var quaternaryCustomFill: UIColor {
        if #available(iOS 13.0, *) {
            return .quaternarySystemFill
        } else {
            return .black
        }
    }

    var customBlue: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBlue
        } else {
            return .blue
        }
    }

    var customGray: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray
        } else {
            return .gray
        }
    }
    var customGray2: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray2
        } else {
            return .gray
        }
    }
    var customGray3: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray3
        } else {
            return .gray
        }
    }
    var customGray4: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray4
        } else {
            return .gray
        }
    }
    var customGray5: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray5
        } else {
            return .gray
        }
    }

    var white: UIColor { .white }
    var black: UIColor { .black }
    var clear: UIColor { .clear }
}

/// Concrete object for color constants.
struct CTColorStyle: CTColorStyler {
    public init() {}
}
