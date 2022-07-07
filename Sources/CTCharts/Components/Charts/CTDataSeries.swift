
import UIKit

/// Representa a single group of data to be plotted. In most cases, CareKit plots accept multiple data
/// series, allowing for for several data series to be plotted on a single axis for easy comparison.
/// - SeeAlso: `CTGraphView`
public struct CTDataSeries: Equatable {
    /// An array of points given in plot space Cartesian coordinates
    /// The plot origin (0, 0) is in the bottom left hand corner.
    public var dataPoints: [CGPoint]

    /// A title for this data series that will be displayed in the plot legend.
    public var title: String

    /// The start color of the gradient this data series will be plotted in.
    public var gradientStartColor: UIColor?

    /// The end color of the gradient this data series will be plotted in.
    public var gradientEndColor: UIColor?

    /// A size specifying how large this data series should appear on the plot.
    /// Its precise interpretation may vary depending on plot type used.
    public var size: CGFloat

    /// Used to set the accessibility labels of each of the data points.
    /// This array should either be empty or contain the same number of elements as the data series array.
    public var accessibilityLabels: [String] = []

    /// Creates a new data series that can be passed to chart to be plotted. The series will be plotted in a single
    /// solid color. Use this initialize if you wish to plot data at precise or irregular intervals.
    ///
    /// - Parameters:
    ///   - dataPoints: An array of points in graph space Cartesian coordinates. The origin is in bottom left corner.
    ///   - title: A title that will be used to represent this data series in the plot legend.
    ///   - color: A solid color to be used when plotting the data series.
    ///   - size: A size specifying how large this data series should appear on the plot.
    public init(dataPoints: [CGPoint], title: String, size: CGFloat = 10, color: UIColor? = nil) {
        self.dataPoints = dataPoints
        self.title = title
        self.gradientStartColor = color
        self.gradientEndColor = color
        self.size = size
    }

    /// Creates a new data series that can be passed to chart to be plotted. The series will be plotted with a gradient
    /// color scheme. Use this initialize if you wish to plot data at precise or irregular intervals.
    ///
    /// - Parameters:
    ///   - dataPoints: An array of points in graph space Cartesian coordinates. The origin is in bottom left corner.
    ///   - title: A title that will be used to represent this data series in the plot legend.
    ///   - gradientStartColor: The start color for the gradient.
    ///   - gradientEndColor: The end color for the gradient.
    ///   - size: A size specifying how large this data series should appear on the plot.
    public init(dataPoints: [CGPoint], title: String, gradientStartColor: UIColor, gradientEndColor: UIColor, size: CGFloat = 10) {
        self.dataPoints = dataPoints
        self.title = title
        self.size = size
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
    }

    /// Creates a new data series that can be passed to chart to be plotted. The series will be plotted in a single solid color.
    /// Values will be evenly spaced when displayed on a chart. Use this option when the x coordinate is not particularly
    /// meaningful, such as when creating bar charts.
    ///
    /// - Parameters:
    ///   - values: An array of values in graph space Cartesian coordinates.
    ///   - title: A title that will be used to represent this data series in the plot legend.
    ///   - size: A size specifying how large this data series should appear on the plot.
    ///   - color: The color that this data series will be plotted in.
    public init(values: [CGFloat], title: String, size: CGFloat = 10, color: UIColor? = nil) {
        self.dataPoints = values.enumerated().map { CGPoint(x: CGFloat($0), y: $1) }
        self.title = title
        self.size = size
        self.gradientStartColor = color
        self.gradientEndColor = color
    }

    /// Creates a new data series that can be passed to chart to be plotted. The series will be plotted with a gradient
    /// color scheme. Values will be evenly spaced when displayed on a chart. Use this option when the x coordinate is not
    /// particularly meaningful, such as when creating bar charts.
    ///
    /// - Parameters:
    ///   - values: An array of values in graph space Cartesian coordinates.
    ///   - title: A title that will be used to represent this data series in the plot legend.
    ///   - gradientStartColor: The start color for the gradient.
    ///   - gradientEndColor: The end color for the gradient.
    ///   - size: A size specifying how large this data series should appear on the plot.
    public init(values: [CGFloat], title: String, gradientStartColor: UIColor, gradientEndColor: UIColor, size: CGFloat = 10) {
        self.dataPoints = values.enumerated().map { CGPoint(x: CGFloat($0), y: $1) }
        self.title = title
        self.size = size
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
    }
}
