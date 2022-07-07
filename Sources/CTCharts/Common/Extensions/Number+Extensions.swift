
import UIKit

extension Double {
    var normalized: Double {
        return max(0, min(self, 1))
    }
}

extension CGFloat {
    func scaled() -> CGFloat {
        UIFontMetrics.default.scaledValue(for: self)
    }
}
