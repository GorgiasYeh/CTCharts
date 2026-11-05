import UIKit
import CTCharts

/// Demo screen: a bar chart with long-press selection, a line chart, and a chart with a limit line.
final class ChartsViewController: UIViewController {

    // Fixed sample data so screenshots are the same every run.
    private let dailySteps: [CGFloat] = [
        4200, 6800, 3100, 9200, 7400, 11800, 5600, 2900, 8300, 6100,
        10400, 4700, 7900, 3600, 9800, 6600, 5200, 12100, 7100, 4400,
        8800, 3900, 6900, 10900, 5800, 7600, 4100, 9500, 6300, 8100
    ]

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CTCharts"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGroupedBackground

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16)
        ])

        stackView.addArrangedSubview(makeBarChart())
        stackView.addArrangedSubview(makeLineChart())
        stackView.addArrangedSubview(makeLimitLineChart())
    }

    /// Bar chart with gradient colors. Long-press to select a day.
    private func makeBarChart() -> CTCartesianChartView {
        var series = CTDataSeries(values: dailySteps, title: "Steps", size: 6)
        series.gradientStartColor = .systemOrange
        series.gradientEndColor = .systemRed

        let chart = makeChart(type: .bar, series: series,
                              title: "Steps in June", detail: "Long-press a bar to see the value")
        chart.delegate = self
        chart.graphView.isHidenSelectLayer = false

        chart.SelectView.addSubview(selectionLabel)
        NSLayoutConstraint.activate([
            selectionLabel.centerXAnchor.constraint(equalTo: chart.SelectView.centerXAnchor),
            selectionLabel.centerYAnchor.constraint(equalTo: chart.SelectView.centerYAnchor)
        ])
        return chart
    }

    /// Line chart.
    private func makeLineChart() -> CTCartesianChartView {
        let series = CTDataSeries(values: dailySteps, title: "Steps", size: 3, color: .systemBlue)
        return makeChart(type: .line, series: series,
                         title: "Daily trend", detail: "Line chart")
    }

    /// Bar chart with a limit line at the goal.
    private func makeLimitLineChart() -> CTCartesianChartView {
        var series = CTDataSeries(values: dailySteps, title: "Steps", size: 6)
        series.gradientStartColor = .systemTeal
        series.gradientEndColor = .systemGreen

        let chart = makeChart(type: .bar, series: series,
                              title: "Goal: 3,500 steps", detail: "Limit line marks the goal")
        chart.graphView.isLimitHiden = false
        chart.graphView.limitLinePoint = 3500
        return chart
    }

    private func makeChart(type: CTCartesianGraphView.PlotType, series: CTDataSeries,
                           title: String, detail: String) -> CTCartesianChartView {
        let chart = CTCartesianChartView(type: type)
        chart.headerView.titleLabel.text = title
        chart.headerView.detailLabel.text = detail
        chart.graphView.dataSeries = [series]
        chart.graphView.yMinimum = 0
        chart.graphView.yMaximum = 14000
        chart.graphView.xMinimum = 0
        chart.graphView.xMaximum = CGFloat(dailySteps.count)
        chart.graphView.horizontalAxisMarkers = ["6/1", "6/30"]
        return chart
    }
}

extension ChartsViewController: CTChartViewDelegate {
    func didSelectChartView(_ chartView: UIView & CTChartDisplayable) {}

    func didSelectPlotDataPoints(_ chartView: UIView & CTChartDisplayable, _ selectIndex: Array.Index) {
        guard dailySteps.indices.contains(selectIndex) else { return }
        selectionLabel.text = "June \(selectIndex + 1): \(Int(dailySteps[selectIndex])) steps"
    }
}
