
import Foundation
import UIKit

open class CTCartesianChartView: CTView, CTChartDisplayable {

    // MARK: Properties

    private let contentView = CTView()

    private let headerContainerView = UIView()

    /// Handles events related to an `CTChartDisplayable` object.
    public weak var delegate: CTChartViewDelegate?

    /// Vertical stack view that
    let contentStackView: CTStackView = {
        let stackView = CTStackView()
        stackView.axis = .vertical
        return stackView
    }()

    /// A default `CTHeaderView`.
    public let headerView = CTHeaderView()
    
    /// SelectView
    public let SelectView = UIView()

    /// The main content of the view.
    public let graphView: CTCartesianGraphView

    // MARK: - Life Cycle

    /// Create a chart with a specified type. Available charts include bar, plot, and scatter.
    ///
    /// - Parameter type: The type of the chart.
    public init(type: CTCartesianGraphView.PlotType) {
        graphView = CTCartesianGraphView(type: type)
        super.init()
        setup()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func setup() {
        super.setup()
        addSubviews()
        constrainSubviews()
        setupGestures()
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerView.addGestureRecognizer(tapGesture)
    }

    private func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(contentStackView)
        headerContainerView.addSubview(headerView)
        headerContainerView.addSubview(SelectView)
        SelectView.backgroundColor = style().color.customBackground
        SelectView.isHidden = true
        [headerContainerView, graphView].forEach { contentStackView.addArrangedSubview($0) }
    }

    private func constrainSubviews() {
        [contentView, contentStackView, headerView, SelectView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate(
            contentStackView.constraints(equalTo: self, directions: [.horizontal]) +
            contentStackView.constraints(equalTo: layoutMarginsGuide, directions: [.vertical]) +
            headerView.constraints(equalTo: headerContainerView.layoutMarginsGuide, directions: [.horizontal]) +
            headerView.constraints(equalTo: headerContainerView, directions: [.vertical]) +
            SelectView.constraints(equalTo: headerContainerView.layoutMarginsGuide, directions: [.horizontal]) +
            SelectView.constraints(equalTo: headerContainerView, directions: [.vertical]) +
            contentStackView.constraints(equalTo: contentView))
    }

    @objc
    private func didTapHeader() {
        delegate?.didSelectChartView(self)
    }

    override open func styleDidChange() {
        super.styleDidChange()
        let cachedStyle = style()
        let cardBuilder = CTCardBuilder(cardView: self, contentView: contentView)
        cardBuilder.enableCardStyling(true, style: cachedStyle)
        contentStackView.spacing = cachedStyle.dimension.directionalInsets1.top
        directionalLayoutMargins = cachedStyle.dimension.directionalInsets1
        headerContainerView.directionalLayoutMargins = cachedStyle.dimension.directionalInsets1
    }
    
    override  func didSelectPlotDataPoints(_ index: Int) {
        self.delegate?.didSelectPlotDataPoints(self, index)
    }
    
    override  func beganSelectPlotDataPoints() {
        if !graphView.isHidenSelectLayer {
            SelectView.isHidden = false
        }
    }
    
    override  func endedSelectPlotDataPoints() {
        if !graphView.isHidenSelectLayer {
            SelectView.isHidden = true
        }
    }
    
}
