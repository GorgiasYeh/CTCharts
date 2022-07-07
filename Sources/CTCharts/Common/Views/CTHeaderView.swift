
import UIKit

/// A title and detail label. The view can also be configured to show a separator,
/// icon image, and a detail disclosure arrow.
///
///     +-------------------------------------------------------+
///     | +----+                                                |
///     | |icon| [title]                                        |
///     | |img | [detail]                                       |
///     | +----+                                                |
///     |                                                       |
///     |  ---------------------------------------------------  |
///     |                                                       |
///     +-------------------------------------------------------+
///
open class CTHeaderView: CTView {

    private enum Constants {
        static let spacing: CGFloat = 4
    }

    /// Configuration for a header view.
    public struct Configuration {
        /// Flag to show a separator under the text in the view.
        public var showsSeparator: Bool = false

        /// Flag to show an image on the trailing end of the view. The default image is an arrow.
        public var showsDetailDisclosure: Bool = false

        /// Flag to show an image on the leading side of the text in the view.
        public var showsIconImage: Bool = false
    }

    // MARK: Properties

    /// Vertical stack view that holds the main content.
    let contentStackView: CTStackView = {
        let stackView = CTStackView(style: .plain)
        stackView.axis = .vertical
        return stackView
    }()

    /// The image on the trialing end of the view. The default image is an arrow. Depending on the configuration, this may be nil.
//    public let detailDisclosureImage: UIImageView?

    /// Multi-line title label above `detailLabel`
    public let titleLabel: CTLabel = {
        let label = CTLabel(textStyle: .headline, weight: .bold)
        label.numberOfLines = 0
        label.animatesTextChanges = true
        return label
    }()

    /// Multi-line detail label below `titleLabel`.
    public let detailLabel: CTLabel = {
        let label = CTLabel(textStyle: .caption1, weight: .medium)
        label.numberOfLines = 0
        label.animatesTextChanges = true
        return label
    }()

    /// The image on the leading end of the text in the view. Depending on the configuration, this may be ni.
    public let iconImageView: UIImageView?

    /// The configuration for the view.
    private let configuration: Configuration

    /// Stack view that holds the text content in the header.
    private let headerTextStackView = CTStackView.vertical()

    /// Stack view that holds the content in the header.
    private let headerStackView: CTStackView = {
        let stackView = CTStackView.horizontal()
        stackView.alignment = .center
        return stackView
    }()

    private var iconImageHeightConstraint: NSLayoutConstraint?

    private lazy var iconHeight = CTAccessibleValue(container: style(), keyPath: \.dimension.imageHeight2) { [weak self] newHeight in
        self?.iconImageHeightConstraint?.constant = newHeight
    }

    /// Separator between the header and the body.
    private let separatorView: CTSeparatorView?

    // MARK: Life Cycle

    /// Create the view with a configuration block. The configuration block determines which views the header should show.
    public init(configurationHandler: (inout Configuration) -> Void = { _ in }) {
        var configuration = Configuration()
        configurationHandler(&configuration)
        self.configuration = configuration

        iconImageView = configuration.showsIconImage ? CTHeaderView.makeIconImageView() : nil
        separatorView = configuration.showsSeparator ? CTSeparatorView() : nil
        super.init()

        accessibilityTraits = configuration.showsDetailDisclosure ? [.header, .button] : [.header]
    }

    public required init?(coder aDecoder: NSCoder) {
        self.configuration = Configuration()
        iconImageView = nil
//        detailDisclosureImage = nil
        separatorView = nil
        super.init(coder: aDecoder)
    }

    // MARK: Methods

    override func setup() {
        super.setup()
        addSubviews()
        constrainSubviews()
        styleSubviews()
        isAccessibilityElement = true
    }

    private func addSubviews() {
        [titleLabel, detailLabel].forEach { headerTextStackView.addArrangedSubview($0) }
        [headerTextStackView].forEach { headerStackView.addArrangedSubview($0) }
        [headerStackView].forEach { contentStackView.addArrangedSubview($0) }

        // Setup dynamic views based on the configuration
        if let separatorView = separatorView { contentStackView.addArrangedSubview(separatorView) }
//        if let detailDisclosureImage = detailDisclosureImage { headerStackView.addArrangedSubview(detailDisclosureImage) }
        if let iconImageView = iconImageView { headerStackView.insertArrangedSubview(iconImageView, at: 0) }

        addSubview(contentStackView)
    }

    private func styleSubviews() {
        let margin = style().dimension.directionalInsets1.top
        contentStackView.spacing = margin
        headerStackView.spacing = margin / 2.0
        headerTextStackView.spacing = margin / 4.0
        contentStackView.setCustomSpacing(margin, after: headerStackView)
    }

    private static func makeIconImageView() -> UIImageView {
        let imageView = CTCircleImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

//    private static func makeDetailDisclosureImage() -> UIImageView {
//        if #available(iOS 13.0, *) {
//            let image = UIImage(systemName: "chevron.right")
//        } else {
//            let image = UIImage(named: "arrow_right")
//        }
//        let imageView = UIImageView(image: image)
//        return imageView
//    }

    private func constrainSubviews() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
//        detailDisclosureImage?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        iconImageView?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        var constraints = contentStackView.constraints(equalTo: self)

        if let imageView = iconImageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: iconHeight.scaledValue)
            constraints += [
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                iconImageHeightConstraint!
            ]
        }

        NSLayoutConstraint.activate(constraints)
    }

    override open func styleDidChange() {
        super.styleDidChange()
        let style = self.style()
        titleLabel.textColor = style.color.label
        detailLabel.textColor = style.color.label

//        detailDisclosureImage?.tintColor = style.color.customGray3
        iconImageView?.tintColor = style.color.customGray3

        iconHeight.update(withContainer: style)
//        detailDisclosurePointSize.update(withContainer: style)
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
//            [iconHeight, detailDisclosurePointSize].forEach { $0.apply() }
            [iconHeight].forEach { $0.apply() }
        }
    }
}

private class CTCircleImageView: UIImageView {

    private let maskLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        maskLayer.path = CGPath(ellipseIn: bounds, transform: nil)
        maskLayer.backgroundColor = UIColor.black.cgColor

        layer.mask = maskLayer
        clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        maskLayer.path = CGPath(ellipseIn: bounds, transform: nil)
    }
}
