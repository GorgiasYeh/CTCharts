
import UIKit

/// Has the ability to display one's self as a card. A card has a particular corner
/// radius and shadow.
protocol CTCardable {
    /// View that will be styled as a card. Should hold the `contentView`.
    var cardView: UIView { get }

    /// Holds the main content. Subviews should be added to this view.
    var contentView: UIView { get }
}

extension CTCardable {
    /// Turn the card styling on/off. If this view is stylable, this method should be called from the `styleDidChange` method. Note that shadow
    /// rastering is set on by default, and consequently a shadow cannot be set over a clear background.
    /// - Parameter enabled: true to turn the card styling on.
    /// - Parameter style: The style to use for the card.
    func enableCardStyling(_ enabled: Bool, style: CTStyler) {
        cardView.backgroundColor = style.color.secondaryCustomGroupedBackground
        cardView.layer.masksToBounds = false
        if #available(iOS 13.0, *) {
            cardView.layer.cornerCurve = .continuous
        }
        cardView.layer.cornerRadius = enabled ? style.appearance.cornerRadius2 : 0
        cardView.layer.shadowColor = enabled ? style.color.black.cgColor : UIColor.clear.cgColor
        cardView.layer.shadowOffset = style.appearance.shadowOffset1
        cardView.layer.shadowRadius = enabled ? style.appearance.shadowRadius1 : 0
        cardView.layer.shadowOpacity = enabled ? style.appearance.shadowOpacity1 : 0
        cardView.layer.rasterizationScale = enabled ? UIScreen.main.scale : 0
        cardView.layer.shouldRasterize = enabled

        if #available(iOS 13.0, *) {
            contentView.layer.cornerCurve = .continuous
        }
        contentView.layer.cornerRadius = cardView.layer.cornerRadius
    }
}

/// Auxiliary object to handle the `CTCardable` protocol.
struct CTCardBuilder: CTCardable {
    let cardView: UIView
    let contentView: UIView
}
