
import UIKit

/// This is an internal subclass of `CTLabel` that has a max font size that will be respected even if
/// the user increases font size or uses accessible sizes. It should be used sparingly and exposed
/// in public API's as its superclass `CTLabel`
class CTCappedSizeLabel: CTLabel {

    var maxFontSize: CGFloat = 20

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if font.pointSize > maxFontSize {
            font = font.withSize(maxFontSize)
        }
    }
}
