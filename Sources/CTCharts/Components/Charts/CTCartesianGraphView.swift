
import UIKit

/// Displays a `CTMultiGraphableView` above an axis. The initializer takes an enum `PlotType` that allows you to choose from
/// several common graph types.
///
///     +-------------------------------------------------------+
///     |                                                       |
///     | [title]                                               |
///     | [detail]                                              |
///     |                                                       |
///     | [graph]                                               |
///     |                                                       |
///     +-------------------------------------------------------+
///
open class CTCartesianGraphView: CTView, CTMultiPlotable {

    /// An enumerator specifying the types of plots this view can display.
    public enum PlotType: String, CaseIterable {
        case line
        case bar
    }

    // MARK: Properties
    
    /// The data points displayed in the graph.
    public var dataSeries: [CTDataSeries] {
        get { return plotView.dataSeries }
        set {
            updateScaling(for: newValue)
            plotView.dataSeries = newValue
            legend.setDataSeries(newValue)
        }
    }

    /// The labels for the horizontal axis.
    public var horizontalAxisMarkers: [String] = [] {
        didSet { axisView.axisMarkers = horizontalAxisMarkers }
    }

    /// A number formatter used for the vertical axis values
    public var numberFormatter: NumberFormatter {
        get { gridView.numberFormatter }
        set { gridView.numberFormatter = newValue }
    }

    /// Get the bounds of the graph.
    ///
    /// - Returns: The bounds of the graph.
    public func graphBounds() -> CGRect {
        return plotView.graphBounds()
    }

    /// The minimum x value in the graph.
    public var xMinimum: CGFloat? {
        get { return plotView.xMinimum }
        set {
            plotView.xMinimum = newValue
            gridView.xMinimum = newValue
        }
    }

    /// The maximum x value in the graph.
    public var xMaximum: CGFloat? {
        get { return plotView.xMaximum }
        set {
            plotView.xMaximum = newValue
            gridView.xMaximum = newValue
        }
    }

    /// The minimum y value in the graph.
    public var yMinimum: CGFloat? {
        get { return plotView.yMinimum }
        set {
            plotView.yMinimum = newValue
            gridView.yMinimum = newValue
        }
    }

    /// The maximum y value in the graph.
    public var yMaximum: CGFloat? {
        get { return plotView.yMaximum }
        set {
            plotView.yMaximum = newValue
            gridView.yMaximum = newValue
        }
    }

    /// The index of the selected label in the x-axis.
    public var selectedIndex: Int? {
        get { return axisView.selectedIndex }
        set { axisView.selectedIndex = newValue }
    }
    
    /// 是否顯示標示線，顯示時須同時設定標示線位置(limitLinePoint)
    public var isLimitHiden: Bool {
        get { return gridView.isLimitHiden }
        set { gridView.isLimitHiden = newValue }
    }
    
    /// 標示線位置
    public var limitLinePoint: Int {
        get { return gridView.limitLinePoint }
        set { gridView.limitLinePoint = newValue }
    }
    
    /// 是否顯示背景網格
    public var isGridHiden: Bool {
        get { return gridView.isGridHiden }
        set { gridView.isGridHiden = newValue }
    }
    
    public var isHidenSelectLayer: Bool {
        get {
            if let pv = self.plotView as? CTGradientPlotView<CTBarLayer> {
                return pv.isHidenSelectLayer
            }
            return true
        }
        set {
            if let pv = self.plotView as? CTGradientPlotView<CTBarLayer> {
                pv.isHidenSelectLayer = newValue
            }
        }
    }

    private let gridView: CTGridView
    private let plotView: UIView & CTMultiPlotable
    private let axisView: CTGraphAxisView
    private let axisHeight: CGFloat = 44
    private let horizontalPlotPadding: CGFloat = 50
    private let legend = CTGraphLegendView()

    // MARK: - Life Cycle

    /// Create a graph view with the specified style.
    ///
    /// - Parameter plotType: The style of the graph view.
    public init(type: PlotType) {
        self.gridView = CTGridView()
        self.axisView = CTGraphAxisView()
        self.plotView = {
            switch type {
            case .line: return CTLinePlotView()
            case .bar: return CTBarPlotView()
            }
        }()
        
        super.init()
        setup()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override open func tintColorDidChange() {
        super.tintColorDidChange()
        applyTintColor()
    }

    private func updateScaling(for dataSeries: [CTDataSeries]) {
        let maxValue = max(CGFloat(gridView.numberOfDivisions), dataSeries.flatMap { $0.dataPoints }.map { $0.y }.max() ?? 0)
        let chartMax = ceil(maxValue / CGFloat(gridView.numberOfDivisions)) * CGFloat(gridView.numberOfDivisions)
        plotView.yMaximum = chartMax
        gridView.yMaximum = chartMax
    }

    override func setup() {
        super.setup()
        [gridView, plotView, axisView, legend].forEach { addSubview($0) }

        gridView.xMinimum = plotView.xMinimum
        gridView.xMaximum = plotView.xMaximum
        gridView.yMinimum = plotView.yMinimum
        gridView.yMaximum = plotView.yMaximum

        [gridView, plotView, axisView, legend].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: plotView.topAnchor),
            gridView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridView.bottomAnchor.constraint(equalTo: plotView.bottomAnchor),
            plotView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: horizontalPlotPadding),
            plotView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPlotPadding),
            plotView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            plotView.bottomAnchor.constraint(equalTo: axisView.topAnchor),
            axisView.leadingAnchor.constraint(equalTo: plotView.leadingAnchor),
            axisView.trailingAnchor.constraint(equalTo: plotView.trailingAnchor),
            axisView.heightAnchor.constraint(equalToConstant: axisHeight),
            axisView.bottomAnchor.constraint(equalTo: legend.topAnchor),
            legend.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor),
            legend.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor),
            legend.centerXAnchor.constraint(equalTo: centerXAnchor),
            legend.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])

        applyTintColor()
    }

    private func applyTintColor() {
        axisView.tintColor = tintColor
    }
}
