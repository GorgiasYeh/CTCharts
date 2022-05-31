/*
 Copyright (c) 2019, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3. Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

/// Has the ability to display one's self as a card. A card has a particular corner
/// radius and shadow.
public protocol OCKCardable {
    /// View that will be styled as a card. Should hold the `contentView`.
    var cardView: UIView { get }

    /// Holds the main content. Subviews should be added to this view.
    var contentView: UIView { get }
}

public extension OCKCardable {
    /// Turn the card styling on/off. If this view is stylable, this method should be called from the `styleDidChange` method. Note that shadow
    /// rastering is set on by default, and consequently a shadow cannot be set over a clear background.
    /// - Parameter enabled: true to turn the card styling on.
    /// - Parameter style: The style to use for the card.
    func enableCardStyling(_ enabled: Bool, style: OCKStyler) {
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

/// Auxiliary object to handle the `OCKCardable` protocol.
struct OCKCardBuilder: OCKCardable {
    let cardView: UIView
    let contentView: UIView
}
